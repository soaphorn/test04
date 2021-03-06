# --
# Kernel/Modules/AgentTicketAttachment.pm - to get the attachments
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketAttachment.pm,v 1.22.2.8 2012-09-13 08:08:40 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketAttachment;

use strict;
use warnings;

use Kernel::System::FileTemp;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.22.2.8 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject EncodeObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # get ArticleID
    $Self->{ArticleID} = $Self->{ParamObject}->GetParam( Param => 'ArticleID' );
    $Self->{FileID}    = $Self->{ParamObject}->GetParam( Param => 'FileID' );
    $Self->{Viewer}    = $Self->{ParamObject}->GetParam( Param => 'Viewer' ) || 0;

    $Self->{LoadInlineContent} = $Self->{ParamObject}->GetParam( Param => 'LoadInlineContent' )
        || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check params
    if ( !$Self->{FileID} || !$Self->{ArticleID} ) {
        $Self->{LogObject}->Log(
            Message  => 'FileID and ArticleID are needed!',
            Priority => 'error',
        );
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # check permissions
    my %Article = $Self->{TicketObject}->ArticleGet( ArticleID => $Self->{ArticleID} );
    if ( !$Article{TicketID} ) {
        $Self->{LogObject}->Log(
            Message  => "No TicketID for ArticleID ($Self->{ArticleID})!",
            Priority => 'error',
        );
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # check permissions
    my $Access = $Self->{TicketObject}->Permission(
        Type     => 'ro',
        TicketID => $Article{TicketID},
        UserID   => $Self->{UserID}
    );
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # get a attachment
    my %Data = $Self->{TicketObject}->ArticleAttachment(
        ArticleID => $Self->{ArticleID},
        FileID    => $Self->{FileID},
    );
    if ( !%Data ) {
        $Self->{LogObject}->Log(
            Message  => "No such attacment ($Self->{FileID})! May be an attack!!!",
            Priority => 'error',
        );
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # find viewer for ContentType
    my $Viewer = '';
    if ( $Self->{Viewer} && $Self->{ConfigObject}->Get('MIME-Viewer') ) {
        for ( keys %{ $Self->{ConfigObject}->Get('MIME-Viewer') } ) {
            if ( $Data{ContentType} =~ /^$_/i ) {
                $Viewer = $Self->{ConfigObject}->Get('MIME-Viewer')->{$_};
                $Viewer =~ s/\<OTRS_CONFIG_(.+?)\>/$Self->{ConfigObject}->{$1}/g;
            }
        }
    }

    # show with viewer
    if ( $Self->{Viewer} && $Viewer ) {

        # write tmp file
        my $FileTempObject = Kernel::System::FileTemp->new( %{$Self} );
        my ( $FH, $Filename ) = $FileTempObject->TempFile();
        if ( open( DATA, '>', $Filename ) ) {
            print DATA $Data{Content};
            close(DATA);
        }
        else {

            # log error
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Cant write $Filename: $!",
            );
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # use viewer
        my $Content = '';
        if ( open( DATA, "$Viewer $Filename |" ) ) {
            while (<DATA>) {
                $Content .= $_;
            }
            close(DATA);
        }
        else {
            return $Self->{LayoutObject}->FatalError(
                Message => "Can't open: $Viewer $Filename: $!",
            );
        }

        # return new page
        return $Self->{LayoutObject}->Attachment(
            %Data,
            ContentType => 'text/html',
            Content     => $Content,
            Type        => 'inline'
        );
    }

    # view attachment for html email
    if ( $Self->{Subaction} eq 'HTMLView' ) {

        # set download type to inline
        $Self->{ConfigObject}->Set( Key => 'AttachmentDownloadType', Value => 'inline' );

        # just return for non-html attachment (e. g. images)
        if ( $Data{ContentType} !~ /text\/html/i ) {
            return $Self->{LayoutObject}->Attachment(%Data);
        }

        # set filename for inline viewing
        $Data{Filename} = "Ticket-$Article{TicketNumber}-ArticleID-$Article{ArticleID}.html";

        # safety check only on customer article
        if ( !$Self->{LoadInlineContent} && $Article{SenderType} ne 'customer' ) {
            $Self->{LoadInlineContent} = 1;
        }

        # get charset and convert content to internal charset
        if ( $Self->{EncodeObject}->EncodeInternalUsed() ) {
            my $Charset = $Data{ContentType};
            $Charset =~ s/.+?charset=("|'|)(\w+)/$2/gi;
            $Charset =~ s/"|'//g;
            $Charset =~ s/(.+?);.*/$1/g;

            # convert charset
            if ($Charset) {
                $Data{Content} = $Self->{EncodeObject}->Convert(
                    Text => $Data{Content},
                    From => $Charset,
                    To   => $Self->{LayoutObject}->{UserCharset},
                );

                # replace charset in content
                $Data{Content}     =~ s/$Charset/utf-8/gi;
                $Data{ContentType} =~ s/$Charset/utf-8/gi;
            }
        }

        # add html links
        $Data{Content} = $Self->{LayoutObject}->HTMLLinkQuote(
            String => $Data{Content},
        );

        # cleanup some html tags to be cross browser compat.
        $Data{Content} = $Self->{LayoutObject}->RichTextDocumentCleanup(
            String => $Data{Content},
        );

        # safety check
        if ( !$Self->{LoadInlineContent} ) {
            $Data{Content} = $Self->RichTextDocumentSafetyCheck(
                String => $Data{Content},
            );
        }

        # replace links to inline images in html content
        my %AtmBox = $Self->{TicketObject}->ArticleAttachmentIndex(
            ArticleID => $Self->{ArticleID},
        );

        # build base url for inline images
        my $SessionID = '';
        if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
            $SessionID = '&' . $Self->{SessionName} . '=' . $Self->{SessionID};
        }
        my $AttachmentLink = $Self->{LayoutObject}->{Baselink}
            . 'Action=AgentTicketAttachment&Subaction=HTMLView'
            . '&ArticleID='
            . $Self->{ArticleID}
            . $SessionID
            . '&FileID=';

        # replace inline images in content with runtime url to images
        $Data{Content} =~ s{
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

            # find matching attachment and replace it with runtime url to image
            for my $AttachmentID ( keys %AtmBox ) {
                next if lc $AtmBox{$AttachmentID}->{ContentID} ne lc "<$ContentID>";
                $ContentID = $AttachmentLink . $AttachmentID;
                last;
            }

            # return new runtime url
            $Start . $ContentID . $End;
        }egxi;

        # return html attachment
        return $Self->{LayoutObject}->Attachment(%Data);
    }

    # download it AttachmentDownloadType is configured
    return $Self->{LayoutObject}->Attachment(%Data);
}

=item RichTextDocumentSafetyCheck()

check if content is safety

    $HTMLBody = $LayoutObject->RichTextDocumentSafetyCheck(
        String => $HTMLBody,
    );

=cut

sub RichTextDocumentSafetyCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # safety check
    my %Safety = $Self->Safety(
        String       => \$Param{String},
        NoApplet     => 1,
        NoObject     => 1,
        NoEmbed      => 1,
        NoIntSrcLoad => 0,
        NoExtSrcLoad => 1,
        NoJavaScript => 1,
        Debug        => $Self->{Debug},
    );

    # return if no safety change has been done
    return $Param{String} if !$Safety{Replaced};

    # generate blocker message
    my $Message = $Self->{LayoutObject}->Output(
        TemplateFile => 'AttachmentBlocker',
    );

    # add it on top of page
    if ( ${ $Safety{String} } =~ /<body.*?/si ) {
        ${ $Safety{String} } =~ s/(<body.*?>)/$1\n$Message/si;
    }

    # add it to end of page
    else {
        ${ $Safety{String} } = $Message . ${ $Safety{String} };
    }

    return ${ $Safety{String} };
}

=item Safety()

To remove/strip active html tags/addons (javascript, applets, embeds and objects)
from html strings.

    my %Safe = $HTMLUtilsObject->Safety(
        String       => $HTMLString,
        NoApplet     => 1,
        NoObject     => 1,
        NoEmbed      => 1,
        NoIntSrcLoad => 0,
        NoExtSrcLoad => 1,
        NoJavaScript => 1,
    );

also string ref is possible

    my %Safe = $HTMLUtilsObject->Safety(
        String       => \$HTMLStringRef,
        NoApplet     => 1,
        NoObject     => 1,
        NoEmbed      => 1,
        NoIntSrcLoad => 0,
        NoExtSrcLoad => 1,
        NoJavaScript => 1,
    );

returns

    my %Safe = (
        String   => $HTMLString, # modified html string (scalar or ref)
        Replaced => 1,           # 1|0 - info if something got replaced
    );

=cut

sub Safety {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $String = $Param{String} || '';

    # check ref
    my $StringScalar;
    if ( !ref $String ) {
        $StringScalar = $String;
        $String       = \$StringScalar;
    }

    my %Safety;

    my $Replaced;

    # In UTF-7, < and > can be encoded to mask them from security filters like this one.
    my $TagStart = '(?:<|[+]ADw-)';
    my $TagEnd   = '(?:>|[+]AD4-)';

    # Replace as many times as it is needed to avoid nesting tag attacks.
    do {
        $Replaced = undef;

        # remove script tags
        if ( $Param{NoJavaScript} ) {
            $Replaced += ${$String} =~ s{
                $TagStart script.*? $TagEnd .*?  $TagStart /script \s* $TagEnd
            }
            {}sgxim;
            $Replaced += ${$String} =~ s{
                $TagStart script.*? $TagEnd .+? ($TagStart|$TagEnd)
            }
            {}sgxim;

            # remove style/javascript parts
            $Replaced += ${$String} =~ s{
                $TagStart style[^>]+?javascript(.+?|) $TagEnd (.*?) $TagStart /style \s* $TagEnd
            }
            {}sgxim;

            # remove MS CSS expressions (JavaScript embedded in CSS)
            ${$String} =~ s{
                ($TagStart style[^>]+? $TagEnd .*? $TagStart /style \s* $TagEnd)
            }
            {
                if ( index($1, 'expression(' ) > -1 ) {
                    $Replaced = 1;
                    '';
                }
                else {
                    $1;
                }
            }egsxim;
        }

        # remove <applet> tags
        if ( $Param{NoApplet} ) {
            $Replaced += ${$String} =~ s{
                $TagStart applet.*? $TagEnd (.*?) $TagStart /applet \s* $TagEnd
            }
            {}sgxim;
        }

        # remove <Object> tags
        if ( $Param{NoObject} ) {
            $Replaced += ${$String} =~ s{
                $TagStart object.*? $TagEnd (.*?) $TagStart /object \s* $TagEnd
            }
            {}sgxim;
        }

        # remove <svg> tags
        if ( $Param{NoSVG} ) {
            $Replaced += ${$String} =~ s{
                $TagStart svg.*? $TagEnd (.*?) $TagStart /svg \s* $TagEnd
            }
            {}sgxim;
        }

        # remove <embed> tags
        if ( $Param{NoEmbed} ) {
            $Replaced += ${$String} =~ s{
                $TagStart embed.*? $TagEnd
            }
            {}sgxim;
        }

        # check each html tag
        ${$String} =~ s{
            ($TagStart.+?$TagEnd)
        }
        {
            my $Tag = $1;
            if ($Param{NoJavaScript}) {

                # remove on action attributes
                $Replaced += $Tag =~ s{
                    \son.+?=(".+?"|'.+?'|.+?)($TagEnd|\s)
                }
                {$2}sgxim;

                # remove entities in tag
                $Replaced += $Tag =~ s{
                    (&\{.+?\})
                }
                {}sgxim;

                # remove javascript in a href links or src links
                $Replaced += $Tag =~ s{
                    ((?:\s|;)(?:background|url|src|href)=)
                    ('|"|)                                  # delimiter, can be empty
                    (?:\s*javascript.*?)                 # javascript, followed by anything but the delimiter
                    \2                                      # delimiter again
                    (\s|$TagEnd)
                }
                {
                    "$1\"\"$3";
                }sgxime;

                # remove link javascript tags
                $Replaced += $Tag =~ s{
                    ($TagStart link .+? javascript (.+?|) $TagEnd)
                }
                {}sgxim;

                # remove MS CSS expressions (JavaScript embedded in CSS)
                $Replaced += $Tag =~ s{
                    \sstyle=("|')[^\1]*?expression[(].*?\1($TagEnd|\s)
                }
                {
                    $2;
                }egsxim;
            }

            # remove load tags
            if ($Param{NoIntSrcLoad} || $Param{NoExtSrcLoad}) {
                $Tag =~ s{
                    ($TagStart (.+?) \s src=(.+?) (\s.+?|) $TagEnd)
                }
                {
                    my $URL = $3;
                    if ($Param{NoIntSrcLoad} || ($Param{NoExtSrcLoad} && $URL =~ /(http|ftp|https):\//i)) {
                        $Replaced = 1;
                        '';
                    }
                    else {
                        $1;
                    }
                }segxim;
            }

            # replace original tag with clean tag
            $Tag;
        }segxim;

        $Safety{Replace} += $Replaced;

    } while ($Replaced);

    # check ref && return result like called
    if ($StringScalar) {
        $Safety{String} = ${$String};
    }
    else {
        $Safety{String} = $String;
    }
    return %Safety;
}

1;
