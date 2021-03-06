# --
# XML.t - XML tests
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: XML.t,v 1.25 2009-07-29 16:43:48 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use utf8;
use Kernel::System::XML;
use Kernel::System::Ticket;

$Self->{XMLObject}    = Kernel::System::XML->new( %{$Self} );
$Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );
my $Charset = $Self->{ConfigObject}->Get('DefaultCharset');

# test with an iso-8859-1 encoded xml
my $String = '<?xml version="1.0" encoding="iso-8859-1" ?>
    <Contact>
      <Name type="long">' . "\x{00FC}" . ' Some Test</Name>
    </Contact>
';
my @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash( String => $String );
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact},
    '#1 XMLParse2XMLHash()',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{Name}->[1]->{type} || '',
    'long',
    '#1 XMLParse2XMLHash() (Contact->Name->type)',
);

# test charset specific situations
if ( $Charset eq 'utf-8' ) {
    $Self->Is(
        $XMLHash[1]->{Contact}->[1]->{Name}->[1]->{Content} || '',
        "ü Some Test",
        '#1 XMLParse2XMLHash() (Contact->Name->Content)',
    );
    $Self->True(
        Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{Name}->[1]->{Content} ) || '',
        '#1 XMLParse2XMLHash() (Contact->Name->type) Encode::is_utf8',
    );
}
elsif ( $Charset eq 'iso-8859-1' || $Charset eq 'iso-8859-15' ) {
    no utf8;
    $Self->Is(
        $XMLHash[1]->{Contact}->[1]->{Name}->[1]->{Content} || '',
        "� Some Test",
        '#1 XMLParse2XMLHash() (Contact->Name->Content)',
    );
    $Self->True(
        !Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{Name}->[1]->{Content} ) || '',
        '#1 XMLParse2XMLHash() (Contact->Name->type) Encode::is_utf8',
    );
}

# test with utf-8 encoded xml
$String = '<?xml version="1.0" encoding="utf-8" ?>
    <Contact role="admin" type="organization">
      <GermanText>German Umlaute öäü ÄÜÖ ß</GermanText>
      <JapanText>Japan カスタ</JapanText>
      <ChineseText>Chinese 用迎使用</ChineseText>
      <BulgarianText>Bulgarian Език</BulgarianText>
    </Contact>
';

@XMLHash = $Self->{XMLObject}->XMLParse2XMLHash( String => $String );
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact},
    '#2 XMLParse2XMLHash()',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{role} || '',
    'admin',
    '#2 XMLParse2XMLHash() (Contact->role)',
);

# test charset specific situations
if ( $Charset eq 'utf-8' ) {
    $Self->Is(
        $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content} || '',
        'German Umlaute öäü ÄÜÖ ß',
        '#2 XMLParse2XMLHash() (Contact->GermanText)',
    );
    $Self->True(
        Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content} ) || '',
        '#2 XMLParse2XMLHash() (Contact->GermanText) Encode::is_utf8',
    );
    $Self->Is(
        $XMLHash[1]->{Contact}->[1]->{JapanText}->[1]->{Content} || '',
        'Japan カスタ',
        '#2 XMLParse2XMLHash() (Contact->JapanText)',
    );
    $Self->True(
        Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{JapanText}->[1]->{Content} ) || '',
        '#2 XMLParse2XMLHash() (Contact->JapanText) Encode::is_utf8',
    );
    $Self->Is(
        $XMLHash[1]->{Contact}->[1]->{ChineseText}->[1]->{Content} || '',
        'Chinese 用迎使用',
        '#2 XMLParse2XMLHash() (Contact->ChineseText)',
    );
    $Self->True(
        Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{ChineseText}->[1]->{Content} ) || '',
        '#2 XMLParse2XMLHash() (Contact->ChineseText) Encode::is_utf8',
    );
    $Self->Is(
        $XMLHash[1]->{Contact}->[1]->{BulgarianText}->[1]->{Content} || '',
        'Bulgarian Език',
        '#2 XMLParse2XMLHash() (Contact->BulgarianText)',
    );
    $Self->True(
        Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{BulgarianText}->[1]->{Content} ) || '',
        '#2 XMLParse2XMLHash() (Contact->BulgarianText) Encode::is_utf8',
    );
}
elsif ( $Charset eq 'iso-8859-1' || $Charset eq 'iso-8859-15' ) {
    no utf8;
    $Self->Is(
        $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content} || '',
        'German Umlaute ��� ��� �',
        '#2 XMLParse2XMLHash() (Contact->GermanText)',
    );
    $Self->True(
        !Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content} ) || '',
        '#2 XMLParse2XMLHash() (Contact->GermanText) Encode::is_utf8',
    );

    $Self->True(
        !Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{JapanText}->[1]->{Content} ) || '',
        '#2 XMLParse2XMLHash() (Contact->JapanText) Encode::is_utf8',
    );

    $Self->True(
        !Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{ChineseText}->[1]->{Content} ) || '',
        '#2 XMLParse2XMLHash() (Contact->ChineseText) Encode::is_utf8',
    );

    $Self->True(
        !Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{BulgarianText}->[1]->{Content} ) || '',
        '#2 XMLParse2XMLHash() (Contact->BulgarianText) Encode::is_utf8',
    );
}

$String = '<?xml version="1.0" encoding="utf-8" ?>
    <Contact role="admin" type="organization">
      <Name type="long">Example Inc.</Name>
      <Email type="primary">info@exampe.com<Domain>1234.com</Domain></Email>
      <Email type="secundary">sales@example.com</Email>
      <Telephone country="germany">+49-999-99999</Telephone>
      <Telephone2 country="" extention="123"></Telephone2>
      <Telephone3 country="" extention="123"/>
      <SpecialCharacters>\'</SpecialCharacters>
      <SpecialCharacters1>\\\'</SpecialCharacters1>
      <SpecialCharacters2>0</SpecialCharacters2>
      <GermanText>German Umlaute öäü ÄÜÖ ß</GermanText>
    </Contact>
';

@XMLHash = $Self->{XMLObject}->XMLParse2XMLHash( String => $String );
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact},
    '#3 XMLParse2XMLHash()',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{role} || '',
    'admin',
    '#3 XMLParse2XMLHash() (Contact->role)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{Telephone}->[1]->{country} || '',
    'germany',
    '#3 XMLParse2XMLHash() (Contact->Telephone->country)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{Telephone2}->[1]->{Content},
    '',
    '#3 XMLParse2XMLHash() (Contact->Telephone2)',
);
my $CountryDefined = $XMLHash[1]->{Contact}->[1]->{Telephone2}->[1]->{country};
$Self->Is(
    $CountryDefined,
    '',
    '#3 XMLParse2XMLHash() (Contact->Telephone2->country)',
);
my $CountryUndefined = $XMLHash[1]->{Contact}->[1]->{Telephone2}->[1]->{country2};
$Self->Is(
    $CountryUndefined,
    undef,
    '#3 XMLParse2XMLHash() (Contact->Telephone2->country2) - undef',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{Telephone3}->[1]->{Content},
    '',
    '#3 XMLParse2XMLHash() (Contact->Telephone3)',
);
$CountryDefined = $XMLHash[1]->{Contact}->[1]->{Telephone3}->[1]->{country};
$Self->Is(
    $CountryDefined,
    '',
    '#3 XMLParse2XMLHash() (Contact->Telephone3->country)',
);
$CountryUndefined = $XMLHash[1]->{Contact}->[1]->{Telephone3}->[1]->{country2};
$Self->Is(
    $CountryUndefined,
    undef,
    '#3 XMLParse2XMLHash() (Contact->Telephone3->country2) - undef',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{SpecialCharacters}->[1]->{Content} || '',
    '\'',
    '#3 XMLParse2XMLHash() (Contact->SpecialCharacters)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{SpecialCharacters1}->[1]->{Content} || '',
    '\\\'',
    '#3 XMLParse2XMLHash() (Contact->SpecialCharacters1)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{SpecialCharacters2}->[1]->{Content},
    0,
    '#3 XMLParse2XMLHash() (Contact->SpecialCharacters2)',
);

# test charset specific situations
if ( $Charset eq 'utf-8' ) {
    $Self->Is(
        $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content} || '',
        'German Umlaute öäü ÄÜÖ ß',
        '#3 XMLParse2XMLHash() (Contact->GermanText)',
    );
    $Self->True(
        Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content} ) || '',
        '#3 XMLParse2XMLHash() (Contact->GermanText) Encode::is_utf8',
    );
}
elsif ( $Charset eq 'iso-8859-1' || $Charset eq 'iso-8859-15' ) {
    no utf8;
    $Self->Is(
        $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content} || '',
        'German Umlaute ��� ��� �',
        '#3 XMLParse2XMLHash() (Contact->GermanText)',
    );
    $Self->True(
        !Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content} ) || '',
        '#3 XMLParse2XMLHash() (Contact->GermanText) Encode::is_utf8',
    );
}

for my $Key ( 'Some\'Key', '123' ) {
    my $XMLHashAdd = $Self->{XMLObject}->XMLHashAdd(
        Type    => 'SomeType',
        Key     => $Key,
        XMLHash => \@XMLHash,
    );
    $Self->Is(
        $XMLHashAdd || '',
        $Key,
        "#3 ($Key) XMLHashAdd() (Key=$Key)",
    );
    my @XMLHashGet = $Self->{XMLObject}->XMLHashGet(
        Type => 'SomeType',
        Key  => $Key,
    );

    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{role} eq 'admin',
        "#3 ($Key) XMLHashGet() (admin) - from db",
    );
    $Self->True(
        $#XMLHashGet == 1
            && $XMLHashGet[1]->{Contact}->[1]->{Telephone}->[1]->{country} eq 'germany',
        "#3 ($Key) XMLHashGet() (Telephone->country)",
    );
    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{Telephone2}->[1]->{Content} eq '',
        "#3 ($Key) XMLHashGet() (Telephone2)",
    );

    # test charset specific situations
    if ( $Charset eq 'utf-8' ) {
        $Self->Is(
            $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
            'German Umlaute öäü ÄÜÖ ß',
            "#3 ($Key) XMLHashGet() (GermanText)",
        );
        $Self->True(
            Encode::is_utf8( $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content} ) || '',
            "#3 ($Key) XMLHashGet() (GermanText) - Encode::is_utf8",
        );
    }
    elsif ( $Charset eq 'iso-8859-1' || $Charset eq 'iso-8859-15' ) {
        no utf8;
        $Self->Is(
            $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
            'German Umlaute ��� ��� �',
            "#3 ($Key) XMLHashGet() (GermanText)",
        );
        $Self->True(
            !Encode::is_utf8( $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content} ) || '',
            "#3 ($Key) XMLHashGet() (GermanText) - Encode::is_utf8",
        );
    }

    @XMLHashGet = $Self->{XMLObject}->XMLHashGet(
        Type  => 'SomeType',
        Key   => $Key,
        Cache => 1,
    );
    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{role} eq 'admin',
        "#3 ($Key) XMLHashGet() (admin) - with cache",
    );
    $Self->True(
        $#XMLHashGet == 1
            && $XMLHashGet[1]->{Contact}->[1]->{Telephone}->[1]->{country} eq 'germany',
        "#3 ($Key) XMLHashGet() (Telephone->country)",
    );
    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{Telephone2}->[1]->{Content} eq '',
        "#3 ($Key) XMLHashGet() (Telephone2)",
    );

    # test charset specific situations
    if ( $Charset eq 'utf-8' ) {
        $Self->Is(
            $#XMLHashGet == 1 && $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
            'German Umlaute öäü ÄÜÖ ß',
            "#3 utf8($Key) XMLHashGet() (GermanText)",
        );
        $Self->True(
            Encode::is_utf8( $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content} ) || '',
            "#3 ($Key) XMLHashGet() (GermanText) - Encode::is_utf8",
        );
    }
    elsif ( $Charset eq 'iso-8859-1' || $Charset eq 'iso-8859-15' ) {
        no utf8;
        $Self->Is(
            $#XMLHashGet == 1 && $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
            'German Umlaute ��� ��� �',
            "#3 utf8($Key) XMLHashGet() (GermanText)",
        );
        $Self->True(
            !Encode::is_utf8( $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content} ) || '',
            "#3 ($Key) XMLHashGet() (GermanText) - Encode::is_utf8",
        );
    }

    @XMLHashGet = $Self->{XMLObject}->XMLHashGet(
        Type  => 'SomeType',
        Key   => $Key,
        Cache => 0,
    );
    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{role} eq 'admin',
        "#3 ($Key) XMLHashGet() (admin) - without cache",
    );
    $Self->True(
        $#XMLHashGet == 1
            && $XMLHashGet[1]->{Contact}->[1]->{Telephone}->[1]->{country} eq 'germany',
        "#3 ($Key) XMLHashGet() (Telephone->country)",
    );
    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{Telephone2}->[1]->{Content} eq '',
        "#3 ($Key) XMLHashGet() (Telephone2)",
    );

    # test charset specific situations
    if ( $Charset eq 'utf-8' ) {
        $Self->Is(
            $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
            'German Umlaute öäü ÄÜÖ ß',
            "#3 ($Key) XMLHashGet() (GermanText)",
        );
    }
    elsif ( $Charset eq 'iso-8859-1' || $Charset eq 'iso-8859-15' ) {
        no utf8;
        $Self->Is(
            $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
            'German Umlaute ��� ��� �',
            "#3 ($Key) XMLHashGet() (GermanText)",
        );
    }

    my $XMLHashUpdateTrue = $Self->{XMLObject}->XMLHashUpdate(
        Type    => 'SomeType',
        Key     => $Key,
        XMLHash => \@XMLHash,
    );
    $Self->True(
        $XMLHashUpdateTrue,
        "#3 ($Key) XMLHashUpdate() (admin)",
    );

    @XMLHashGet = $Self->{XMLObject}->XMLHashGet(
        Type  => 'SomeType',
        Key   => $Key,
        Cache => 0,
    );
    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{role} eq 'admin',
        "#3 ($Key) XMLHashGet() (admin) - from db",
    );
    $Self->True(
        $#XMLHashGet == 1
            && $XMLHashGet[1]->{Contact}->[1]->{Telephone}->[1]->{country} eq 'germany',
        "#3 ($Key) XMLHashGet() (Telephone->country)",
    );
    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{Telephone2}->[1]->{Content} eq '',
        "#3 ($Key) XMLHashGet() (Telephone2)",
    );

    # test charset specific situations
    if ( $Charset eq 'utf-8' ) {
        $Self->Is(
            $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
            'German Umlaute öäü ÄÜÖ ß',
            "utf8#3 ($Key) XMLHashGet() (GermanText)",
        );
        $Self->True(
            Encode::is_utf8( $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content} ) || '',
            "#3 ($Key) XMLHashGet() (GermanText) - Encode::is_utf8",
        );
    }
    elsif ( $Charset eq 'iso-8859-1' || $Charset eq 'iso-8859-15' ) {
        no utf8;
        $Self->Is(
            $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
            'German Umlaute ��� ��� �',
            "utf8#3 ($Key) XMLHashGet() (GermanText)",
        );
        $Self->True(
            !Encode::is_utf8( $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content} ) || '',
            "#3 ($Key) XMLHashGet() (GermanText) - Encode::is_utf8",
        );
    }

    my $XMLHashDelete = $Self->{XMLObject}->XMLHashDelete(
        Type => 'SomeType',
        Key  => $Key,
    );
    $Self->True(
        $XMLHashDelete,
        "#3 ($Key) XMLHashDelete()",
    );
}

my @XMLHashAdd = ();
$XMLHashAdd[1]->{Contact}->[1]->{role} = 'admin1';
$XMLHashAdd[1]->{Contact}->[1]->{Name}->[1]->{Content} = 'Example Inc. 2';
my $XMLHashUpdateAdd = $Self->{XMLObject}->XMLHashAdd(
    Type    => 'SomeType',
    Key     => '123',
    XMLHash => \@XMLHashAdd,
);
$Self->True(
    $XMLHashUpdateAdd,
    '#4 XMLHashAdd() (admin1) # 1',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key  => '123',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin1',
    '#4 XMLHashGet() (admin1) # 2',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key  => '123',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin1',
    '#4 XMLHashGet() (admin1)',
);

my @XMLHashUpdate = ();
$XMLHashUpdate[1]->{Contact}->[1]->{role} = 'admin';
$XMLHashUpdate[1]->{Contact}->[1]->{Name}->[1]->{Content} = 'Example Inc.';
my $XMLHashUpdateTrue = $Self->{XMLObject}->XMLHashUpdate(
    Type    => 'SomeType',
    Key     => '123',
    XMLHash => \@XMLHashUpdate,
);
$Self->True(
    $XMLHashUpdateTrue,
    '#4 XMLHashUpdate() (admin)',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key  => '123',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin',
    '#4 XMLHashGet() (admin)',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type  => 'SomeType',
    Key   => '123',
    Cache => 0,
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin',
    '#4 XMLHashGet() (admin) - without cache',
);

my $XML = $Self->{XMLObject}->XMLHash2XML(@XMLHash);
@XMLHash = $Self->{XMLObject}->XMLParse2XMLHash( String => $XML );
my $XML2 = $Self->{XMLObject}->XMLHash2XML(@XMLHash);
$Self->True(
    $XML eq $XML2,
    '#4 XMLHash2XML() -> XMLParse2XMLHash() -> XMLHash2XML()',
);

my $XML3 = $Self->{XMLObject}->XMLHash2XML(@XMLHash);
@XMLHash = $Self->{XMLObject}->XMLParse2XMLHash( String => $XML );
my $XML4 = $Self->{XMLObject}->XMLHash2XML(@XMLHash);
$Self->True(
    ( $XML2 eq $XML3 && $XML3 eq $XML4 ),
    '#4 XMLHash2XML() -> XMLHash2XML() -> XMLParse2XMLHash() -> XMLHash2XML()',
);

my @Keys = $Self->{XMLObject}->XMLHashList(
    Type => 'SomeType',
);
$Self->True(
    ( $Keys[0] == 123 ),
    '#4 XMLHashList() ([0] == 123)',
);

@Keys = $Self->{XMLObject}->XMLHashList(
    Type => 'SomeType',
);
for my $Key (@Keys) {
    my $XMLHashMove = $Self->{XMLObject}->XMLHashMove(
        OldType => 'SomeType',
        OldKey  => $Key,
        NewType => 'SomeTypeNew',
        NewKey  => $Key,
    );
    $Self->True(
        $XMLHashMove,
        "#4 XMLHashMove() (Key=$Key)",
    );
}

@Keys = $Self->{XMLObject}->XMLHashList(
    Type => 'SomeTypeNew',
);
for my $Key (@Keys) {
    my $XMLHashDelete = $Self->{XMLObject}->XMLHashDelete(
        Type => 'SomeTypeNew',
        Key  => $Key,
    );
    $Self->True(
        $XMLHashDelete,
        "#4 XMLHashDelete() (Key=$Key)",
    );
}

for my $KeyShould ( 1 .. 12 ) {
    my $XMLHashAdd = $Self->{XMLObject}->XMLHashAdd(
        Type             => 'SomeType',
        KeyAutoIncrement => 1,
        XMLHash          => \@XMLHash,
    );
    $Self->Is(
        $XMLHashAdd || '',
        $KeyShould,
        "#4 XMLHashAdd() ($KeyShould KeyAutoIncrement)",
    );
}

@Keys = $Self->{XMLObject}->XMLHashList(
    Type => 'SomeType',
);
for my $Key (@Keys) {
    my $XMLHashMove = $Self->{XMLObject}->XMLHashMove(
        OldType => 'SomeType',
        OldKey  => $Key,
        NewType => 'SomeTypeNew',
        NewKey  => $Key . 'New',
    );
    $Self->True(
        $XMLHashMove,
        "#4 XMLHashMove() 2 (Key=$Key)",
    );
}

@Keys = $Self->{XMLObject}->XMLHashList(
    Type => 'SomeTypeNew',
);
for my $Key (@Keys) {
    my $XMLHashDelete = $Self->{XMLObject}->XMLHashDelete(
        Type => 'SomeTypeNew',
        Key  => $Key,
    );
    $Self->True(
        $XMLHashDelete,
        "#4 XMLHashDelete() 2 (Key=$Key)",
    );
}

#------------------------------------------------#
# a test to find charset problems with xml files
#------------------------------------------------#

# get the example xml
my $Path = $Self->{ConfigObject}->Get('Home');
$Path .= "/scripts/test/sample";
my $File = 'XML-Test-file.xml';
$String = '';
if ( open( DATA, "< $Path/$File" ) ) {
    while (<DATA>) {
        $String .= $_;
    }
    close(DATA);

    # charset test - use file form the filesystem and parse it
    @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash( String => $String );
    $Self->True(
        $#XMLHash == 1
            && $XMLHash[1]->{'EISPP-Advisory'}->[1]->{System_Information}->[1]->{information},
        'XMLParse2XMLHash() - charset test - use file form the filesystem and parse it',
    );

    # charset test - use file form the articleattachement and parse it
    my $TicketID = $Self->{TicketObject}->TicketCreate(
        Title        => 'Some Ticket Title',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'closed successful',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    $Self->True(
        $TicketID,
        'XMLParse2XMLHash() - charset test - create ticket',
    );

    my $ArticleID = $Self->{TicketObject}->ArticleCreate(
        TicketID    => $TicketID,
        ArticleType => 'note-internal',
        SenderType  => 'agent',
        From        => 'Some Agent <email@example.com>',
        To          => 'Some Customer <customer-a@example.com>',
        Cc          => 'Some Customer <customer-b@example.com>',
        ReplyTo     => 'Some Customer <customer-b@example.com>',
        Subject     => 'some short description',
        Body =>
            'the message text Perl modules provide a range of featurheel, and can be downloaded',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify => 1,    # if you don't want to send agent notifications
    );

    $Self->True(
        $ArticleID,
        'XMLParse2XMLHash() - charset test - create article',
    );

    my $Feedback = $Self->{TicketObject}->ArticleWriteAttachment(
        Content     => $String,
        ContentType => 'text/html; charset="iso-8859-15"',
        Filename    => $File,
        ArticleID   => $ArticleID,
        UserID      => 1,
    );
    $Self->True(
        $Feedback,
        'XMLParse2XMLHash() - charset test - write an article attachemnt to storage',
    );

    my %Attachment = $Self->{TicketObject}->ArticleAttachment(
        ArticleID => $ArticleID,
        FileID    => 1,
        UserID    => 1,
    );

    @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash( String => $Attachment{Content} );
    $Self->True(
        $#XMLHash == 1
            && $XMLHash[1]->{'EISPP-Advisory'}->[1]->{System_Information}->[1]->{information},
        'XMLParse2XMLHash() - charset test - use file form the articleattachement and parse it',
    );

}
else {
    $Self->True(
        0,
        "XMLParse2XMLHash() - charset test - failed because example file not found",
    );
}

1;
