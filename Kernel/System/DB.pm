# --
# Kernel/System/DB.pm - the global database wrapper to support different databases
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DB.pm,v 1.105.2.4 2011-07-28 22:35:14 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DB;

use strict;
use warnings;

use DBI;

use Kernel::System::Time;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.105.2.4 $) [1];

=head1 NAME

Kernel::System::DB - global database interface

=head1 SYNOPSIS

All database functions to connect/insert/update/delete/... to a database.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create database object with database connect

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        # if you don't use the follow params, then this are used
        # from Kernel/Config.pm!
        DatabaseDSN  => 'DBI:odbc:database=123;host=localhost;',
        DatabaseUser => 'user',
        DatabasePw   => 'somepass',
        Type         => 'mysql',
        Attribute => {
            LongTruncOk => 1,
            LongReadLen => 100*1024,
        },
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # 0=off; 1=updates; 2=+selects; 3=+Connects;
    $Self->{Debug} = $Param{Debug} || 0;

    # check needed objects
    for (qw(ConfigObject LogObject MainObject EncodeObject)) {
        if ( $Param{$_} ) {
            $Self->{$_} = $Param{$_};
        }
        else {
            die "Got no $_!";
        }
    }

    # time object
    $Self->{TimeObject} = Kernel::System::Time->new( %{$Self} );

    # get config data
    $Self->{DSN}  = $Param{DatabaseDSN}  || $Self->{ConfigObject}->Get('DatabaseDSN');
    $Self->{USER} = $Param{DatabaseUser} || $Self->{ConfigObject}->Get('DatabaseUser');
    $Self->{PW}   = $Param{DatabasePw}   || $Self->{ConfigObject}->Get('DatabasePw');
    $Self->{SlowLog} = $Param{'Database::SlowLog'}
        || $Self->{ConfigObject}->Get('Database::SlowLog');

    # decrypt pw (if needed)
    if ( $Self->{PW} =~ /^\{(.*)\}$/ ) {
        my $Length = length($1) * 4;
        $Self->{PW} = pack( "h$Length", $1 );
        $Self->{PW} = unpack( "B$Length", $Self->{PW} );
        $Self->{PW} =~ s/1/A/g;
        $Self->{PW} =~ s/0/1/g;
        $Self->{PW} =~ s/A/0/g;
        $Self->{PW} = pack( "B$Length", $Self->{PW} );
    }

    # get database type (auto detection)
    if ( $Self->{DSN} =~ /:mysql/i ) {
        $Self->{'DB::Type'} = 'mysql';
    }
    elsif ( $Self->{DSN} =~ /:pg/i ) {
        $Self->{'DB::Type'} = 'postgresql';
    }
    elsif ( $Self->{DSN} =~ /:oracle/i ) {
        $Self->{'DB::Type'} = 'oracle';
    }
    elsif ( $Self->{DSN} =~ /:db2/i ) {
        $Self->{'DB::Type'} = 'db2';
    }
    elsif ( $Self->{DSN} =~ /:(mssql|sybase)/i ) {
        $Self->{'DB::Type'} = 'mssql';
    }

    # get database type (config option)
    if ( $Self->{ConfigObject}->Get('Database::Type') ) {
        $Self->{'DB::Type'} = $Self->{ConfigObject}->Get('Database::Type');
    }

    # get database type (overwrite with params)
    if ( $Param{Type} ) {
        $Self->{'DB::Type'} = $Param{Type};
    }

    # load backend module
    if ( $Self->{'DB::Type'} ) {
        my $GenericModule = "Kernel::System::DB::$Self->{'DB::Type'}";
        if ( !$Self->{MainObject}->Require($GenericModule) ) {
            return;
        }
        $Self->{Backend} = $GenericModule->new( %{$Self} );

        # set database functions
        $Self->{Backend}->LoadPreferences();
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'Error',
            Message  => "Unknown database type! Set option Database::Type in "
                . "Kernel/Config.pm to (mysql|postgresql|oracle|db2|mssql).",
        );
        return;
    }

    # check/get extra database config options
    # (overwrite auto detection with config options)
    for (qw(Type Limit DirectBlob Attribute QuoteSingle QuoteBack Connect Encode)) {
        if ( defined( $Self->{ConfigObject}->Get("Database::$_") ) ) {
            $Self->{Backend}->{"DB::$_"} = $Self->{ConfigObject}->Get("Database::$_");
        }
    }

    # check/get extra database config options
    # (overwrite with params)
    for (
        qw(Type Limit DirectBlob Attribute QuoteSingle QuoteBack Connect Encode NoLowerInLargeText LcaseLikeInLargeText)
        )
    {
        if ( defined( $Param{$_} ) ) {
            $Self->{Backend}->{"DB::$_"} = $Param{$_};
        }
    }

    # do database connect
    if ( !$Self->Connect() ) {
        return;
    }
    return $Self;
}

=item Connect()

to connect to a database

=cut

sub Connect {
    my $Self = shift;

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'debug',
            Message =>
                "DB.pm->Connect: DSN: $Self->{DSN}, User: $Self->{USER}, Pw: $Self->{PW}, DB Type: $Self->{'DB::Type'};",
        );
    }

    # db connect
    $Self->{dbh} = DBI->connect(
        $Self->{DSN},
        $Self->{USER},
        $Self->{PW},
        $Self->{Backend}->{'DB::Attribute'},
    );
    if ( !$Self->{dbh} ) {
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'Error',
            Message  => $DBI::errstr,
        );
        return;
    }
    if ( $Self->{Backend}->{'DB::Connect'} ) {
        $Self->Do( SQL => $Self->{Backend}->{'DB::Connect'} );
    }
    return $Self->{dbh};
}

=item Disconnect()

to disconnect to a database

=cut

sub Disconnect {
    my $Self = shift;

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'debug',
            Message  => "DB.pm->Disconnect",
        );
    }

    # do disconnect
    if ( $Self->{dbh} ) {
        $Self->{dbh}->disconnect();
    }
    return 1;
}

=item Quote()

to quote sql params

    quote strings, date and time:
    =============================
    my $DBString = $DBObject->Quote( "This isn't a problem!" );

    my $DBString = $DBObject->Quote( "2005-10-27 20:15:01" );

    quote integers:
    ===============
    my $DBString = $DBObject->Quote( 1234, 'Integer' );

    quote numbers (e. g. 1, 1.4, 42342.23424):
    ==========================================
    my $DBString = $DBObject->Quote( 1234, 'Number' );

=cut

sub Quote {
    my ( $Self, $Text, $Type ) = @_;

    if ( !defined $Text ) {
        return;
    }

    # do quote string
    if ( !defined $Type ) {
        return ${ $Self->{Backend}->Quote( \$Text ) };
    }

    # do quote integer
    if ( $Type && $Type eq 'Integer' ) {
        if ( $Text !~ /^(\+|\-|)\d{1,16}$/ ) {
            $Self->{LogObject}->Log(
                Caller   => 1,
                Priority => 'error',
                Message  => "Invalid integer in query '$Text'!",
            );
            return '';
        }
        return $Text;
    }

    # numbers
    if ( $Type && $Type eq 'Number' ) {
        if ( $Text !~ /^(\+|\-|)(\d{1,20}|\d{1,20}\.\d{1,20})$/ ) {
            $Self->{LogObject}->Log(
                Caller   => 1,
                Priority => 'error',
                Message  => "Invalid number in query '$Text'!",
            );
            return '';
        }
        return $Text;
    }

    # do quote like string
    if ( $Type && $Type eq 'Like' ) {
        return ${ $Self->{Backend}->Quote( \$Text, $Type ) };
    }

    $Self->{LogObject}->Log(
        Caller   => 1,
        Priority => 'error',
        Message  => "Invalid quote type '$Type'!",
    );
    return '';
}

=item Error()

to get database errors back

    my $ErrorMessage = $DBObject->Error();

=cut

sub Error {
    my $Self = shift;

    return $DBI::errstr;
}

=item Do()

to insert, update or delete something

    $DBObject->Do( SQL => "INSERT INTO table (name) VALUES ('dog')" );

    $DBObject->Do( SQL => "DELETE FROM table" );

    you also can use DBI bind values (used for large strings):

    my $Var1 = 'dog1';
    my $Var2 = 'dog2';

    $DBObject->Do(
        SQL  => "INSERT INTO table (name1, name2) VALUES (?, ?)",
        Bind => [ \$Var1, \$Var2 ],
    );

=cut

sub Do {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SQL} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need SQL!' );
        return;
    }

    # check bind params
    my @Array = ();
    if ( $Param{Bind} ) {
        for my $Data ( @{ $Param{Bind} } ) {
            if ( ref $Data eq 'SCALAR' ) {
                push @Array, $$Data;
            }
            else {
                $Self->{LogObject}->Log(
                    Caller   => 1,
                    Priority => 'Error',
                    Message  => 'No SCALAR param in Bind!',
                );
                return;
            }
        }
    }
    if ( !$Self->{ConfigObject}->Get('TimeZone') ) {

        # doing timestamp workaround (if needed)
        if ( $Self->{Backend}->{'DB::CurrentTimestamp'} ) {
            $Param{SQL} =~ s/current_timestamp/$Self->{Backend}->{'DB::CurrentTimestamp'}/g;
        }
    }
    else {

        # replace current_timestamp
        my $Timestamp = $Self->{TimeObject}->CurrentTimestamp();
        $Param{SQL} =~ s/(\s|\(|,| )current_timestamp(\s|\)|,| )/$1'$Timestamp'$2/g;
    }

    # debug
    if ( $Self->{Debug} > 0 ) {
        $Self->{DoCounter}++;
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'debug',
            Message  => "DB.pm->Do ($Self->{DoCounter}) SQL: '$Param{SQL}'",
        );
    }

    # check length, don't use more the 4 k
    use bytes;
    if ( length( $Param{SQL} ) > 4 * 1024 ) {
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => 'Your SQL is longer the 4k, this probably not work on many '
                . 'databases (use Bind instead)!',
        );
    }
    no bytes;

    # send sql to database
    if ( !$Self->{dbh}->do( $Param{SQL}, undef, @Array ) ) {
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'Error',
            Message  => "$DBI::errstr, SQL: '$Param{SQL}'",
        );
        return;
    }
    return 1;
}

=item Prepare()

to send a select something to the database

    $DBObject->Prepare(
        SQL   => "SELECT id, name FROM table",
        Limit => 10,
    );

or in case you want just to get row 10 till 30

    $DBObject->Prepare(
        SQL   => "SELECT id, name FROM table",
        Start => 10,
        Limit => 20,
    );

in case you wan't not utf-8 encoding for some column use this to do
not encode content column

    $DBObject->Prepare(
        SQL    => "SELECT id, name, content FROM table",
        Encode => [ 1, 1, 0 ],
    );

you also can use DBI bind values (used for large strings):

    my $Var1 = 'dog1';
    my $Var2 = 'dog2';

    $DBObject->Do(
        SQL    => "SELECT id, name, content FROM table WHERE name_a = ? AND name_b = ?",
        Encode => [ 1, 1, 0 ],
        Bind   => [ \$Var1, \$Var2 ],
    );

=cut

sub Prepare {
    my ( $Self, %Param ) = @_;

    my $SQL   = $Param{SQL};
    my $Limit = $Param{Limit} || '';
    my $Start = $Param{Start} || '';

    # check needed stuff
    if ( !$Param{SQL} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need SQL!' );
        return;
    }
    if ( defined( $Param{Encode} ) ) {
        $Self->{Encode} = $Param{Encode};
    }
    else {
        $Self->{Encode} = undef;
    }
    $Self->{Limit}        = 0;
    $Self->{LimitStart}   = 0;
    $Self->{LimitCounter} = 0;

    # build finally select query
    if ($Limit) {
        if ($Start) {
            $Limit = $Limit + $Start;
            $Self->{LimitStart} = $Start;
        }
        if ( $Self->{Backend}->{'DB::Limit'} eq 'limit' ) {
            $SQL .= " LIMIT $Limit";
        }
        elsif ( $Self->{Backend}->{'DB::Limit'} eq 'fetch' ) {
            $SQL .= " fetch $Limit first row";
        }
        else {
            $Self->{Limit} = $Limit;
        }
    }

    # debug
    if ( $Self->{Debug} > 1 ) {
        $Self->{PrepareCounter}++;
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'debug',
            Message  => "DB.pm->Prepare ($Self->{PrepareCounter}/" . time() . ") SQL: '$SQL'",
        );
    }

    # slow log feature
    my $LogTime;
    if ( $Self->{SlowLog} ) {
        $LogTime = time();
    }

    # check bind params
    my @Array = ();
    if ( $Param{Bind} ) {
        for my $Data ( @{ $Param{Bind} } ) {
            if ( ref $Data eq 'SCALAR' ) {
                push @Array, $$Data;
            }
            else {
                $Self->{LogObject}->Log(
                    Caller   => 1,
                    Priority => 'Error',
                    Message  => 'No SCALAR param in Bind!',
                );
                return;
            }
        }
    }

    # do
    if ( !( $Self->{Cursor} = $Self->{dbh}->prepare($SQL) ) ) {
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'Error',
            Message  => "$DBI::errstr, SQL: '$SQL'",
        );
        return;
    }

    if ( !$Self->{Cursor}->execute(@Array) ) {
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'Error',
            Message  => "$DBI::errstr, SQL: '$SQL'",
        );
        return;
    }

    # slow log feature
    if ( $Self->{SlowLog} ) {
        my $LogTimeTaken = time() - $LogTime;
        if ( $LogTimeTaken > 4 ) {
            $Self->{LogObject}->Log(
                Caller   => 1,
                Priority => 'error',
                Message  => "Slow ($LogTimeTaken s) SQL: '$SQL'",
            );
        }
    }
    return 1;
}

=item FetchrowArray()

to get a select return

    $DBObject->Prepare(
        SQL   => "SELECT id, name FROM table",
        Limit => 10
    );

    while (my @Row = $DBObject->FetchrowArray()) {
        print "$Row[0]:$Row[1]\n";
    }

=cut

sub FetchrowArray {
    my $Self = shift;

    # work with cursors if database don't support limit
    if ( !$Self->{Backend}->{'DB::Limit'} && $Self->{Limit} ) {
        if ( $Self->{Limit} <= $Self->{LimitCounter} ) {
            $Self->{Cursor}->finish();
            return;
        }
        $Self->{LimitCounter}++;
    }

    # fetch first not used rows
    if ( $Self->{LimitStart} ) {
        for ( 1 .. $Self->{LimitStart} ) {
            if ( !$Self->{Cursor}->fetchrow_array() ) {
                $Self->{LimitStart} = 0;
                return ();
            }
            $Self->{LimitCounter}++;
        }
        $Self->{LimitStart} = 0;
    }

    # return
    my @Row = $Self->{Cursor}->fetchrow_array();

    if ( !$Self->{Backend}->{'DB::Encode'} ) {
        return @Row;
    }

    # e. g. set utf-8 flag
    my $Counter = 0;
    ELEMENT:
    for my $Element (@Row) {
        if ( !$Element ) {
            next ELEMENT;
        }

        if ( !defined( $Self->{Encode} ) || ( $Self->{Encode} && $Self->{Encode}->[$Counter] ) ) {
            $Self->{EncodeObject}->Encode( \$Element );
        }
    }
    continue {
        $Counter++;
    }

    return @Row;
}

=item FetchrowArrayOnce()

return the records of SELECT statement

    my @Results = $DBObject->FetchrowArrayOnce(
        SQL   => "SELECT id, name FROM table",
        Limit => 10
    );

=cut

sub FetchrowArrayOnce {
    my ( $Self, %Param ) = @_;

    return if !$Self->Prepare(%Param);

    my @Records;
    while ( my @Row = $Self->FetchrowArray() ) {
        push @Records, \@Row;
    }
    return @Records;
}

=item GetDatabaseFunction()

to get database functions like
    o Limit
    o DirectBlob
    o QuoteSingle
    o QuoteBack
    o QuoteSemicolon
    o NoLikeInLargeText
    o CurrentTimestamp
    o Encode
    o Comment
    o ShellCommit
    o ShellConnect
    o Connect

    my $What = $DBObject->GetDatabaseFunction('DirectBlob');

=cut

sub GetDatabaseFunction {
    my ( $Self, $What ) = @_;

    return $Self->{Backend}->{ 'DB::' . $What };
}

=item SQLProcessor()

generate database based sql syntax (e. g. CREATE TABLE ...)

    my @SQL = $DBObject->SQLProcessor(
        Database =>
            [
                Tag  => 'TableCreate',
                Name => 'table_name',
            ],
            [
                Tag  => 'Column',
                Name => 'col_name',
                Type => 'VARCHAR',
                Size => 150,
            ],
            [
                Tag  => 'Column',
                Name => 'col_name2',
                Type => 'INTEGER',
            ],
            [
                Tag => 'TableEnd',
            ],
    );

=cut

sub SQLProcessor {
    my ( $Self, %Param ) = @_;

    my @SQL = ();
    if ( $Param{Database} && ref $Param{Database} eq 'ARRAY' ) {
        my @Table = ();
        for my $Tag ( @{ $Param{Database} } ) {

            # create table
            if ( $Tag->{Tag} eq 'Table' || $Tag->{Tag} eq 'TableCreate' ) {
                if ( $Tag->{TagType} eq 'Start' ) {
                    $Self->_NameCheck($Tag);
                }
                push @Table, $Tag;
                if ( $Tag->{TagType} eq 'End' ) {
                    push @SQL, $Self->{Backend}->TableCreate(@Table);
                    @Table = ();
                }
            }

            # unique
            elsif (
                $Tag->{Tag}    eq 'Unique'
                || $Tag->{Tag} eq 'UniqueCreate'
                || $Tag->{Tag} eq 'UniqueDrop'
                )
            {
                push @Table, $Tag;
            }

            #            elsif ( $Tag->{Tag} eq 'UniqueColumn' && $Tag->{TagType} eq 'Start' ) {
            elsif ( $Tag->{Tag} eq 'UniqueColumn' ) {
                push @Table, $Tag;
            }

            # index
            elsif (
                $Tag->{Tag}    eq 'Index'
                || $Tag->{Tag} eq 'IndexCreate'
                || $Tag->{Tag} eq 'IndexDrop'
                )
            {
                push @Table, $Tag;
            }

            #            elsif ( $Tag->{Tag} eq 'IndexColumn' && $Tag->{TagType} eq 'Start' ) {
            elsif ( $Tag->{Tag} eq 'IndexColumn' ) {
                push @Table, $Tag;
            }

            # foreign keys
            elsif (
                $Tag->{Tag}    eq 'ForeignKey'
                || $Tag->{Tag} eq 'ForeignKeyCreate'
                || $Tag->{Tag} eq 'ForeignKeyDrop'
                )
            {
                push @Table, $Tag;
            }
            elsif ( $Tag->{Tag} eq 'Reference' && $Tag->{TagType} eq 'Start' ) {
                push @Table, $Tag;
            }

            # alter table
            elsif ( $Tag->{Tag} eq 'TableAlter' ) {
                push @Table, $Tag;
                if ( $Tag->{TagType} eq 'End' ) {
                    push @SQL, $Self->{Backend}->TableAlter(@Table);
                    @Table = ();
                }
            }

            # column
            elsif ( $Tag->{Tag} eq 'Column' && $Tag->{TagType} eq 'Start' ) {

                # type check
                $Self->_TypeCheck($Tag);
                push @Table, $Tag;
            }
            elsif ( $Tag->{Tag} eq 'ColumnAdd' && $Tag->{TagType} eq 'Start' ) {

                # type check
                $Self->_TypeCheck($Tag);
                push @Table, $Tag;
            }
            elsif ( $Tag->{Tag} eq 'ColumnChange' && $Tag->{TagType} eq 'Start' ) {

                # type check
                $Self->_TypeCheck($Tag);
                push @Table, $Tag;
            }
            elsif ( $Tag->{Tag} eq 'ColumnDrop' && $Tag->{TagType} eq 'Start' ) {

                # type check
                $Self->_TypeCheck($Tag);
                push @Table, $Tag;
            }

            # drop table
            elsif ( $Tag->{Tag} eq 'TableDrop' && $Tag->{TagType} eq 'Start' ) {
                push @Table, $Tag;
                push @SQL,   $Self->{Backend}->TableDrop(@Table);
                @Table = ();
            }

            # insert
            elsif ( $Tag->{Tag} eq 'Insert' ) {
                push @Table, $Tag;
                if ( $Tag->{TagType} eq 'End' ) {
                    push @Table, $Tag;
                    push @SQL,   $Self->{Backend}->Insert(@Table);
                    @Table = ();
                }
            }
            elsif ( $Tag->{Tag} eq 'Data' && $Tag->{TagType} eq 'Start' ) {
                push @Table, $Tag;
            }
        }
    }
    return @SQL;
}

=item SQLProcessorPost()

generate database based sql syntax, post data of SQLProcessor(),
e. g. foreign keys

    my @SQL = $DBObject->SQLProcessorPost();

=cut

sub SQLProcessorPost {
    my ( $Self, %Param ) = @_;

    if ( $Self->{Backend}->{Post} ) {
        my @Return = @{ $Self->{Backend}->{Post} };
        undef $Self->{Backend}->{Post};
        return @Return;
    }
    return ();
}

# GetTableData()
#
# !! DONT USE THIS FUNCTION !!
#
# Due to compatibility reason this function is still in use and will be removed
# in a further release.

sub GetTableData {
    my ( $Self, %Param ) = @_;

    my $Table = $Param{Table};
    my $What  = $Param{What};
    my $Where = $Param{Where} || '';
    my $Valid = $Param{Valid} || '';
    my $Clamp = $Param{Clamp} || '';
    my %Data;

    my $SQL = "SELECT $What FROM $Table ";
    $SQL .= ' WHERE ' . $Where if ($Where);

    if ( !$Where && $Valid ) {
        my @ValidIDs;

        $Self->Prepare( SQL => 'SELECT id FROM valid WHERE name = \'valid\'' );
        while ( my @Row = $Self->FetchrowArray() ) {
            push @ValidIDs, $Row[0];
        }

        $SQL .= " WHERE valid_id IN ( ${\(join ', ', @ValidIDs)} )";
    }
    $Self->Prepare( SQL => $SQL );
    while ( my @Row = $Self->FetchrowArray() ) {
        if ( $Row[3] ) {
            if ($Clamp) {
                $Data{ $Row[0] } = "$Row[1] $Row[2] ($Row[3])";
            }
            else {
                $Data{ $Row[0] } = "$Row[1] $Row[2] $Row[3]";
            }
        }
        elsif ( $Row[2] ) {
            if ($Clamp) {
                $Data{ $Row[0] } = "$Row[1] ( $Row[2] )";
            }
            else {
                $Data{ $Row[0] } = "$Row[1] $Row[2]";
            }
        }
        else {
            $Data{ $Row[0] } = $Row[1];
        }
    }
    return %Data;
}

=item QueryCondition()

generate SQL condition query based on a search expration

    my $SQL = $DBObject->QueryCondition(
        Key   => 'some_col',
        Value => '(ABC+DEF)',
    );

    add SearchPrefix and SearchSuffix to search in this case automaticaly
    for "(ABC*+DEF*)"

    my $SQL = $DBObject->QueryCondition(
        Key          => 'some_col',
        Value        => '(ABC+DEF)',
        SearchPrefix => '',
        SearchSuffix => '*'
    );

    example of a more complex search condition

    my $SQL = $DBObject->QueryCondition(
        Key   => 'some_col',
        Value => '((ABC&&DEF)&&!GHI)',
    );

    for a earch condition over more col.

    my $SQL = $DBObject->QueryCondition(
        Key   => [ 'some_col_a', 'some_col_b' ],
        Value => '((ABC&&DEF)&&!GHI)',
    );

=cut

sub QueryCondition {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Key Value)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # search prefix/suffix check
    my $SearchPrefix = $Param{SearchPrefix} || '';
    my $SearchSuffix = $Param{SearchSuffix} || '';

    # remove leading/tailing spaces
    $Param{Value} =~ s/^\s+//g;
    $Param{Value} =~ s/\s+$//g;

    # add base brackets
    if ( $Param{Value} !~ /^\(/ || $Param{Value} !~ /\)$/ ) {
        $Param{Value} = '(' . $Param{Value} . ')';
    }

    # remove double spaces
    $Param{Value} =~ s/\s\s/ /g;

    # replace + by &&
    $Param{Value} =~ s/\+/&&/g;

    # replace AND by &&
    $Param{Value} =~ s/(\s|\)|\()AND(\s|\(|\))/&&/g;

    # replace OR by ||
    $Param{Value} =~ s/(\s|\)|\()OR(\s|\(|\))/||/g;

    # replace * with % (for SQL)
    $Param{Value} =~ s/\*/%/g;

    # remove double %% (also if there is only whitespace in between)
    $Param{Value} =~ s/%\s*%/%/g;

    # replace '%!%' by '!%' (done if * gets added by search frontend)
    $Param{Value} =~ s/\%!\%/!%/g;

    # replace '%!' by '!%' (done if * gets added by search frontend)
    $Param{Value} =~ s/\%!/!%/g;

    # remove leading/tailing conditions
    $Param{Value} =~ s/(&&|\|\|)\)$/)/g;
    $Param{Value} =~ s/^\((&&|\|\|)/(/g;

    # clean up not needed spaces in conditions
    $Param{Value} =~ s/(\s(\(|\)|\||&))/$2/g;
    $Param{Value} =~ s/((\(|\)|\||&)\s)/$2/g;

    # get col.
    my @Keys;
    if ( ref $Param{Key} eq 'ARRAY' ) {
        @Keys = @{ $Param{Key} };
    }
    else {
        @Keys = ( $Param{Key} );
    }

    # for syntax check
    my $Open  = 0;
    my $Close = 0;

    # for processing
    my @Array = split( //, $Param{Value} );
    my $SQL   = '';
    my $Word  = '';
    my $Not   = 0;
    for my $Position ( 0 .. $#Array ) {

        # find word
        if ( $Array[$Position] !~ /(\(|\)|\!|\||&)/ ) {
            $Word .= $Array[$Position];
            next;
        }

        # if word exists, do something with it
        if ($Word) {

            # database quote
            $Word = $SearchPrefix . $Word . $SearchSuffix;
            $Word =~ s/\*/%/g;
            $Word =~ s/%%/%/g;
            $Word =~ s/%%/%/g;
            $Word = $Self->Quote( $Word, 'Like' );

            # if it's a NOT LIKE condition
            if ( $Array[$Position] eq '!' || $Not ) {
                $Not = 0;
                my $SQLA;
                for my $Key (@Keys) {
                    if ($SQLA) {
                        $SQLA .= ' AND ';
                    }

                    # check if database supports LIKE in large text types
                    if ( $Self->GetDatabaseFunction('NoLowerInLargeText') ) {
                        $SQLA .= "$Key NOT LIKE '$Word'";
                    }
                    elsif ( $Self->GetDatabaseFunction('LcaseLikeInLargeText') ) {
                        $SQLA .= "LCASE($Key) NOT LIKE LCASE('$Word')";
                    }
                    else {
                        $SQLA .= "LOWER($Key) NOT LIKE LOWER('$Word')";
                    }
                }
                $SQL .= '(' . $SQLA . ') ';
            }

            # if it's a LIKE condition
            else {
                my $SQLA;
                for my $Key (@Keys) {
                    if ($SQLA) {
                        $SQLA .= ' OR ';
                    }

                    # check if database supports LIKE in large text types
                    if ( $Self->GetDatabaseFunction('NoLowerInLargeText') ) {
                        $SQLA .= "$Key LIKE '$Word'";
                    }
                    elsif ( $Self->GetDatabaseFunction('LcaseLikeInLargeText') ) {
                        $SQLA .= "LCASE($Key) LIKE LCASE('$Word')";
                    }
                    else {
                        $SQLA .= "LOWER($Key) LIKE LOWER('$Word')";
                    }
                }
                $SQL .= '(' . $SQLA . ') ';
            }

            # reset word
            $Word = '';
        }

        # check AND and OR conditions
        if ( $Array[ $Position + 1 ] ) {

            # if it's an AND condition
            if ( $Array[$Position] eq '&' && $Array[ $Position + 1 ] eq '&' ) {
                $SQL .= ' AND ';
            }

            # if it's an OR condition
            elsif ( $Array[$Position] eq '|' && $Array[ $Position + 1 ] eq '|' ) {
                $SQL .= ' OR ';
            }
        }

        # add ( or ) for query
        if ( $Array[$Position] =~ /(\(|\))/ ) {
            $SQL .= $Array[$Position];

            # remember for syntax check
            if ( $1 eq '(' ) {
                $Open++;
            }
            elsif ( $1 eq ')' ) {
                $Close++;
            }
        }

        # remember if it's a NOT condition
        elsif ( $Array[$Position] eq '!' ) {
            $Not = 1;
        }
    }

    # check syntax
    if ( $Open != $Close ) {
        $Self->{LogObject}->Log(
            Priority => 'Error',
            Message  => "Invalid condition '$Param{Value}', $Open open and $Close close!",
        );
        return;
    }
    return $SQL;
}

sub _TypeCheck {
    my ( $Self, $Tag ) = @_;

    if (
        $Tag->{Type}
        && $Tag->{Type} !~ /^(DATE|SMALLINT|BIGINT|INTEGER|DECIMAL|VARCHAR|LONGBLOB)$/i
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'Error',
            Message  => "Unknown data type '$Tag->{Type}'!",
        );
    }
    return 1;
}

sub _NameCheck {
    my ( $Self, $Tag ) = @_;

    if ( $Tag->{Name} && length $Tag->{Name} > 30 ) {
        $Self->{LogObject}->Log(
            Priority => 'Error',
            Message  => "Table names should not have more the 30 chars ($Tag->{Name})!",
        );
    }
    return 1;
}

sub DESTROY {
    my $Self = shift;

    # cleanup open statement handle if there is any and then disconnect from DB
    if ( $Self->{Cursor} ) {
        $Self->{Cursor}->finish();
    }
    $Self->Disconnect();

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.105.2.4 $ $Date: 2011-07-28 22:35:14 $

=cut
