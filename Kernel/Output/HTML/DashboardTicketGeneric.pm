# --
# Kernel/Output/HTML/DashboardTicketGeneric.pm
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: DashboardTicketGeneric.pm,v 1.20.2.2 2010-09-22 09:30:24 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardTicketGeneric;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.20.2.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID)
        )
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    # get current filter
    my $Name = $Self->{ParamObject}->GetParam( Param => 'Name' ) || '';
    my $PreferencesKey = 'UserDashboardTicketGenericFilter' . $Self->{Name};
    if ( $Self->{Name} eq $Name ) {
        $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || '';
    }

    # remember filter
    if ( $Self->{Filter} ) {

        # update ssession
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => $PreferencesKey,
            Value     => $Self->{Filter},
        );

        # update preferences
        if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {
            $Self->{UserObject}->SetPreferences(
                UserID => $Self->{UserID},
                Key    => $PreferencesKey,
                Value  => $Self->{Filter},
            );
        }
    }

    if ( !$Self->{Filter} ) {
        $Self->{Filter} = $Self->{$PreferencesKey} || $Self->{Config}->{Filter} || 'All';
    }

    $Self->{PrefKey} = 'UserDashboardPref' . $Self->{Name} . '-Shown';

    $Self->{PageShown} = $Self->{LayoutObject}->{ $Self->{PrefKey} } || $Self->{Config}->{Limit};

    $Self->{StartHit} = int( $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1 );

    $Self->{CacheKey}
        = $Self->{Name} . '-'
        . $Self->{PageShown} . '-'
        . $Self->{StartHit} . '-'
        . $Self->{UserID};

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    my @Params = (
        {
            Desc  => 'Shown Tickets',
            Name  => $Self->{PrefKey},
            Block => 'Option',

            #            Block => 'Input',
            Data => {
                5  => ' 5',
                10 => '10',
                15 => '15',
                20 => '20',
                25 => '25',
            },
            SelectedID => $Self->{PageShown},
        },
    );

    return @Params;
}

sub Config {
    my ( $Self, %Param ) = @_;

    # check if frontend module of link is used
    if ( $Self->{Config}->{Link} && $Self->{Config}->{Link} =~ /Action=(.+?)(&.+?|)$/ ) {
        my $Action = $1;
        if ( !$Self->{ConfigObject}->Get('Frontend::Module')->{$Action} ) {
            $Self->{Config}->{Link} = '';
        }
    }

    return (
        %{ $Self->{Config} },

        # remember, do not allow to use page cache
        # (it's not working because of internal filter)
        CacheTTL => undef,
        CacheKey => undef,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get all search base attributes
    my %TicketSearch;
    my @Params = split /;/, $Self->{Config}->{Attributes};
    for my $String (@Params) {
        next if !$String;
        my ( $Key, $Value ) = split /=/, $String;

        if ( $Key eq 'StateType' ) {
            push @{ $TicketSearch{$Key} }, $Value;
        }
        elsif ( !defined $TicketSearch{$Key} ) {
            $TicketSearch{$Key} = $Value;
        }
        elsif ( !ref $TicketSearch{$Key} ) {
            my $ValueTmp = $TicketSearch{$Key};
            $TicketSearch{$Key} = [$ValueTmp];
        }
        else {
            push @{ $TicketSearch{$Key} }, $Value;
        }
    }
    %TicketSearch = (
        %TicketSearch,
        Permission => $Self->{Config}->{Permission} || 'ro',
        UserID => $Self->{UserID},
    );

    # define filter attributes
    my @MyQueues = $Self->{QueueObject}->GetAllCustomQueues(
        UserID => $Self->{UserID},
    );
    if ( !@MyQueues ) {
        @MyQueues = (999_999);
    }
    my %TicketSearchSummary = (
        Locked => {
            OwnerIDs => [ $Self->{UserID}, ],
            Locks    => ['lock'],
        },
        Watcher => {
            WatchUserIDs => [ $Self->{UserID}, ],
            Locks        => undef,
        },
        Responsible => {
            ResponsibleIDs => [ $Self->{UserID}, ],
            Locks          => undef,
        },
        MyQueues => {
            QueueIDs => \@MyQueues,
            Locks    => undef,
        },
        All => {
            OwnerIDs => undef,
            Locks    => undef,
        },
    );

    # check cache
    my $TicketIDs = $Self->{CacheObject}->Get(
        Type => 'Dashboard',
        Key  => $Self->{CacheKey} . '-' . $Self->{Filter} . '-List',
    );

    # find and show ticket list
    my $CacheUsed = 1;
    if ( !$TicketIDs ) {
        $CacheUsed = 0;
        my @TicketIDsArray = $Self->{TicketObject}->TicketSearch(
            Result => 'ARRAY',
            %TicketSearch,
            %{ $TicketSearchSummary{ $Self->{Filter} } },
            Limit => $Self->{PageShown} + $Self->{StartHit} - 1,
        );
        $TicketIDs = \@TicketIDsArray;
    }

    # check cache
    my $Summary = $Self->{CacheObject}->Get(
        Type => 'Dashboard',
        Key  => $Self->{CacheKey} . '-Summary',
    );

    # if no cache ot new list result, do count lookup
    if ( !$Summary || !$CacheUsed ) {
        for my $Type ( sort keys %TicketSearchSummary ) {
            next if !$TicketSearchSummary{$Type};
            $Summary->{$Type} = $Self->{TicketObject}->TicketSearch(
                Result => 'COUNT',
                %TicketSearch,
                %{ $TicketSearchSummary{$Type} },
            );
        }
    }

    # set cache
    if ( !$CacheUsed && $Self->{Config}->{CacheTTLLocal} ) {
        $Self->{CacheObject}->Set(
            Type  => 'Dashboard',
            Key   => $Self->{CacheKey} . '-Summary',
            Value => $Summary,
            TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
        );
        $Self->{CacheObject}->Set(
            Type  => 'Dashboard',
            Key   => $Self->{CacheKey} . '-' . $Self->{Filter} . '-List',
            Value => $TicketIDs,
            TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
        );
    }

    # get filter ticket counts
    $Self->{LayoutObject}->SetEnv(
        Key   => 'Color',
        Value => 'searchactive',
    );
    $Summary->{ $Self->{Filter} . '::Style' } = 'text-decoration:none';
    $Self->{LayoutObject}->Block(
        Name => 'ContentLargeTicketGenericFilter',
        Data => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %{$Summary},
        },
    );

    # show also watcher if feature is enabled
    if ( $Self->{ConfigObject}->Get('Ticket::Watcher') ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericFilterWatcher',
            Data => {
                %{ $Self->{Config} },
                Name => $Self->{Name},
                %{$Summary},
            },
        );
    }

    # show also responsible if feature is enabled
    if ( $Self->{ConfigObject}->Get('Ticket::Responsible') ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericFilterResponsible',
            Data => {
                %{ $Self->{Config} },
                Name => $Self->{Name},
                %{$Summary},
            },
        );
    }

    # add page nav bar
    my $Total    = $Summary->{ $Self->{Filter} } || 0;
    my $LinkPage = 'Subaction=Element&Name=' . $Self->{Name} . '&Filter=' . $Self->{Filter} . '&';
    my %PageNav  = $Self->{LayoutObject}->PageNavBar(
        StartHit    => $Self->{StartHit},
        PageShown   => $Self->{PageShown},
        AllHits     => $Total || 1,
        Action      => 'Action=' . $Self->{LayoutObject}->{Action},
        Link        => $LinkPage,
        WindowSize  => 10,
        AJAXReplace => $Self->{Name},
    );
    $Self->{LayoutObject}->Block(
        Name => 'ContentLargeTicketGenericFilterNavBar',
        Data => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %PageNav,
        },
    );

    # show tickets
    my $Count = 0;
    for my $TicketID ( @{$TicketIDs} ) {
        $Count++;
        next if $Count < $Self->{StartHit};
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $TicketID,
            UserID   => $Self->{UserID},
        );

        # create human age
        if ( $Self->{Config}->{Time} ne 'Age' ) {
            $Ticket{Time} = $Self->{LayoutObject}->CustomerAgeInHours(
                Age   => $Ticket{ $Self->{Config}->{Time} },
                Space => ' ',
            );
        }
        else {
            $Ticket{Time} = $Self->{LayoutObject}->CustomerAge(
                Age   => $Ticket{ $Self->{Config}->{Time} },
                Space => ' ',
            );
        }

        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericRow',
            Data => \%Ticket,
        );
    }

    # show "none" if no ticket is available
    if ( !$TicketIDs || !@{$TicketIDs} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericNone',
            Data => {},
        );
    }

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardTicketGeneric',
        Data         => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %{$Summary},
        },
    );

    return $Content;
}

1;
