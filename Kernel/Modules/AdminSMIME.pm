# --
# Kernel/Modules/AdminSMIME.pm - to add/update/delete smime keys
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AdminSMIME.pm,v 1.23.2.1 2009-09-22 13:04:56 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSMIME;

use strict;
use warnings;

use Kernel::System::Crypt;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.23.2.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject MainObject EncodeObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{CryptObject} = Kernel::System::Crypt->new( %Param, CryptType => 'SMIME' );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Param{Search} = $Self->{ParamObject}->GetParam( Param => 'Search' );
    if ( !defined $Param{Search} ) {
        $Param{Search} = $Self->{SMIMESearch} || '';
    }
    if ( $Self->{Subaction} eq '' ) {
        $Param{Search} = '';
    }
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'SMIMESearch',
        Value     => $Param{Search},
    );

    # ------------------------------------------------------------ #
    # delete key
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Delete' ) {
        my $Hash = $Self->{ParamObject}->GetParam( Param => 'Hash' ) || '';
        my $Type = $Self->{ParamObject}->GetParam( Param => 'Type' ) || '';
        if ( !$Hash ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Need param Hash to delete!', );
        }
        my $Message = '';

        # remove private key
        if ( $Type eq 'key' ) {
            $Message = $Self->{CryptObject}->PrivateRemove( Hash => $Hash );
        }

        # remove certificate and private key if exists
        else {
            my $Certificate = $Self->{CryptObject}->CertificateGet( Hash => $Hash );
            my %Attributes
                = $Self->{CryptObject}->CertificateAttributes( Certificate => $Certificate, );
            $Message = $Self->{CryptObject}->CertificateRemove( Hash => $Hash );
            if ( $Attributes{Private} eq 'Yes' ) {
                $Message .= $Self->{CryptObject}->PrivateRemove( Hash => $Hash );
            }
        }

        my @List = $Self->{CryptObject}->Search( Search => $Param{Search} );
        for my $Key (@List) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => {
                    StartFont => '<font color ="red">',
                    StopFont  => '</font>',
                    %{$Key},
                },
            );
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        if ($Message) {
            $Output .= $Self->{LayoutObject}->Notify( Info => $Message );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSMIMEForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add certivicate
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddCertificate' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'SMIMESearch',
            Value     => '',
        );
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'file_upload',
            Source => 'String',
        );
        if ( !%UploadStuff ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Need Certificate!', );
        }
        my $Message = $Self->{CryptObject}->CertificateAdd( Certificate => $UploadStuff{Content} );
        if ( !$Message ) {
            $Message = $Self->{LogObject}->GetLogEntry(
                Type => 'Error',
                What => 'Message',
            );
        }
        my @List = $Self->{CryptObject}->Search( Search => $Param{Search} );
        for my $Key (@List) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => {
                    StartFont => '<font color ="red">',
                    StopFont  => '</font>',
                    %{$Key},
                },
            );
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify( Info => $Message );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSMIMEForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add private
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddPrivate' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Secret = $Self->{ParamObject}->GetParam( Param => 'Secret' ) || '';
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'SMIMESearch',
            Value     => '',
        );
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'file_upload',
            Source => 'String',
        );
        if ( !%UploadStuff ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Need Private Key!', );
        }
        my $Message = $Self->{CryptObject}->PrivateAdd(
            Private => $UploadStuff{Content},
            Secret  => $Secret,
        );
        if ( !$Message ) {
            $Message = $Self->{LogObject}->GetLogEntry(
                Type => 'Error',
                What => 'Message',
            );
        }
        my @List = $Self->{CryptObject}->Search( Search => $Param{Search} );
        for my $Key (@List) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => {
                    StartFont => '<font color ="red">',
                    StopFont  => '</font>',
                    %{$Key},
                },
            );
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify( Info => $Message );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSMIMEForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # download fingerprint
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'DownloadFingerprint' ) {
        my $Hash = $Self->{ParamObject}->GetParam( Param => 'Hash' ) || '';
        if ( !$Hash ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Need param Hash to download!', );
        }
        my $Certificate = $Self->{CryptObject}->CertificateGet( Hash => $Hash );
        my %Attributes = $Self->{CryptObject}->CertificateAttributes( Certificate => $Certificate );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain',
            Content     => $Attributes{Fingerprint},
            Filename    => "$Hash.txt",
            Type        => 'inline',
        );
    }

    # ------------------------------------------------------------ #
    # download key
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Download' ) {
        my $Hash = $Self->{ParamObject}->GetParam( Param => 'Hash' ) || '';
        my $Type = $Self->{ParamObject}->GetParam( Param => 'Type' ) || '';
        if ( !$Hash ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Need param Hash to download!', );
        }
        my $Download = '';

        # download key
        if ( $Type eq 'key' ) {
            my $Secret = '';
            ( $Download, $Secret ) = $Self->{CryptObject}->PrivateGet( Hash => $Hash );
        }

        # download certificate
        else {
            $Download = $Self->{CryptObject}->CertificateGet( Hash => $Hash );
        }
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain',
            Content     => $Download,
            Filename    => "$Hash.pem",
            Type        => 'attachment',
        );
    }

    # ------------------------------------------------------------ #
    # search key
    # ------------------------------------------------------------ #
    else {
        my @List = ();
        if ( $Self->{CryptObject} ) {
            @List = $Self->{CryptObject}->Search( Search => $Param{Search} );
        }
        for my $Key (@List) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => {
                    StartFont => '<font color ="red">',
                    StopFont  => '</font>',
                    %{$Key},
                },
            );
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # check if SMIME is activated in the sysconfig first
        if ( !$Self->{ConfigObject}->Get('SMIME') ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data     => '$Text{"You need to activate %s first to use it!", "SMIME"}',
                Link =>
                    '$Env{"Baselink"}Action=AdminSysConfig&Subaction=Edit&SysConfigGroup=Framework&SysConfigSubGroup=Crypt::SMIME"',
            );
        }

        # check if SMIME Paths are writable
        foreach my $PathKey (qw(SMIME::CertPath SMIME::PrivatePath)) {
            if ( !-w $Self->{ConfigObject}->Get($PathKey) ) {
                $Output .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Data     => '$Text{"%s is not writable!", "'
                        . "$PathKey "
                        . $Self->{ConfigObject}->Get($PathKey) . '"}',
                    Link =>
                        '$Env{"Baselink"}Action=AdminSysConfig&Subaction=Edit&SysConfigGroup=Framework&SysConfigSubGroup=Crypt::SMIME"',
                );
            }
        }
        if ( !$Self->{CryptObject} ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data     => '$Text{"Cannot create %s!", "CryptObject"}',
                Link =>
                    '$Env{"Baselink"}Action=AdminSysConfig&Subaction=Edit&SysConfigGroup=Framework&SysConfigSubGroup=Crypt::SMIME"',
            );
        }
        if ( $Self->{CryptObject} && $Self->{CryptObject}->Check() ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data     => '$Text{"' . $Self->{CryptObject}->Check() . '"}',
            );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSMIMEForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;
