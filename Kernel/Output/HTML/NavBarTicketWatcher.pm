# --
# Kernel/Output/HTML/NavBarTicketWatcher.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: NavBarTicketWatcher.pm,v 1.14 2009-02-20 12:05:39 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NavBarTicketWatcher;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject TicketObject LayoutObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check if feature is aktive
    return if !$Self->{ConfigObject}->Get('Ticket::Watcher');

    # check access
    my @Groups;
    if ( $Self->{ConfigObject}->Get('Ticket::WatcherGroup') ) {
        @Groups = @{ $Self->{ConfigObject}->Get('Ticket::WatcherGroup') };
    }
    my $Access = 0;
    if ( !@Groups ) {
        $Access = 1;
    }
    else {
        for my $Group (@Groups) {
            next if !$Self->{LayoutObject}->{"UserIsGroup[$Group]"};
            if ( $Self->{LayoutObject}->{"UserIsGroup[$Group]"} eq 'Yes' ) {
                $Access = 1;
                last;
            }
        }
    }

    # return on no access
    return if !$Access;

    # find watched tickets
    my $Count = $Self->{TicketObject}->TicketSearch(
        Result       => 'ARRAY',
        Limit        => 1000,
        WatchUserIDs => [ $Self->{UserID} ],
        UserID       => 1,
        Permission   => 'ro',
    );
    my $Text   = $Self->{LayoutObject}->{LanguageObject}->Get('Watched Tickets') . " ($Count)";
    my %Return = ();
    $Return{'0999978'} = {
        Block       => 'ItemPersonal',
        Description => $Text,
        Name        => $Text,
        Image       => 'watcher.png',
        Link        => 'Action=AgentTicketWatchView',
        AccessKey   => '',
    };
    return %Return;
}

1;
