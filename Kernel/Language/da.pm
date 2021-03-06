# --
# Kernel/Language/da.pm - provides da (Danish) language translation
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2006 Thorsten Rossner <thorsten.rossner[at]stepstone.de>
# Copyright (C) 2007-2008 Mads N. Vestergaard <mnv[at]timmy.dk>
# Copyright (C) 2010 Jesper Ulrik R�nnov <jeron[at]faaborgmidtfyn.dk>
# --
# $Id: da.pm,v 1.59.2.5 2010-06-25 08:43:21 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::da;

use strict;
use warnings;

use vars qw($VERSION);

$VERSION = qw($Revision: 1.59.2.5 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Sat Jun 27 13:54:57 2009

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Ja',
        'No' => 'Nej',
        'yes' => 'ja',
        'no' => 'nej',
        'Off' => 'Fra',
        'off' => 'fra',
        'On' => 'Til',
        'on' => 'til',
        'top' => 'start',
        'end' => 'slut',
        'Done' => 'F�rdig',
        'Cancel' => 'Annuller',
        'Reset' => 'Nulstil',
        'last' => 'sidste',
        'before' => 'f�r',
        'day' => 'dag',
        'days' => 'dage',
        'day(s)' => 'dag(e)',
        'hour' => 'time',
        'hours' => 'timer',
        'hour(s)' => 'time(r)',
        'minute' => 'minut',
        'minutes' => 'minutter',
        'minute(s)' => 'minut(ter)',
        'month' => 'm�ned',
        'months' => 'm�neder',
        'month(s)' => 'm�ned(er)',
        'week' => 'uge',
        'week(s)' => 'uge(r)',
        'year' => '�r',
        'years' => '�r',
        'year(s)' => '�r',
        'second(s)' => 'sekund(er)',
        'seconds' => 'sekunder',
        'second' => 'sekund',
        'wrote' => 'skrev',
        'Message' => 'Meddelelse',
        'Error' => 'Fejl',
        'Bug Report' => 'Fejlrapport',
        'Attention' => 'OBS',
        'Warning' => 'Advarsel',
        'Module' => 'Modul',
        'Modulefile' => 'Modulfil',
        'Subfunction' => 'Underfunktion',
        'Line' => 'Linje',
        'Setting' => 'Indstilling',
        'Settings' => 'Indstillinger',
        'Example' => 'Eksempel',
        'Examples' => 'Eksempler',
        'valid' => 'gyldig',
        'invalid' => 'ugyldig',
        '* invalid' => '* ugyldig',
        'invalid-temporarily' => 'ugyldig-midlertidigt',
        ' 2 minutes' => '2 minutter',
        ' 5 minutes' => '5 minutter',
        ' 7 minutes' => '7 minutter',
        '10 minutes' => '10 minutter',
        '15 minutes' => '15 minutter',
        'Mr.' => 'Hr.',
        'Mrs.' => 'Fru',
        'Next' => 'N�ste',
        'Back' => 'Tilbage',
        'Next...' => 'N�ste...',
        '...Back' => '...Tilbage',
        '-none-' => '-ingen-',
        'none' => 'ingen',
        'none!' => 'ingen!',
        'none - answered' => 'ingen - svarede',
        'please do not edit!' => 'v�r venlig ikke at redigere!',
        'AddLink' => 'Tilf�jLink',
        'Link' => 'Link',
        'Unlink' => 'Fjern link',
        'Linked' => 'Linket',
        'Link (Normal)' => 'Link (normal)',
        'Link (Parent)' => 'Link (for�ldre)',
        'Link (Child)' => 'Link (barn)',
        'Normal' => 'Normal',
        'Parent' => 'For�ldre',
        'Child' => 'Barn',
        'Hit' => 'Resultat',
        'Hits' => 'Antal resultater',
        'Text' => 'Tekst',
        'Lite' => 'Let',
        'User' => 'Bruger',
        'Username' => 'Brugernavn',
        'Language' => 'Sprog',
        'Languages' => 'Sprog',
        'Password' => 'Adgangskode',
        'Salutation' => 'Hilsen',
        'Signature' => 'Underskrift',
        'Customer' => 'Kunde',
        'CustomerID' => 'Kunde-ID',
        'CustomerIDs' => 'Kunde-ID\'er',
        'customer' => 'kunde',
        'agent' => 'konsulent',
        'system' => 'system',
        'Customer Info' => 'Kundeinfo',
        'Customer Company' => 'Kunde Firma',
        'Company' => 'Firma',
        'go!' => 'g�!',
        'go' => 'g�',
        'All' => 'Alle',
        'all' => 'alle',
        'Sorry' => 'Beklager',
        'update!' => 'opdater!',
        'update' => 'opdater',
        'Update' => 'Opdater',
        'Updated!' => 'Opdateret!',
        'submit!' => 'indsend!',
        'submit' => 'indsend',
        'Submit' => 'Indsend',
        'change!' => 'skift!',
        'Change' => 'Skift',
        'change' => 'skift',
        'click here' => 'klik her',
        'Comment' => 'Kommentar',
        'Valid' => 'Gyldig',
        'Invalid Option!' => 'Ugyldig valgmulighed!',
        'Invalid time!' => 'Ugyldigt tidsrum!',
        'Invalid date!' => 'Ugyldig dato!',
        'Name' => 'Navn',
        'Group' => 'Gruppe',
        'Description' => 'Beskrivelse',
        'description' => 'beskrivelse',
        'Theme' => 'Tema',
        'Created' => 'Oprettet',
        'Created by' => 'Oprettet af',
        'Changed' => 'Udskiftet',
        'Changed by' => 'Udskiftet af',
        'Search' => 'S�g',
        'and' => 'og',
        'between' => 'mellem',
        'Fulltext Search' => 'Friteksts�gning',
        'Data' => 'Data',
        'Options' => 'Valgmuligheder',
        'Title' => 'Titel',
        'Item' => 'Punkt',
        'Delete' => 'Slet',
        'Edit' => 'Rediger',
        'View' => 'Vis',
        'Number' => 'Nummer',
        'System' => 'System',
        'Contact' => 'Kontaktperson',
        'Contacts' => 'Kontaktpersoner',
        'Export' => 'Eksporter',
        'Up' => 'Op',
        'Down' => 'Ned',
        'Add' => 'Tilf�j',
        'Added!' => 'Tilf�jet!',
        'Category' => 'Kategori',
        'Viewer' => 'Fremviser',
        'Expand' => 'Udvid',
        'New message' => 'Ny meddelelse',
        'New message!' => 'Ny meddelelse!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'V�r venlig at besvare �n eller flere sager for at komme tilbage til k�ens normale visning!',
        'You got new message!' => 'Du har f�et en ny meddelelse!',
        'You have %s new message(s)!' => 'Du har %s ny(e) meddelelse(r)!',
        'You have %s reminder ticket(s)!' => 'Du har %s p�mindelses sag(er)!',
        'The recommended charset for your language is %s!' => 'Det anbefalede tegns�t til dit sprog er %s!',
        'Passwords doesn\'t match! Please try it again!' => 'Adgangskoderne er ikke ens! Pr�v igen!',
        'Password is already in use! Please use an other password!' => 'Adgangskoden er allerede i brug! Brug venligst en anden adgangskode!',
        'Password is already used! Please use an other password!' => 'Adgangskoden er allerede brugt! Brug venligst en anden adgangskode!',
        'You need to activate %s first to use it!' => 'Du skal f�rst aktivere %s for at bruge den!',
        'No suggestions' => 'Ingen forslag',
        'Word' => 'Ord',
        'Ignore' => 'Ignorer',
        'replace with' => 'udskift med',
        'There is no account with that login name.' => 'Der er ingen konto med det login-navn.',
        'Login failed! Your username or password was entered incorrectly.' => 'Login mislykkedes! Brugernavnet eller adgangskoden blev forkert indtastet.',
        'Please contact your admin' => 'Kontakt din administrator',
        'Logout successful. Thank you for using OTRS!' => 'Du er nu logget ud. Tak fordi du bruger OTRS.',
        'Invalid SessionID!' => 'Ugyldigt sessions-ID!',
        'Feature not active!' => 'Funktionen er ikke aktiv!',
        'Notification (Event)' => 'Besked (Event)',
        'Login is needed!' => 'Login er p�kr�vet',
        'Password is needed!' => 'Adgangskode er p�kr�vet!',
        'License' => 'Licens',
        'Take this Customer' => 'Tag denne kunde',
        'Take this User' => 'Tag denne bruger',
        'possible' => 'mulig',
        'reject' => 'afvis',
        'reverse' => 'omvendt',
        'Facility' => 'Facilitet',
        'Timeover' => 'Tidsoverskridelse',
        'Pending till' => 'Afventer til',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Arbejd ikke med bruger-ID 1 (systemkonto)! Opret nye brugere!',
        'Dispatching by email To: field.' => 'Sendes via e-mail til: felt.',
        'Dispatching by selected Queue.' => 'Sendes via den valgte k�.',
        'No entry found!' => 'Ingen post fundet!',
        'Session has timed out. Please log in again.' => 'Sessionens tidsfrist er udl�bet. V�r venlig at logge ind igen.',
        'No Permission!' => 'Ingen tilladelse!',
        'To: (%s) replaced with database email!' => 'Til: (%s) udskiftet med e-mail til database!',
        'Cc: (%s) added database email!' => 'Cc: (%s) tilf�jet e-mail til database!',
        '(Click here to add)' => '(Klik her for at tilf�je)',
        'Preview' => 'Vis udskrift',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Pakke ikke korrekt indsat. Du b�r installere pakken igen.',
        'Added User "%s"' => 'Tilf�jet til bruger "%s"',
        'Contract' => 'Kontrakt',
        'Online Customer: %s' => 'Online kunde: %s ',
        'Online Agent: %s' => 'Online konsulenter: %s ',
        'Calendar' => 'Kalender',
        'File' => 'Fil',
        'Filename' => 'Filnavn',
        'Type' => 'Type',
        'Size' => 'St�rrelse',
        'Upload' => 'Upload',
        'Directory' => 'Katalog',
        'Signed' => 'Underskrevet',
        'Sign' => 'Underskriv',
        'Crypted' => 'Krypteret',
        'Crypt' => 'Krypter',
        'Office' => 'Kontor',
        'Phone' => 'Telefon',
        'Fax' => 'Fax',
        'Mobile' => 'Mobil',
        'Zip' => 'Post Nr.',
        'City' => 'By',
        'Street' => 'Gade',
        'Country' => 'Land',
        'Location' => 'Lokation',
        'installed' => 'installeret',
        'uninstalled' => 'afinstalleret',
        'Security Note: You should activate %s because application is already running!' => 'Sikkerheds advarsel: Du skal aktivere %s fordi applikationen allerede k�rer!',
        'Unable to parse Online Repository index document!' => 'Det var ikke muligt at l�se Online Repositoryets index dokument',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'Der var ingen pakker for the valgte Framework i Online Repositoryet, der var dog pakker til andre Frameworks!',
        'No Packages or no new Packages in selected Online Repository!' => 'Der var ingen pakker, eller ingen nye pakker i det valgte Online Repository.',
        'printed at' => 'printet den',
        'Dear Mr. %s,' => 'K�re Hr. %s',
        'Dear Mrs. %s,' => 'K�re Fru. %s',
        'Dear %s,' => 'K�re %s',
        'Hello %s,' => 'Hej %s',
        'This account exists.' => 'Denne konto eksisterer allerede.',
        'New account created. Sent Login-Account to %s.' => 'Ny konto er oprettet. Login informationer er sendt til %s.',
        'Please press Back and try again.' => 'Tryk venligst tilbage og pr�v igen.',
        'Sent password token to: %s' => 'Kodeords kendetegn er sendt til: %s',
        'Sent new password to: %s' => 'Nyt kodeord er sendt til: %s',
        'Upcoming Events' => 'Kommende h�ndelser',
        'Event' => 'Handling',
        'Events' => 'H�ndelser',
        'Invalid Token!' => 'Ugyldigt kendetegn!',
        'more' => 'mere',
        'For more info see:' => 'For mere information se:',
        'Package verification failed!' => 'Pakke godkendelse fejlede!',
        'Collapse' => 'Indskr�nk',
        'News' => 'Nyheder',
        'Product News' => 'Produktnyheder',
        'Bold' => 'Fed',
        'Italic' => 'Kursiv',
        'Underline' => 'Understregning',
        'Font Color' => 'Font farve',
        'Background Color' => 'Baggrundsfarve',
        'Remove Formatting' => 'Fjern formattering',
        'Show/Hide Hidden Elements' => 'Vis/Skjul Skjulte elementer',
        'Align Left' => 'Venstrestil',
        'Align Center' => 'Centre',
        'Align Right' => 'H�jrestil',
        'Justify' => 'Lige margner',
        'Header' => 'Overskrift',
        'Indent' => '',
        'Outdent' => '',
        'Create an Unordered List' => 'Lav en usorteret liste',
        'Create an Ordered List' => 'Lav en sorteret liste',
        'HTML Link' => '',
        'Insert Image' => 'Inds�t billed',
        'CTRL' => '',
        'SHIFT' => '',
        'Undo' => 'Fortryd',
        'Redo' => 'Gendan',

        # Template: AAAMonth
        'Jan' => 'Jan',
        'Feb' => 'Feb',
        'Mar' => 'Mar',
        'Apr' => 'Apr',
        'May' => 'Maj',
        'Jun' => 'Jun',
        'Jul' => 'Jul',
        'Aug' => 'Aug',
        'Sep' => 'Sep',
        'Oct' => 'Okt',
        'Nov' => 'Nov',
        'Dec' => 'Dec',
        'January' => 'Januar',
        'February' => 'Februar',
        'March' => 'Marts',
        'April' => 'April',
        'May_long' => 'Maj',
        'June' => 'Juni',
        'July' => 'Juli',
        'August' => 'August',
        'September' => 'September',
        'October' => 'Oktober',
        'November' => 'November',
        'December' => 'December',

        # Template: AAANavBar
        'Admin-Area' => 'Admin-omr�de',
        'Agent-Area' => 'Konsulent-omr�de',
        'Ticket-Area' => 'Sag-Omr�de',
        'Logout' => 'Log ud',
        'Agent Preferences' => 'Konsulentindstillinger',
        'Preferences' => 'Indstillinger',
        'Agent Mailbox' => 'Konsulentmailboks',
        'Stats' => 'Statistik',
        'Stats-Area' => 'Statistikomr�de',
        'Admin' => 'Administrator',
        'Customer Users' => 'Kundebrugere',
        'Customer Users <-> Groups' => 'Kundebrugere <-> Grupper',
        'Users <-> Groups' => 'Brugere <-> Grupper',
        'Roles' => 'Roller',
        'Roles <-> Users' => 'Roller <-> Brugere',
        'Roles <-> Groups' => 'Roller <-> Grupper',
        'Salutations' => 'Hilsner',
        'Signatures' => 'Underskrifter',
        'Email Addresses' => 'E-mailadresser',
        'Notifications' => 'Beskeder',
        'Category Tree' => 'Kategoritr�',
        'Admin Notification' => 'Besked til admin',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Indstillingerne er opdateret!',
        'Mail Management' => 'Mailstyring',
        'Frontend' => 'Frontend',
        'Other Options' => 'Andre valgmuligheder',
        'Change Password' => 'Skift adgangskode',
        'New password' => 'Ny adgangskode',
        'New password again' => 'Ny adgangskode igen',
        'Select your QueueView refresh time.' => 'V�lg genindl�sningstid til k�visningen.',
        'Select your frontend language.' => 'V�lg dit sprog til frontend.',
        'Select your frontend Charset.' => 'V�lg dit tegns�t til frontend.',
        'Select your frontend Theme.' => 'V�lg dit tema til frontend.',
        'Select your frontend QueueView.' => 'V�lg din k�visning til frontend.',
        'Spelling Dictionary' => 'Ordbog til stavekontrol',
        'Select your default spelling dictionary.' => 'V�lg din standardordbog til stavekontrol.',
        'Max. shown Tickets a page in Overview.' => 'Max. viste sager pr. side i oversigten.',
        'Can\'t update password, your new passwords do not match! Please try again!' => 'Kan ikke opdatere adgangskode, adgangskoderne er ikke ens! Pr�v igen!',
        'Can\'t update password, invalid characters!' => 'Kan ikke opdatere adgangskode, ugyldige tegn!',
        'Can\'t update password, must be at least %s characters!' => 'Kan ikke opdatere adgangskode, der skal v�re mindst %s tegn!',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => 'Kan ikke opdatere adgangskode, der skal v�re 2 sm� og 2 store bogstaver!',
        'Can\'t update password, needs at least 1 digit!' => 'Kan ikke opdatere adgangskode, mindst 1 tal mangler!',
        'Can\'t update password, needs at least 2 characters!' => 'Kan ikke opdatere adgangskode, mindst 2 tegn mangler!',

        # Template: AAAStats
        'Stat' => 'Statistik',
        'Please fill out the required fields!' => 'Udfyld venligst de p�kr�vede felter.',
        'Please select a file!' => 'V�lg venligst en fil',
        'Please select an object!' => 'V�lg venligst et objekt',
        'Please select a graph size!' => 'V�lg venligst graf st�rrelse',
        'Please select one element for the X-axis!' => 'V�lg venligst et element til X-aksen',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'V�lg venligst kun et element, eller vend knappen \'Fixed\' hvor feltet er markeret',
        'If you use a checkbox you have to select some attributes of the select field!' => 'For at bruge en checkbox, skal du v�lge nogle attributter fra feltet',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Indtast venligst en v�rdi, i det valghte input felt, eller fra v�lg \'Fixed\' checkboxen.',
        'The selected end time is before the start time!' => 'Den valgte sluttid, er f�r starttiden.',
        'You have to select one or more attributes from the select field!' => 'Du skal v�lge en eller flere attributter fra det valgte felt.',
        'The selected Date isn\'t valid!' => 'Den valgte dato er ugyldig.',
        'Please select only one or two elements via the checkbox!' => 'V�lg kun ene eller 2 elemeter fra checkboksene.',
        'If you use a time scale element you can only select one element!' => 'Hvis du bruger en tidsskale, kan du kun v�lge et element!',
        'You have an error in your time selection!' => 'iDer er fejl i den valgte tid!',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Rapport tids-intervallet er for kort, v�lg en st�rre tids horisont!',
        'The selected start time is before the allowed start time!' => 'Den valgte start tid, er f�r den tilladte starttid!',
        'The selected end time is after the allowed end time!' => 'Den valgte slut tid, el senere end den tilladte sluttid!',
        'The selected time period is larger than the allowed time period!' => 'Den valgte tidsperiode, er l�ngere end den tilladte tidsperiode!',
        'Common Specification' => 'F�lles sspecifikationer',
        'Xaxis' => 'X-akse',
        'Value Series' => 'V�rdi serier',
        'Restrictions' => 'Begr�nsning',
        'graph-lines' => 'graf-linjer',
        'graph-bars' => 'graf-bar',
        'graph-hbars' => 'graf-hbar',
        'graph-points' => 'graf-punkter',
        'graph-lines-points' => 'graf-linje-punkter',
        'graph-area' => 'praf-omr�de',
        'graph-pie' => 'graf-cirkel',
        'extended' => 'udvidet',
        'Agent/Owner' => 'Konsulent/ejer',
        'Created by Agent/Owner' => 'Oprettet af konsulent/ejer',
        'Created Priority' => 'Oprettelses prioritet',
        'Created State' => 'Oprettelses Status',
        'Create Time' => 'Oprettelses tid',
        'CustomerUserLogin' => 'KundeBrugerLogin',
        'Close Time' => 'Slut tid',
        'TicketAccumulation' => 'Sagsakkumulation',
        'Attributes to be printed' => 'Attributter til udskrift',
        'Sort sequence' => 'Sorter sekvens',
        'Order by' => 'Sorter efter',
        'Limit' => 'Gr�nse',
        'Ticketlist' => 'Sagsliste',
        'ascending' => 'stigende',
        'descending' => 'falende',
        'First Lock' => 'F�rste l�s',
        'Evaluation by' => 'Evaluering af',
        'Total Time' => 'Samlet tid',
        'Ticket Average' => 'Sagsgennemsnit',
        'Ticket Min Time' => 'Sag - Min.tid',
        'Ticket Max Time' => 'Sag - Max.tid',
        'Number of Tickets' => 'Antal af sager',
        'Article Average' => 'Artikel gennemsnit',
        'Article Min Time' => 'Artikel - Min.tid',
        'Article Max Time' => 'Artikel - Max.tid',
        'Number of Articles' => 'Antal af artikler',
        'Accounted time by Agent' => 'Konteret tid for konsulent',
        'Ticket/Article Accounted Time' => 'Sag/Artikel - Konteret tid',
        'TicketAccountedTime' => 'SagKonteretTid',
        'Ticket Create Time' => 'Tidspunkt for sagsoprettelse',
        'Ticket Close Time' => 'Tidspunkt for sagslukning',

        # Template: AAATicket
        'Lock' => 'L�s',
        'Unlock' => 'Ul�st',
        'History' => 'Historik',
        'Zoom' => 'Vis',
        'Age' => 'Alder',
        'Bounce' => 'Retur til afsender',
        'Forward' => 'Videresend',
        'From' => 'Fra',
        'To' => 'Til',
        'Cc' => 'Cc',
        'Bcc' => 'Bcc',
        'Subject' => 'Emne',
        'Move' => 'Flyt',
        'Queue' => 'K�',
        'Priority' => 'Prioritering',
        'Priority Update' => 'Prioritets opdatering',
        'State' => 'Status',
        'Compose' => 'Skrive',
        'Pending' => 'Afventer',
        'Owner' => 'Konsulent',
        'Owner Update' => 'Konsulent Opdatering',
        'Responsible' => 'Ansvarlig',
        'Responsible Update' => 'Ansvarlig Opdatering',
        'Sender' => 'Afsender',
        'Article' => 'Artikel',
        'Ticket' => 'Sag',
        'Createtime' => 'Oprettelses tid',
        'plain' => 'almindelig',
        'Email' => 'E-mail',
        'email' => 'e-mail',
        'Close' => 'Luk',
        'Action' => 'Handling',
        'Attachment' => 'Vedh�ftet fil',
        'Attachments' => 'Vedh�ftede filer',
        'This message was written in a character set other than your own.' => 'Denne meddelelse blev skrevet i et andet tegns�t end dit eget.',
        'If it is not displayed correctly,' => 'Vises den ikke korrekt,',
        'This is a' => 'Dette er en',
        'to open it in a new window.' => 'for at �bne i et nyt vindue.',
        'This is a HTML email. Click here to show it.' => 'Dette er en e-mail i HTML. Klik her for at vise den.',
        'Free Fields' => 'Frie felter',
        'Merge' => 'Sammel',
        'merged' => 'samlet',
        'closed successful' => 'lukning lykkedes',
        'closed unsuccessful' => 'lukning mislykkedes',
        'new' => 'ny',
        'open' => '�ben',
        'Open' => '�ben',
        'closed' => 'lukket',
        'Closed' => 'Lukket',
        'removed' => 'fjernet',
        'pending reminder' => 'afventer p�mindelse',
        'pending auto' => 'afventer auto',
        'pending auto close+' => 'afventer autolukning+',
        'pending auto close-' => 'afventer autolukning-',
        'email-external' => 'email-ekstern',
        'email-internal' => 'email-intern',
        'note-external' => 'bem�rkning-ekstern',
        'note-internal' => 'bem�rkning-intern',
        'note-report' => 'bem�rkning-rapport',
        'phone' => 'telefon',
        'sms' => 'sms',
        'webrequest' => 'webanmodning',
        'lock' => 'l�s',
        'unlock' => 'ul�st',
        'very low' => 'meget lav',
        'low' => 'lav',
        'normal' => 'normal',
        'high' => 'h�j',
        'very high' => 'meget h�j',
        '1 very low' => '1 meget lav',
        '2 low' => '2 lav',
        '3 normal' => '3 normal',
        '4 high' => '4 h�j',
        '5 very high' => '5 meget h�j',
        'Ticket "%s" created!' => 'Sag "%s" oprettet!',
        'Ticket Number' => 'Sagsnummer',
        'Ticket Object' => 'Sagsobjekt',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Intet s�dant sagsnummer "%s"! Kan ikke sammenk�de det!',
        'Don\'t show closed Tickets' => 'Vis ikke lukkede sag',
        'Show closed Tickets' => 'Vis lukkede sag',
        'New Article' => 'Ny artikkel',
        'Email-Ticket' => 'E-mail-sag',
        'Create new Email Ticket' => 'Opret ny e-mailsag',
        'Phone-Ticket' => 'Telefon-Sag',
        'Search Tickets' => 'S�g sager',
        'Edit Customer Users' => 'Rediger kundebrugere',
        'Edit Customer Company' => 'Rediger kunde firma',
        'Bulk Action' => 'Massehandling',
        'Bulk Actions on Tickets' => 'Massehandlinger vedr�rende sager',
        'Send Email and create a new Ticket' => 'Send e-mail og opret en ny sag',
        'Create new Email Ticket and send this out (Outbound)' => 'Opret ny email sag, og afsend denne (Outbound)',
        'Create new Phone Ticket (Inbound)' => 'Opret ny telefon sag (Inbound)',
        'Overview of all open Tickets' => 'Oversigt over alle �bne sager',
        'Locked Tickets' => 'L�ste sager',
        'Watched Tickets' => 'Overv�gede sager',
        'Watched' => 'Overv�get',
        'Subscribe' => 'Tilmeld',
        'Unsubscribe' => 'Afmeld',
        'Lock it to work on it!' => 'L�s den for at arbejde p� den!',
        'Unlock to give it back to the queue!' => 'L�s den op for at give den tilbage til k�en!',
        'Shows the ticket history!' => 'Vis saghistorik!',
        'Print this ticket!' => 'Udskriv denne sag!',
        'Change the ticket priority!' => 'Skift sagsprioriteringen!',
        'Change the ticket free fields!' => 'Skift sagens frie felter!',
        'Link this ticket to an other objects!' => 'Sammenk�d denne sag til et andet objekt!',
        'Change the ticket owner!' => 'Skift konsulent p� sagen!',
        'Change the ticket customer!' => 'Skift sagskunden!',
        'Add a note to this ticket!' => 'Tilf�j en bem�rkning til denne sag!',
        'Merge this ticket!' => 'Saml denne sag!',
        'Set this ticket to pending!' => 'Marker denne sag som afventende!',
        'Close this ticket!' => 'Luk denne sag!',
        'Look into a ticket!' => 'Se n�rmere p� en sag!',
        'Delete this ticket!' => 'Slet denne sag!',
        'Mark as Spam!' => 'Mark�r som spam!',
        'My Queues' => 'Mine k�er',
        'Shown Tickets' => 'Vis sager',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Din e-mail med sagnummer "<OTRS_TICKET>" er samlet til "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Sag %s: f�rste svar er overskredet (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Sag %s: f�rste svar vil v�re overskrevet om %s!',
        'Ticket %s: update time is over (%s)!' => 'Sag %s: opdaterings tid er overskredet (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Sag %s: opdaterings tid vil v�re overskredet om %s!',
        'Ticket %s: solution time is over (%s)!' => 'Sag %s: L�snings tid er overskredet (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Sag %s: l�snings tid er overskredet om %s!',
        'There are more escalated tickets!' => 'Der er ikke flere eskalerede sager!',
        'New ticket notification' => 'Besked om ny sag',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Send mig en besked, hvis der er en ny sag i "Mine k�er".',
        'Follow up notification' => 'Besked om opf�lgning',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' => 'Send mig en besked, hvis en kunde sender en opf�lgning, og jeg er denne sags indehaver.',
        'Ticket lock timeout notification' => 'Besked om sagl�s efter tidsfristens udl�b',
        'Send me a notification if a ticket is unlocked by the system.' => 'Send mig en besked, hvis systemet l�ser en sag op.',
        'Move notification' => 'Besked om flytning',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Send mig en besked, hvis en sag flyttes ind i en af "Mine k�er".',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Dit k�valg af foretrukne k�er. Du f�r ogs� besked om disse k�er via e-mail, hvis det er aktiveret.',
        'Custom Queue' => 'Brugertilpas k�',
        'QueueView refresh time' => 'K�Visnings genindl�sningstid',
        'Screen after new ticket' => 'Sk�rm efter ny sag',
        'Select your screen after creating a new ticket.' => 'V�lg din sk�rm, efter ioprettelse af ny sag.',
        'Closed Tickets' => 'Lukkede sager',
        'Show closed tickets.' => 'Vis lukkede sager.',
        'Max. shown Tickets a page in QueueView.' => 'Max. viste sager pr. side i k�-visning - QueueView.',
        'Watch notification' => 'Se notifikation',
        'Send me a notification of an watched ticket like an owner of an ticket.' => 'Send mig beskeder om en overv�get sag, p� samme m�de som konsulenten',
        'Out Of Office' => 'Ikke-p�-kontoret',
        'Select your out of office time.' => 'V�lg din Ikke-p�-kontoret tid',
        'CompanyTickets' => 'Virksomhedssager',
        'MyTickets' => 'Mine sager',
        'New Ticket' => 'Ny sag',
        'Create new Ticket' => 'Opret ny sag',
        'Customer called' => 'Opkald fra Kunde',
        'phone call' => 'opringning',
        'Reminder Reached' => 'P�mindelse n�et',
        'Reminder Tickets' => 'Sager med p�mindelse',
        'Escalated Tickets' => 'Eskalerede sager',
        'New Tickets' => 'Nye sager',
        'Open Tickets / Need to be answered' => 'Sager under behandling',
        'Tickets which need to be answered!' => 'Sag som besvares',
        'All new tickets!' => 'Alle nye sager',
        'All tickets which are escalated!' => 'Alle sager som er eskaleret',
        'All tickets where the reminder date has reached!' => 'Alle sager som har n�et en p�mindelse',
        'Responses' => 'Svar',
        'Responses <-> Queue' => 'Svar <-> K�',
        'Auto Responses' => 'Autosvar',
        'Auto Responses <-> Queue' => 'Autosvar <-> K�',
        'Attachments <-> Responses' => 'Vedh�ftede filer <-> Responssvar',
        'History::Move' => 'Historik::Flytning',
        'History::TypeUpdate' => 'Updated Type to %s (ID=%s).',
        'History::ServiceUpdate' => 'Updated Service to %s (ID=%s).',
        'History::SLAUpdate' => 'Updated SLA to %s (ID=%s).',
        'History::NewTicket' => 'Historik::NySag',
        'History::FollowUp' => 'Historik::Opf�lgning',
        'History::SendAutoReject' => 'Historik::SendAutoAfslag',
        'History::SendAutoReply' => 'Historik::SendAutoSvar',
        'History::SendAutoFollowUp' => 'Historik::SendAutoOpf�lgning',
        'History::Forward' => 'Historik::Videresend',
        'History::Bounce' => 'Historik::Retur til afsender',
        'History::SendAnswer' => 'Historik::SendSvar',
        'History::SendAgentNotification' => 'Historik::SendAgentBesked',
        'History::SendCustomerNotification' => 'Historik::SendKundeBesked',
        'History::EmailAgent' => 'Historik::E-mailAgent',
        'History::EmailCustomer' => 'Historik::E-mailKunde',
        'History::PhoneCallAgent' => 'Historik::TelefonOpkaldAgent',
        'History::PhoneCallCustomer' => 'Historik::TelefonOpkaldKunde',
        'History::AddNote' => 'Historik::Tilf�jBem�rkning',
        'History::Lock' => 'Historik::L�s',
        'History::Unlock' => 'Historik::L�s op',
        'History::TimeAccounting' => 'Historik::TidRegnskab',
        'History::Remove' => 'Historik::Fjern',
        'History::CustomerUpdate' => 'Historik::KundeOpdatering',
        'History::PriorityUpdate' => 'Historik::Prioritetsopdatering',
        'History::OwnerUpdate' => 'Historik::IndehaverOpdatering',
        'History::LoopProtection' => 'Historik::LoopBeskyttelse',
        'History::Misc' => 'Historik::Diverse',
        'History::SetPendingTime' => 'Historik::IndstilVentetid',
        'History::StateUpdate' => 'Historik::TilstandOpdatering',
        'History::TicketFreeTextUpdate' => 'Historik::SagFriTekstOpdatering',
        'History::WebRequestCustomer' => 'Historik::WebAnmodningKunde',
        'History::TicketLinkAdd' => 'Historik::SagLinkTilf�j',
        'History::TicketLinkDelete' => 'Historik::SagLinkSlet',
        'History::Subscribe' => 'Historik::Tilmeld',
        'History::Unsubscribe' => 'Historik::Afmeld',

        # Template: AAAWeekDay
        'Sun' => 'S�n',
        'Mon' => 'Man',
        'Tue' => 'Tir',
        'Wed' => 'Ons',
        'Thu' => 'Tor',
        'Fri' => 'Fre',
        'Sat' => 'L�r',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Styring af vedh�ftede filer',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Styring af autosvar',
        'Response' => 'Svar',
        'Auto Response From' => 'Autosvar fra',
        'Note' => 'Bem�rkning',
        'Useable options' => 'Brugbare valgmuligheder',
        'To get the first 20 character of the subject.' => 'For at f� de f�rste 20 tegn af emnet.',
        'To get the first 5 lines of the email.' => 'For at f� de f�rste 5 linjer af emailen.',
        'To get the realname of the sender (if given).' => 'For at f� afsenderes navn, hvis angivet.',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'For at f� articlens attributter( f.eks. <OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Muligheder for den nuv�rendes kundes data (f.eks. <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Sagens konsulent muligheder (f.eks. <OTRS_OWNER_UserFirstname>)',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Sags ansvarlig muligheder (f.eks. <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Muligheder for bruger der har udf�rt denne handling (f.eks. <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Muligheder for sags data (f.eks. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Konfigurations muligheder (f.eks. <OTRS_CONFIG_HttpType>).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Kunde Firma Administration',
        'Search for' => 'S�g efter',
        'Add Customer Company' => 'Tilf�j kunde firma',
        'Add a new Customer Company.' => 'Tilf�j et nyt Kunde firma',
        'List' => 'Liste',
        'This values are required.' => 'Disse v�rdier er p�kr�vede.',
        'This values are read only.' => 'Disse v�rdier kan kun l�ses.',

        # Template: AdminCustomerUserForm
        'The message being composed has been closed.  Exiting.' => 'Den meddelelse, der er ved at blive formuleret, er blevet lukket.  Afslutter.',
        'This window must be called from compose window' => 'Dette vindue skal �bnes via Skriv-vinduet.',
        'Customer User Management' => 'Styring af kundebruger',
        'Add Customer User' => 'Tilf�j Kunde Bruger',
        'Source' => 'Kilde',
        'Create' => 'Opret',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Kundebrugeren er n�dvendig for at have en kundehistorik og for at logge ind via kundepanelerne.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Kundebrugere <-> Gruppestyring',
        'Change %s settings' => 'Skift %s indstillinger',
        'Select the user:group permissions.' => 'V�lg rettigheder til brugeren:gruppen.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Er intet valgt, er der ingen rettigheder i denne gruppe (der er ingen tilg�ngelige sag til brugeren).',
        'Permission' => 'Tilladdelse',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Kun l�seadgang til sager i denne gruppe/k�.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' => 'Komplet l�se- og skriveadgang til sagerne i denne gruppe/k�.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Kunde Bruger <-> Service Administration',
        'CustomerUser' => 'KundeBruger',
        'Service' => 'Service',
        'Edit default services.' => 'Ret standard services.',
        'Search Result' => 'S�geresultat',
        'Allocate services to CustomerUser' => 'V�lg services til kunde bruger',
        'Active' => 'Aktiv',
        'Allocate CustomerUser to service' => 'V�lg kunde bruger til service',

        # Template: AdminEmail
        'Message sent to' => 'Meddelelse sendt til',
        'A message should have a subject!' => 'En meddelelse skal have et emne!',
        'Recipients' => 'Modtagere',
        'Body' => 'Hovedtekst',
        'Send' => 'Afsend',

        # Template: AdminGenericAgent
        'GenericAgent' => 'Generel konsulent',
        'Job-List' => 'Job-Liste',
        'Last run' => 'Sidste k�rsel',
        'Run Now!' => 'K�r nu!',
        'x' => 'x',
        'Save Job as?' => 'Gem et job som?',
        'Is Job Valid?' => 'Er jobbet gyldigt?',
        'Is Job Valid' => 'Er jobbet gyldigt',
        'Schedule' => 'Tidsplan',
        'Currently this generic agent job will not run automatically.' => 'Lige nu vil denne generiske agent ikke k�rer automatisk.',
        'To enable automatic execution select at least one value from minutes, hours and days!' => 'For at aktivere automatisk k�rsel skal du v�lge mindst en v�rdi fra minutter, timer og dage!',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Friteksts�gning i artikel (f.eks. "Mar*in" eller "Baue*")',
        '(e. g. 10*5155 or 105658*)' => '(f.eks. 10*5155 eller 105658*)',
        '(e. g. 234321)' => '(f.eks. 234321)',
        'Customer User Login' => 'Kundebrugers login',
        '(e. g. U5150)' => '(f.eks. U5150)',
        'SLA' => 'SLA',
        'Agent' => 'Konsulent',
        'Ticket Lock' => 'Sagsl�s',
        'TicketFreeFields' => 'SagsFriFelter',
        'Create Times' => 'Opret tider',
        'No create time settings.' => 'Opret ikke tider.',
        'Ticket created' => 'Sag oprettet',
        'Ticket created between' => 'Sag oprettet mellem',
        'Close Times' => 'Lukke tid',
        'No close time settings.' => 'Ingen lukke tids indstillinger',
        'Ticket closed' => 'Sag lukket',
        'Ticket closed between' => 'Sag lukket mellem',
        'Pending Times' => 'Afventende tider',
        'No pending time settings.' => 'Ingen afventende tider',
        'Ticket pending time reached' => 'Sags afvents tid er n�et',
        'Ticket pending time reached between' => 'Sagens afventnings tid er opn�et mellem',
        'Escalation Times' => 'Eskalationstider',
        'No escalation time settings.' => 'Der er ikke sat nogen eskalationstid.',
        'Ticket escalation time reached' => 'Sagens eskalationstid er n�et',
        'Ticket escalation time reached between' => 'Sagens eskalationstid er n�et mellem',
        'Escalation - First Response Time' => 'Eskalation - F�rste svar tid',
        'Ticket first response time reached' => 'Sagens tid for f�rste svar er n�et',
        'Ticket first response time reached between' => 'Sagens tid for f�rste svar er n�et mellem',
        'Escalation - Update Time' => 'Eskalation - Opdaterings tid',
        'Ticket update time reached' => 'Sagens opdaterings tid er n�et',
        'Ticket update time reached between' => 'Sagens ogdateringstid er n�et mellem',
        'Escalation - Solution Time' => 'Eskalation - L�snings tid',
        'Ticket solution time reached' => 'Sagens l�sningstid er n�et',
        'Ticket solution time reached between' => 'Sagens l�sningstid er n�et mellem',
        'New Service' => 'Ny service',
        'New SLA' => 'Ny SLA',
        'New Priority' => 'Ny prioritering',
        'New Queue' => 'Ny k�',
        'New State' => 'Ny status',
        'New Agent' => 'Ny konsulent',
        'New Owner' => 'Ny konsulent',
        'New Customer' => 'Ny kunde',
        'New Ticket Lock' => 'Ny sagl�s',
        'New Type' => 'Ny type',
        'New Title' => 'Ny titel',
        'New TicketFreeFields' => 'iNy SagsFriFelter',
        'Add Note' => 'Tilf�j bem�rkning',
        'Time units' => 'Tidsenheder',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Denne kommando vil blive udf�rt. ARG[0] bliver sagens nummer. ARG[1] sagens ID. ',
        'Delete tickets' => 'Slet sager',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Advarsel! Denne sag fjernes fra databasen! Denne sag er g�et tabt!',
        'Send Notification' => 'Send Meddelse',
        'Param 1' => 'Param 1',
        'Param 2' => 'Param 2',
        'Param 3' => 'Param 3',
        'Param 4' => 'Param 4',
        'Param 5' => 'Param 5',
        'Param 6' => 'Param 6',
        'Send agent/customer notifications on changes' => 'Send besked til konsulenten ved �ndringer',
        'Save' => 'Gem',
        '%s Tickets affected! Do you really want to use this job?' => '%s sager bliver ber�rt! �nsker du stadig at k�re dette job.',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => '',
        'Group Management' => 'Gruppestyring',
        'Add Group' => 'Tilf�j Gruppe',
        'Add a new Group.' => 'Tilf�j en ny Gruppe',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Admin-gruppen skal ind i administratoromr�det og statistikgruppen i statistikomr�det.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Opret nye grupper til at h�ndtere adgangstilladelser for konsulentens forskellige grupper (f.eks. indk�bs-, support- og salgsafdeling ...).',
        'It\'s useful for ASP solutions.' => 'Det er nyttigt for ASP-l�sninger.',

        # Template: AdminLog
        'System Log' => 'Systemlog',
        'Time' => 'Tid',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Mail Konto Administration',
        'Host' => 'V�rt',
        'Trusted' => 'P�lidelig',
        'Dispatching' => 'Sender',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Alle indkommende e-mails med 1 konto sendes til den valgte k�!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Er der tillid til din konto, bliver den allerede eksisterende X-OTRS-header ved ankomsttidspunktet (for prioritering, ...) anvendt! Der anvendes PostMaster-filter under alle omst�ndigheder.',

        # Template: AdminNavigationBar
        'Users' => 'Brugere',
        'Groups' => 'Grupper',
        'Misc' => 'Diverse',

        # Template: AdminNotificationEventForm
        'Notification Management' => 'Beskedstyring',
        'Add Notification' => 'Tilf�j besked',
        'Add a new Notification.' => 'Tilf�j en ny besked',
        'Name is required!' => 'Navn er p�kr�vet!',
        'Event is required!' => 'H�ndelse er p�kr�vet',
        'A message should have a body!' => 'En meddelelse skal have en tekst!',
        'Recipient' => 'Modtaget',
        'Group based' => 'Gruppebaseret',
        'Agent based' => 'Konsulent baseret',
        'Email based' => 'Email baseret',
        'Article Type' => 'Artikel type',
        'Only for ArticleCreate Event.' => 'Kun for h�ndelsen NyArtikel',
        'Subject match' => 'Emen ens',
        'Body match' => 'Indhold ens',
        'Notifications are sent to an agent or a customer.' => 'Beskeder sendes til en konsulent eller kunde.',
        'To get the first 20 character of the subject (of the latest agent article).' => 'For at f� de f�rste 20 tegn af emnet (af den sidste konsulents artikel).',
        'To get the first 5 lines of the body (of the latest agent article).' => 'For at f� de f�rste 5 linier af teksten (af den sidste konsulents artikel).',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => 'For at f� artikel attributter (fx. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).',
        'To get the first 20 character of the subject (of the latest customer article).' => 'For at f� de f�rste 20 tegn af emnet (af den sidste kundes artikel).',
        'To get the first 5 lines of the body (of the latest customer article).' => 'For at f� de f�rste 5 linier af teksten (af den sidste kundes artikel).',

        # Template: AdminNotificationForm
        'Notification' => 'Besked',

        # Template: AdminPackageManager
        'Package Manager' => 'Pakke Styring',
        'Uninstall' => 'Afinstaller',
        'Version' => 'Version',
        'Do you really want to uninstall this package?' => 'Er du sikker p�, du �nsker at afinstallere denne pakke?',
        'Reinstall' => 'Geninstaller',
        'Do you really want to reinstall this package (all manual changes get lost)?' => '�nsker du virkeleg at geninstallere denne pakke (Alle manuelle �ndringer vil blive slettet)?',
        'Continue' => 'Forts�t',
        'Install' => 'Installation',
        'Package' => 'Pakke',
        'Online Repository' => 'Online lagerdepot',
        'Vendor' => 'S�lger',
        'Module documentation' => 'Modul-dokumentation',
        'Upgrade' => 'Opgrader',
        'Local Repository' => 'Lokalt lagerdepot',
        'Status' => 'Status',
        'Overview' => 'Oversigt',
        'Download' => 'Download',
        'Rebuild' => 'Genopbyg',
        'ChangeLog' => 'ChangeLog',
        'Date' => 'Dato',
        'Filelist' => 'Filliste',
        'Download file from package!' => 'Download fil fra pakke!',
        'Required' => 'P�kr�vet',
        'PrimaryKey' => 'Prim�rN�gle',
        'AutoIncrement' => 'AutoForh�jelse',
        'SQL' => 'SQL',
        'Diff' => 'Diff',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Ydelses log',
        'This feature is enabled!' => 'Denne fuktion er aktiveret',
        'Just use this feature if you want to log each request.' => 'Benyt denne funktion hvis du �nsker at alle foresp�rgsler skal logges.',
        'Activating this feature might affect your system performance!' => 'Aktivering af denne funktion, vil m�ske p�virke effekten af dit system!',
        'Disable it here!' => 'Deaktiver det her!',
        'This feature is disabled!' => 'Denne mulighed er deaktiveret!',
        'Enable it here!' => 'Aktiver det her!',
        'Logfile too large!' => 'Logfil er for stor',
        'Logfile too large, you need to reset it!' => 'Log fil er fort stor, du skal nulstille den',
        'Range' => 'Omr�de',
        'Interface' => 'Interface',
        'Requests' => 'Foresp�rgsel',
        'Min Response' => 'Min Svar',
        'Max Response' => 'Max Svar',
        'Average Response' => 'Gennemsnitligt Svar',
        'Period' => 'Periode',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Gennemsnitlig',

        # Template: AdminPGPForm
        'PGP Management' => 'PGP-styring',
        'Result' => 'Resultat',
        'Identifier' => 'Identifikator',
        'Bit' => 'Bit',
        'Key' => 'N�gle',
        'Fingerprint' => 'Fingeraftryk',
        'Expires' => 'Udl�ber',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'Du kan p� denne m�de direkte redigere den n�glering, der er konfigureret i SysConfig.',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMasters filterstyring',
        'Filtername' => 'Filternavn',
        'Stop after match' => 'Stop efter resultat',
        'Match' => 'Match',
        'Value' => 'V�rdi',
        'Set' => 'Indstil',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Send eller filtrer indkommende e-mail baseret p� hver e-mails X-header! RegExp er ogs� mulig.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Hvis du kun �nsker at matche email adressen, s� brug EMAILADDRESS:info@example.com i Fra, Til eller Cc.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Anvender du RegExp, kan du ogs� bruge den matchede v�rdi i () som [***] i \'Set\'.',

        # Template: AdminPriority
        'Priority Management' => 'Prioritets administration',
        'Add Priority' => 'Tilf�j prioritet',
        'Add a new Priority.' => 'Tilf�j ny prioritet',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'K� <-> Styring af autosvar',
        'settings' => 'indstillinger',

        # Template: AdminQueueForm
        'Queue Management' => 'K�styring',
        'Sub-Queue of' => 'Underk� af',
        'Unlock timeout' => 'L�s tisfristen op',
        '0 = no unlock' => '0 = ingen opl�sning',
        'Only business hours are counted.' => 'Kun normal kontor tid er beregnet.',
        '0 = no escalation' => '0 = ingen eskalering',
        'Notify by' => 'Adviser via',
        'Follow up Option' => 'Opf�lgningsmulighed',
        'Ticket lock after a follow up' => 'Sag opl�st efter en opf�lgning',
        'Systemaddress' => 'Systemadresse',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Hvis en konsulent l�ser en sag, og vedkommende ikke sender et svar inden for dette tidsrum, l�ses sagen automatisk op. Derved kan alle andre konsulenter se sagen.',
        'Escalation time' => 'Eskaleringstid',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Besvares en sag ikke inden for dette tidsrum, vil kun denne sag blive vist.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Er en sag lukket, og kunden sender en opf�lgning, l�ses sagen for den gamle konsulent.',
        'Will be the sender address of this queue for email answers.' => 'Bliver til denne k�s afsenderadresse for e-mailsvar.',
        'The salutation for email answers.' => 'Den hilsen, der bruges til e-mailsvar.',
        'The signature for email answers.' => 'Den underskrift, der bruges til e-mailsvar.',
        'Customer Move Notify' => 'Kundebesked ved flytning',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS sender en e-mail med besked til kunden, hvis sagen er flyttet.',
        'Customer State Notify' => 'Besked om kunde status',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS sender en e-mail med besked til kunden, hvis sagens tilstand er �ndret.',
        'Customer Owner Notify' => 'Besked til kundeejer',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS sender en e-mail med besked til kunden, hvis sagen har f�et en anden indehaver.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Svar <-> K�styring',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Svar',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Svar <-> Styring af vedh�ftede filer',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Svar Styring',
        'A response is default text to write faster answer (with default text) to customers.' => 'Et Svar er en standardtekst, der bruges til at skrive et hurtigere svar (med standardtekst) til kunderne.',
        'Don\'t forget to add a new response a queue!' => 'Glem ikke at tilf�je et nyt svar pr. k�!',
        'The current ticket state is' => 'Den aktuelle sags status er',
        'Your email address is new' => 'Din e-mailadresse er ny',

        # Template: AdminRoleForm
        'Role Management' => 'Rollestyring',
        'Add Role' => 'Tilf�j rolle',
        'Add a new Role.' => 'Tilf�j en ny rolle',
        'Create a role and put groups in it. Then add the role to the users.' => 'Opret en rolle og inds�t grupper i den. Tilf�j dern�st brugernes rolle.',
        'It\'s useful for a lot of users and groups.' => 'Det er nyttigt for mange brugere og grupper.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Roller <-> Gruppestyring',
        'move_into' => 'flyt_til',
        'Permissions to move tickets into this group/queue.' => 'Tilladelser til at flytte sager ind i denne gruppe/k�.',
        'create' => 'opret',
        'Permissions to create tickets in this group/queue.' => 'Tilladelser til at oprette sager i denne gruppe/k�.',
        'owner' => 'konsulent',
        'Permissions to change the ticket owner in this group/queue.' => 'Tilladelser til at �ndre ansvarlig konsulent i denne gruppe/k�.',
        'priority' => 'prioritering',
        'Permissions to change the ticket priority in this group/queue.' => 'Tilladelser til at �ndre sagprioriteringen i denne gruppe/k�.',

        # Template: AdminRoleGroupForm
        'Role' => 'Rolle',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Roller <-> Brugerstyring',
        'Select the role:user relations.' => 'V�lg relationer mellem rollen:brugeren.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Styring af hilsner',
        'Add Salutation' => 'Tilf�j hilsen',
        'Add a new Salutation.' => 'Tilf�j en ny hilsen',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => 'Sikker tilstand skal v�re sl�et til!',
        'Secure mode will (normally) be set after the initial installation is completed.' => 'Sikker tilstand vil (normalt) v�ret sl�et til efter installationen er fuldf�rt.',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => 'Sikker tilstand skal v�re sl�et fra for at reinstallere via Web-installer',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => 'Hvis sikker tilstand ikker er sl�et til, s� g�r det via SysConfig, da programmet allerede k�rer.',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'SQL Box',
        'Go' => 'G�',
        'Select Box Result' => 'V�lg feltresultat',

        # Template: AdminService
        'Service Management' => 'Service administration',
        'Add Service' => 'Tilf�j service',
        'Add a new Service.' => 'Tilf�j en ny service',
        'Sub-Service of' => 'Under service af',

        # Template: AdminSession
        'Session Management' => 'Sessionsstyring',
        'Sessions' => 'Sessioner',
        'Uniq' => 'Unik',
        'Kill all sessions' => 'Dr�b alle sessions',
        'Session' => 'Session',
        'Content' => 'Indhold',
        'kill session' => 'afbryd session',

        # Template: AdminSignatureForm
        'Signature Management' => 'Underskriftstyring',
        'Add Signature' => 'Tilf�j underskrift',
        'Add a new Signature.' => 'Tilf�j ny underskrift',

        # Template: AdminSLA
        'SLA Management' => 'SLA Administration',
        'Add SLA' => 'Tilf�j SLA',
        'Add a new SLA.' => 'Tilf�j en ny SLA',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'S/MIME Styring',
        'Add Certificate' => 'Tilf�j certifikat',
        'Add Private Key' => 'Tilf�j privat n�gle',
        'Secret' => 'Hemmelig',
        'Hash' => 'Hash',
        'In this way you can directly edit the certification and private keys in file system.' => 'Du kan p� denne m�de direkte redigere certificeringsn�gler og private n�gler i filsystemet.',

        # Template: AdminStateForm
        'State Management' => 'Tilstands administration',
        'Add State' => 'Tilf�j tilstand',
        'Add a new State.' => 'Tilf�j en ny tilstand',
        'State Type' => 'Tilstandstype',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'S�rg for, at du ogs� opdatede standardtilstandene i Kernel/Config.pm!',
        'See also' => 'Se ogs�',

        # Template: AdminSysConfig
        'SysConfig' => 'SysConfig',
        'Group selection' => 'Gruppevalg',
        'Show' => 'Vis',
        'Download Settings' => 'Download indstillinger',
        'Download all system config changes.' => 'Download alle systemkonfigurations �ndringer.',
        'Load Settings' => 'Indl�s indstillinger',
        'Subgroup' => 'Undergruppe',
        'Elements' => 'Elementer',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Konfiguationsmuligheder',
        'Default' => 'Standard',
        'New' => 'Ny',
        'New Group' => 'Ny gruppe',
        'Group Ro' => 'Gruppe Ro',
        'New Group Ro' => 'Ny grupperolle',
        'NavBarName' => 'NavBarNavn',
        'NavBar' => 'NavBar',
        'Image' => 'Billede',
        'Prio' => 'Prio',
        'Block' => 'Blok',
        'AccessKey' => 'AdgangsN�gle',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Systems e-mailadressestyring',
        'Add System Address' => 'Tilf�j system adresse',
        'Add a new System Address.' => 'Tilf�j en ny system adresse',
        'Realname' => 'RigtigtNavn',
        'All email addresses get excluded on replaying on composing an email.' => 'Alle email adresser ekskluderes ved gentagelse af oprettelse af ny email.',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle indkommende e-mail med denne "E-mail" (Til:) sendes til den valgte k�!',

        # Template: AdminTypeForm
        'Type Management' => 'Type administration',
        'Add Type' => 'Tilf�j type',
        'Add a new Type.' => 'Tilf�j en ny type',

        # Template: AdminUserForm
        'User Management' => 'Brugerstyring',
        'Add User' => 'Tilf�j bruger',
        'Add a new Agent.' => 'Tilf�j en ny Agent',
        'Login as' => 'Login som',
        'Firstname' => 'Fornavn',
        'Lastname' => 'Efternavn',
        'Start' => 'Start',
        'End' => 'Slut',
        'User will be needed to handle tickets.' => 'Brugeren beh�ves til at h�ndtere sagerne.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Glem ikke at tilf�je en ny bruger til grupper og/eller roller!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Brugere <-> Gruppestyring',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Adressebog',
        'Return to the compose screen' => 'Vend tilbage til skrivesk�rmen',
        'Discard all changes and return to the compose screen' => 'Kass�r alle �ndringer og vend tilbage til skrivesk�rmen',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerSearch

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Oversigt',

        # Template: AgentDashboardCalendarOverview
        'in' => 'i',

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s er tilg�ngelig',
        'Please update now.' => 'Opgrader venligst nu.',
        'Release Note' => 'Frigivelsesnoter',
        'Level' => 'Niveau',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Indsendt %s siden',

        # Template: AgentDashboardTicketOverview

        # Template: AgentDashboardTicketStats

        # Template: AgentInfo
        'Info' => 'Info',

        # Template: AgentLinkObject
        'Link Object: %s' => 'K�d objekt: %s',
        'Object' => 'Objekt',
        'Link Object' => 'K�d til objekt',
        'with' => 'med',
        'Select' => 'V�lg',
        'Unlink Object: %s' => 'Fjern k�dning af objekt: %s',

        # Template: AgentLookup
        'Lookup' => 'Find',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Stavekontrolprogram',
        'spelling error(s)' => 'stavefejl',
        'or' => 'eller',
        'Apply these changes' => 'Anvend disse �ndringer',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Er du sikker p�, du �nsker at slette dette objekt?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'V�lg begr�nsningerne til at karakterisere stat',
        'Fixed' => 'Fast',
        'Please select only one element or turn off the button \'Fixed\'.' => 'V�lg venligst kun et Element, eller frav�lg knappen \'Fast\'',
        'Absolut Period' => 'Absolut periode',
        'Between' => 'Mellem',
        'Relative Period' => 'Relativ periode',
        'The last' => 'Den sidste',
        'Finish' => 'F�rdig',
        'Here you can make restrictions to your stat.' => 'Her kan du begr�nse din stat',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Vis du fjerner markeringen i boksen "Fast", kan agenten �ndrer attributterne ved det valgte element.',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Inds�t f�lles specifikationer',
        'Permissions' => 'Rettigeheder',
        'Format' => 'Format',
        'Graphsize' => 'Graf st�rrelse',
        'Sum rows' => 'Antal r�kker',
        'Sum columns' => 'Antal Kollonner',
        'Cache' => 'Cache',
        'Required Field' => 'P�k�rvede felter',
        'Selection needed' => 'Valg p�kr�vet',
        'Explanation' => 'Forklaring',
        'In this form you can select the basic specifications.' => 'I denne formular kan du v�lge de grundl�ggende specifikationer.',
        'Attribute' => 'Atribut',
        'Title of the stat.' => 'Title p� stat.',
        'Here you can insert a description of the stat.' => 'Her kan du indtaste en beskrivelse af stat.',
        'Dynamic-Object' => 'Dynamisk-Objekt',
        'Here you can select the dynamic object you want to use.' => 'Her kan du v�lge det dynamiske objekt du vil bruge',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '(Bemlrk: Det afh�nger af din installation hvor mange dynamiske objekter du kan bruge)',
        'Static-File' => 'Statisk-Fil',
        'For very complex stats it is possible to include a hardcoded file.' => 'For meget komplekse statistiker er det muligt at inkludere en hardcoded fil.',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Hvis en hardcoded fil er tilg�ngelig, vil denne attribute v�re vist, og du kan v�lge den.',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Rettigheds indstillinger, Du kan v�lge en eller flere grupper, for at g�re den konfigurerede stat synlig for forskellige agenter.',
        'Multiple selection of the output format.' => 'Flere valg af output format',
        'If you use a graph as output format you have to select at least one graph size.' => 'iHvis du bruger en graf som output format skal du v�lge mindst en graf st�rrelse',
        'If you need the sum of every row select yes' => 'Hvis du skal bruge summen af hver r�kke, v�lg da ja',
        'If you need the sum of every column select yes.' => 'Hvis du skal bruge summe af hver kolonne v�lg da ja',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'De fleste statistikker kan blive cachet, det vil g�re pr�sentationen hurtigere',
        '(Note: Useful for big databases and low performance server)' => '(Bem�rk: Brugbart for store databse og lavydelse servere)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Med en ugyldig stat er det ikke muligt at generere en stat',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'Dette er brugbart hvis du ikke �nsker at nogen kan se resultatet afen stat der ikke er konfigureret.',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'V�lg elementerne for v�rdi serien',
        'Scale' => 'Skala',
        'minimal' => 'minimum',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'Husk venligst at skalen for v�rdi serien, skal v�re st�rre end den skala for X-Aksen (f.eks. X-Akse => Month, V�rdiSerie => �r).',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Her kan du v�lge v�rdi serierne. Du har muligheden for at v�lge en eller to elementer. Derefter kan du v�lge attributter for elementerne. Hvert element vil blive vist som en enkelt v�rdi sere. Hvis du ikke har valgt nogle attributter, vil alle attributter for elementet blive brugt til at generere stat. Ligesom en ny attribut vil blive tilf�jet siden sidste konfiguration.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'V�lg det element der skal bruges ved X-aksen',
        'maximal period' => 'maksimal periode',
        'minimal scale' => 'minimal skala',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Her kan du definere X-aksen. Du kan v�lge et element via knapperne. Hvis du ikke v�lger s� vil alle egenskaberne ved elementet blive benyttet n�r du laver statistik. S�vel som nye egenskaber der er tilf�jet siden sidste konfiguration.',

        # Template: AgentStatsImport
        'Import' => 'Importer',
        'File is not a Stats config' => 'Filen er ikke en Stats konfiguration',
        'No File selected' => 'Ingen fil valgt',

        # Template: AgentStatsOverview
        'Results' => 'Resultater',
        'Total hits' => 'Samlede antal hit',
        'Page' => 'Side',

        # Template: AgentStatsPrint
        'Print' => 'Udskriv',
        'No Element selected.' => 'Intet element er valgt',

        # Template: AgentStatsView
        'Export Config' => 'Eksporter konfiguration',
        'Information about the Stat' => 'Information om Stat',
        'Exchange Axis' => 'Udskiftning af akser',
        'Configurable params of static stat' => 'Konfigurer bare parametre af en statitisk stat',
        'No element selected.' => 'Intet element er valgt',
        'maximal period from' => 'maksimal periode fra',
        'to' => 'til',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'Med input og select felterne kan du konfigurere en stat til dine behov. Hvilket element af en stat du kan rette afh�nger af administratoren der har konfigureret denne stat.',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => 'En meddelelse skal have en Til: modtager!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Der skal v�re en e-mailadresse (f.eks. customer@eksempel.com) i feltet Til:!',
        'Bounce ticket' => 'Sag retur til afsender',
        'Ticket locked!' => 'Sag l�st!',
        'Ticket unlock!' => 'Sag l�st op!',
        'Bounce to' => 'Retur til',
        'Next ticket state' => 'N�ste sags status',
        'Inform sender' => 'Informer afsender',
        'Send mail!' => 'Send email',

        # Template: AgentTicketBulk
        'You need to account time!' => 'Du skal beregne tiden!',
        'Ticket Bulk Action' => 'Sagsmassehandling',
        'Spell Check' => 'Stavekontrol',
        'Note type' => 'Bem�rkningstype',
        'Next state' => 'N�ste status',
        'Pending date' => 'Afventer dato',
        'Merge to' => 'Saml til',
        'Merge to oldest' => 'Saml til �ldste',
        'Link together' => 'Link sammen',
        'Link to Parent' => 'Link til for�ldre',
        'Unlock Tickets' => 'L�s sager op',

        # Template: AgentTicketClose
        'Ticket Type is required!' => 'Sagstype er kr�vet!',
        'A required field is:' => 'Et kr�vet felt er:',
        'Close ticket' => 'Luk sag',
        'Previous Owner' => 'Tidligere konsulent',
        'Inform Agent' => 'Informer konsulent',
        'Optional' => 'Valgfri',
        'Inform involved Agents' => 'Informer involverede konsulenter',
        'Attach' => 'Vedh�ft',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => 'En meddelelse skal stavekontrolleres!',
        'Compose answer for ticket' => 'Formuler svar til sag',
        'Pending Date' => 'Afventer dato',
        'for pending* states' => 'for afventende* tilstande',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Skift sagskunde',
        'Set customer user and customer id of a ticket' => 'Indstil en sags kundebruger og kunde-ID',
        'Customer User' => 'Kundebruger',
        'Search Customer' => 'S�g kunde',
        'Customer Data' => 'Kundedata',
        'Customer history' => 'Kundehistorik',
        'All customer tickets.' => 'Alle kundesager.',

        # Template: AgentTicketEmail
        'Compose Email' => 'Formuler e-mail',
        'new ticket' => 'ny sag',
        'Refresh' => 'Opdater',
        'Clear To' => 'Ryd til',
        'All Agents' => 'Alle konsulenter',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => 'Artikeltype',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Skift sagens fritekst',

        # Template: AgentTicketHistory
        'History of' => 'Historik af',

        # Template: AgentTicketLocked

        # Template: AgentTicketMerge
        'You need to use a ticket number!' => 'Du skal have et sagsnummer!',
        'Ticket Merge' => 'Sagfletning',

        # Template: AgentTicketMove
        'If you want to account time, please provide Subject and Text!' => 'Hvis du �nsker at t�lle tid, s� inds�t Emne og Tekst',
        'Move Ticket' => 'Flyt sag',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Tilf�j bem�rkning til sag',

        # Template: AgentTicketOverviewMedium
        'First Response Time' => 'F�rste svar tid',
        'Service Time' => 'Service tid',
        'Update Time' => 'Opdaterings tid',
        'Solution Time' => 'L�snings tid',

        # Template: AgentTicketOverviewMediumMeta
        'You need min. one selected Ticket!' => 'Du skal v�lge mindst 1 dag!',

        # Template: AgentTicketOverviewNavBar
        'Filter' => 'Filter',
        'Change search options' => 'Skift s�gemuligheder',
        'Tickets' => 'Sager',
        'of' => 'af',

        # Template: AgentTicketOverviewNavBarSmall

        # Template: AgentTicketOverviewPreview
        'Compose Answer' => 'Formuler svar',
        'Contact customer' => 'Kontakt kunde',
        'Change queue' => 'Skift k�',

        # Template: AgentTicketOverviewPreviewMeta

        # Template: AgentTicketOverviewSmall
        'sort upward' => 'sorter stigende',
        'up' => 'op',
        'sort downward' => 'sorter faldende',
        'down' => 'ned',
        'Escalation in' => 'Eskalering ind',
        'Locked' => 'L�st',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Skift konsulent',

        # Template: AgentTicketPending
        'Set Pending' => 'Indstil afventer',

        # Template: AgentTicketPhone
        'Phone call' => 'Telefonopkald',
        'Clear From' => 'Ryd fra',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Almindelig',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Sag-Info',
        'Accounted time' => 'Benyttet tid',
        'Linked-Object' => 'Linket-Objekt',
        'by' => 'af',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Skift sagsprioritering',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Viste sager',
        'Tickets available' => 'Ledige sager',
        'All tickets' => 'Alle sager',
        'Queues' => 'K�er',
        'Ticket escalation!' => 'Sagskalering!',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Skift Ansvarlig for sag',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Sagss�gning',
        'Profile' => 'Profil',
        'Search-Template' => 'S�ge-skabelon',
        'TicketFreeText' => 'SagFriTekst',
        'Created in Queue' => 'Oprettet i k�',
        'Article Create Times' => 'Artikel oprettet',
        'Article created' => 'Artikel oprettet',
        'Article created between' => 'Artikel oprettet mellem',
        'Change Times' => 'Skift tider',
        'No change time settings.' => 'Ingen skift tid indstillinger',
        'Ticket changed' => 'Sag �ndret',
        'Ticket changed between' => 'Sag �ndret mellem',
        'Result Form' => 'Resultatformular',
        'Save Search-Profile as Template?' => 'Gem s�geprofil som skabelon?',
        'Yes, save it with name' => 'Ja, gem den med navn',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => 'Fritekst',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => 'Udvid visning',
        'Collapse View' => 'Indskr�nk visning',
        'Split' => 'Del',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => 'Indstillinger for artikel filter',
        'Save filter settings as default' => 'Gem filter som standard',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Tilbagesporing',

        # Template: CustomerFooter
        'Powered by' => 'Drevet af',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Login',
        'Lost your password?' => 'Mistet din adgangskode?',
        'Request new password' => 'Anmod om ny adgangskode',
        'Create Account' => 'Opret konto',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Velkommen %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Tider',
        'No time settings.' => 'Ingen tidsindstillinger.',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Klik her for at rapportere en fejl!',

        # Template: Footer
        'Top of Page' => '�verst p� siden',

        # Template: FooterSmall

        # Template: Header
        'Home' => 'Hjem',

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Web-Installation',
        'Welcome to %s' => 'Velkommen til %s',
        'Accept license' => 'Accepter licens',
        'Don\'t accept license' => 'Accepter ikke icensen',
        'Admin-User' => 'Admin-bruger',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => 'Hvis du har sat et root kodeord til din database skal du taste det her. Hvis ikke, lad feltet v�re tomt. Af sikkerheds �rsager anbefaler vi at s�tte et root kodeord. For mere information henviser vi til documentationen for din database.',
        'Admin-Password' => 'Admin-adgangskode',
        'Database-User' => 'Database-bruger',
        'default \'hot\'' => 'standard \'hot\'',
        'DB connect host' => 'DB tilsluttes v�rtscomputer',
        'Database' => 'Database',
        'Default Charset' => 'Standardtegns�t',
        'utf8' => 'utf8',
        'false' => 'negativ',
        'SystemID' => 'System-ID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Systemets identificering. Hvert sagnummer og hver http-sessions ID starter med dette tal) ',
        'System FQDN' => 'Systemets FQDN',
        '(Full qualified domain name of your system)' => '(Dit systems FQDN(Fully qualified domain name)) ',
        'AdminEmail' => 'AdminE-mail',
        '(Email of the system admin)' => '(Systemadministrators e-mail)',
        'Organization' => 'Organisation',
        'Log' => 'Log',
        'LogModule' => 'LogModul',
        '(Used log backend)' => '(Anvendt log til backend)',
        'Logfile' => 'Logfil',
        '(Logfile just needed for File-LogModule!)' => '(Logfilen beh�ves kun til Fil-LogModul!)',
        'Webfrontend' => 'Webfrontend',
        'Use utf-8 it your database supports it!' => 'Anvend utf-8, hvis din database underst�tter det!',
        'Default Language' => 'Standardsprog',
        '(Used default language)' => '(Anvendt standardsprog)',
        'CheckMXRecord' => 'KontrollerMXRecord',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Kontrollerer MX-records af anvendte e-mailadresser ved at udforme et svar. Anvend ikke KontrollerMXRecord, hvis OTRS-maskinen befinder sig bag en opkaldslinje $!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'For at kunne anvende OTRS, er du n�dt til at indtaste f�lgende linje i din kommandolinje (Terminal/Shell) som root.',
        'Restart your webserver' => 'Genstart webserveren',
        'After doing so your OTRS is up and running.' => 'N�r det er gjort, er din OTRS sat i gang og fungerer.',
        'Start page' => 'Startside',
        'Your OTRS Team' => 'Dit OTRS Team',

        # Template: LinkObject

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Ingen Rettighed',

        # Template: Notify
        'Important' => 'Vigtigt',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'udskrevet af',

        # Template: PublicDefault

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'OTRS pr�veside',
        'Counter' => 'T�ller',

        # Template: Warning

        # Template: YUI

        # Misc
        'Edit Article' => 'Ret artikkel',
        'Create Database' => 'Opret database',
        'DB Host' => 'DB v�rtscomputer',
        'Ticket Number Generator' => 'Sagsnummergenerator',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Sagidentifikator. Nogle personer �nsker at indstille dette til f.eks. \Ticket#\, \Call#\ eller \MyTicket#\)',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Du kan p� denne m�de direkte redigere den n�glering, der er konfigureret i Kernel/Config.pm.',
        'Create new Phone Ticket' => 'Opret ny telefonsag',
        'Symptom' => 'Symptom',
        'U' => 'O',
        'Site' => 'Websted',
        'Customer history search (e. g. "ID342425").' => 'Kundehistoriks�gning (f.eks. "ID342425").',
        'your MySQL DB should have a root password! Default is empty!' => 'din MySQL DB skat have en rod-adgangskode! Standarden er tom!',
        'Close!' => 'Luk!',
        'for agent firstname' => 'til konsulentens fornavn',
        ' (minutes)' => ' (minutter)',
        'No means, send agent and customer notifications on changes.' => 'Nej betyder, send meddelser til konsulent eller Kunde ved �ndringer.',
        'A web calendar' => 'En webkalender',
        'to get the realname of the sender (if given)' => 'for at f� afsenderens virkelige navn (hvis det er oplyst)',
        'OTRS DB Name' => 'OTRS DB-navn',
        'Notification (Customer)' => 'Meddelse (Kunde)',
        'Select Source (for add)' => 'V�lg kilde (til tilf�jelse)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Muligheder for sags data (f.eks. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Child-Object' => 'Barn-Objekt',
        'Queue ID' => 'K�-ID',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Konfigurationsmuligheder (f.eks. <OTRS_CONFIG_HttpType>)',
        'System History' => 'Systemhistorik',
        'customer realname' => 'kundens virkelige navn',
        'Pending messages' => 'Afventer meddelelser',
        'Port' => 'Port',
        'Modules' => 'Moduler',
        'for agent login' => 'til konsulentens login',
        'Keyword' => 'S�geord',
        'Close type' => 'Luk type',
        'DB Admin User' => 'DB-admin-bruger',
        'for agent user id' => 'til konsulentens bruger-ID',
        'Change user <-> group settings' => 'Skift bruger <-> gruppeindstillinger',
        'Problem' => 'Problem',
        'Escalation' => 'Eskalering',
        '"}' => '',
        'Order' => 'Ordre',
        'next step' => 'n�ste trin',
        'Follow up' => 'Opf�lgning',
        'Customer history search' => 'Kunde historik s�gning',
        'Admin-Email' => 'Admin-E-mail',
        'Stat#' => '',
        'Create new database' => 'Opret ny database',
        'ArticleID' => 'Artikel-ID',
        'Keywords' => 'S�geord',
        'Ticket Escalation View' => 'Sags eskalerings visning',
        'Today' => 'Idag',
        'No * possible!' => 'Ingen * er mulig!',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Muligheder for den nuv�rende bruger der har udf�rt denne handling (f.eks. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner' => 'Meddelelse til ny konsulent',
        'to get the first 5 lines of the email' => 'for at f� e-mailens f�rste 5 linjer',
        '}' => '}',
        'Sort by' => 'Sorter efter',
        'OTRS DB Password' => 'OTRS DB-adgangskode',
        'Last update' => 'Sidste opdatering',
        'Tomorrow' => 'Imorgen',
        'to get the first 20 character of the subject' => 'for at f� emnets f�rste 20 tegn',
        'Select the customeruser:service relations.' => 'Udv�lg Kundebruger service relationer.',
        'DB Admin Password' => 'DB-admins adgangskode',
        'Advisory' => 'Bekendtg�relse',
        'Drop Database' => 'Udelad database',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Her kan du definere X-aksen. Du kan v�lge et element med radio button. Derefter skal du v�lge et eller flere attributter til elementet. Hvis du ikke v�lger nogle attributter, vil alle attributter blive brugt, ligesom et nyt attribut vil blive gemt, siden sidste konfiguration.',
        'FileManager' => 'FilManager',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Valgmuligheder for de aktuelle kundebrugerdata (f.eks. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Afventer type',
        'Comment (internal)' => 'Kommentar (intern)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Sagen konsulent muligheder (f.eks. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Valgmuligheder for sagens data (f.eks. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Anvendt sagsnummerformat)',
        'Reminder' => 'P�mindelse',
        'Incident' => 'H�ndelse',
        'All Agent variables.' => 'Alle konsulent variabler',
        ' (work units)' => '(arbejdsenheder)',
        'Next Week' => 'N�ste uge',
        'All Customer variables like defined in config option CustomerUser.' => 'Alle kundevariabler som definerede i konfigurationsmuligheden KundeBruger.',
        'accept license' => 'accepter licens',
        '0' => '0',
        'for agent lastname' => 'til agents efternavn',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Valgmuligheder for den aktuelle bruger, som anmodede om denne handling (f.eks. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'P�mindelsesmeddelelser',
        'Parent-Object' => 'For�ldre-Objekt',
        'Of couse this feature will take some system performance it self!' => 'Selvf�lgelig vil denne mulighed tage noget af system kr�ften.',
        'Detail' => 'Oplysning',
        'Your own Ticket' => 'Din egen sag',
        'Don\'t forget to add a new user to groups!' => 'Glem ikke at tilf�je en ny bruger til grupper!',
        'Open Tickets' => '�bne sager',
        'CreateTicket' => 'Opret sag',
        'You have to select two or more attributes from the select field!' => 'Du skal v�lge to eller flere attributter fra feltet!',
        'System Settings' => 'Systemindstillinger',
        'WebWatcher' => 'WebWatcher',
        'Finished' => 'F�rdig',
        'Account Type' => 'Konto type',
        'D' => 'N',
        'All messages' => 'Alle meddelelser',
        'System Status' => 'System status',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Valgmuligheder for de aktuelle sagsdata (f.eks. lt;OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Artefact' => 'Artefakt',
        'A article should have a title!' => 'En artikel skal have en titel!',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Konfigurations muligheder (f.eks. &lt;OTRS_CONFIG_HttpType&gt;)',
        'All email addresses get excluded on replaying on composing and email.' => 'Alle email adresser er ekskluderet n�r du besvarer eller laver en ny email.',
        'don\'t accept license' => 'accepter ikke licens',
        'A web mail client' => 'En webmailklient',
        'Compose Follow up' => 'Formuler opf�lgning',
        'WebMail' => 'WebMail',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Valgmuligheder for sagens data (f.eks. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Konsulent valgmuligheder (f.eks. <OTRS_OWNER_UserFirstname>)',
        'DB Type' => 'DB type',
        'Termin1' => 'Termin1',
        'kill all sessions' => 'afbryd alle sessioner',
        'to get the from line of the email' => 'for at f� e-mailens "fra"-linje',
        'Solution' => 'L�sning',
        'Package not correctly deployed, you need to deploy it again!' => 'Pakken blev ikke korrekt installeret, den skal installeres igen!',
        'QueueView' => 'K�Visning',
        'Select Box' => 'V�lg felt',
        'New messages' => 'Nye meddelelser',
        'Welcome to OTRS' => 'Velkommen til OTRS',
        'modified' => 'modificeret',
        'Delete old database' => 'Slet gammel database',
        'A web file manager' => 'En webfilmanager',
        'Have a lot of fun!' => 'Hav det rigtig sjovt!',
        'send' => '',
        'Send no notifications' => 'Send ingen meddelser',
        'Note Text' => 'Bem�rkningstekst',
        'POP3 Account Management' => 'POP3 kontostyring',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Muligheder for den nuv�rende kundes data (f.eks. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'System State Management' => 'Systemtilstandsstyring',
        'OTRS DB User' => 'OTRS DB-bruger',
        'Mailbox' => 'Mailboks',
        'PhoneView' => 'TelefonVisning',
        'maximal period form' => 'maksimal periode form',
        'TicketID' => 'Sag-ID',
        'Escaladed Tickets' => 'Eskalerede sager',
        'Yes means, send no agent and customer notifications on changes.' => 'Ja betyder, send ingen meddelser til konsulent eller Kunde ved �ndringer.',
        'SMIME Management' => 'SMIME-styring',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Din e-mail med sagnummer "<OTRS_TICKET>" er sendt retur til afsender til "<OTRS_BOUNCE_TO>". Kontakt denne adresse for at f� flere oplysninger.',
        'Ticket Status View' => 'Sagsstatusvisning',
        'Modified' => 'Modificeret',
        'Ticket selected for bulk action!' => 'Sag valgt til massehandling!',
        '%s is not writable!' => '',
        'Cannot create %s!' => '',
    };
    # $$STOP$$
    return;
}
1;
