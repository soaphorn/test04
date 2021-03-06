# --
# Kernel/System/Web/Request.pm - a wrapper for CGI.pm or Apache::Request.pm
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Request.pm,v 1.31.2.3 2011-11-21 10:21:02 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Web::Request;

use strict;
use warnings;

use Kernel::System::CheckItem;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.31.2.3 $) [1];

=head1 NAME

Kernel::System::Web::Request - global cgi param interface

=head1 SYNOPSIS

All cgi param functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create param object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Web::Request;

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
    my $ParamObject = Kernel::System::Web::Request->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        EncodeObject => $EncodeObject,
        MainObject   => $MainObject,

    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    for my $Object (qw(ConfigObject LogObject EncodeObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new( %{$Self} );

    # Simple Common Gateway Interface Class
    use CGI qw(:cgi);

    # send errors to web server error log
    use CGI::Carp;

    # max 5 MB posts
    $CGI::POST_MAX = $Self->{ConfigObject}->Get('WebMaxFileUpload') || 1024 * 1024 * 5;

    # query object (in case use already existing WebRequest, e. g. fast cgi)
    $Self->{Query} = $Param{WebRequest} || new CGI;

    return $Self;
}

=item Error()

to get the error back

    if ( $ParamObject->Error() ) {
        print STDERR $ParamObject->Error() . "\n";
    }

=cut

sub Error {
    my ( $Self, %Param ) = @_;

    # Workaround, do not check cgi_error() with perlex, CGI module is not
    # working with perlex.
    if ( $ENV{'GATEWAY_INTERFACE'} && $ENV{'GATEWAY_INTERFACE'} =~ /^CGI-PerlEx/ ) {
        return;
    }

    return if !cgi_error();
    return cgi_error() . ' - POST_MAX=' . ( $CGI::POST_MAX / 1024 ) . 'KB';
}

=item GetParam()

to get params

    my $Param = $ParamObject->GetParam(
        Param => 'ID',
    );

=cut

sub GetParam {
    my ( $Self, %Param ) = @_;

    my $Value = $Self->{Query}->param( $Param{Param} );
    $Self->{EncodeObject}->Encode( \$Value );

    if (
        $Param{TrimLeft}
        || $Param{TrimRight}
        || $Param{RemoveAllNewlines}
        || $Param{RemoveAllTabs}
        || $Param{RemoveAllSpaces}
        )
    {
        $Self->{CheckItemObject}->StringClean(
            StringRef => \$Value,
            %Param,
        );
    }

    return $Value;
}

=item GetArray()

to get array params

    my @Param = $ParamObject->GetArray( Param => 'ID' );

=cut

sub GetArray {
    my ( $Self, %Param ) = @_;

    my @Values = $Self->{Query}->param( $Param{Param} );
    $Self->{EncodeObject}->Encode( \@Values );

    if (
        $Param{TrimLeft}
        || $Param{TrimRight}
        || $Param{RemoveAllNewlines}
        || $Param{RemoveAllTabs}
        || $Param{RemoveAllSpaces}
        )
    {
        for my $Value (@Values) {
            $Self->{CheckItemObject}->StringClean(
                StringRef => \$Value,
                %Param,
            );
        }
    }

    return @Values;
}

=item GetUpload()

internal function for GetUploadAll()

=cut

sub GetUpload {
    my ( $Self, %Param ) = @_;

    return $Self->{Query}->upload( $Param{Filename} );
}

=item GetUploadInfo()

internal function for GetUploadAll()

=cut

sub GetUploadInfo {
    my ( $Self, %Param ) = @_;

    my $ContentType = 'application/octet-stream';
    if (
        $Self->{Query}->uploadInfo( $Param{Filename} )
        && $Self->{Query}->uploadInfo( $Param{Filename} )->{ $Param{Header} }
        )
    {
        $ContentType = $Self->{Query}->uploadInfo( $Param{Filename} )->{ $Param{Header} };
    }
    return $ContentType;
}

=item GetUploadAll()

to get file upload

    my %File = $ParamObject->GetUploadAll(
        Param  => 'FileParam',
        Source => 'string',
    );

    to get file upload without uft-8 encoding

    my %File = $ParamObject->GetUploadAll(
        Param  => 'FileParam',
        Source => 'string',
    );

    print "Filename: $File{Filename}\n";
    print "ContentType: $File{ContentType}\n";
    print "Content: $File{Content}\n";

    If param Source is file, the the content contains the file location
    in your local file system.

=cut

sub GetUploadAll {
    my ( $Self, %Param ) = @_;

    # get upload
    my $Upload = $Self->GetUpload( Filename => $Param{Param} );
    return if !$Upload;

    # get real file name
    my $UploadFilenameOrig = $Self->GetParam( Param => $Param{Param} ) || 'unkown';
    my $NewFileName = "$UploadFilenameOrig";    # use "" to get filename of anony. object
    $Self->{EncodeObject}->Encode( \$NewFileName );

    # replace all devices like c: or d: and dirs for IE!
    $NewFileName =~ s/.:\\(.*)/$1/g;
    $NewFileName =~ s/.*\\(.+?)/$1/g;

    # return a string
    my $Content;
    if ( $Param{Source} && lc $Param{Source} eq 'string' ) {

        while (<$Upload>) {
            $Content .= $_;
        }
        close $Upload;
    }

    # return file location in file system
    else {

        # delete upload dir if exists
        my $Path = "/tmp/$$";
        if ( -d $Path ) {
            File::Path::rmtree( [$Path] );
        }

        # create upload dir
        File::Path::mkpath( [$Path], 0, 0700 );

        $Content = "$Path/$NewFileName";

        open my $Out, '>', $Content or die $!;
        while (<$Upload>) {
            print $Out $_;
        }
        close $Out;
    }

    # check if content is there, IE is always sending file uploades
    # without content
    return if !$Content;

    my $ContentType = $Self->GetUploadInfo(
        Filename => $UploadFilenameOrig,
        Header   => 'Content-Type',
    ) || '';

    return (
        Filename    => $NewFileName,
        Content     => $Content,
        ContentType => $ContentType,
    );
}

=item SetCookie()

set a cookie

    $ParamObject->SetCookie(
        Key     => ID,
        Value   => 123456,
        Expires => '+3660s',
        Secure  => 1,           # optional, set secure attribute to disable cookie on HTTP (HTTPS only)
    );

=cut

sub SetCookie {
    my ( $Self, %Param ) = @_;

    return $Self->{Query}->cookie(
        -name    => $Param{Key},
        -value   => $Param{Value},
        -expires => $Param{Expires},
        -secure  => $Param{Secure},
    );
}

=item GetCookie()

get a cookie

    my $String = $ParamObject->GetCookie(
        Key => ID,
    );

=cut

sub GetCookie {
    my ( $Self, %Param ) = @_;

    return $Self->{Query}->cookie( $Param{Key} ) || '';
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

$Revision: 1.31.2.3 $ $Date: 2011-11-21 10:21:02 $

=cut
