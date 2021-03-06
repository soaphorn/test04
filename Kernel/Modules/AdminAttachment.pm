# --
# Kernel/Modules/AdminAttachment.pm - provides admin std response module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AdminAttachment.pm,v 1.21.2.1 2010-02-09 12:43:41 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminAttachment;

use strict;
use warnings;

use Kernel::System::StdAttachment;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.21.2.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    $Self->{StdAttachmentObject} = Kernel::System::StdAttachment->new(%Param);
    $Self->{ValidObject}         = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';
        my %Data = $Self->{StdAttachmentObject}->StdAttachmentGet( ID => $ID, );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %Data,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminAttachmentForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my @NewIDs = $Self->{ParamObject}->GetArray( Param => 'IDs' );
        my %GetParam;
        for (qw(ID Name Comment ValidID)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        # get attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'file_upload',
            Source => 'string',
        );

        # update group
        my $Update = $Self->{StdAttachmentObject}->StdAttachmentUpdate(
            %GetParam,
            %UploadStuff,
            UserID => $Self->{UserID},
        );
        if ( !$Update ) {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
            $Self->_Edit(
                Action => 'Change',
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminAttachmentForm',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify( Info => 'Attachment updated!' );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminAttachmentForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam;
        for (qw(Name)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminAttachmentForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my @NewIDs = $Self->{ParamObject}->GetArray( Param => 'IDs' );
        my %GetParam;
        for (qw(ID Name Comment ValidID)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        # get attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'file_upload',
            Source => 'string',
        );

        # add state
        my $StdAttachmentID = $Self->{StdAttachmentObject}->StdAttachmentAdd(
            %GetParam,
            %UploadStuff,
            UserID => $Self->{UserID},
        );
        if ( !$StdAttachmentID ) {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
            $Self->_Edit(
                Action => 'Add',
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminAttachmentForm',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify( Info => 'Attachment added!' );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminAttachmentForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # delete action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        my $Delete = $Self->{StdAttachmentObject}->StdAttachmentDelete(
            ID => $ID,
        );
        if ( !$Delete ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # download action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Download' ) {

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        my %Data = $Self->{StdAttachmentObject}->StdAttachmentGet( ID => $ID, );
        if ( !%Data ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        return $Self->{LayoutObject}->Attachment(
            %Data,
            Type => 'attachment',
        );
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminAttachmentForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

}

sub _Edit {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    # get valid list
    my %ValidList        = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );
    my %List = $Self->{StdAttachmentObject}->GetAllStdAttachments(
        UserID => 1,
        Valid  => 0,
    );

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList();
    my $CssClass  = '';
    for my $ID ( sort { $List{$a} cmp $List{$b} } keys %List ) {

        # set output class
        if ( $CssClass && $CssClass eq 'searchactive' ) {
            $CssClass = 'searchpassive';
        }
        else {
            $CssClass = 'searchactive';
        }
        my %Data = $Self->{StdAttachmentObject}->StdAttachmentGet( ID => $ID, );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResultRow',
            Data => {
                Valid    => $ValidList{ $Data{ValidID} },
                CssClass => $CssClass,
                %Data,
            },
        );
    }
    return 1;
}

1;
