# --
# Kernel/Output/HTML/LayoutTicket.pm - provides generic ticket HTML output
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: LayoutTicket.pm,v 1.50.2.10 2011-09-08 10:33:53 te Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutTicket;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.50.2.10 $) [1];

sub TicketStdResponseString {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(StdResponsesRef TicketID ArticleID)) {
        if ( !$Param{$_} ) {
            return "Need $_ in TicketStdResponseString()";
        }
    }

    # get StdResponsesStrg
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::StdResponsesMode') eq 'Form' ) {

        # build html string
        $Param{StdResponsesStrg}
            .= '<form action="'
            . $Self->{CGIHandle}
            . '" method="post">'
            . '<input type="hidden" name="Action" value="AgentTicketCompose"/>'
            . '<input type="hidden" name="ArticleID" value="'
            . $Param{ArticleID} . '"/>'
            . '<input type="hidden" name="TicketID" value="'
            . $Param{TicketID} . '"/>'
            . $Self->OptionStrgHashRef(
            Name => 'ResponseID',
            Data => $Param{StdResponsesRef},
            ) . '<input class="button" type="submit" value="$Text{"Compose"}"/></form>';
    }
    else {
        my %StdResponses = %{ $Param{StdResponsesRef} };
        for ( sort { $StdResponses{$a} cmp $StdResponses{$b} } keys %StdResponses ) {

            # build html string
            $Param{StdResponsesStrg}
                .= "\n<li><a href=\"$Self->{Baselink}"
                . "Action=AgentTicketCompose&"
                . "ResponseID=$_&TicketID=$Param{TicketID}&ArticleID=$Param{ArticleID}\" "
                . 'onmouseover="window.status=\'$Text{"Compose"}\'; return true;" '
                . 'onmouseout="window.status=\'\';">'
                .

                # html quote
                $Self->Ascii2Html( Text => $StdResponses{$_} ) . "</A></li>\n";
        }
    }
    return $Param{StdResponsesStrg};
}

sub AgentCustomerViewTable {
    my ( $Self, %Param ) = @_;

    # check customer params
    if ( ref $Param{Data} ne 'HASH' ) {
        $Self->FatalError( Message => 'Need Hash ref in Data param' );
    }
    elsif ( ref $Param{Data} eq 'HASH' && !%{ $Param{Data} } ) {
        return $Self->{LanguageObject}->Get('none');
    }

    # add ticket params if given
    if ( $Param{Ticket} ) {
        %{ $Param{Data} } = ( %{ $Param{Data} }, %{ $Param{Ticket} } );
    }

    my @MapNew = ();
    my $Map    = $Param{Data}->{Config}->{Map};
    if ($Map) {
        @MapNew = ( @{$Map} );
    }

    # check if customer company support is enabled
    if ( $Param{Data}->{Config}->{CustomerCompanySupport} ) {
        my $Map2 = $Param{Data}->{CompanyConfig}->{Map};
        if ($Map2) {
            push( @MapNew, @{$Map2} );
        }
    }

    my $ShownType = 1;
    if ( $Param{Type} && $Param{Type} eq 'Lite' ) {
        $ShownType = 2;

        # check if min one lite view item is configured, if not, use
        # the normal view also
        my $Used = 0;
        for my $Field (@MapNew) {
            if ( $Field->[3] == 2 ) {
                $Used = 1;
            }
        }
        if ( !$Used ) {
            $ShownType = 1;
        }
    }

    # build html table
    $Self->Block(
        Name => 'Customer',
        Data => $Param{Data},
    );

    # check Frontend::CustomerUser::Image
    my $CustomerImage = $Self->{ConfigObject}->Get('Frontend::CustomerUser::Image');
    if ($CustomerImage) {
        my %Modules = %{$CustomerImage};
        for my $Module ( sort keys %Modules ) {
            if ( !$Self->{MainObject}->Require( $Modules{$Module}->{Module} ) ) {
                $Self->FatalDie();
            }

            my $Object = $Modules{$Module}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );

            # run module
            next if !$Object;

            $Object->Run(
                Config => $Modules{$Module},
                Data   => $Param{Data},
            );
        }
    }

    # build table
    for my $Field (@MapNew) {
        if ( $Field->[3] && $Field->[3] >= $ShownType && $Param{Data}->{ $Field->[0] } ) {
            my %Record = (
                %{ $Param{Data} },
                Key   => $Field->[1],
                Value => $Param{Data}->{ $Field->[0] },
            );
            if ( $Field->[6] ) {
                $Record{LinkStart} = "<a href=\"$Field->[6]\"";
                if ( $Field->[8] ) {
                    $Record{LinkStart} .= " target=\"$Field->[8]\"";
                }
                $Record{LinkStart} .= "\">";
                $Record{LinkStop} = "</a>";
            }
            if ( $Field->[0] ) {
                $Record{ValueShort} = $Self->Ascii2Html(
                    Text => $Record{Value},
                    Max  => $Param{Max}
                );
            }
            $Self->Block(
                Name => 'CustomerRow',
                Data => \%Record,
            );
        }
    }

    # check Frontend::CustomerUser::Item
    my $CustomerItem      = $Self->{ConfigObject}->Get('Frontend::CustomerUser::Item');
    my $CustomerItemCount = 0;
    if ($CustomerItem) {
        $Self->Block(
            Name => 'CustomerItem',
        );
        my %Modules = %{$CustomerItem};
        for my $Module ( sort keys %Modules ) {
            if ( !$Self->{MainObject}->Require( $Modules{$Module}->{Module} ) ) {
                $Self->FatalDie();
            }

            my $Object = $Modules{$Module}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );

            # run module
            next if !$Object;

            my $Run = $Object->Run(
                Config => $Modules{$Module},
                Data   => $Param{Data},
            );

            next if !$Run;

            $CustomerItemCount++;
            if ( ( $CustomerItemCount / 2 ) !~ /\./ ) {
                $Self->Block(
                    Name => 'CustomerItem',
                );
            }
        }
    }

    # Acivity Index: History
    # CTI
    # vCard
    # Bugzilla Status
    # create & return output
    return $Self->Output( TemplateFile => 'AgentCustomerTableView', Data => \%Param );
}

# AgentQueueListOption()
#
# !! DONT USE THIS FUNCTION !! Use BuildSelection() instead.
#
# Due to compatibility reason this function is still in use and will be removed
# in a further release.

sub AgentQueueListOption {
    my ( $Self, %Param ) = @_;

    my $Size       = $Param{Size}                  ? "size='$Param{Size}'" : '';
    my $MaxLevel   = defined( $Param{MaxLevel} )   ? $Param{MaxLevel}      : 10;
    my $SelectedID = defined( $Param{SelectedID} ) ? $Param{SelectedID}    : '';
    my $Selected   = defined( $Param{Selected} )   ? $Param{Selected}      : '';
    my $SelectedIDRefArray = $Param{SelectedIDRefArray} || '';
    my $Multiple = $Param{Multiple} ? 'multiple' : '';
    my $OnChangeSubmit = defined( $Param{OnChangeSubmit} ) ? $Param{OnChangeSubmit} : '';
    if ($OnChangeSubmit) {
        $OnChangeSubmit = " onchange=\"submit()\"";
    }
    else {
        $OnChangeSubmit = '';
    }

    # set OnChange if AJAX is used
    if ( $Param{Ajax} ) {
        if ( !$Param{Ajax}->{Depend} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need Depend Param Ajax option!",
            );
            $Self->FatalError();
        }
        if ( !$Param{Ajax}->{Update} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need Update Param Ajax option()!",
            );
            $Self->FatalError();
        }
        $Param{OnChange} = "AJAXUpdate('" . $Param{Ajax}->{Subaction} . "',"
            . " '$Param{Name}',"
            . " ['"
            . join( "', '", @{ $Param{Ajax}->{Depend} } ) . "'], ['"
            . join( "', '", @{ $Param{Ajax}->{Update} } ) . "']);";
    }

    if ( $Param{OnChange} ) {
        $OnChangeSubmit = " onchange=\"$Param{OnChange}\"";
    }

    # just show a simple list
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'list' ) {
        $Param{'MoveQueuesStrg'} = $Self->OptionStrgHashRef( %Param, HTMLQuote => 0, );
        return $Param{MoveQueuesStrg};
    }

    # build tree list
    $Param{MoveQueuesStrg}
        = '<select name="' . $Param{Name} . "\" $Size $Multiple $OnChangeSubmit>\n";
    my %UsedData = ();
    my %Data     = ();
    if ( $Param{Data} && ref $Param{Data} eq 'HASH' ) {
        %Data = %{ $Param{Data} };
    }
    else {
        return 'Need Data Ref in AgentQueueListOption()!';
    }

    # add suffix for correct sorting
    for ( sort { $Data{$a} cmp $Data{$b} } keys %Data ) {
        $Data{$_} .= '::';
    }

    # to show disabled queues only one time in the selection tree
    my %DisabledQueueAlreadyUsed = ();

    # build selection string
    for ( sort { $Data{$a} cmp $Data{$b} } keys %Data ) {
        my @Queue = split( /::/, $Param{Data}->{$_} );
        $UsedData{ $Param{Data}->{$_} } = 1;
        my $UpQueue = $Param{Data}->{$_};
        $UpQueue =~ s/^(.*)::.+?$/$1/g;
        if ( !$Queue[$MaxLevel] && $Queue[-1] ne '' ) {
            $Queue[-1] = $Self->Ascii2Html( Text => $Queue[-1], Max => 50 - $#Queue );
            my $Space = '';
            for ( my $i = 0; $i < $#Queue; $i++ ) {
                $Space .= '&nbsp;&nbsp;';
            }

            # check if SelectedIDRefArray exists
            if ($SelectedIDRefArray) {
                for my $ID ( @{$SelectedIDRefArray} ) {
                    if ( $ID eq $_ ) {
                        $Param{SelectedIDRefArrayOK}->{$_} = 1;
                    }
                }
            }

            if ( !$UsedData{$UpQueue} ) {

                # integrate the not selectable parent and root queues of this queue
                # useful for ACLs and complex permission settings
                for my $Index ( 0 .. ( scalar @Queue - 2 ) ) {
                    if ( !$DisabledQueueAlreadyUsed{ $Queue[$Index] } ) {
                        my $DSpace = '&nbsp;&nbsp;' x $Index;
                        $Param{MoveQueuesStrg}
                            .= '<option value="-" disabled>'
                            . $DSpace
                            . $Queue[$Index]
                            . "</option>\n";
                        $DisabledQueueAlreadyUsed{ $Queue[$Index] } = 1;
                    }
                }
            }

            # create selectable elements
            my $String = $Space . $Queue[-1];
            if (
                $SelectedID  eq $_
                || $Selected eq $Param{Data}->{$_}
                || $Param{SelectedIDRefArrayOK}->{$_}
                )
            {
                $Param{MoveQueuesStrg}
                    .= '<option selected value="' . $_ . '">' . $String . "</option>\n";
            }
            else {
                $Param{MoveQueuesStrg} .= '<option value="' . $_ . '">' . $String . "</option>\n";
            }
        }
    }
    $Param{MoveQueuesStrg} .= "</select>\n";
    $Param{MoveQueuesStrg} .= "<a id=\"AJAXImage$Param{Name}\"></a>\n";

    return $Param{MoveQueuesStrg};
}

sub AgentFreeText {
    my ( $Self, %Param ) = @_;

    my %NullOption = ();
    my %SelectData = ();
    my %Ticket     = ();
    my %Config     = ();
    if ( $Param{NullOption} ) {

        #        $NullOption{''} = '-';
        $SelectData{Size}     = 3;
        $SelectData{Multiple} = 1;
    }
    if ( $Param{Ticket} ) {
        %Ticket = %{ $Param{Ticket} };
    }
    if ( $Param{Config} ) {
        %Config = %{ $Param{Config} };
    }
    my %Data = ();
    for ( 1 .. 16 ) {

        # key
        if ( ref $Config{"TicketFreeKey$_"} eq 'HASH' && %{ $Config{"TicketFreeKey$_"} } ) {
            my $Counter = 0;
            my $LastKey = '';
            for ( keys %{ $Config{"TicketFreeKey$_"} } ) {
                $Counter++;
                $LastKey = $_;
            }
            if ( $Counter == 1 && $Param{NullOption} ) {
                if ($LastKey) {
                    $Data{"TicketFreeKeyField$_"} = $Config{"TicketFreeKey$_"}->{$LastKey};
                }
            }
            elsif ( $Counter > 1 ) {
                $Data{"TicketFreeKeyField$_"} = $Self->OptionStrgHashRef(
                    Data => { %NullOption, %{ $Config{"TicketFreeKey$_"} }, },
                    Name => "TicketFreeKey$_",
                    SelectedID          => $Ticket{"TicketFreeKey$_"},
                    SelectedIDRefArray  => $Ticket{"TicketFreeKey$_"},
                    LanguageTranslation => 0,
                    HTMLQuote           => 1,
                    %SelectData,
                );
            }
            else {
                if ($LastKey) {
                    $Data{"TicketFreeKeyField$_"}
                        = $Config{"TicketFreeKey$_"}->{$LastKey}
                        . '<input type="hidden" name="TicketFreeKey'
                        . $_
                        . '" value="'
                        . $Self->Ascii2Html( Text => $LastKey ) . '"/>';
                }
            }
        }
        else {
            if ( defined $Ticket{"TicketFreeKey$_"} ) {
                if ( ref $Ticket{"TicketFreeKey$_"} eq 'ARRAY' ) {
                    if ( $Ticket{"TicketFreeKey$_"}->[0] ) {
                        $Ticket{"TicketFreeKey$_"} = $Ticket{"TicketFreeKey$_"}->[0];
                    }
                    else {
                        $Ticket{"TicketFreeKey$_"} = '';
                    }
                }
                $Data{"TicketFreeKeyField$_"}
                    = '<input type="text" name="TicketFreeKey'
                    . $_
                    . '" value="'
                    . $Self->Ascii2Html( Text => $Ticket{"TicketFreeKey$_"} )
                    . '" size="18"/>';
            }
            else {
                $Data{"TicketFreeKeyField$_"}
                    = '<input type="text" name="TicketFreeKey' . $_ . '" value="" size="18"/>';
            }
        }

        # value
        if ( ref $Config{"TicketFreeText$_"} eq 'HASH' ) {
            $Data{"TicketFreeTextField$_"} = $Self->OptionStrgHashRef(
                Data => { %NullOption, %{ $Config{"TicketFreeText$_"} }, },
                Name => "TicketFreeText$_",
                SelectedID          => $Ticket{"TicketFreeText$_"},
                SelectedIDRefArray  => $Ticket{"TicketFreeText$_"},
                LanguageTranslation => 0,
                HTMLQuote           => 1,
                %SelectData,
            );
        }
        else {
            if ( defined $Ticket{"TicketFreeText$_"} ) {
                if ( ref $Ticket{"TicketFreeText$_"} eq 'ARRAY' ) {
                    if ( $Ticket{"TicketFreeText$_"}->[0] ) {
                        $Ticket{"TicketFreeText$_"} = $Ticket{"TicketFreeText$_"}->[0];
                    }
                    else {
                        $Ticket{"TicketFreeText$_"} = '';
                    }
                }
                $Data{"TicketFreeTextField$_"}
                    = '<input type="text" name="TicketFreeText'
                    . $_
                    . '" value="'
                    . $Self->Ascii2Html( Text => $Ticket{"TicketFreeText$_"} )
                    . '" size="30"/>';
            }
            else {
                $Data{"TicketFreeTextField$_"}
                    = '<input type="text" name="TicketFreeText' . $_ . '" value="" size="30"/>';
            }
        }
        $Data{"TicketFreeTextField$_"}
            .= '<font color="red" size="-2">$Text{"$Data{"TicketFreeTextField'
            . $_
            . ' invalid"}"}</font>';
    }
    return %Data;
}

sub AgentFreeDate {
    my ( $Self, %Param ) = @_;

    my %NullOption = ();
    my %SelectData = ();
    my %Ticket     = ();
    my %Config     = ();

    if ( $Param{NullOption} ) {
        $SelectData{Size}     = 3;
        $SelectData{Multiple} = 1;
    }
    if ( $Param{Ticket} ) {
        %Ticket = %{ $Param{Ticket} };
    }
    if ( $Param{Config} ) {
        %Config = %{ $Param{Config} };
    }
    my %Data = ();
    for my $Count ( 1 .. 6 ) {
        my %TimePeriod = ();
        if ( $Self->{ConfigObject}->Get( 'TicketFreeTimePeriod' . $Count ) ) {
            %TimePeriod = %{ $Self->{ConfigObject}->Get( 'TicketFreeTimePeriod' . $Count ) };
        }
        $Data{ 'TicketFreeTime' . $Count } = $Self->BuildDateSelection(
            %Param,
            %Ticket,
            Prefix   => 'TicketFreeTime' . $Count,
            Format   => 'DateInputFormatLong',
            DiffTime => $Self->{ConfigObject}->Get( 'TicketFreeTimeDiff' . $Count ) || 0,
            %TimePeriod,
        );
    }
    return %Data;
}

sub TicketArticleFreeText {
    my ( $Self, %Param ) = @_;

    my %NullOption = ();
    my %SelectData = ();
    my %Article    = ();
    my %Config     = ();
    if ( $Param{NullOption} ) {
        $SelectData{Size}     = 3;
        $SelectData{Multiple} = 1;
    }
    if ( $Param{Article} ) {
        %Article = %{ $Param{Article} };
    }
    if ( $Param{Config} ) {
        %Config = %{ $Param{Config} };
    }
    my %Data = ();
    for ( 1 .. 3 ) {

        # key
        if ( ref $Config{"ArticleFreeKey$_"} eq 'HASH' && %{ $Config{"ArticleFreeKey$_"} } ) {
            my $Counter = 0;
            my $LastKey = '';
            for ( keys %{ $Config{"ArticleFreeKey$_"} } ) {
                $Counter++;
                $LastKey = $_;
            }
            if ( $Counter == 1 && $Param{NullOption} ) {
                if ($LastKey) {
                    $Data{"ArticleFreeKeyField$_"} = $Config{"ArticleFreeKey$_"}->{$LastKey};
                }
            }
            elsif ( $Counter > 1 ) {
                $Data{"ArticleFreeKeyField$_"} = $Self->OptionStrgHashRef(
                    Data => { %NullOption, %{ $Config{"ArticleFreeKey$_"} }, },
                    Name => "ArticleFreeKey$_",
                    SelectedID          => $Article{"ArticleFreeKey$_"},
                    SelectedIDRefArray  => $Article{"ArticleFreeKey$_"},
                    LanguageTranslation => 0,
                    HTMLQuote           => 1,
                    %SelectData,
                );
            }
            else {
                if ($LastKey) {
                    $Data{"ArticleFreeKeyField$_"}
                        = $Config{"ArticleFreeKey$_"}->{$LastKey}
                        . '<input type="hidden" name="ArticleFreeKey'
                        . $_
                        . '" value="'
                        . $Self->Ascii2Html( Text => $LastKey ) . '"/>';
                }
            }
        }
        else {
            if ( defined $Article{"ArticleFreeKey$_"} ) {
                if ( ref $Article{"ArticleFreeKey$_"} eq 'ARRAY' ) {
                    if ( $Article{"ArticleFreeKey$_"}->[0] ) {
                        $Article{"ArticleFreeKey$_"} = $Article{"ArticleFreeKey$_"}->[0];
                    }
                    else {
                        $Article{"ArticleFreeKey$_"} = '';
                    }
                }
                $Data{"ArticleFreeKeyField$_"}
                    = '<input type="text" name="ArticleFreeKey'
                    . $_
                    . '" value="'
                    . $Self->Ascii2Html( Text => $Article{"ArticleFreeKey$_"} )
                    . '" size="18"/>';
            }
            else {
                $Data{"ArticleFreeKeyField$_"}
                    = '<input type="text" name="ArticleFreeKey' . $_ . '" value="" size="18"/>';
            }
        }

        # value
        if ( ref $Config{"ArticleFreeText$_"} eq 'HASH' ) {
            $Data{"ArticleFreeTextField$_"} = $Self->OptionStrgHashRef(
                Data => { %NullOption, %{ $Config{"ArticleFreeText$_"} }, },
                Name => "ArticleFreeText$_",
                SelectedID          => $Article{"ArticleFreeText$_"},
                SelectedIDRefArray  => $Article{"ArticleFreeText$_"},
                LanguageTranslation => 0,
                HTMLQuote           => 1,
                %SelectData,
            );
        }
        else {
            if ( defined $Article{"ArticleFreeText$_"} ) {
                if ( ref $Article{"ArticleFreeText$_"} eq 'ARRAY' ) {
                    if ( $Article{"ArticleFreeText$_"}->[0] ) {
                        $Article{"ArticleFreeText$_"} = $Article{"ArticleFreeText$_"}->[0];
                    }
                    else {
                        $Article{"ArticleFreeText$_"} = '';
                    }
                }
                $Data{"ArticleFreeTextField$_"}
                    = '<input type="text" name="ArticleFreeText'
                    . $_
                    . '" value="'
                    . $Self->Ascii2Html( Text => $Article{"ArticleFreeText$_"} )
                    . '" size="30"/>';
            }
            else {
                $Data{"ArticleFreeTextField$_"}
                    = '<input type="text" name="ArticleFreeText' . $_ . '" value="" size="30"/>';
            }
        }
    }
    return %Data;
}

sub CustomerFreeDate {
    my ( $Self, %Param ) = @_;

    my %NullOption = ();
    my %SelectData = ();
    my %Ticket     = ();
    my %Config     = ();
    if ( $Param{NullOption} ) {
        $SelectData{Size}     = 3;
        $SelectData{Multiple} = 1;
    }
    if ( $Param{Ticket} ) {
        %Ticket = %{ $Param{Ticket} };
    }
    if ( $Param{Config} ) {
        %Config = %{ $Param{Config} };
    }
    my %Data = ();
    for my $Count ( 1 .. 6 ) {
        my %TimePeriod = ();
        if ( $Self->{ConfigObject}->Get( 'TicketFreeTimePeriod' . $Count ) ) {
            %TimePeriod = %{ $Self->{ConfigObject}->Get( 'TicketFreeTimePeriod' . $Count ) };
        }
        $Data{ 'TicketFreeTime' . $Count } = $Self->BuildDateSelection(
            Area => 'Customer',
            %Param,
            %Ticket,
            Prefix   => 'TicketFreeTime' . $Count,
            Format   => 'DateInputFormatLong',
            DiffTime => $Self->{ConfigObject}->Get( 'TicketFreeTimeDiff' . $Count ) || 0,
            %TimePeriod,
        );
    }
    return %Data;
}

=item ArticleQuote()

get body and attach e. g. inline documents and/or attach all attachments to
upload cache

for forward or split, get body and attach all attachments

    my $HTMLBody = $LayoutObject->ArticleQuote(
        TicketID           => 123,
        ArticleID          => 123,
        FormID             => $Self->{FormID},
        UploadCachObject   => $Self->{UploadCachObject},
        AttachmentsInclude => 1,
    );

of just for including inline documents to upload cache

    my $HTMLBody = $LayoutObject->ArticleQuote(
        TicketID           => 123,
        ArticleID          => 123,
        FormID             => $Self->{FormID},
        UploadCachObject   => $Self->{UploadCachObject},
        AttachmentsInclude => 0,
    );

Both will also work without rich text (if $ConfigObject->Get('Frontend::RichText')
is false), return param will be text/plain instead.

=cut

sub ArticleQuote {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID ArticleID FormID UploadCachObject)) {
        if ( !$Param{$_} ) {
            $Self->FatalError( Message => "Need $_!" );
        }
    }

    # body preparation for plain text processing
    if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {

        my $Body = '';

        # check for html body
        my @ArticleBox = $Self->{TicketObject}->ArticleContentIndex(
            TicketID                   => $Param{TicketID},
            StripPlainBodyAsAttachment => 1,
        );

        my %NotInlineAttachments;
        ARTICLE:
        for my $ArticleTmp (@ArticleBox) {

            # search for article to answer (reply article)
            next ARTICLE if $ArticleTmp->{ArticleID} ne $Param{ArticleID};

            # check if no html body exists
            last ARTICLE if !$ArticleTmp->{AttachmentIDOfHTMLBody};

            my %AttachmentHTML = $Self->{TicketObject}->ArticleAttachment(
                ArticleID => $ArticleTmp->{ArticleID},
                FileID    => $ArticleTmp->{AttachmentIDOfHTMLBody},
            );
            my $Charset = $AttachmentHTML{ContentType};
            $Charset =~ s/.+?charset=("|'|)(\w+)/$2/gi;
            $Charset =~ s/"|'//g;
            $Charset =~ s/(.+?);.*/$1/g;

            # convert html body to correct charset
            $Body = $Self->{EncodeObject}->Convert(
                Text => $AttachmentHTML{Content},
                From => $Charset,
                To   => $Self->{UserCharset},
            );

            # add url quoting
            $Body = $Self->{HTMLUtilsObject}->LinkQuote(
                String => $Body,
            );

            # strip head, body and meta elements
            $Body = $Self->{HTMLUtilsObject}->DocumentStrip(
                String => $Body,
            );

            # display inline images if exists
            my $SessionID = '';
            if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
                $SessionID = "&" . $Self->{SessionName} . "=" . $Self->{SessionID};
            }
            my $AttachmentLink = $Self->{Baselink}
                . 'Action=PictureUpload'
                . '&FormID='
                . $Param{FormID}
                . $SessionID
                . '&ContentID=';

            # search inline documents in body and add it to upload cache
            my %Attachments = %{ $ArticleTmp->{Atms} };
            my %AttachmentAlreadyUsed;
            $Body =~ s{
                (=|"|')cid:(.*?)("|'|>|\/>|\s)
            }
            {
                my $Start= $1;
                my $ContentID = $2;
                my $End = $3;

                # improve html quality
                if ( $Start ne '"' && $Start ne '\'' ) {
                    $Start .= '"';
                }
                if ( $End ne '"' && $End ne '\'' ) {
                    $End = '"' . $End;
                }

                # find attachment to include
                ATMCOUNT:
                for my $AttachmentID ( sort keys %Attachments ) {

                    # next is cid is not matchin
                    if ( lc $Attachments{$AttachmentID}->{ContentID} ne lc "<$ContentID>" ) {
                        next ATMCOUNT;
                    }

                    # get whole attachment
                    my %AttachmentPicture = $Self->{TicketObject}->ArticleAttachment(
                        ArticleID => $Param{ArticleID},
                        FileID    => $AttachmentID,
                        UserID    => $Self->{UserID},
                    );

                    # content id cleanup
                    $AttachmentPicture{ContentID} =~ s/^<//;
                    $AttachmentPicture{ContentID} =~ s/>$//;

                    # find cid, add attachment URL and remeber, file is already uploaded
                    $ContentID = $AttachmentLink . $AttachmentPicture{ContentID};

                    # add to upload cache if not uploaded and remember
                    if (!$AttachmentAlreadyUsed{$AttachmentID}) {

                        # remember
                        $AttachmentAlreadyUsed{$AttachmentID} = 1;

                        # write attachment to upload cache
                        $Param{UploadCachObject}->FormIDAddFile(
                            FormID      => $Param{FormID},
                            Disposition => 'inline',
                            %{ $Attachments{$AttachmentID} },
                            %AttachmentPicture,
                        );
                    }
                }

                # return link
                $Start . $ContentID . $End;
            }egxi;

            # find not inline images
            for my $AttachmentID ( sort keys %Attachments ) {
                next if $AttachmentAlreadyUsed{$AttachmentID};
                $NotInlineAttachments{$AttachmentID} = 1;
            }

            # do no more article
            last ARTICLE;
        }

        # attach also other attachments on article forward
        if ( $Body && $Param{AttachmentsInclude} ) {
            for my $AttachmentID ( sort keys %NotInlineAttachments ) {
                my %Attachment = $Self->{TicketObject}->ArticleAttachment(
                    ArticleID => $Param{ArticleID},
                    FileID    => $AttachmentID,
                    UserID    => $Self->{UserID},
                );

                # add attachment
                $Param{UploadCachObject}->FormIDAddFile(
                    FormID => $Param{FormID},
                    %Attachment,
                );
            }
        }

        return $Body if $Body;
    }

    # as fallback use text body for quote
    my %Article = $Self->{TicketObject}->ArticleGet( ArticleID => $Param{ArticleID} );

    # check if original content isn't text/plain or text/html, don't use it
    if ( !$Article{ContentType} ) {
        $Article{ContentType} = 'text/plain';
    }

    # check if original content isn't text/plain or text/html, don't use it
    if ( $Article{ContentType} !~ /text\/(plain|html)/i ) {
        $Article{Body}        = '-> no quotable message <-';
        $Article{ContentType} = 'text/plain';
    }
    else {
        my $Size = $Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaEmail') || 82;
        $Article{Body} =~ s/(^>.+|.{4,$Size})(?:\s|\z)/$1\n/gm;
    }

    # attach attachments
    if ( $Param{AttachmentsInclude} ) {
        my %ArticleIndex = $Self->{TicketObject}->ArticleAttachmentIndex(
            ArticleID => $Param{ArticleID},
            UserID    => $Self->{UserID},
        );
        for my $Index ( keys %ArticleIndex ) {
            my %Attachment = $Self->{TicketObject}->ArticleAttachment(
                ArticleID => $Param{ArticleID},
                FileID    => $Index,
                UserID    => $Self->{UserID},
            );

            # add attachment
            $Param{UploadCachObject}->FormIDAddFile(
                FormID => $Param{FormID},
                %Attachment,
            );
        }
    }

    # return body as html
    if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {

        $Article{Body} = $Self->Ascii2Html(
            Text           => $Article{Body},
            HTMLResultMode => 1,
            LinkFeature    => 1,
        );
    }

    # return body as plain text
    return $Article{Body};

}

sub TicketListShow {
    my ( $Self, %Param ) = @_;

    # take object ref to local, remove it from %Param (prevent memory leak)
    my $Env = $Param{Env};
    delete $Param{Env};

    # lookup latest used view mode
    if ( !$Param{View} && $Self->{ 'UserTicketOverview' . $Env->{Action} } ) {
        $Param{View} = $Self->{ 'UserTicketOverview' . $Env->{Action} };
    }

    # set defaut view mode to 'small'
    my $View = $Param{View} || 'Small';

    # set default view mode for AgentTicketQueue
    if ( !$Param{View} && $Env->{Action} eq 'AgentTicketQueue' ) {
        $View = 'Preview';
    }

    # store latest view mode
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'UserTicketOverview' . $Env->{Action},
        Value     => $View,
    );

    # update preferences
    if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {
        $Self->{UserObject}->SetPreferences(
            UserID => $Self->{UserID},
            Key    => 'UserTicketOverview' . $Env->{Action},
            Value  => $View,
        );
    }

    # check backends
    my $Backends = $Self->{ConfigObject}->Get('Ticket::Frontend::Overview');
    if ( !$Backends ) {
        return $Env->{LayoutObject}->FatalError(
            Message => 'Need config option Ticket::Frontend::Overview',
        );
    }
    if ( ref $Backends ne 'HASH' ) {
        return $Env->{LayoutObject}->FatalError(
            Message => 'Config option Ticket::Frontend::Overview need to be HASH ref!',
        );
    }

    # check if selected view is available
    if ( !$Backends->{$View} ) {

        # try to find fallback, take first configured view mode
        for my $Key ( sort keys %{$Backends} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No Config option found for view mode $View, took $Key instead!",
            );
            $View = $Key;
            last;
        }
    }

    # nav bar
    my $StartHit = $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1;

    # check start option, if higher then tickets available, set
    # it to the last ticket page (Thanks to Stefan Schmidt!)
    my $PageShown = $Backends->{$View}->{PageShown};
    if ( $StartHit > $Param{Total} ) {
        my $Pages = int( ( $Param{Total} / $PageShown ) + 0.99999 );
        $StartHit = ( ( $Pages - 1 ) * $PageShown ) + 1;
    }

    my $Limit = $Param{Limit} || 20_000;
    my %PageNav = $Env->{LayoutObject}->PageNavBar(
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
        Action    => 'Action=' . $Env->{LayoutObject}->{Action},
        Link      => $Param{LinkPage},
    );

    $Env->{LayoutObject}->Block(
        Name => 'OverviewNavBar',
        Data => \%Param,
    );

    # back link
    if ( $Param{LinkBack} ) {
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarPageBack',
            Data => \%Param,
        );
    }

    # filter
    if ( $Param{Filters} ) {
        my @NavBarFilters;
        for my $Prio ( sort keys %{ $Param{Filters} } ) {
            push @NavBarFilters, $Param{Filters}->{$Prio};
        }
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarFilter',
            Data => {
                %Param,
            },
        );
        my $Count = 0;
        for my $Filter (@NavBarFilters) {
            if ($Count) {
                $Env->{LayoutObject}->Block(
                    Name => 'OverviewNavBarFilterItemSplit',
                    Data => {
                        %Param,
                        %{$Filter},
                    },
                );
            }
            $Count++;
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarFilterItem',
                Data => {
                    %Param,
                    %{$Filter},
                },
            );
            if ( $Filter->{Filter} eq $Param{Filter} ) {
                $Env->{LayoutObject}->Block(
                    Name => 'OverviewNavBarFilterItemSelected',
                    Data => {
                        %Param,
                        %{$Filter},
                    },
                );
            }
            else {
                $Env->{LayoutObject}->Block(
                    Name => 'OverviewNavBarFilterItemSelectedNot',
                    Data => {
                        %Param,
                        %{$Filter},
                    },
                );
            }
        }
    }

    # mode
    for my $Backend ( keys %{$Backends} ) {
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarViewMode',
            Data => {
                %Param,
                %{ $Backends->{$Backend} },
                Filter => $Param{Filter},
                View   => $Backend,
            },
        );
        if ( $View eq $Backend ) {
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarViewModeSelected',
                Data => {
                    %Param,
                    %{ $Backends->{$Backend} },
                    Filter => $Param{Filter},
                    View   => $Backend,
                },
            );
        }
        else {
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarViewModeNotSelected',
                Data => {
                    %Param,
                    %{ $Backends->{$Backend} },
                    Filter => $Param{Filter},
                    View   => $Backend,
                },
            );
        }
    }

    if (%PageNav) {
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarPageNavBar',
            Data => \%PageNav,
        );
    }

    if ( $Param{NavBar} ) {
        if ( $Param{NavBar}->{MainName} ) {
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarMain',
                Data => $Param{NavBar},
            );
        }
    }

    my $OutputNavBar = $Env->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketOverviewNavBar',
        Data         => { %Param, },
    );
    my $OutputRaw = '';
    if ( !$Param{Output} ) {
        $Env->{LayoutObject}->Print( Output => \$OutputNavBar );
    }
    else {
        $OutputRaw .= $OutputNavBar;
    }

    # load module
    if ( !$Self->{MainObject}->Require( $Backends->{$View}->{Module} ) ) {
        return $Env->{LayoutObject}->FatalError();
    }
    my $Object = $Backends->{$View}->{Module}->new( %{$Env} );
    return if !$Object;

    # run module
    my $Output = $Object->Run(
        %Param,
        Config    => $Backends->{$View},
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
    );
    if ( !$Param{Output} ) {
        $Env->{LayoutObject}->Print( Output => \$Output );
    }
    else {
        $OutputRaw .= $Output;
    }

    if (1) {
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBar',
            Data => \%Param,
        );
        if (%PageNav) {
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarPageNavBar',
                Data => \%PageNav,
            );
        }
        my $OutputNavBarSmall = $Env->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketOverviewNavBarSmall',
            Data         => { %Param, },
        );
        if ( !$Param{Output} ) {
            $Env->{LayoutObject}->Print( Output => \$OutputNavBarSmall );
        }
        else {
            $OutputRaw .= $OutputNavBarSmall;
        }
    }

    return $OutputRaw;
}

1;
