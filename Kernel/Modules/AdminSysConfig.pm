# --
# Kernel/Modules/AdminSysConfig.pm - to change ConfigParameter
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AdminSysConfig.pm,v 1.77 2009-04-23 13:47:27 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSysConfig;

use strict;
use warnings;

use Kernel::System::Config;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.77 $) [1];

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

    $Self->{SysConfigObject} = Kernel::System::Config->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Data;
    my $Group = '';
    my $Anker = '';

    # write default file
    if ( !$Self->{ParamObject}->GetParam( Param => 'DontWriteDefault' ) ) {
        if ( !$Self->{SysConfigObject}->WriteDefault() ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # ------------------------------------------------------------ #
    # download
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Download' ) {
        my ( $s, $m, $h, $D, $M, $Y, $wd, $yd, $dst )
            = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
            );
        $M = sprintf( "%02d", $M );
        $D = sprintf( "%02d", $D );
        $h = sprintf( "%02d", $h );
        $m = sprintf( "%02d", $m );

        # return file
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/octet-stream',
            Content     => $Self->{SysConfigObject}->Download(),
            Filename    => "SysConfigBackup" . "_" . "$Y-$M-$D" . "_$h-$m.pm",
            Type        => 'attachment',
        );
    }

    # ------------------------------------------------------------ #
    # upload
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Upload' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get submit attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'file_upload',
            Source => 'String',
        );
        if ( !%UploadStuff ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Need File!', );
        }
        elsif ( $Self->{SysConfigObject}->Upload( Content => $UploadStuff{Content} ) ) {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );

        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # ------------------------------------------------------------ #
    # update config
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Update' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $SubGroup = $Self->{ParamObject}->GetParam( Param => 'SysConfigSubGroup' );
        my $Group    = $Self->{ParamObject}->GetParam( Param => 'SysConfigGroup' );
        my @List = $Self->{SysConfigObject}->ConfigSubGroupConfigItemList(
            Group    => $Group,
            SubGroup => $SubGroup
        );

        # list all Items
        for (@List) {

            # Get all Attributes from Item
            my %ItemHash = $Self->{SysConfigObject}->ConfigItemGet( Name => $_ );

            # Reset Item
            if ( defined( $Self->{ParamObject}->GetParam( Param => "Reset$_.x" ) ) ) {
                $Self->{SysConfigObject}->ConfigItemReset( Name => $_ );
                $Anker = $ItemHash{Name};
                next;
            }

            # Get ElementAktiv (checkbox)
            my $Aktiv = 0;
            if (
                ( $ItemHash{Required} && $ItemHash{Required} == 1 )
                || (
                    $Self->{ParamObject}->GetParam( Param => $_ . 'ItemAktiv' )
                    && $Self->{ParamObject}->GetParam( Param => $_ . 'ItemAktiv' ) == 1
                )
                )
            {
                $Aktiv = 1;
            }

            # ConfigElement String
            if ( defined( $ItemHash{Setting}[1]{String} ) ) {

                # Get Value (Content)
                my $Content = $Self->{ParamObject}->GetParam( Param => $_ );

                # write ConfigItem
                if (
                    !$Self->{SysConfigObject}->ConfigItemUpdate(
                        Key   => $_,
                        Value => $Content,
                        Valid => $Aktiv
                    )
                    )
                {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement TextArea
            if ( defined( $ItemHash{Setting}[1]{TextArea} ) ) {

                # Get Value (Content)
                my $Content = $Self->{ParamObject}->GetParam( Param => $_ );

                # write ConfigItem
                if (
                    !$Self->{SysConfigObject}->ConfigItemUpdate(
                        Key   => $_,
                        Value => $Content,
                        Valid => $Aktiv
                    )
                    )
                {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement PulldownMenue
            elsif ( defined( $ItemHash{Setting}[1]{Option} ) ) {
                my $Content = $Self->{ParamObject}->GetParam( Param => $_ );

                # write ConfigItem
                if (
                    !$Self->{SysConfigObject}->ConfigItemUpdate(
                        Key   => $_,
                        Value => $Content,
                        Valid => $Aktiv
                    )
                    )
                {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement Hash
            elsif ( defined( $ItemHash{Setting}[1]{Hash} ) ) {
                my @Keys         = $Self->{ParamObject}->GetArray( Param => $_ . 'Key[]' );
                my @Values       = $Self->{ParamObject}->GetArray( Param => $_ . 'Content[]' );
                my @DeleteNumber = $Self->{ParamObject}->GetArray( Param => $_ . 'DeleteNumber[]' );
                my %Content;
                for my $Index ( 0 .. $#Keys ) {

                    # SubHash
                    if ( $Values[$Index] eq '##SubHash##' ) {
                        my @SubHashKeys = $Self->{ParamObject}->GetArray(
                            Param => $_ . '##SubHash##' . $Keys[$Index] . 'Key[]'
                        );
                        my @SubHashValues = $Self->{ParamObject}->GetArray(
                            Param => $_ . '##SubHash##' . $Keys[$Index] . 'Content[]'
                        );
                        my %SubHash;
                        for my $Index2 ( 0 .. $#SubHashKeys ) {

                            # Delete SubHash Element?
                            if (
                                !$Self->{ParamObject}->GetParam(
                                    Param => $ItemHash{Name}
                                        . '##SubHash##'
                                        . $Keys[$Index]
                                        . '#DeleteSubHashElement'
                                        . ( $Index2 + 1 )
                                )
                                )
                            {
                                $SubHash{ $SubHashKeys[$Index2] } = $SubHashValues[$Index2];
                            }
                            else {
                                $Anker = $ItemHash{Name};
                            }
                        }

                        # New SubHashElement
                        if (
                            $Self->{ParamObject}->GetParam(
                                Param => $ItemHash{Name} . '#' . $Keys[$Index] . '#NewSubElement'
                            )
                            )
                        {
                            $SubHash{''} = '';
                            $Anker = $ItemHash{Name};
                        }
                        $Content{ $Keys[$Index] } = \%SubHash;
                    }

                    # SubArray
                    elsif ( $Values[$Index] eq '##SubArray##' ) {
                        my @SubArray = $Self->{ParamObject}->GetArray(
                            Param => $_ . '##SubArray##' . $Keys[$Index] . 'Content[]'
                        );

                        # New SubArrayElement
                        if (
                            $Self->{ParamObject}->GetParam(
                                Param => $ItemHash{Name} . '#' . $Keys[$Index] . '#NewSubElement'
                            )
                            )
                        {
                            push( @SubArray, '' );
                            $Anker = $ItemHash{Name};
                        }

                        #Delete SubArray Element?
                        for my $Index2 ( 0 .. $#SubArray ) {
                            if (
                                $Self->{ParamObject}->GetParam(
                                    Param => $ItemHash{Name}
                                        . '##SubArray##'
                                        . $Keys[$Index]
                                        . '#DeleteSubArrayElement'
                                        . ( $Index2 + 1 )
                                )
                                )
                            {
                                splice( @SubArray, $Index2, 1 );
                                $Anker = $ItemHash{Name};
                            }
                        }
                        $Content{ $Keys[$Index] } = \@SubArray;
                    }

                    # Delete Hash Element?
                    elsif (
                        !$Self->{ParamObject}->GetParam(
                            Param => $ItemHash{Name} . '#DeleteHashElement' . $DeleteNumber[$Index]
                        )
                        )
                    {
                        $Content{ $Keys[$Index] } = $Values[$Index];
                    }
                    else {
                        $Anker = $ItemHash{Name};
                    }
                }

                # New HashElement
                if (
                    $Self->{ParamObject}->GetParam( Param => $ItemHash{Name} . '#NewHashElement' )
                    )
                {
                    $Anker = $ItemHash{Name};
                    $Content{''} = '';
                }

                # write ConfigItem
                if (
                    !$Self->{SysConfigObject}->ConfigItemUpdate(
                        Key   => $_,
                        Value => \%Content,
                        Valid => $Aktiv
                    )
                    )
                {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement Array
            elsif ( defined( $ItemHash{Setting}[1]{Array} ) ) {
                my @Content = $Self->{ParamObject}->GetArray( Param => $_ . 'Content[]' );

                # New ArrayElement
                if (
                    $Self->{ParamObject}->GetParam( Param => $ItemHash{Name} . '#NewArrayElement' )
                    )
                {
                    push( @Content, '' );
                    $Anker = $ItemHash{Name};
                }

                #Delete Array Element
                for my $Index ( 0 .. $#Content ) {
                    if (
                        $Self->{ParamObject}->GetParam(
                            Param => $ItemHash{Name} . '#DeleteArrayElement' . ( $Index + 1 )
                        )
                        )
                    {
                        splice( @Content, $Index, 1 );
                        $Anker = $ItemHash{Name};
                    }
                }

                # write ConfigItem
                if (
                    !$Self->{SysConfigObject}->ConfigItemUpdate(
                        Key   => $_,
                        Value => \@Content,
                        Valid => $Aktiv
                    )
                    )
                {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement FrontendModuleReg
            elsif ( defined( $ItemHash{Setting}[1]{FrontendModuleReg} ) ) {
                my $ElementKey = $_;
                my %Content;

                # get Params
                for (qw(Description Title NavBarName)) {
                    $Content{$_}
                        = $Self->{ParamObject}->GetParam( Param => $ElementKey . '#' . $_ );
                }
                for my $Type (qw(Group GroupRo)) {
                    my @Group = $Self->{ParamObject}->GetArray(
                        Param => $ElementKey . '#' . $Type . '[]'
                    );

                    # New Group(Ro)Element
                    if (
                        $Self->{ParamObject}->GetParam(
                            Param => $ItemHash{Name} . '#New' . $Type . 'Element'
                        )
                        )
                    {
                        push( @Group, '' );
                        $Anker = $ItemHash{Name};
                    }

                    # Delete Group Element
                    for my $Index ( 0 .. $#Group ) {
                        if (
                            $Self->{ParamObject}->GetParam(
                                Param => $ItemHash{Name}
                                    . '#Delete'
                                    . $Type
                                    . 'Element'
                                    . ( $Index + 1 )
                            )
                            )
                        {
                            splice( @Group, $Index, 1 );
                            $Anker = $ItemHash{Name};
                        }
                    }
                    if ( $#Group > -1 ) {
                        $Content{$Type} = \@Group;
                    }
                }

                # NavBar get Params
                my %NavBarParams;
                for (qw(Description Name Image Link Type Prio Block NavBar AccessKey)) {
                    my @Param = $Self->{ParamObject}->GetArray(
                        Param => $ElementKey . '#NavBar#' . $_ . '[]'
                    );
                    $NavBarParams{$_} = \@Param;
                }

                # Add NavBar Element
                if (
                    $Self->{ParamObject}->GetParam(
                        Param => $ItemHash{Name} . '#NavBar#AddElement'
                    )
                    )
                {
                    push( @{ $NavBarParams{Description} }, '' );
                    $Anker = $ItemHash{Name};
                }

                # Create Hash
                for my $Index ( 0 .. $#{ $NavBarParams{Description} } ) {
                    for my $Type (qw(Group GroupRo)) {
                        my @Group
                            = $Self->{ParamObject}->GetArray(
                            Param => $ElementKey
                                . '#NavBar'
                                . ( $Index + 1 ) . '#'
                                . $Type
                                . '[]'
                            );

                        # New Group(Ro)Element
                        if (
                            $Self->{ParamObject}->GetParam(
                                Param => $ItemHash{Name}
                                    . '#NavBar'
                                    . ( $Index + 1 ) . '#New'
                                    . $Type
                                    . 'Element'
                            )
                            )
                        {
                            push( @Group, '' );
                            $Anker = $ItemHash{Name};
                        }

                        # Delete Group Element
                        for my $Index2 ( 0 .. $#Group ) {
                            if (
                                $Self->{ParamObject}->GetParam(
                                    Param => $ItemHash{Name}
                                        . '#NavBar'
                                        . ( $Index + 1 )
                                        . '#Delete'
                                        . $Type
                                        . 'Element'
                                        . ( $Index2 + 1 )
                                )
                                )
                            {
                                splice( @Group, $Index2, 1 );
                                $Anker = $ItemHash{Name};
                            }
                        }
                        if ( $#Group > -1 ) {
                            $Content{NavBar}[$Index]{$Type} = \@Group;
                        }
                    }
                    for (qw(Description Name Image Link Type Prio Block NavBar AccessKey)) {
                        if ( defined( $NavBarParams{$_}[$Index] ) ) {
                            $Content{NavBar}[$Index]{$_} = $NavBarParams{$_}[$Index];
                        }
                    }
                }

                # Delete NavBar Element
                for my $Index ( 0 .. $#{ $NavBarParams{Description} } ) {
                    if (
                        $Self->{ParamObject}->GetParam(
                            Param => $ItemHash{Name}
                                . '#NavBar#'
                                . ( $Index + 1 )
                                . '#DeleteElement'
                        )
                        )
                    {
                        splice( @{ $Content{NavBar} }, $Index, 1 );
                        $Anker = $ItemHash{Name};
                    }
                }

                # NavBarModule
                if (
                    $Self->{ParamObject}->GetArray(
                        Param => $ElementKey . '#NavBarModule#Module[]'
                    )
                    )
                {

                    # get Params
                    my %NavBarModuleParams;
                    for (qw(Module Name Block Prio)) {
                        my @Param = $Self->{ParamObject}->GetArray(
                            Param => $ElementKey . '#NavBarModule#' . $_ . '[]'
                        );
                        $NavBarModuleParams{$_} = \@Param;
                    }

                    # Create Hash
                    for (qw(Group GroupRo Module Name Block Prio)) {
                        if (
                            defined( $NavBarModuleParams{$_}[0] )
                            && $NavBarModuleParams{$_}[0] ne ''
                            )
                        {
                            $Content{NavBarModule}{$_} = $NavBarModuleParams{$_}[0];
                        }
                    }
                }

                # write ConfigItem
                if (
                    !$Self->{SysConfigObject}->ConfigItemUpdate(
                        Key   => $_,
                        Value => \%Content,
                        Valid => $Aktiv
                    )
                    )
                {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement TimeVacationDaysOneTime
            elsif ( defined( $ItemHash{Setting}[1]{TimeVacationDaysOneTime} ) ) {
                my @Year   = $Self->{ParamObject}->GetArray( Param => $_ . 'year[]' );
                my @Month  = $Self->{ParamObject}->GetArray( Param => $_ . 'month[]' );
                my @Day    = $Self->{ParamObject}->GetArray( Param => $_ . 'day[]' );
                my @Values = $Self->{ParamObject}->GetArray( Param => $_ . 'Content[]' );
                my %Content;
                for my $Index ( 0 .. $#Year ) {

                    # Delete TimeVacationDaysOneTime Element?
                    if (
                        !$Self->{ParamObject}->GetParam(
                            Param => $ItemHash{Name}
                                . '#DeleteTimeVacationDaysOneTimeElement'
                                . ( $Index + 1 )
                        )
                        )
                    {
                        $Content{ $Year[$Index] }{ int( $Month[$Index] ) }{ int( $Day[$Index] ) }
                            = $Values[$Index];
                    }
                    else {
                        $Anker = $ItemHash{Name};
                    }
                }

                # New TimeVacationDaysOneTimeElement
                if (
                    $Self->{ParamObject}->GetParam(
                        Param => $ItemHash{Name} . '#NewTimeVacationDaysOneTimeElement'
                    )
                    )
                {
                    my ( $s, $m, $h, $D, $M, $Y, $wd, $yd, $dst )
                        = $Self->{TimeObject}->SystemTime2Date(
                        SystemTime => $Self->{TimeObject}->SystemTime(),
                        );
                    $Content{$Y}->{''}->{''} = '-new-';
                    $Anker = $ItemHash{Name};
                }

                # write ConfigItem
                if (
                    !$Self->{SysConfigObject}->ConfigItemUpdate(
                        Key   => $_,
                        Value => \%Content,
                        Valid => $Aktiv
                    )
                    )
                {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement TimeVacationDays
            elsif ( defined( $ItemHash{Setting}[1]{TimeVacationDays} ) ) {
                my @Month  = $Self->{ParamObject}->GetArray( Param => $_ . 'month[]' );
                my @Day    = $Self->{ParamObject}->GetArray( Param => $_ . 'day[]' );
                my @Values = $Self->{ParamObject}->GetArray( Param => $_ . 'Content[]' );
                my %Content;
                for my $Index ( 0 .. $#Month ) {

                    # Delete TimeVacationDays Element?
                    if (
                        !$Self->{ParamObject}->GetParam(
                            Param => $ItemHash{Name}
                                . '#DeleteTimeVacationDaysElement'
                                . ( $Index + 1 )
                        )
                        )
                    {
                        $Content{ int( $Month[$Index] ) }{ int( $Day[$Index] ) } = $Values[$Index];
                    }
                    else {
                        $Anker = $ItemHash{Name};
                    }
                }

                # New TimeVacationDaysElement
                if (
                    $Self->{ParamObject}->GetParam(
                        Param => $ItemHash{Name} . '#NewTimeVacationDaysElement'
                    )
                    )
                {
                    my ( $s, $m, $h, $D, $M, $Y, $wd, $yd, $dst )
                        = $Self->{TimeObject}->SystemTime2Date(
                        SystemTime => $Self->{TimeObject}->SystemTime(),
                        );

                    $Content{$M}->{''} = '-new-';
                    $Anker = $ItemHash{Name};
                }

                # write ConfigItem
                if (
                    !$Self->{SysConfigObject}->ConfigItemUpdate(
                        Key   => $_,
                        Value => \%Content,
                        Valid => $Aktiv
                    )
                    )
                {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement TimeWorkingHours
            elsif ( defined( $ItemHash{Setting}[1]{TimeWorkingHours} ) ) {
                my %Content;
                for my $Index ( 1 .. $#{ $ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day} } ) {
                    my $Weekday = $ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day}[$Index]{Name};
                    my @Hours = $Self->{ParamObject}->GetArray( Param => $_ . $Weekday . '[]' );
                    $Content{$Weekday} = \@Hours;
                }

                # write ConfigItem
                if (
                    !$Self->{SysConfigObject}->ConfigItemUpdate(
                        Key   => $_,
                        Value => \%Content,
                        Valid => $Aktiv
                    )
                    )
                {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }
        }

        # submit config changes
        $Self->{SysConfigObject}->CreateConfig();

        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=$Self->{Action}&Subaction=Edit&SysConfigSubGroup=$SubGroup&SysConfigGroup=$Group&#$Anker",
        );
    }

    # ------------------------------------------------------------ #
    # edit config
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Edit' ) {
        my $SubGroup = $Self->{ParamObject}->GetParam( Param => 'SysConfigSubGroup' );
        my $Group    = $Self->{ParamObject}->GetParam( Param => 'SysConfigGroup' );
        my @List = $Self->{SysConfigObject}->ConfigSubGroupConfigItemList(
            Group    => $Group,
            SubGroup => $SubGroup
        );

        #Language
        my $UserLang = $Self->{UserLanguage} || $Self->{ConfigObject}->Get('DefaultLanguage');

        # list all Items
        for (@List) {

            # Get all Attributes from Item
            my %ItemHash = $Self->{SysConfigObject}->ConfigItemGet( Name => $_ );

            # Required
            my $Required = '';
            if ( $ItemHash{Required} ) {
                $Required = 'disabled';
            }

            # Valid
            my $Valid      = '';
            my $Validstyle = 'passiv';
            if ( $ItemHash{Valid} ) {
                $Valid      = 'checked';
                $Validstyle = '';
            }

            #Description
            my %HashLang;
            for my $Index ( 1 .. $#{ $ItemHash{Description} } ) {
                $HashLang{ $ItemHash{Description}[$Index]{Lang} }
                    = $ItemHash{Description}[$Index]{Content};
            }
            my $Description;

            # Description in User Language
            if ( defined $HashLang{$UserLang} ) {
                $Description = $HashLang{$UserLang};
            }

            # Description in Default Language
            else {
                $Description = $HashLang{'en'};
            }
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementBlock',
                Data => {
                    Name        => $ItemHash{Name},
                    ItemKey     => $_,
                    Description => $Description,
                    Valid       => $Valid,
                    Validstyle  => $Validstyle,
                    Required    => $Required,
                },
            );
            if ( $ItemHash{Diff} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementBlockReset',
                    Data => { ItemKey => $_, },
                );
            }

            # ListConfigItem
            $Self->ListConfigItem( Hash => \%ItemHash );
        }
        $Data{SubGroup} = $SubGroup;
        $Data{Group}    = $Group;
        my $Output .= $Self->{LayoutObject}->Header( Value => "$Group -> $SubGroup" );
        $Output    .= $Self->{LayoutObject}->NavigationBar();
        $Output    .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSysConfigEdit',
            Data         => \%Data
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # search config
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Search' ) {
        my $Search = $Self->{ParamObject}->GetParam( Param => 'Search' );
        my @List = $Self->{SysConfigObject}->ConfigItemSearch( Search => $Search );
        for my $Option (@List) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => $Option,
            );
        }
    }

    # list subgroups
    elsif ( $Self->{Subaction} eq 'SelectGroup' ) {
        $Group = $Self->{ParamObject}->GetParam( Param => 'SysConfigGroup' );
        my %List = $Self->{SysConfigObject}->ConfigSubGroupList( Name => $Group );
        for ( sort keys %List ) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => {
                    SubGroup      => $_,
                    SubGroupCount => $List{$_},
                    Group         => $Group,
                },
            );
        }
    }

    # secure mode message (don't allow this action till secure mode is enabled)
    if ( !$Self->{ConfigObject}->Get('SecureMode') ) {
        $Self->{LayoutObject}->SecureMode();
    }

    # list Groups
    my %List = $Self->{SysConfigObject}->ConfigGroupList();

    # create select Box
    $Data{Liste} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data                => \%List,
        SelectedID          => $Group,
        Name                => 'SysConfigGroup',
        LanguageTranslation => 0,
    );

    # check if sysconfig download link should be shown
    if ( $Self->{SysConfigObject}->Download( Type => 'Check' ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'Download',
            Data => {},
        );
    }

    my $Output .= $Self->{LayoutObject}->Header( Value => $Group );
    $Output    .= $Self->{LayoutObject}->NavigationBar();
    $Output    .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminSysConfig',
        Data => { %Data, ConfigCounter => $Self->{SysConfigObject}->{ConfigCounter}, }
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub ListConfigItem {
    my ( $Self, %Param ) = @_;

    my %ItemHash = %{ $Param{Hash} };
    my $Valid    = '';
    my $Default  = '';

    # ConfigElement String
    if ( defined( $ItemHash{Setting}[1]{String} ) ) {

        # file check
        if (
            $ItemHash{Setting}[1]{String}[1]{Check}
            && $ItemHash{Setting}[1]{String}[1]{Check} eq 'File'
            && !-f $ItemHash{Setting}[1]{String}[1]{Content}
            )
        {
            $Valid = 'file not found';
        }

        # file check
        if (
            $ItemHash{Setting}[1]{String}[1]{Check}
            && $ItemHash{Setting}[1]{String}[1]{Check} eq 'Directory'
            && !-d $ItemHash{Setting}[1]{String}[1]{Content}
            )
        {
            $Valid = 'directory not found';
        }

        # Regex check
        if (
            $ItemHash{Setting}[1]{String}[1]{Regex}
            && $ItemHash{Setting}[1]{String}[1]{Content}
            !~ /$ItemHash{Setting}[1]{String}[1]{Regex}/
            )
        {
            $Valid = 'invalid';
        }
        if ( $ItemHash{Setting}[1]{String}[1]{Default} ) {
            $Default = $ItemHash{Setting}[1]{String}[1]{Default};
        }
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementString',
            Data => {
                ElementKey => $ItemHash{Name},
                Content    => $ItemHash{Setting}[1]{String}[1]{Content},
                Valid      => $Valid,
                Default    => $Default,
            },
        );
    }

    # ConfigElement TextArea
    elsif ( defined( $ItemHash{Setting}[1]{TextArea} ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementTextArea',
            Data => {
                ElementKey => $ItemHash{Name},
                Content    => $ItemHash{Setting}[1]{TextArea}[1]{Content},
                Valid      => $Valid,
            },
        );
    }

    # ConfigElement PulldownMenue
    elsif ( defined( $ItemHash{Setting}[1]{Option} ) ) {
        my %Hash;
        my $Default = '';
        for my $Index ( 1 .. $#{ $ItemHash{Setting}[1]{Option}[1]{Item} } ) {
            $Hash{ $ItemHash{Setting}[1]{Option}[1]{Item}[$Index]{Key} }
                = $ItemHash{Setting}[1]{Option}[1]{Item}[$Index]{Content};
            if (
                $ItemHash{Setting}[1]{Option}[1]{Item}[$Index]{Key} eq
                $ItemHash{Setting}[1]{Option}[1]{Default}
                )
            {
                $Default = $ItemHash{Setting}[1]{Option}[1]{Item}[$Index]{Content};
            }
        }
        my $PulldownMenue = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => \%Hash,
            SelectedID => $ItemHash{Setting}[1]{Option}[1]{SelectedID},
            Name       => $ItemHash{Name},
        );
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementSelect',
            Data => {
                Item    => $ItemHash{Name},
                Liste   => $PulldownMenue,
                Default => $Default,
            },
        );
    }

    # ConfigElement Hash
    elsif ( defined( $ItemHash{Setting}[1]{Hash} ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementHash',
            Data => { ElementKey => $ItemHash{Name}, },
        );

        # Hashelements
        my %SortContainer = ();
        for my $Index ( 1 .. $#{ $ItemHash{Setting}[1]{Hash}[1]{Item} } ) {
            $SortContainer{$Index} = $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Key};
        }
        for my $Index ( sort { $SortContainer{$a} cmp $SortContainer{$b} } keys %SortContainer ) {

            # SubHash
            if ( defined( $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Hash} ) ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementHashContent2',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Key},
                        Content    => '##SubHash##',
                        Index      => $Index,
                    },
                );

                # SubHashElements
                for my $Index2 (
                    1 .. $#{ $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Hash}[1]{Item} }
                    )
                {
                    $Self->{LayoutObject}->Block(
                        Name => 'ConfigElementSubHashContent',
                        Data => {
                            ElementKey => $ItemHash{Name}
                                . '##SubHash##'
                                . $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Key},
                            Key =>
                                $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Hash}[1]{Item}[$Index2]
                                {Key},
                            Content =>
                                $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Hash}[1]{Item}[$Index2]
                                {Content},
                            Index  => $Index,
                            Index2 => $Index2,
                        },
                    );
                }
            }

            # SubArray
            elsif ( defined( $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Array} ) ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementHashContent2',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Key},
                        Content    => '##SubArray##',
                        Index      => $Index,
                    },
                );

                # SubArrayElements
                for my $Index2 (
                    1 .. $#{ $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Array}[1]{Item} }
                    )
                {
                    $Self->{LayoutObject}->Block(
                        Name => 'ConfigElementSubArrayContent',
                        Data => {
                            ElementKey => $ItemHash{Name}
                                . '##SubArray##'
                                . $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Key},
                            Content => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Array}[1]{Item}
                                [$Index2]{Content},
                            Index  => $Index,
                            Index2 => $Index2,
                        },
                    );
                }
            }

            #SubOption
            # REMARK: The SubOptionHandling does not work any more
            elsif ( defined( $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Option} ) ) {

                # Pulldownmenue
                my %Hash;
                for my $Index2 (
                    1 .. $#{ $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Option}[1]{Item} }
                    )
                {
                    $Hash{
                        $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Option}[1]{Item}[$Index2]
                            {Key}
                        }
                        = $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Option}[1]{Item}[$Index2]
                        {Content};
                }
                my $PulldownMenue = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data => \%Hash,
                    SelectedID =>
                        $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Option}[1]{SelectedID},
                    Name => $ItemHash{Name} . 'Content[]',
                );
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementHashContent3',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Key},
                        Liste      => $PulldownMenue,
                        Index      => $Index,
                    },
                );
            }

            # StandardElement
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementHashContent',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Key},
                        Content    => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Content},
                        Index      => $Index,
                    },
                );
            }
        }
    }

    # ConfigElement Array
    elsif ( defined( $ItemHash{Setting}[1]{Array} ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementArray',
            Data => { ElementKey => $ItemHash{Name}, },
        );

        # ArrayElements
        for my $Index ( 1 .. $#{ $ItemHash{Setting}[1]{Array}[1]{Item} } ) {
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementArrayContent',
                Data => {
                    ElementKey => $ItemHash{Name},
                    Content    => $ItemHash{Setting}[1]{Array}[1]{Item}[$Index]{Content},
                    Index      => $Index,
                },
            );
        }
    }

    # ConfigElement FrontendModuleReg
    elsif ( defined( $ItemHash{Setting}[1]{FrontendModuleReg} ) ) {
        my %Data = ();
        for my $Key (qw(Title Description NavBarName)) {
            $Data{ 'Key' . $Key }     = $Key;
            $Data{ 'Content' . $Key } = '';
            if ( defined( $ItemHash{Setting}[1]{FrontendModuleReg}[1]{$Key} ) ) {
                $Data{ 'Content' . $Key }
                    = $ItemHash{Setting}[1]{FrontendModuleReg}[1]{$Key}[1]{Content};
            }
        }
        $Data{ElementKey} = $ItemHash{Name};
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementFrontendModuleReg',
            Data => \%Data,
        );

        # Array Element Group
        for my $ArrayElement qw(Group GroupRo) {
            for my $Index ( 1 .. $#{ $ItemHash{Setting}[1]{FrontendModuleReg}[1]{$ArrayElement} } )
            {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementFrontendModuleRegContent' . $ArrayElement,
                    Data => {
                        Index      => $Index,
                        ElementKey => $ItemHash{Name},
                        Content =>
                            $ItemHash{Setting}[1]{FrontendModuleReg}[1]{$ArrayElement}[$Index]
                            {Content},
                    },
                );
            }
        }

        # NavBar
        for my $Index ( 1 .. $#{ $ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBar} } ) {
            my %Data = ();
            for my $Key (qw(Description Name Image Link Type Prio Block NavBar AccessKey)) {
                $Data{ 'Key' . $Key }     = $Key;
                $Data{ 'Content' . $Key } = '';
                if (
                    defined(
                        $ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBar}[1]{$Key}[1]{Content}
                    )
                    )
                {
                    $Data{ 'Content' . $Key }
                        = $ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBar}[$Index]{$Key}[1]
                        {Content};
                }
            }
            $Data{ElementKey} = $ItemHash{Name} . '#NavBar';
            $Data{Index}      = $Index;
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementFrontendModuleRegContentNavBar',
                Data => \%Data,
            );

            # Array Element Group
            for my $ArrayElement qw(Group GroupRo) {
                for my $Index2 (
                    1 ..
                    $#{ $ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBar}[$Index]{$ArrayElement} }
                    )
                {
                    $Self->{LayoutObject}->Block(
                        Name => 'ConfigElementFrontendModuleRegContentNavBar' . $ArrayElement,
                        Data => {
                            Index      => $Index,
                            ArrayIndex => $Index2,
                            ElementKey => $ItemHash{Name},
                            Content => $ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBar}[$Index]
                                {$ArrayElement}[$Index2]{Content},
                        },
                    );
                }
            }
        }

        # NavBarModule
        if ( ref( $ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBarModule} ) eq 'ARRAY' ) {
            for my $Index ( 1 .. $#{ $ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBarModule} } )
            {
                my %Data = ();
                for my $Key qw (Module Name Block Prio) {
                    $Data{ 'Key' . $Key }     = $Key;
                    $Data{ 'Content' . $Key } = '';
                    if (
                        defined(
                            $ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBarModule}[1]{$Key}[1]
                                {Content}
                        )
                        )
                    {
                        $Data{ 'Content' . $Key }
                            = $ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBarModule}[1]{$Key}[1]
                            {Content};
                    }
                }
                $Data{ElementKey} = $ItemHash{Name} . '#NavBarModule';
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementFrontendModuleRegContentNavBarModule',
                    Data => \%Data,
                );
            }
        }
        elsif ( defined( $ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBarModule} ) ) {
            my %Data = ();
            for my $Key qw (Module Name Block Prio) {
                $Data{ 'Key' . $Key }     = $Key;
                $Data{ 'Content' . $Key } = '';
                if (
                    defined(
                        $ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBarModule}{$Key}[1]{Content}
                    )
                    )
                {
                    $Data{ 'Content' . $Key }
                        = $ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBarModule}{$Key}[1]
                        {Content};
                }
            }
            $Data{ElementKey} = $ItemHash{Name} . '#NavBarModule';
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementFrontendModuleRegContentNavBarModule',
                Data => \%Data,
            );
        }
    }

    # ConfigElement TimeVacationDaysOneTime
    elsif ( defined( $ItemHash{Setting}[1]{TimeVacationDaysOneTime} ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementTimeVacationDaysOneTime',
            Data => { ElementKey => $ItemHash{Name}, },
        );

        # New TimeVacationDaysOneTimeElement
        if (
            $Self->{ParamObject}->GetParam(
                Param => $ItemHash{Name} . '#NewTimeVacationDaysOneTimeElement'
            )
            )
        {
            push(
                @{ $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item} },
                { Key => '', Content => '' }
            );
        }

        # TimeVacationDaysOneTimeElements
        for my $Index ( 1 .. $#{ $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item} } ) {
            my %Valid = ();
            if (
                $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}[$Index]{Year}
                && $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}[$Index]{Year}
                !~ /^\d\d\d\d$/
                )
            {
                $Valid{ValidYear} = 'invalid';
            }
            if (
                $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}[$Index]{Month}
                && $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}[$Index]{Month}
                !~ /^(1[0-2]|[1-9])$/
                )
            {
                $Valid{ValidMonth} = 'invalid';
            }
            if (
                $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}[$Index]{Day}
                && $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}[$Index]{Day}
                !~ /^([1-3][0-9]|[1-9])$/
                )
            {
                $Valid{ValidDay} = 'invalid';
            }
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementTimeVacationDaysOneTimeContent',
                Data => {
                    ElementKey => $ItemHash{Name},
                    Year  => $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}[$Index]{Year},
                    Month => $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}[$Index]{Month},
                    Day   => $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}[$Index]{Day},
                    Content =>
                        $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}[$Index]{Content},
                    Index => $Index,
                    %Valid,
                },
            );
        }
    }

    # ConfigElement TimeVacationDays
    elsif ( defined( $ItemHash{Setting}[1]{TimeVacationDays} ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementTimeVacationDays',
            Data => { ElementKey => $ItemHash{Name}, },
        );

        # New TimeVacationDaysElement
        if (
            $Self->{ParamObject}->GetParam(
                Param => $ItemHash{Name} . '#NewTimeVacationDaysElement'
            )
            )
        {
            push(
                @{ $ItemHash{Setting}[1]{TimeVacationDays}[1]{Item} },
                { Key => '', Content => '' }
            );
        }

        # TimeVacationDaysElements
        for my $Index ( 1 .. $#{ $ItemHash{Setting}[1]{TimeVacationDays}[1]{Item} } ) {
            my %Valid = ();
            if (
                $ItemHash{Setting}[1]{TimeVacationDays}[1]{Item}[$Index]{Month}
                && $ItemHash{Setting}[1]{TimeVacationDays}[1]{Item}[$Index]{Month}
                !~ /^(1[0-2]|[1-9])$/
                )
            {
                $Valid{ValidMonth} = 'invalid';
            }
            if (
                $ItemHash{Setting}[1]{TimeVacationDays}[1]{Item}[$Index]{Day}
                && $ItemHash{Setting}[1]{TimeVacationDays}[1]{Item}[$Index]{Day}
                !~ /^([1-3][0-9]|[1-9])$/
                )
            {
                $Valid{ValidDay} = 'invalid';
            }
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementTimeVacationDaysContent',
                Data => {
                    ElementKey => $ItemHash{Name},
                    Month      => $ItemHash{Setting}[1]{TimeVacationDays}[1]{Item}[$Index]{Month},
                    Day        => $ItemHash{Setting}[1]{TimeVacationDays}[1]{Item}[$Index]{Day},
                    Content    => $ItemHash{Setting}[1]{TimeVacationDays}[1]{Item}[$Index]{Content},
                    Index      => $Index,
                    %Valid,
                },
            );
        }
    }

    # ConfigElement TimeWorkingHours
    elsif ( defined( $ItemHash{Setting}[1]{TimeWorkingHours} ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementTimeWorkingHours',
            Data => { ElementKey => $ItemHash{Name}, },
        );

        # TimeWorkingHoursElements

        # create lookup day -> day id
        my %WeekdayLookup = (
            Mon => 1,
            Tue => 2,
            Wed => 3,
            Thu => 4,
            Fri => 5,
            Sat => 6,
            Sun => 7,
        );
        my %SortWeekdays;
        for my $Index ( 1 .. $#{ $ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day} } ) {

            # assign index id to day id for sorting
            $SortWeekdays{
                $WeekdayLookup{
                    $ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day}[$Index]
                        {Name}
                    }
                }
                = $Index;
        }

        # get output sorted by day id
        for my $DayIndex ( 1 .. 7 ) {
            my $Index = $SortWeekdays{$DayIndex};
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementTimeWorkingHoursContent',
                Data => {
                    ElementKey => $ItemHash{Name},
                    Weekday    => $ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day}[$Index]{Name},
                    Index      => $Index,
                },
            );

            # Hours
            my @ArrayHours = (
                '', '', '', '', '', '', '', '', '', '', '', '', '', '',
                '', '', '', '', '', '', '', '', '', '', ''
            );

            # Aktiv Hours
            if ( defined( $ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day}[$Index]{Hour} ) ) {
                for my $Index2 (
                    1 .. $#{ $ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day}[$Index]{Hour} }
                    )
                {
                    $ArrayHours[
                        $ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day}[$Index]{Hour}
                        [$Index2]{Content}
                        ]
                        = 'checked';
                }
            }
            for my $Z ( 0 .. 23 ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementTimeWorkingHoursHours',
                    Data => {
                        ElementKey => $ItemHash{Name}
                            . $ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day}[$Index]{Name},
                        Hour  => $Z,
                        Aktiv => $ArrayHours[$Z],
                    },
                );
            }
        }
    }
}

1;
