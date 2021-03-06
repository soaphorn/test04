# --
# Signature.t - Signature tests
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: Signature.t,v 1.6 2009-03-11 23:26:05 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use Kernel::System::Signature;

$Self->{SignatureObject} = Kernel::System::Signature->new( %{$Self} );

# add signature
my $SignatureNameRand0 = 'example-signature' . int( rand(1000000) );
my $Signature          = "Your OTRS-Team

<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname>

--
Super Support Company Inc. - Waterford Business Park
5201 Blue Lagoon Drive - 8th Floor & 9th Floor - Miami, 33126 USA
Email: hot\@florida.com - Web: http://hot.florida.com/
--";

my $SignatureID = $Self->{SignatureObject}->SignatureAdd(
    Name        => $SignatureNameRand0,
    Text        => $Signature,
    ContentType => 'text/plain; charset=iso-8859-1',
    Comment     => 'some comment',
    ValidID     => 1,
    UserID      => 1,
);

$Self->True(
    $SignatureID,
    'SignatureAdd()',
);

my %Signature = $Self->{SignatureObject}->SignatureGet( ID => $SignatureID );

$Self->Is(
    $Signature{Name} || '',
    $SignatureNameRand0,
    'SignatureGet() - Name',
);
$Self->True(
    $Signature{Text} eq $Signature,
    'SignatureGet() - Signature',
);
$Self->Is(
    $Signature{ContentType} || '',
    'text/plain; charset=iso-8859-1',
    'SignatureGet() - Comment',
);
$Self->Is(
    $Signature{Comment} || '',
    'some comment',
    'SignatureGet() - Comment',
);
$Self->Is(
    $Signature{ValidID} || '',
    1,
    'SignatureGet() - ValidID',
);

my %SignatureList = $Self->{SignatureObject}->SignatureList(
    Valid => 0,
);
my $Hit = 0;
for ( sort keys %SignatureList ) {
    if ( $_ eq $SignatureID ) {
        $Hit = 1;
    }
}
$Self->True(
    $Hit eq 1,
    'SignatureList()',
);

my $SignatureUpdate = $Self->{SignatureObject}->SignatureUpdate(
    ID          => $SignatureID,
    Name        => $SignatureNameRand0 . '1',
    Text        => $Signature . '1',
    ContentType => 'text/plain; charset=utf-8',
    Comment     => 'some comment 1',
    ValidID     => 2,
    UserID      => 1,
);

$Self->True(
    $SignatureUpdate,
    'SignatureUpdate()',
);

%Signature = $Self->{SignatureObject}->SignatureGet( ID => $SignatureID );

$Self->Is(
    $Signature{Name} || '',
    $SignatureNameRand0 . '1',
    'SignatureGet() - Name',
);
$Self->True(
    $Signature{Text} eq $Signature . '1',
    'SignatureGet() - Signature',
);
$Self->Is(
    $Signature{ContentType} || '',
    'text/plain; charset=utf-8',
    'SignatureGet() - Comment',
);
$Self->Is(
    $Signature{Comment} || '',
    'some comment 1',
    'SignatureGet() - Comment',
);
$Self->Is(
    $Signature{ValidID} || '',
    2,
    'SignatureGet() - ValidID',
);

1;
