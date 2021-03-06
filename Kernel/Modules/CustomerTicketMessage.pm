# --
# Kernel/Modules/CustomerTicketMessage.pm - to handle customer messages
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: CustomerTicketMessage.pm,v 1.47.2.1 2010-04-02 15:44:07 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketMessage;

use strict;
use warnings;

use Kernel::System::Web::UploadCache;
use Kernel::System::SystemAddress;
use Kernel::System::Queue;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.47.2.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # needed objects
    $Self->{StateObject}      = Kernel::System::State->new(%Param);
    $Self->{SystemAddress}    = Kernel::System::SystemAddress->new(%Param);
    $Self->{QueueObject}      = Kernel::System::Queue->new(%Param);
    $Self->{UploadCachObject} = Kernel::System::Web::UploadCache->new(%Param);

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCachObject}->FormIDCreate();
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my %GetParam = ();
    for (
        qw(
        Subject Body PriorityID TypeID ServiceID SLAID Expand
        AttachmentUpload
        AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
        AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
        AttachmentDelete9 AttachmentDelete10 )
        )
    {
        $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
    }

    if ( !$Self->{Subaction} ) {

        # get default selections
        my %TicketFreeDefault;
        for my $Count ( 1 .. 16 ) {
            my $Key  = 'TicketFreeKey' . $Count;
            my $Text = 'TicketFreeText' . $Count;

            $TicketFreeDefault{$Key} = $GetParam{$Key}
                || $Self->{ConfigObject}->Get( $Key . '::DefaultSelection' );
            $TicketFreeDefault{$Text} = $GetParam{$Text}
                || $Self->{ConfigObject}->Get( $Text . '::DefaultSelection' );
        }

        # get free text config options
        my %TicketFreeText;
        for my $Count ( 1 .. 16 ) {
            my $Key  = 'TicketFreeKey' . $Count;
            my $Text = 'TicketFreeText' . $Count;
            $TicketFreeText{$Key} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                Type           => $Key,
                CustomerUserID => $Self->{UserID},
            );
            $TicketFreeText{$Text} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                Type           => $Text,
                CustomerUserID => $Self->{UserID},
            );
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => {%TicketFreeDefault},
        );

        # get ticket free time params
        my %TicketFreeTime;
        for ( 1 .. 6 ) {
            for my $Type (qw(Used Year Month Day Hour Minute)) {
                $TicketFreeTime{ "TicketFreeTime" . $_ . $Type }
                    = $Self->{ParamObject}->GetParam( Param => "TicketFreeTime" . $_ . $Type );
            }
            $TicketFreeTime{ 'TicketFreeTime' . $_ . 'Optional' }
                = $Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $_ ) || 0;
            if ( !$Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $_ ) ) {
                $TicketFreeTime{ 'TicketFreeTime' . $_ . 'Used' } = 1;
            }
        }

        # free time
        my %FreeTime = $Self->{LayoutObject}->CustomerFreeDate(
            %Param,
            Ticket => \%TicketFreeTime,
        );

        # print form ...
        my $Output .= $Self->{LayoutObject}->CustomerHeader();
        $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
        $Output .= $Self->_MaskNew( %TicketFreeTextHTML, %FreeTime, );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    elsif ( $Self->{Subaction} eq 'StoreNew' ) {
        my $NextScreen = $Self->{Config}->{NextScreenAfterNewTicket};
        my %Error      = ();

        # get dest queue
        my $Dest = $Self->{ParamObject}->GetParam( Param => 'Dest' ) || '';
        my ( $NewQueueID, $To ) = split( /\|\|/, $Dest );
        if ( !$To ) {
            $NewQueueID = $Self->{ParamObject}->GetParam( Param => 'NewQueueID' ) || '';
            $To = 'System';
        }

        # fallback, if no dest is given
        if ( !$NewQueueID ) {
            my $Queue = $Self->{ParamObject}->GetParam( Param => 'Queue' ) || '';
            if ($Queue) {
                my $QueueID = $Self->{QueueObject}->QueueLookup( Queue => $Queue );
                $NewQueueID = $QueueID;
                $To         = $Queue;
            }
        }
        my %TicketFree = ();
        for ( 1 .. 16 ) {
            $TicketFree{"TicketFreeKey$_"}
                = $Self->{ParamObject}->GetParam( Param => "TicketFreeKey$_" );
            $TicketFree{"TicketFreeText$_"}
                = $Self->{ParamObject}->GetParam( Param => "TicketFreeText$_" );
        }

        # get free text config options
        my %TicketFreeText = ();
        for ( 1 .. 16 ) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                Type           => "TicketFreeKey$_",
                QueueID        => $NewQueueID || 0,
                ServiceID      => $GetParam{ServiceID} || 0,
                CustomerUserID => $Self->{UserID},
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                Type           => "TicketFreeText$_",
                QueueID        => $NewQueueID || 0,
                ServiceID      => $GetParam{ServiceID} || 0,
                CustomerUserID => $Self->{UserID},
            );

            # check required FreeTextField (if configured)
            if (
                $Self->{Config}{'TicketFreeText'}{$_} == 2
                && $TicketFree{"TicketFreeText$_"} eq ''
                )
            {
                $Error{"TicketFreeTextField$_ invalid"} = '* invalid';
            }
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => {%TicketFree},
        );

        # get ticket free time params
        my %TicketFreeTime = ();
        for ( 1 .. 6 ) {
            for my $Type (qw(Used Year Month Day Hour Minute)) {
                $TicketFreeTime{ "TicketFreeTime" . $_ . $Type } = $Self->{ParamObject}->GetParam(
                    Param => "TicketFreeTime" . $_ . $Type,
                );
            }
            $TicketFreeTime{ 'TicketFreeTime' . $_ . 'Optional' }
                = $Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $_ ) || 0;
            if ( !$Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $_ ) ) {
                $TicketFreeTime{ 'TicketFreeTime' . $_ . 'Used' } = 1;
            }
        }

        # transform free time, time stamp based on user time zone
        for my $Count ( 1 .. 6 ) {
            my $Prefix = 'TicketFreeTime' . $Count;
            next if !$TicketFreeTime{ $Prefix . 'Year' };
            next if !$TicketFreeTime{ $Prefix . 'Month' };
            next if !$TicketFreeTime{ $Prefix . 'Day' };
            next if !$TicketFreeTime{ $Prefix . 'Hour' };
            next if !$TicketFreeTime{ $Prefix . 'Minute' };
            %TicketFreeTime = $Self->{LayoutObject}->TransfromDateSelection(
                %TicketFreeTime,
                Prefix => $Prefix
            );
        }

        # free time
        my %FreeTime = $Self->{LayoutObject}->CustomerFreeDate(
            %Param,
            Ticket => \%TicketFreeTime,
        );

        # rewrap body if exists
        if ( $Self->{ConfigObject}->Get('Frontend::RichText') && $GetParam{Body} ) {
            $GetParam{Body}
                =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
        }

        # attachment delete
        for ( 1 .. 10 ) {
            if ( $GetParam{"AttachmentDelete$_"} ) {
                $Error{AttachmentDelete} = 1;
                $Self->{UploadCachObject}->FormIDRemoveFile(
                    FormID => $Self->{FormID},
                    FileID => $_,
                );
            }
        }

        # attachment upload
        if ( $GetParam{AttachmentUpload} ) {
            $Error{AttachmentUpload} = 1;
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param  => 'file_upload',
                Source => 'string',
            );
            $Self->{UploadCachObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );
        }

        # get all attachments meta data
        my @Attachments = $Self->{UploadCachObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # check queue
        if ( !$NewQueueID ) {
            $Error{'Queue invalid'} = '* invalid';
        }

        # check subject
        if ( !$GetParam{Subject} ) {
            $Error{'Subject invalid'} = '* invalid';
        }

        # check body
        if ( !$GetParam{Body} ) {
            $Error{'Body invalid'} = '* invalid';
        }
        if ( $GetParam{Expand} ) {
            %Error = ();
            $Error{'Expand'} = 1;
        }
        if (%Error) {

            # html output
            my $Output .= $Self->{LayoutObject}->CustomerHeader();
            $Output    .= $Self->{LayoutObject}->CustomerNavigationBar();
            $Output    .= $Self->_MaskNew(
                Attachments => \@Attachments,
                %GetParam,
                ToSelected => $Dest,
                QueueID    => $NewQueueID,
                %TicketFreeTextHTML,
                %FreeTime,
                Errors => \%Error,
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }

        # if customer is not alown to set priority, set it to default
        if ( !$Self->{Config}->{Priority} ) {
            $GetParam{PriorityID} = '';
            $GetParam{Priority}   = $Self->{Config}->{PriorityDefault};
        }

        # create new ticket, do db insert
        my $TicketID = $Self->{TicketObject}->TicketCreate(
            QueueID      => $NewQueueID,
            TypeID       => $GetParam{TypeID},
            ServiceID    => $GetParam{ServiceID},
            SLAID        => $GetParam{SLAID},
            Title        => $GetParam{Subject},
            PriorityID   => $GetParam{PriorityID},
            Priority     => $GetParam{Priority},
            Lock         => 'unlock',
            State        => $Self->{Config}->{StateDefault},
            CustomerID   => $Self->{UserCustomerID},
            CustomerUser => $Self->{UserLogin},
            OwnerID      => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            UserID       => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
        );

        # set ticket free text
        for ( 1 .. 16 ) {
            if ( defined( $TicketFree{"TicketFreeKey$_"} ) ) {
                $Self->{TicketObject}->TicketFreeTextSet(
                    TicketID => $TicketID,
                    Key      => $TicketFree{"TicketFreeKey$_"},
                    Value    => $TicketFree{"TicketFreeText$_"},
                    Counter  => $_,
                    UserID   => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                );
            }
        }

        # set ticket free time
        for my $Count ( 1 .. 6 ) {
            my $Prefix = 'TicketFreeTime' . $Count;
            next if !defined $TicketFreeTime{ $Prefix . 'Year' };
            next if !defined $TicketFreeTime{ $Prefix . 'Month' };
            next if !defined $TicketFreeTime{ $Prefix . 'Day' };
            next if !defined $TicketFreeTime{ $Prefix . 'Hour' };
            next if !defined $TicketFreeTime{ $Prefix . 'Minute' };

            # set time stamp to NULL if field is not used/checked
            if ( !$TicketFreeTime{ $Prefix . 'Used' } ) {
                $TicketFreeTime{ $Prefix . 'Year' }   = 0;
                $TicketFreeTime{ $Prefix . 'Month' }  = 0;
                $TicketFreeTime{ $Prefix . 'Day' }    = 0;
                $TicketFreeTime{ $Prefix . 'Hour' }   = 0;
                $TicketFreeTime{ $Prefix . 'Minute' } = 0;
            }

            # set free time
            $Self->{TicketObject}->TicketFreeTimeSet(
                %TicketFreeTime,
                Prefix   => 'TicketFreeTime',
                TicketID => $TicketID,
                Counter  => $Count,
                UserID   => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            );
        }

        my $MimeType = 'text/plain';
        if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {
            $MimeType = 'text/html';

            # verify html document
            $GetParam{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                String => $GetParam{Body},
            );
        }

        # create article
        my $From      = "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>";
        my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID         => $TicketID,
            ArticleType      => $Self->{Config}->{ArticleType},
            SenderType       => $Self->{Config}->{SenderType},
            From             => $From,
            To               => $To,
            Subject          => $GetParam{Subject},
            Body             => $GetParam{Body},
            MimeType         => $MimeType,
            Charset          => $Self->{LayoutObject}->{UserCharset},
            UserID           => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            HistoryType      => $Self->{Config}->{HistoryType},
            HistoryComment   => $Self->{Config}->{HistoryComment} || '%%',
            AutoResponseType => 'auto reply',
            OrigHeader       => {
                From    => $From,
                To      => $Self->{UserLogin},
                Subject => $GetParam{Subject},
                Body    => $Self->{LayoutObject}->RichText2Ascii( String => $GetParam{Body} ),
            },
            Queue => $Self->{QueueObject}->QueueLookup( QueueID => $NewQueueID ),
        );
        if ( !$ArticleID ) {
            my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
            $Output .= $Self->{LayoutObject}->CustomerError();
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }

        # get pre loaded attachment
        my @AttachmentData = $Self->{UploadCachObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # get submit attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'file_upload',
            Source => 'String',
        );
        if (%UploadStuff) {
            push @AttachmentData, \%UploadStuff;
        }

        # write attachments
        WRITEATTACHMENT:
        for my $Ref (@AttachmentData) {

            # skip deleted inline images
            next WRITEATTACHMENT if $Ref->{ContentID}
                    && $Ref->{ContentID} =~ /^inline/
                    && $GetParam{Body} !~ /$Ref->{ContentID}/;
            $Self->{TicketObject}->ArticleWriteAttachment(
                %{$Ref},
                ArticleID => $ArticleID,
                UserID    => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            );
        }

        # remove pre submitted attachments
        $Self->{UploadCachObject}->FormIDRemove( FormID => $Self->{FormID} );

        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$NextScreen&TicketID=$TicketID",
        );
    }
    else {
        my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
        $Output .= $Self->{LayoutObject}->CustomerError(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
}

sub _MaskNew {
    my ( $Self, %Param ) = @_;

    $Param{FormID} = $Self->{FormID};

    # get list type
    my $TreeView = 0;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # check own selection
    my %NewTos = ( '', '-' );
    my $Module = $Self->{ConfigObject}->Get('CustomerPanel::NewTicketQueueSelectionModule')
        || 'Kernel::Output::HTML::CustomerNewTicketQueueSelectionGeneric';
    if ( $Self->{MainObject}->Require($Module) ) {
        my $Object = $Module->new( %{$Self}, Debug => $Self->{Debug}, );

        # log loaded module
        if ( $Self->{Debug} > 1 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "Module: $Module loaded!",
            );
        }
        %NewTos = ( $Object->Run( Env => $Self ), ( '', => '-' ) );
    }
    else {
        return $Self->{LayoutObject}->FatalError();
    }

    # build to string
    if (%NewTos) {
        for ( keys %NewTos ) {
            $NewTos{"$_||$NewTos{$_}"} = $NewTos{$_};
            delete $NewTos{$_};
        }
    }
    $Param{'ToStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data       => \%NewTos,
        Multiple   => 0,
        Size       => 0,
        Name       => 'Dest',
        SelectedID => $Param{ToSelected},
        OnChange   => "document.compose.Expand.value='3'; document.compose.submit(); return false;",
    );

    # get priority
    if ( $Self->{Config}->{Priority} ) {
        my %Priorities = $Self->{TicketObject}->PriorityList(
            CustomerUserID => $Self->{UserID},
            Action         => $Self->{Action},
        );

        # build priority string
        my %PrioritySelected = ();
        if ( $Param{PriorityID} ) {
            $PrioritySelected{SelectedID} = $Param{PriorityID};
        }
        else {
            $PrioritySelected{Selected} = $Self->{Config}->{PriorityDefault} || '3 normal';
        }
        $Param{'PriorityStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%Priorities,
            Name => 'PriorityID',
            %PrioritySelected,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Priority',
            Data => { %Param, },
        );
    }

    # types
    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        my %Type = $Self->{TicketObject}->TicketTypeList(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Self->{UserID},
        );
        $Param{'TypeStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%Type,
            Name         => 'TypeID',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            OnChange =>
                "document.compose.Expand.value='3'; document.compose.submit(); return false;",
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketType',
            Data => {%Param},
        );
    }

    # services
    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {
        my %Service = ();
        if ( $Param{QueueID} || $Param{TicketID} ) {
            %Service = $Self->{TicketObject}->TicketServiceList(
                %Param,
                Action         => $Self->{Action},
                CustomerUserID => $Self->{UserID},
            );
        }
        $Param{'ServiceStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%Service,
            Name         => 'ServiceID',
            SelectedID   => $Param{ServiceID},
            PossibleNone => 1,
            TreeView     => $TreeView,
            Sort         => 'TreeView',
            Translation  => 0,
            Max          => 200,
            OnChange =>
                "document.compose.Expand.value='3'; document.compose.submit(); return false;",
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketService',
            Data => \%Param,
        );
        my %SLA = ();
        if ( $Param{ServiceID} ) {
            %SLA = $Self->{TicketObject}->TicketSLAList(
                %Param,
                Action         => $Self->{Action},
                CustomerUserID => $Self->{UserID},
            );
        }
        $Param{'SLAStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%SLA,
            Name         => 'SLAID',
            SelectedID   => $Param{SLAID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            Max          => 200,
            OnChange =>
                "document.compose.Expand.value='3'; document.compose.submit(); return false;",
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketSLA',
            Data => \%Param,
        );
    }

    # prepare errors!
    if ( $Param{Errors} ) {
        for ( keys %{ $Param{Errors} } ) {
            $Param{$_} = $Self->{LayoutObject}->Ascii2Html( Text => $Param{Errors}->{$_} );
        }
    }

    # ticket free text
    for my $Count ( 1 .. 16 ) {
        if ( $Self->{Config}->{'TicketFreeText'}->{$Count} ) {
            $Self->{LayoutObject}->Block(
                Name => 'FreeText',
                Data => {
                    TicketFreeKeyField  => $Param{ 'TicketFreeKeyField' . $Count },
                    TicketFreeTextField => $Param{ 'TicketFreeTextField' . $Count },
                    Count               => $Count,
                    %Param,
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'FreeText' . $Count,
                Data => { %Param, Count => $Count, },
            );
        }
    }
    for my $Count ( 1 .. 6 ) {
        if ( $Self->{Config}->{'TicketFreeTime'}->{$Count} ) {
            $Self->{LayoutObject}->Block(
                Name => 'FreeTime',
                Data => {
                    TicketFreeTimeKey => $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Count ),
                    TicketFreeTime    => $Param{ 'TicketFreeTime' . $Count },
                    Count             => $Count,
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'FreeTime' . $Count,
                Data => { %Param, Count => $Count, },
            );
        }
    }

    # show attachments
    for my $DataRef ( @{ $Param{Attachments} } ) {
        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $DataRef,
        );
    }

    # java script check for required free text fields by form submit
    for my $Key ( keys %{ $Self->{Config}->{TicketFreeText} } ) {
        if ( $Self->{Config}->{TicketFreeText}->{$Key} == 2 ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTextCheckJs',
                Data => {
                    TicketFreeTextField => "TicketFreeText$Key",
                    TicketFreeKeyField  => "TicketFreeKey$Key",
                },
            );
        }
    }

    # java script check for required free time fields by form submit
    for my $Key ( keys %{ $Self->{Config}->{TicketFreeTime} } ) {
        if ( $Self->{Config}->{TicketFreeTime}->{$Key} == 2 ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTimeCheckJs',
                Data => {
                    TicketFreeTimeCheck => 'TicketFreeTime' . $Key . 'Used',
                    TicketFreeTimeField => 'TicketFreeTime' . $Key,
                    TicketFreeTimeKey   => $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Key ),
                },
            );
        }
    }

    # add rich text editor
    if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }

    # get output back
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerTicketMessage',
        Data         => \%Param,
    );
}

1;
