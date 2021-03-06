# --
# Kernel/System/XML.pm - lib xml
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: XML.pm,v 1.83 2009-04-23 13:47:08 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::XML;

use strict;
use warnings;

use Kernel::System::Cache;

use vars qw($VERSION $S);
$VERSION = qw($Revision: 1.83 $) [1];

=head1 NAME

Kernel::System::XML - xml lib

=head1 SYNOPSIS

All xml related functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::XML;

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
    );
    my $XMLObject = Kernel::System::XML->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ConfigObject LogObject DBObject MainObject EncodeObject)) {
        die "Got no $_" if !$Self->{$_};
    }

    $Self->{CacheObject} = Kernel::System::Cache->new( %{$Self} );

    # to access object over non object oriented XML::Parser and XML::Parser::Lite
    $S = $Self;

    return $Self;
}

=item XMLHashAdd()

add a XMLHash to storage

    $XMLObject->XMLHashAdd(
        Type    => 'SomeType',
        Key     => '123',
        XMLHash => \@XMLHash,
    );

    my $Key = $XMLObject->XMLHashAdd(
        Type             => 'SomeType',
        KeyAutoIncrement => 1,
        XMLHash          => \@XMLHash,
    );

=cut

sub XMLHashAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type XMLHash)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !$Param{Key} && !$Param{KeyAutoIncrement} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Key or KeyAutoIncrement param!',
        );
        return;
    }
    my %ValueHASH = $Self->XMLHash2D( XMLHash => $Param{XMLHash} );
    if (%ValueHASH) {
        if ( !$Param{Key} ) {
            $Param{Key} = $Self->_XMLHashAddAutoIncrement(%Param);
        }
        if ( !$Param{Key} ) {
            return;
        }
        $Self->XMLHashDelete(%Param);

        # create rand number
        my $Rand   = int( rand(1000000) );
        my $TmpKey = "TMP-$Rand-$Param{Type}";
        for my $Key ( sort keys %ValueHASH ) {
            $Self->{DBObject}->Do(
                SQL =>
                    'INSERT INTO xml_storage (xml_type, xml_key, xml_content_key, xml_content_value) VALUES (?, ?, ?, ?)',
                Bind => [ \$TmpKey, \$Param{Key}, \$Key, \$ValueHASH{$Key}, ],
            );
        }

        # move new hash if insert is complete
        $Self->XMLHashMove(
            OldType => $TmpKey,
            OldKey  => $Param{Key},
            NewType => $Param{Type},
            NewKey  => $Param{Key},
        );
        return $Param{Key};
    }

    $Self->{LogObject}->Log(
        Priority => 'error',
        Message  => 'Got no %ValueHASH from XMLHash2D()',
    );
    return;
}

sub _XMLHashAddAutoIncrement {
    my ( $Self, %Param ) = @_;

    my $KeyAutoIncrement = 0;
    my @KeysExists;

    # check needed stuff
    for (qw(Type KeyAutoIncrement)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT DISTINCT(xml_key) FROM xml_storage WHERE xml_type = ?',
        Bind => [ \$Param{Type} ],
    );
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        if ( $Data[0] ) {
            push( @KeysExists, $Data[0] );
        }
    }
    for my $Key (@KeysExists) {
        if ( $Key !~ /^\d{1,99}$/ ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No KeyAutoIncrement possible, no int key exists ($Key)!",
            );
            return;
        }
        if ( $Key > $KeyAutoIncrement ) {
            $KeyAutoIncrement = $Key;
        }
    }

    $KeyAutoIncrement++;
    return $KeyAutoIncrement;
}

=item XMLHashUpdate()

update an XMLHash part to storage

    $XMLHash[1]->{Name}->[1]->{Content} = 'Some Name';

    $XMLObject->XMLHashUpdate(
        Type    => 'SomeType',
        Key     => '123',
        XMLHash => \@XMLHash,
    );

=cut

sub XMLHashUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type Key XMLHash)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    return $Self->XMLHashAdd(%Param);
}

=item XMLHashGet()

get a XMLHash from database

    my @XMLHash = $XMLObject->XMLHashGet(
        Type => 'SomeType',
        Key  => '123',
    );

    my @XMLHash = $XMLObject->XMLHashGet(
        Type  => 'SomeType',
        Key   => '123',
        Cache => 0, # do not use the file system cache
    );

=cut

sub XMLHashGet {
    my ( $Self, %Param ) = @_;

    my $Content = '';
    my @XMLHash = ();

    # check needed stuff
    for (qw(Type Key)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !defined( $Param{Cache} ) ) {
        $Param{Cache} = 1;
    }

    # read cache
    if ( $Param{Cache} ) {
        my $Cache = $Self->{CacheObject}->Get(
            Type => 'XML',
            Key  => "$Param{Type}-$Param{Key}",
        );
        if ($Cache) {
            return @{$Cache};
        }
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT xml_content_key, xml_content_value '
            . ' FROM xml_storage WHERE xml_type = ? AND xml_key = ?',
        Bind => [ \$Param{Type}, \$Param{Key} ],

    );
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        if ( defined( $Data[1] ) ) {
            $Data[1] =~ s/\\/\\\\/g;
            $Data[1] =~ s/'/\\'/g;
        }
        else {
            $Data[1] = '';
        }
        $Content .= '$XMLHash' . $Data[0] . " = '$Data[1]';\n 1;\n";
    }
    if ( $Content && !eval $Content ) {
        print STDERR "ERROR: XML.pm $@\n";
    }

    # write cache file
    if ( $Param{Cache} && $Content ) {
        $Self->{CacheObject}->Set(
            Type  => 'XML',
            Key   => "$Param{Type}-$Param{Key}",
            Value => \@XMLHash,
            TTL   => 24 * 60 * 60,
        );
    }
    return @XMLHash;
}

=item XMLHashDelete()

delete a XMLHash from database

    $XMLObject->XMLHashDelete(
        Type => 'SomeType',
        Key  => '123',
    );

=cut

sub XMLHashDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type Key)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # remove cache
    $Self->{CacheObject}->Delete(
        Type => 'XML',
        Key  => "$Param{Type}-$Param{Key}",
    );

    return $Self->{DBObject}->Do(
        SQL => 'DELETE FROM xml_storage WHERE xml_type = ? AND xml_key = ?',
        Bind => [ \$Param{Type}, \$Param{Key} ],
    );
}

=item XMLHashMove()

move a XMLHash from one type or/and key to another

    $XMLObject->XMLHashMove(
        OldType => 'SomeType',
        OldKey  => '123',
        NewType => 'NewType',
        NewKey  => '321',
    );

=cut

sub XMLHashMove {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(OldType OldKey NewType NewKey)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # remove cache
    $Self->{CacheObject}->Delete(
        Type => 'XML',
        Key  => "$Param{OldType}-$Param{OldKey}",
    );
    $Self->{CacheObject}->Delete(
        Type => 'XML',
        Key  => "$Param{NewType}-$Param{NewKey}",
    );

    # delete existing xml hash
    $Self->{DBObject}->Do(
        SQL => 'DELETE FROM xml_storage WHERE xml_type = ? AND xml_key = ?',
        Bind => [ \$Param{NewType}, \$Param{NewKey} ],
    );

    # update xml hash
    return $Self->{DBObject}->Do(
        SQL => 'UPDATE xml_storage SET xml_type = ?, xml_key = ? '
            . 'WHERE xml_type = ? AND xml_key = ?',
        Bind => [ \$Param{NewType}, \$Param{NewKey}, \$Param{OldType}, \$Param{OldKey} ],
    );
}

=item XMLHashSearch()

search a xml hash from database

    my @Keys = $XMLObject->XMLHashSearch(
        Type => 'SomeType',
        What => [
            # each array element is a and condition
            {
                # or condition in hash
                "[%]{'ElementA'}[%]{'ElementB'}[%]{'Content'}" => '%contentA%',
                "[%]{'ElementA'}[%]{'ElementC'}[%]{'Content'}" => '%contentA%',
            },
            {
                "[%]{'ElementA'}[%]{'ElementB'}[%]{'Content'}" => '%contentB%',
                "[%]{'ElementA'}[%]{'ElementC'}[%]{'Content'}" => '%contentB%',
            },
            {
                # use array reference if different content with same key was searched
                "[%]{'ElementA'}[%]{'ElementB'}[%]{'Content'}" => ['%contentC%', '%contentD%', '%contentE%'],
                "[%]{'ElementA'}[%]{'ElementC'}[%]{'Content'}" => ['%contentC%', '%contentD%', '%contentE%'],
            },
        ],
    );

=cut

sub XMLHashSearch {
    my ( $Self, %Param ) = @_;

    my @Keys    = ();
    my %Hash    = ();
    my %HashNew = ();

    # check needed stuff
    if ( !$Param{Type} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Type!' );
        return;
    }

    $Self->{DBObject}->Prepare(
        SQL  => 'SELECT DISTINCT(xml_key) FROM xml_storage WHERE xml_type = ? GROUP BY xml_key',
        Bind => [ \$Param{Type} ],
    );
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $Hash{ $Data[0] } = 1;
    }

    if ( $Param{What} && ref( $Param{What} ) eq 'ARRAY' ) {
        for my $And ( @{ $Param{What} } ) {
            my %HashNew = ();
            my $SQL     = '';
            for my $Key ( sort keys %{$And} ) {
                my $Value = $Self->{DBObject}->Quote( $And->{$Key} );
                $Key = $Self->{DBObject}->Quote( $Key, 'Like' );
                if ( $Value && ref($Value) eq 'ARRAY' ) {
                    for my $Element ( @{$Value} ) {
                        $Element = $Self->{DBObject}->Quote( $Element, 'Like' );
                        if ($SQL) {
                            $SQL .= ' OR ';
                        }
                        $SQL
                            .= " (xml_content_key LIKE '$Key' AND xml_content_value LIKE '$Element')";
                    }
                }
                else {
                    $Value = $Self->{DBObject}->Quote( $Value, 'Like' );
                    if ($SQL) {
                        $SQL .= ' OR ';
                    }
                    $SQL .= " (xml_content_key LIKE '$Key' AND xml_content_value LIKE '$Value')";
                }
            }
            $Self->{DBObject}->Prepare(
                SQL =>
                    "SELECT DISTINCT(xml_key) FROM xml_storage WHERE $SQL AND xml_type = ? GROUP BY xml_key",
                Bind => [ \$Param{Type} ],
            );
            while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
                if ( $Hash{ $Data[0] } ) {
                    $HashNew{ $Data[0] } = 1;
                }
            }
            %Hash = %HashNew;
        }
    }
    for my $Key ( keys %Hash ) {
        push @Keys, $Key;
    }
    return @Keys;
}

=item XMLHashList()

a list of xml hash's in database

    my @Keys = $XMLObject->XMLHashList(
        Type => 'SomeType',
    );

=cut

sub XMLHashList {
    my ( $Self, %Param ) = @_;

    my @Keys = ();

    # check needed stuff
    if ( !$Param{Type} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Type!' );
        return;
    }

    $Self->{DBObject}->Prepare(
        SQL  => 'SELECT distinct(xml_key) FROM xml_storage WHERE xml_type = ? GROUP BY xml_key',
        Bind => [ \$Param{Type} ],
    );
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @Keys, $Data[0];
    }

    return @Keys;
}

=item XMLHash2XML()

generate a xml string from a XMLHash

    my $XMLString = $XMLObject->XMLHash2XML(@XMLHash);

=cut

sub XMLHash2XML {
    my ( $Self, @XMLHash ) = @_;

    my $Output = '<?xml version="1.0" encoding="'
        . $Self->{ConfigObject}->Get('DefaultCharset')
        . '"?>' . "\n";

    $Self->{XMLHash2XMLLayer} = 0;
    for my $Key (@XMLHash) {
        $Output .= $Self->_ElementBuild( %{$Key} );
    }
    return $Output;
}

sub _ElementBuild {
    my ( $Self, %Param ) = @_;

    my @Tag    = ();
    my @Sub    = ();
    my $Output = '';
    if ( $Param{Key} ) {
        $Self->{XMLHash2XMLLayer}++;
        for ( 2 .. $Self->{XMLHash2XMLLayer} ) {

            #            $Output .= "  ";
        }
        $Output .= "<$Param{Key}";
    }
    for ( sort keys %Param ) {
        if ( ref( $Param{$_} ) eq 'ARRAY' ) {
            push( @Tag, $_ );
            push( @Sub, $Param{$_} );
        }
        elsif ( $_ ne 'Content' && $_ ne 'Key' && $_ !~ /^Tag/ ) {
            if ( defined( $Param{$_} ) ) {
                $Param{$_} =~ s/&/&amp;/g;
                $Param{$_} =~ s/</&lt;/g;
                $Param{$_} =~ s/>/&gt;/g;
                $Param{$_} =~ s/"/&quot;/g;
            }
            $Output .= " $_=\"$Param{$_}\"";
        }
    }
    if ( $Param{Key} ) {
        $Output .= '>';
    }
    if ( defined( $Param{Content} ) ) {

        # encode
        $Param{Content} =~ s/&/&amp;/g;
        $Param{Content} =~ s/</&lt;/g;
        $Param{Content} =~ s/>/&gt;/g;
        $Param{Content} =~ s/"/&quot;/g;
        $Output .= $Param{Content};
    }
    else {
        $Output .= "\n";
    }
    for ( 0 .. $#Sub ) {
        for my $K ( @{ $Sub[$_] } ) {
            if ( defined($K) ) {
                $Output .= $Self->_ElementBuild( %{$K}, Key => $Tag[$_], );
            }
        }
    }

    if ( $Param{Key} ) {

        #        if (!$Param{Content}) {
        #            for (2..$Self->{XMLHash2XMLLayer}) {
        #                $Output .= "  ";
        #            }
        #        }
        $Output .= "</$Param{Key}>\n";
        $Self->{XMLHash2XMLLayer} = $Self->{XMLHash2XMLLayer} - 1;
    }
    return $Output;
}

=item XMLParse2XMLHash()

parse a xml file and return a XMLHash structur

    my @XMLHash = $XMLObject->XMLParse2XMLHash( String => $FileString );

    XML:
    ====
    <Contact role="admin" type="organization">
        <Name type="long">Example Inc.</Name>
        <Email type="primary">info@exampe.com<Domain>1234.com</Domain></Email>
        <Email type="secundary">sales@example.com</Email>
        <Telephone country="germany">+49-999-99999</Telephone>
    </Contact>

    ARRAY:
    ======
    @XMLHash = (
        undef,
        {
            Contact => [
                undef,
                {
                    role => 'admin',
                    type => 'organization',
                    Name => [
                        undef,
                        {
                            Content => 'Example Inc.',
                            type => 'long',
                        },
                    ],
                    Email => [
                        undef,
                        {
                            type => 'primary',
                            Content => 'info@exampe.com',
                            Domain => [
                                undef,
                                {
                                    Content => '1234.com',
                                },
                            ],
                        },
                        {
                            type => 'secundary',
                            Content => 'sales@exampe.com',
                        },
                    ],
                    Telephone => [
                        undef,
                        {
                            country => 'germany',
                            Content => '+49-999-99999',
                        },
                    ],
                }
            ],
        }
    );

    $XMLHash[1]{Contact}[1]{TagKey} = "[1]{'Contact'}[1]";
    $XMLHash[1]{Contact}[1]{role} = "admin";
    $XMLHash[1]{Contact}[1]{type} = "organization";
    $XMLHash[1]{Contact}[1]{Name}[1]{TagKey} = "[1]{'Contact'}[1]{'Name'}[1]";
    $XMLHash[1]{Contact}[1]{Name}[1]{Content} = "Example Inc.";
    $XMLHash[1]{Contact}[1]{Name}[1]{type} = "long";
    $XMLHash[1]{Contact}[1]{Email}[1]{TagKey} = "[1]{'Contact'}[1]{'Email'}[1]";
    $XMLHash[1]{Contact}[1]{Email}[1]{Content} = "info\@exampe.com";
    $XMLHash[1]{Contact}[1]{Email}[1]{Domain}[1]{TagKey} = "[1]{'Contact'}[1]{'Email'}[1]{'Domain'}[1]";
    $XMLHash[1]{Contact}[1]{Email}[1]{Domain}[1]{Content} = "1234.com";
    $XMLHash[1]{Contact}[1]{Email}[2]{TagKey} = "[1]{'Contact'}[1]{'Email'}[2]";
    $XMLHash[1]{Contact}[1]{Email}[2]{type} = "secundary";
    $XMLHash[1]{Contact}[1]{Email}[2]{Content} = "sales\@exampe.com";

=cut

sub XMLParse2XMLHash {
    my ( $Self, %Param ) = @_;

    my @XMLStructure = $Self->XMLParse(%Param);
    return () if !@XMLStructure;

    my @XMLHash = ( undef, $Self->XMLStructure2XMLHash( XMLStructure => \@XMLStructure ) );
    return @XMLHash;

}

=item XMLHash2D()

return a hash with long hash key and content

    my %Hash = $XMLObject->XMLHash2D(XMLHash => \@XMLHash);

    for example:

    $Hash{"[1]{'Planet'}[1]{'Content'}"'} = 'Sun';

=cut

sub XMLHash2D {
    my ( $Self, %Param ) = @_;

    my @NewXMLStructure;

    # check needed stuff
    if ( !defined $Param{XMLHash} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'XMLHash not defined!' );
        return;
    }

    $Self->{XMLLevel}      = 0;
    $Self->{XMLTagCount}   = 0;
    $Self->{XMLHash}       = {};
    $Self->{XMLHashReturn} = 1;
    undef $Self->{XMLLevelTag};
    undef $Self->{XMLLevelCount};
    my $Count = 0;
    for my $Item ( @{ $Param{XMLHash} } ) {
        if ( ref($Item) eq 'HASH' ) {
            for ( keys %{$Item} ) {
                $Self->_XMLHash2D( Key => $Item->{Tag}, Item => $Item, Counter => $Count );
            }
        }
        $Count++;
    }
    $Self->{XMLHashReturn} = 0;
    return %{ $Self->{XMLHash} };
}

sub _XMLHash2D {
    my ( $Self, %Param ) = @_;

    if ( !defined( $Param{Item} ) ) {
        return '';
    }
    elsif ( ref( $Param{Item} ) eq 'HASH' ) {
        $S->{XMLLevel}++;
        $S->{XMLTagCount}++;
        $S->{XMLLevelTag}->{ $S->{XMLLevel} } = $Param{Key};
        if ( $S->{Tll} && $S->{Tll} > $S->{XMLLevel} ) {
            for ( ( $S->{XMLLevel} + 1 ) .. 30 ) {
                undef $S->{XMLLevelCount}->{$_};    #->{$Element} = 0;
            }
        }
        $S->{XMLLevelCount}->{ $S->{XMLLevel} }->{ $Param{Key} || '' }++;

        # remember old level
        $S->{Tll} = $S->{XMLLevel};

        my $Key = "[$Param{Counter}]";
        for ( 2 .. ( $S->{XMLLevel} ) ) {
            $Key .= "{'$S->{XMLLevelTag}->{$_}'}";
            $Key .= "[" . $S->{XMLLevelCount}->{$_}->{ $S->{XMLLevelTag}->{$_} } . "]";
        }
        $Param{Item}->{TagKey} = $Key;
        for ( keys %{ $Param{Item} } ) {
            if ( defined( $Param{Item}->{$_} ) && ref( $Param{Item}->{$_} ) ne 'ARRAY' ) {
                $Self->{XMLHash}->{ $Key . "{'$_'}" } = $Param{Item}->{$_};
            }
            $Self->_XMLHash2D( Key => $_, Item => $Param{Item}->{$_}, Counter => $Param{Counter} );
        }
        $S->{XMLLevel} = $S->{XMLLevel} - 1;
    }
    elsif ( ref( $Param{Item} ) eq 'ARRAY' ) {
        for ( @{ $Param{Item} } ) {
            $Self->_XMLHash2D( Key => $Param{Key}, Item => $_, Counter => $Param{Counter} );
        }
    }

    return 1;
}

=item XMLStructure2XMLHash()

get a @XMLHash from a @XMLStructure with current TagKey param

    my @XMLHash = $XMLObject->XMLStructure2XMLHash(XMLStructure => \@XMLStructure);

=cut

sub XMLStructure2XMLHash {
    my ( $Self, %Param ) = @_;

    my @NewXMLStructure;

    # check needed stuff
    if ( !defined $Param{XMLStructure} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'XMLStructure not defined!' );
        return;
    }

    $Self->{Tll}           = 0;
    $Self->{XMLTagCount}   = 0;
    $Self->{XMLHash2}      = {};
    $Self->{XMLHashReturn} = 1;
    undef $Self->{XMLLevelTag};
    undef $Self->{XMLLevelCount};

    for my $Item ( @{ $Param{XMLStructure} } ) {
        if ( ref($Item) eq 'HASH' ) {
            $Self->_XMLStructure2XMLHash( Key => $Item->{Tag}, Item => $Item, Type => 'ARRAY' );
        }
    }
    $Self->{XMLHashReturn} = 0;
    return ( \%{ $Self->{XMLHash2} } );
}

sub _XMLStructure2XMLHash {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    if ( !defined( $Param{Item} ) ) {
        return;
    }
    elsif ( ref( $Param{Item} ) eq 'HASH' ) {
        if ( $Param{Item}->{TagType} eq 'End' ) {
            return '';
        }
        $S->{XMLTagCount}++;
        $S->{XMLLevelTag}->{ $Param{Item}->{TagLevel} } = $Param{Key};
        if ( $S->{Tll} && $S->{Tll} > $Param{Item}->{TagLevel} ) {
            for ( ( $Param{Item}->{TagLevel} + 1 ) .. 30 ) {
                undef $S->{XMLLevelCount}->{$_};
            }
        }
        $S->{XMLLevelCount}->{ $Param{Item}->{TagLevel} }->{ $Param{Key} }++;

        # remember old level
        $S->{Tll} = $Param{Item}->{TagLevel};

        if ( $Param{Item}->{TagLevel} == 1 ) {
            for ( keys %{ $Param{Item} } ) {
                if ( !defined( $Param{Item}->{$_} ) ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $S->{XMLLevelTag}->{1} }
                        ->[ $S->{XMLLevelCount}->{1}->{ $S->{XMLLevelTag}->{1} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 2 ) {
            for ( keys %{ $Param{Item} } ) {
                if ( !defined( $Param{Item}->{$_} ) ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $S->{XMLLevelTag}->{1} }
                        ->[ $S->{XMLLevelCount}->{1}->{ $S->{XMLLevelTag}->{1} } ]
                        ->{ $S->{XMLLevelTag}->{2} }
                        ->[ $S->{XMLLevelCount}->{2}->{ $S->{XMLLevelTag}->{2} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 3 ) {
            for ( keys %{ $Param{Item} } ) {
                if ( !defined( $Param{Item}->{$_} ) ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $S->{XMLLevelTag}->{1} }
                        ->[ $S->{XMLLevelCount}->{1}->{ $S->{XMLLevelTag}->{1} } ]
                        ->{ $S->{XMLLevelTag}->{2} }
                        ->[ $S->{XMLLevelCount}->{2}->{ $S->{XMLLevelTag}->{2} } ]
                        ->{ $S->{XMLLevelTag}->{3} }
                        ->[ $S->{XMLLevelCount}->{3}->{ $S->{XMLLevelTag}->{3} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 4 ) {
            for ( keys %{ $Param{Item} } ) {
                if ( !defined( $Param{Item}->{$_} ) ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $S->{XMLLevelTag}->{1} }
                        ->[ $S->{XMLLevelCount}->{1}->{ $S->{XMLLevelTag}->{1} } ]
                        ->{ $S->{XMLLevelTag}->{2} }
                        ->[ $S->{XMLLevelCount}->{2}->{ $S->{XMLLevelTag}->{2} } ]
                        ->{ $S->{XMLLevelTag}->{3} }
                        ->[ $S->{XMLLevelCount}->{3}->{ $S->{XMLLevelTag}->{3} } ]
                        ->{ $S->{XMLLevelTag}->{4} }
                        ->[ $S->{XMLLevelCount}->{4}->{ $S->{XMLLevelTag}->{4} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 5 ) {
            for ( keys %{ $Param{Item} } ) {
                if ( !defined( $Param{Item}->{$_} ) ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $S->{XMLLevelTag}->{1} }
                        ->[ $S->{XMLLevelCount}->{1}->{ $S->{XMLLevelTag}->{1} } ]
                        ->{ $S->{XMLLevelTag}->{2} }
                        ->[ $S->{XMLLevelCount}->{2}->{ $S->{XMLLevelTag}->{2} } ]
                        ->{ $S->{XMLLevelTag}->{3} }
                        ->[ $S->{XMLLevelCount}->{3}->{ $S->{XMLLevelTag}->{3} } ]
                        ->{ $S->{XMLLevelTag}->{4} }
                        ->[ $S->{XMLLevelCount}->{4}->{ $S->{XMLLevelTag}->{4} } ]
                        ->{ $S->{XMLLevelTag}->{5} }
                        ->[ $S->{XMLLevelCount}->{5}->{ $S->{XMLLevelTag}->{5} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 6 ) {
            for ( keys %{ $Param{Item} } ) {
                if ( !defined( $Param{Item}->{$_} ) ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $S->{XMLLevelTag}->{1} }
                        ->[ $S->{XMLLevelCount}->{1}->{ $S->{XMLLevelTag}->{1} } ]
                        ->{ $S->{XMLLevelTag}->{2} }
                        ->[ $S->{XMLLevelCount}->{2}->{ $S->{XMLLevelTag}->{2} } ]
                        ->{ $S->{XMLLevelTag}->{3} }
                        ->[ $S->{XMLLevelCount}->{3}->{ $S->{XMLLevelTag}->{3} } ]
                        ->{ $S->{XMLLevelTag}->{4} }
                        ->[ $S->{XMLLevelCount}->{4}->{ $S->{XMLLevelTag}->{4} } ]
                        ->{ $S->{XMLLevelTag}->{5} }
                        ->[ $S->{XMLLevelCount}->{5}->{ $S->{XMLLevelTag}->{5} } ]
                        ->{ $S->{XMLLevelTag}->{6} }
                        ->[ $S->{XMLLevelCount}->{6}->{ $S->{XMLLevelTag}->{6} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 7 ) {
            for ( keys %{ $Param{Item} } ) {
                if ( !defined( $Param{Item}->{$_} ) ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $S->{XMLLevelTag}->{1} }
                        ->[ $S->{XMLLevelCount}->{1}->{ $S->{XMLLevelTag}->{1} } ]
                        ->{ $S->{XMLLevelTag}->{2} }
                        ->[ $S->{XMLLevelCount}->{2}->{ $S->{XMLLevelTag}->{2} } ]
                        ->{ $S->{XMLLevelTag}->{3} }
                        ->[ $S->{XMLLevelCount}->{3}->{ $S->{XMLLevelTag}->{3} } ]
                        ->{ $S->{XMLLevelTag}->{4} }
                        ->[ $S->{XMLLevelCount}->{4}->{ $S->{XMLLevelTag}->{4} } ]
                        ->{ $S->{XMLLevelTag}->{5} }
                        ->[ $S->{XMLLevelCount}->{5}->{ $S->{XMLLevelTag}->{5} } ]
                        ->{ $S->{XMLLevelTag}->{6} }
                        ->[ $S->{XMLLevelCount}->{6}->{ $S->{XMLLevelTag}->{6} } ]
                        ->{ $S->{XMLLevelTag}->{7} }
                        ->[ $S->{XMLLevelCount}->{7}->{ $S->{XMLLevelTag}->{7} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 8 ) {
            for ( keys %{ $Param{Item} } ) {
                if ( !defined( $Param{Item}->{$_} ) ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $S->{XMLLevelTag}->{1} }
                        ->[ $S->{XMLLevelCount}->{1}->{ $S->{XMLLevelTag}->{1} } ]
                        ->{ $S->{XMLLevelTag}->{2} }
                        ->[ $S->{XMLLevelCount}->{2}->{ $S->{XMLLevelTag}->{2} } ]
                        ->{ $S->{XMLLevelTag}->{3} }
                        ->[ $S->{XMLLevelCount}->{3}->{ $S->{XMLLevelTag}->{3} } ]
                        ->{ $S->{XMLLevelTag}->{4} }
                        ->[ $S->{XMLLevelCount}->{4}->{ $S->{XMLLevelTag}->{4} } ]
                        ->{ $S->{XMLLevelTag}->{5} }
                        ->[ $S->{XMLLevelCount}->{5}->{ $S->{XMLLevelTag}->{5} } ]
                        ->{ $S->{XMLLevelTag}->{6} }
                        ->[ $S->{XMLLevelCount}->{6}->{ $S->{XMLLevelTag}->{6} } ]
                        ->{ $S->{XMLLevelTag}->{7} }
                        ->[ $S->{XMLLevelCount}->{7}->{ $S->{XMLLevelTag}->{7} } ]
                        ->{ $S->{XMLLevelTag}->{8} }
                        ->[ $S->{XMLLevelCount}->{8}->{ $S->{XMLLevelTag}->{8} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 9 ) {
            for ( keys %{ $Param{Item} } ) {
                if ( !defined( $Param{Item}->{$_} ) ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $S->{XMLLevelTag}->{1} }
                        ->[ $S->{XMLLevelCount}->{1}->{ $S->{XMLLevelTag}->{1} } ]
                        ->{ $S->{XMLLevelTag}->{2} }
                        ->[ $S->{XMLLevelCount}->{2}->{ $S->{XMLLevelTag}->{2} } ]
                        ->{ $S->{XMLLevelTag}->{3} }
                        ->[ $S->{XMLLevelCount}->{3}->{ $S->{XMLLevelTag}->{3} } ]
                        ->{ $S->{XMLLevelTag}->{4} }
                        ->[ $S->{XMLLevelCount}->{4}->{ $S->{XMLLevelTag}->{4} } ]
                        ->{ $S->{XMLLevelTag}->{5} }
                        ->[ $S->{XMLLevelCount}->{5}->{ $S->{XMLLevelTag}->{5} } ]
                        ->{ $S->{XMLLevelTag}->{6} }
                        ->[ $S->{XMLLevelCount}->{6}->{ $S->{XMLLevelTag}->{6} } ]
                        ->{ $S->{XMLLevelTag}->{7} }
                        ->[ $S->{XMLLevelCount}->{7}->{ $S->{XMLLevelTag}->{7} } ]
                        ->{ $S->{XMLLevelTag}->{8} }
                        ->[ $S->{XMLLevelCount}->{8}->{ $S->{XMLLevelTag}->{8} } ]
                        ->{ $S->{XMLLevelTag}->{9} }
                        ->[ $S->{XMLLevelCount}->{9}->{ $S->{XMLLevelTag}->{9} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 10 ) {
            for ( keys %{ $Param{Item} } ) {
                if ( !defined( $Param{Item}->{$_} ) ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $S->{XMLLevelTag}->{1} }
                        ->[ $S->{XMLLevelCount}->{1}->{ $S->{XMLLevelTag}->{1} } ]
                        ->{ $S->{XMLLevelTag}->{2} }
                        ->[ $S->{XMLLevelCount}->{2}->{ $S->{XMLLevelTag}->{2} } ]
                        ->{ $S->{XMLLevelTag}->{3} }
                        ->[ $S->{XMLLevelCount}->{3}->{ $S->{XMLLevelTag}->{3} } ]
                        ->{ $S->{XMLLevelTag}->{4} }
                        ->[ $S->{XMLLevelCount}->{4}->{ $S->{XMLLevelTag}->{4} } ]
                        ->{ $S->{XMLLevelTag}->{5} }
                        ->[ $S->{XMLLevelCount}->{5}->{ $S->{XMLLevelTag}->{5} } ]
                        ->{ $S->{XMLLevelTag}->{6} }
                        ->[ $S->{XMLLevelCount}->{6}->{ $S->{XMLLevelTag}->{6} } ]
                        ->{ $S->{XMLLevelTag}->{7} }
                        ->[ $S->{XMLLevelCount}->{7}->{ $S->{XMLLevelTag}->{7} } ]
                        ->{ $S->{XMLLevelTag}->{8} }
                        ->[ $S->{XMLLevelCount}->{8}->{ $S->{XMLLevelTag}->{8} } ]
                        ->{ $S->{XMLLevelTag}->{9} }
                        ->[ $S->{XMLLevelCount}->{9}->{ $S->{XMLLevelTag}->{9} } ]
                        ->{ $S->{XMLLevelTag}->{10} }
                        ->[ $S->{XMLLevelCount}->{10}->{ $S->{XMLLevelTag}->{10} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 11 ) {
            for ( keys %{ $Param{Item} } ) {
                if ( !defined( $Param{Item}->{$_} ) ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $S->{XMLLevelTag}->{1} }
                        ->[ $S->{XMLLevelCount}->{1}->{ $S->{XMLLevelTag}->{1} } ]
                        ->{ $S->{XMLLevelTag}->{2} }
                        ->[ $S->{XMLLevelCount}->{2}->{ $S->{XMLLevelTag}->{2} } ]
                        ->{ $S->{XMLLevelTag}->{3} }
                        ->[ $S->{XMLLevelCount}->{3}->{ $S->{XMLLevelTag}->{3} } ]
                        ->{ $S->{XMLLevelTag}->{4} }
                        ->[ $S->{XMLLevelCount}->{4}->{ $S->{XMLLevelTag}->{4} } ]
                        ->{ $S->{XMLLevelTag}->{5} }
                        ->[ $S->{XMLLevelCount}->{5}->{ $S->{XMLLevelTag}->{5} } ]
                        ->{ $S->{XMLLevelTag}->{6} }
                        ->[ $S->{XMLLevelCount}->{6}->{ $S->{XMLLevelTag}->{6} } ]
                        ->{ $S->{XMLLevelTag}->{7} }
                        ->[ $S->{XMLLevelCount}->{7}->{ $S->{XMLLevelTag}->{7} } ]
                        ->{ $S->{XMLLevelTag}->{8} }
                        ->[ $S->{XMLLevelCount}->{8}->{ $S->{XMLLevelTag}->{8} } ]
                        ->{ $S->{XMLLevelTag}->{9} }
                        ->[ $S->{XMLLevelCount}->{9}->{ $S->{XMLLevelTag}->{9} } ]
                        ->{ $S->{XMLLevelTag}->{10} }
                        ->[ $S->{XMLLevelCount}->{10}->{ $S->{XMLLevelTag}->{10} } ]
                        ->{ $S->{XMLLevelTag}->{11} }
                        ->[ $S->{XMLLevelCount}->{11}->{ $S->{XMLLevelTag}->{11} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 12 ) {
            for ( keys %{ $Param{Item} } ) {
                if ( !defined( $Param{Item}->{$_} ) ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $S->{XMLLevelTag}->{1} }
                        ->[ $S->{XMLLevelCount}->{1}->{ $S->{XMLLevelTag}->{1} } ]
                        ->{ $S->{XMLLevelTag}->{2} }
                        ->[ $S->{XMLLevelCount}->{2}->{ $S->{XMLLevelTag}->{2} } ]
                        ->{ $S->{XMLLevelTag}->{3} }
                        ->[ $S->{XMLLevelCount}->{3}->{ $S->{XMLLevelTag}->{3} } ]
                        ->{ $S->{XMLLevelTag}->{4} }
                        ->[ $S->{XMLLevelCount}->{4}->{ $S->{XMLLevelTag}->{4} } ]
                        ->{ $S->{XMLLevelTag}->{5} }
                        ->[ $S->{XMLLevelCount}->{5}->{ $S->{XMLLevelTag}->{5} } ]
                        ->{ $S->{XMLLevelTag}->{6} }
                        ->[ $S->{XMLLevelCount}->{6}->{ $S->{XMLLevelTag}->{6} } ]
                        ->{ $S->{XMLLevelTag}->{7} }
                        ->[ $S->{XMLLevelCount}->{7}->{ $S->{XMLLevelTag}->{7} } ]
                        ->{ $S->{XMLLevelTag}->{8} }
                        ->[ $S->{XMLLevelCount}->{8}->{ $S->{XMLLevelTag}->{8} } ]
                        ->{ $S->{XMLLevelTag}->{9} }
                        ->[ $S->{XMLLevelCount}->{9}->{ $S->{XMLLevelTag}->{9} } ]
                        ->{ $S->{XMLLevelTag}->{10} }
                        ->[ $S->{XMLLevelCount}->{10}->{ $S->{XMLLevelTag}->{10} } ]
                        ->{ $S->{XMLLevelTag}->{11} }
                        ->[ $S->{XMLLevelCount}->{11}->{ $S->{XMLLevelTag}->{11} } ]
                        ->{ $S->{XMLLevelTag}->{12} }
                        ->[ $S->{XMLLevelCount}->{12}->{ $S->{XMLLevelTag}->{12} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 13 ) {
            for ( keys %{ $Param{Item} } ) {
                if ( !defined( $Param{Item}->{$_} ) ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $S->{XMLLevelTag}->{1} }
                        ->[ $S->{XMLLevelCount}->{1}->{ $S->{XMLLevelTag}->{1} } ]
                        ->{ $S->{XMLLevelTag}->{2} }
                        ->[ $S->{XMLLevelCount}->{2}->{ $S->{XMLLevelTag}->{2} } ]
                        ->{ $S->{XMLLevelTag}->{3} }
                        ->[ $S->{XMLLevelCount}->{3}->{ $S->{XMLLevelTag}->{3} } ]
                        ->{ $S->{XMLLevelTag}->{4} }
                        ->[ $S->{XMLLevelCount}->{4}->{ $S->{XMLLevelTag}->{4} } ]
                        ->{ $S->{XMLLevelTag}->{5} }
                        ->[ $S->{XMLLevelCount}->{5}->{ $S->{XMLLevelTag}->{5} } ]
                        ->{ $S->{XMLLevelTag}->{6} }
                        ->[ $S->{XMLLevelCount}->{6}->{ $S->{XMLLevelTag}->{6} } ]
                        ->{ $S->{XMLLevelTag}->{7} }
                        ->[ $S->{XMLLevelCount}->{7}->{ $S->{XMLLevelTag}->{7} } ]
                        ->{ $S->{XMLLevelTag}->{8} }
                        ->[ $S->{XMLLevelCount}->{8}->{ $S->{XMLLevelTag}->{8} } ]
                        ->{ $S->{XMLLevelTag}->{9} }
                        ->[ $S->{XMLLevelCount}->{9}->{ $S->{XMLLevelTag}->{9} } ]
                        ->{ $S->{XMLLevelTag}->{10} }
                        ->[ $S->{XMLLevelCount}->{10}->{ $S->{XMLLevelTag}->{10} } ]
                        ->{ $S->{XMLLevelTag}->{11} }
                        ->[ $S->{XMLLevelCount}->{11}->{ $S->{XMLLevelTag}->{11} } ]
                        ->{ $S->{XMLLevelTag}->{12} }
                        ->[ $S->{XMLLevelCount}->{12}->{ $S->{XMLLevelTag}->{12} } ]
                        ->{ $S->{XMLLevelTag}->{13} }
                        ->[ $S->{XMLLevelCount}->{13}->{ $S->{XMLLevelTag}->{13} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 14 ) {
            for ( keys %{ $Param{Item} } ) {
                if ( !defined( $Param{Item}->{$_} ) ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $S->{XMLLevelTag}->{1} }
                        ->[ $S->{XMLLevelCount}->{1}->{ $S->{XMLLevelTag}->{1} } ]
                        ->{ $S->{XMLLevelTag}->{2} }
                        ->[ $S->{XMLLevelCount}->{2}->{ $S->{XMLLevelTag}->{2} } ]
                        ->{ $S->{XMLLevelTag}->{3} }
                        ->[ $S->{XMLLevelCount}->{3}->{ $S->{XMLLevelTag}->{3} } ]
                        ->{ $S->{XMLLevelTag}->{4} }
                        ->[ $S->{XMLLevelCount}->{4}->{ $S->{XMLLevelTag}->{4} } ]
                        ->{ $S->{XMLLevelTag}->{5} }
                        ->[ $S->{XMLLevelCount}->{5}->{ $S->{XMLLevelTag}->{5} } ]
                        ->{ $S->{XMLLevelTag}->{6} }
                        ->[ $S->{XMLLevelCount}->{6}->{ $S->{XMLLevelTag}->{6} } ]
                        ->{ $S->{XMLLevelTag}->{7} }
                        ->[ $S->{XMLLevelCount}->{7}->{ $S->{XMLLevelTag}->{7} } ]
                        ->{ $S->{XMLLevelTag}->{8} }
                        ->[ $S->{XMLLevelCount}->{8}->{ $S->{XMLLevelTag}->{8} } ]
                        ->{ $S->{XMLLevelTag}->{9} }
                        ->[ $S->{XMLLevelCount}->{9}->{ $S->{XMLLevelTag}->{9} } ]
                        ->{ $S->{XMLLevelTag}->{10} }
                        ->[ $S->{XMLLevelCount}->{10}->{ $S->{XMLLevelTag}->{10} } ]
                        ->{ $S->{XMLLevelTag}->{11} }
                        ->[ $S->{XMLLevelCount}->{11}->{ $S->{XMLLevelTag}->{11} } ]
                        ->{ $S->{XMLLevelTag}->{12} }
                        ->[ $S->{XMLLevelCount}->{12}->{ $S->{XMLLevelTag}->{12} } ]
                        ->{ $S->{XMLLevelTag}->{13} }
                        ->[ $S->{XMLLevelCount}->{13}->{ $S->{XMLLevelTag}->{13} } ]
                        ->{ $S->{XMLLevelTag}->{14} }
                        ->[ $S->{XMLLevelCount}->{14}->{ $S->{XMLLevelTag}->{14} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 15 ) {
            for ( keys %{ $Param{Item} } ) {
                if ( !defined( $Param{Item}->{$_} ) ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $S->{XMLLevelTag}->{1} }
                        ->[ $S->{XMLLevelCount}->{1}->{ $S->{XMLLevelTag}->{1} } ]
                        ->{ $S->{XMLLevelTag}->{2} }
                        ->[ $S->{XMLLevelCount}->{2}->{ $S->{XMLLevelTag}->{2} } ]
                        ->{ $S->{XMLLevelTag}->{3} }
                        ->[ $S->{XMLLevelCount}->{3}->{ $S->{XMLLevelTag}->{3} } ]
                        ->{ $S->{XMLLevelTag}->{4} }
                        ->[ $S->{XMLLevelCount}->{4}->{ $S->{XMLLevelTag}->{4} } ]
                        ->{ $S->{XMLLevelTag}->{5} }
                        ->[ $S->{XMLLevelCount}->{5}->{ $S->{XMLLevelTag}->{5} } ]
                        ->{ $S->{XMLLevelTag}->{6} }
                        ->[ $S->{XMLLevelCount}->{6}->{ $S->{XMLLevelTag}->{6} } ]
                        ->{ $S->{XMLLevelTag}->{7} }
                        ->[ $S->{XMLLevelCount}->{7}->{ $S->{XMLLevelTag}->{7} } ]
                        ->{ $S->{XMLLevelTag}->{8} }
                        ->[ $S->{XMLLevelCount}->{8}->{ $S->{XMLLevelTag}->{8} } ]
                        ->{ $S->{XMLLevelTag}->{9} }
                        ->[ $S->{XMLLevelCount}->{9}->{ $S->{XMLLevelTag}->{9} } ]
                        ->{ $S->{XMLLevelTag}->{10} }
                        ->[ $S->{XMLLevelCount}->{10}->{ $S->{XMLLevelTag}->{10} } ]
                        ->{ $S->{XMLLevelTag}->{11} }
                        ->[ $S->{XMLLevelCount}->{11}->{ $S->{XMLLevelTag}->{11} } ]
                        ->{ $S->{XMLLevelTag}->{12} }
                        ->[ $S->{XMLLevelCount}->{12}->{ $S->{XMLLevelTag}->{12} } ]
                        ->{ $S->{XMLLevelTag}->{13} }
                        ->[ $S->{XMLLevelCount}->{13}->{ $S->{XMLLevelTag}->{13} } ]
                        ->{ $S->{XMLLevelTag}->{14} }
                        ->[ $S->{XMLLevelCount}->{14}->{ $S->{XMLLevelTag}->{14} } ]
                        ->{ $S->{XMLLevelTag}->{15} }
                        ->[ $S->{XMLLevelCount}->{15}->{ $S->{XMLLevelTag}->{15} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
    }
    return 1;
}

=item XMLParse()

parse a xml file

    my @XMLStructure = $XMLObject->XMLParse( String => $FileString );

    my @XMLStructure = $XMLObject->XMLParse( String => \$FileStringScalar );

=cut

sub XMLParse {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{String} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'String not defined!' );
        return;
    }

    # check input type
    if ( ref $Param{String} ) {
        $Param{String} = ${ $Param{String} };
    }

    # cleanup global vars
    undef $Self->{XMLARRAY};
    $Self->{XMLLevel}    = 0;
    $Self->{XMLTagCount} = 0;
    undef $Self->{XMLLevelTag};
    undef $Self->{XMLLevelCount};
    $S = $Self;

    # convert string
    if ( $Param{String} =~ /(<.+?>)/ ) {
        if ( $1 !~ /(utf-8|utf8)/i && $1 =~ /encoding=('|")(.+?)('|")/i ) {
            my $SourceCharset = $2;
            $Param{String} =~ s/$SourceCharset/utf-8/i;
            $Param{String} = $Self->{EncodeObject}->Convert(
                Text  => $Param{String},
                From  => $SourceCharset,
                To    => 'utf-8',
                Force => 1,
            );
        }
    }

    # load parse package and parse
    my $UseFallback = 1;

    if ( eval 'require XML::Parser' ) {
        my $Parser = XML::Parser->new(
            Handlers => {
                Start => \&_HS,
                End   => \&_ES,
                Char  => \&_CS,
            },
        );

        if ( eval { $Parser->parse( $Param{String} ) } ) {
            $UseFallback = 0;
        }
        else {
            $Self->{LogObject}->Log( Priority => 'error', Message => "C-Parser: $@!" );
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'XML::Parser produced errors. I use XML::Parser::Lite as fallback!'
            );
        }
    }

    if ($UseFallback) {
        require XML::Parser::Lite;

        my $Parser = XML::Parser::Lite->new(
            Handlers => {
                Start => \&_HS,
                End   => \&_ES,
                Char  => \&_CS,
            },
        );
        $Parser->parse( $Param{String} );
    }

    # quote
    for my $XMLElement ( @{ $Self->{XMLARRAY} } ) {
        $Self->_Decode($XMLElement);
    }
    return @{ $Self->{XMLARRAY} };
}

sub _Decode {
    my ( $Self, $A ) = @_;

    for ( keys %{$A} ) {
        if ( ref( $A->{$_} ) eq 'ARRAY' ) {
            for my $B ( @{ $A->{$_} } ) {
                $Self->_Decode($B);
            }
        }

        # decode
        elsif ( defined $A->{$_} ) {
            $A->{$_} =~ s/&amp;/&/g;
            $A->{$_} =~ s/&lt;/</g;
            $A->{$_} =~ s/&gt;/>/g;
            $A->{$_} =~ s/&quot;/"/g;

            # convert into default charset
            $A->{$_} = $Self->{EncodeObject}->Convert(
                Text  => $A->{$_},
                From  => 'utf-8',
                To    => $Self->{ConfigObject}->Get('DefaultCharset'),
                Force => 1,
            );
        }
    }
    return 1;
}

sub _HS {
    my ( $Expat, $Element, %Attr ) = @_;

    if ( $S->{LastTag} ) {
        push( @{ $S->{XMLARRAY} }, { %{ $S->{LastTag} }, Content => $S->{C} } );
    }
    undef $S->{LastTag};
    undef $S->{C};
    $S->{XMLLevel}++;
    $S->{XMLTagCount}++;
    $S->{XMLLevelTag}->{ $S->{XMLLevel} } = $Element;
    if ( $S->{Tll} && $S->{Tll} > $S->{XMLLevel} ) {
        for ( ( $S->{XMLLevel} + 1 ) .. 30 ) {
            undef $S->{XMLLevelCount}->{$_};
        }
    }
    $S->{XMLLevelCount}->{ $S->{XMLLevel} }->{$Element}++;

    # remember old level
    $S->{Tll} = $S->{XMLLevel};

    my $Key = '';
    for ( 1 .. ( $S->{XMLLevel} ) ) {
        if ($Key) {

            #            $Key .= "->";
        }
        $Key .= "{'$S->{XMLLevelTag}->{$_}'}";
        $Key .= "[" . $S->{XMLLevelCount}->{$_}->{ $S->{XMLLevelTag}->{$_} } . "]";
    }

    $S->{LastTag} = {
        %Attr,
        TagType  => 'Start',
        Tag      => $Element,
        TagLevel => $S->{XMLLevel},
        TagCount => $S->{XMLTagCount},

        #        TagKey => $Key,
        TagLastLevel => $S->{XMLLevelTag}->{ ( $S->{XMLLevel} - 1 ) },
    };
    return 1;
}

sub _CS {
    my ( $Expat, $Element, $I, $II ) = @_;

    if ( $S->{LastTag} ) {
        $S->{C} .= $Element;
    }
    return 1;
}

sub _ES {
    my ( $Expat, $Element ) = @_;

    $S->{XMLTagCount}++;
    if ( $S->{LastTag} ) {
        push( @{ $S->{XMLARRAY} }, { %{ $S->{LastTag} }, Content => $S->{C} } );
    }
    undef $S->{LastTag};
    undef $S->{C};
    push(
        @{ $S->{XMLARRAY} },
        {
            TagType  => 'End',
            TagLevel => $S->{XMLLevel},
            TagCount => $S->{XMLTagCount},
            Tag      => $Element
        },
    );
    $S->{XMLLevel} = $S->{XMLLevel} - 1;
    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.83 $ $Date: 2009-04-23 13:47:08 $

=cut
