# --
# Kernel/Output/HTML/TicketMenuLock.pm
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: TicketMenuLock.pm,v 1.2 2005-02-17 07:09:28 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::TicketMenuLock;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Ticket}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Ticket!");
        return;
    }

    if (!defined($Param{ACL}->{$Param{Config}->{Action}}) || $Param{ACL}->{$Param{Config}->{Action}}) {
        $Self->{LayoutObject}->Block(
            Name => 'Menu',
            Data => { },
        );
        if ($Param{Counter}) {
            $Self->{LayoutObject}->Block(
                Name => 'MenuItemSplit',
                Data => {  },
            );
        }
        if ($Param{Ticket}->{Lock} eq 'lock') {
            $Self->{LayoutObject}->Block(
                Name => 'MenuItem',
                Data => {
                    %{$Param{Config}},
                    %{$Param{Ticket}},
                    %Param,
                    Name => 'Unlock',
                    Description => 'Unlock to give it back to the queue!',
                    Link => 'Action=AgentTicketLock&Subaction=Unlock&TicketID=$QData{"TicketID"}',
                },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'MenuItem',
                Data => {
                    %{$Param{Config}},
                    %Param,
                    Name => 'Lock',
                    Description => 'Lock it to work on it!',
                    Link => 'Action=AgentTicketLock&Subaction=Lock&TicketID=$QData{"TicketID"}',
                },
            );
        }
        $Param{Counter}++;
    }
    return $Param{Counter};
}
# --
1;
