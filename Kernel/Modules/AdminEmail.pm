# --
# Kernel/Modules/AdminEmail.pm - to send a email to all agents
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AdminEmail.pm,v 1.39 2009-07-20 10:36:04 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminEmail;

use strict;
use warnings;

use Kernel::System::Email;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.39 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{SendmailObject} = Kernel::System::Email->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for (qw(From Subject Body Bcc GroupPermission)) {
        $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || $Param{$_} || '';
    }

    # ------------------------------------------------------------ #
    # send email(s)
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Send' ) {

        # check needed stuff
        for (qw(From Subject Body GroupPermission)) {
            if ( !$Param{$_} ) {
                my $Output = $Self->{LayoutObject}->Header( Title => 'Warning' );
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Need $_!",
                    Comment => 'Click back and check the needed value.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }
        my %Bcc = ();

        # get user recipients address
        for ( $Self->{ParamObject}->GetArray( Param => 'UserIDs' ) ) {
            my %UserData = $Self->{UserObject}->GetUserData( UserID => $_, Valid => 1 );
            if ( $UserData{UserEmail} ) {
                $Bcc{ $UserData{UserLogin} } = $UserData{UserEmail};
            }
        }

        # get group recipients address
        for ( $Self->{ParamObject}->GetArray( Param => 'GroupIDs' ) ) {
            my @GroupMemberList = $Self->{GroupObject}->GroupMemberList(
                Result  => 'ID',
                Type    => $Param{GroupPermission},
                GroupID => $_,
            );
            for (@GroupMemberList) {
                my %UserData = $Self->{UserObject}->GetUserData( UserID => $_, Valid => 1 );
                if ( $UserData{UserEmail} ) {
                    $Bcc{ $UserData{UserLogin} } = $UserData{UserEmail};
                }
            }
        }
        for ( sort keys %Bcc ) {
            $Param{Bcc} .= $Bcc{$_} . ', ';
        }

        # check needed stuff
        for (qw(Bcc)) {
            if ( !$Param{$_} ) {
                my $Output = $Self->{LayoutObject}->Header( Title => 'Warning' );
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Need $_!",
                    Comment => 'Click back and check the needed value.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }

        # clean up
        $Param{Body} =~ s/(\r\n|\n\r)/\n/g;
        $Param{Body} =~ s/\r/\n/g;

        # get content type
        my $ContentType = 'text/plain';
        if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {
            $ContentType = 'text/html';

            # verify html document
            $Param{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                String => $Param{Body},
            );
        }

        # send mail
        my $Sent = $Self->{SendmailObject}->Send(
            From     => $Param{From},
            Bcc      => $Param{Bcc},
            Subject  => $Param{Subject},
            Charset  => $Self->{LayoutObject}->{UserCharset},
            MimeType => $ContentType,
            Body     => $Param{Body},
        );
        if ( !$Sent ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        $Self->{LayoutObject}->Block(
            Name => 'Sent',
            Data => \%Param,
        );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminEmail',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # show mask
    # ------------------------------------------------------------ #
    else {

        # add rich text editor
        if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {
            $Self->{LayoutObject}->Block(
                Name => 'RichText',
                Data => \%Param,
            );
        }

        $Param{UserOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{UserObject}->UserList( Valid => 1 ) },
            Name => 'UserIDs',
            Size => 8,
            Multiple => 1,
        );
        $Param{GroupOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{GroupObject}->GroupList( Valid => 1 ) },
            Size => 6,
            Name => 'GroupIDs',
            Multiple => 1,
        );

        $Self->{LayoutObject}->Block(
            Name => 'Form',
            Data => \%Param,
        );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminEmail',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;
