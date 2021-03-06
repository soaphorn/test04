# --
# Kernel/Language/pt_BR.pm - provides pt_BR language translation
# Copyright (C) 2003 Gilberto Cezar de Almeida <gibalmeida at hotmail.com>
# Copyright (C) 2005 Alterado por Glaucia C. Messina (glauglauu@yahoo.com)
# Copyright (C) 2007-2010 Fabricio Luiz Machado <soprobr gmail.com>
# --
# $Id: pt_BR.pm,v 1.89.2.8 2011-03-23 12:49:30 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.89.2.8 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Sat May 21 12:47:50 2010

    # possible charsets
    $Self->{Charset} = ['UTF-8', 'iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Separator}           = ';';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Sim',
        'No' => 'N�o',
        'yes' => 'sim',
        'no' => 'n�o',
        'Off' => 'Desligado',
        'off' => 'desligado',
        'On' => 'Ligado',
        'on' => 'ligado',
        'top' => 'in�cio',
        'end' => 'fim',
        'Done' => 'Feito',
        'Cancel' => 'Cancelar',
        'Reset' => 'Reiniciar',
        'last' => '�ltimo',
        'before' => 'antes',
        'day' => 'dia',
        'days' => 'dias',
        'day(s)' => 'dia(s)',
        'hour' => 'hora',
        'hours' => 'horas',
        'hour(s)' => 'hora(s)',
        'minute' => 'minuto',
        'minutes' => 'minutos',
        'minute(s)' => 'minuto(s)',
        'month' => 'm�s',
        'months' => 'meses',
        'month(s)' => 'm�s(s)',
        'week' => 'semana',
        'week(s)' => 'semana(s)',
        'year' => 'ano',
        'years' => 'anos',
        'year(s)' => 'ano(s)',
        'second(s)' => 'segundo(s)',
        'seconds' => 'segundos',
        'second' => 'segundo',
        'wrote' => 'escreveu',
        'Message' => 'Mensagem',
        'Error' => 'Erro',
        'Bug Report' => 'Relat�rio de Erros',
        'Attention' => 'Aten��o',
        'Warning' => 'Aviso',
        'Module' => 'M�dulo',
        'Modulefile' => 'Arquivo de M�dulo',
        'Subfunction' => 'Subfun��o',
        'Line' => 'Linha',
        'Setting' => 'Configura��o',
        'Settings' => 'Configura��es',
        'Example' => 'Exemplo',
        'Examples' => 'Exemplos',
        'valid' => 'V�lido',
        'invalid' => 'Inv�lido',
        '* invalid' => '* inv�lido',
        'invalid-temporarily' => 'Inv�lido-temporariamente',
        ' 2 minutes' => ' 2 minutos',
        ' 5 minutes' => ' 5 minutos',
        ' 7 minutes' => ' 7 minutos',
        '10 minutes' => '10 minutos',
        '15 minutes' => '15 minutos',
        'Mr.' => 'Sr.',
        'Mrs.' => 'Sra.',
        'Next' => 'Pr�ximo',
        'Back' => 'Voltar',
        'Next...' => 'Pr�ximo',
        '...Back' => '...Voltar',
        '-none-' => '-vazio-',
        'none' => 'Vazio',
        'none!' => 'Vazio!',
        'none - answered' => 'vazio  - respondido',
        'please do not edit!' => 'Por favor, n�o edite!',
        'AddLink' => 'Adicionar associa��o',
        'Link' => 'Associar',
        'Unlink' => 'Desassociar',
        'Linked' => 'Associado',
        'Link (Normal)' => 'Associa��o (Normal)',
        'Link (Parent)' => 'Associa��o (Pai)',
        'Link (Child)' => 'Associa��o (Filho)',
        'Normal' => '',
        'Parent' => 'Pai',
        'Child' => 'Filho',
        'Hit' => 'Acesso',
        'Hits' => 'Acessos',
        'Text' => 'Texto',
        'Lite' => 'Simples',
        'User' => 'Usu�rio',
        'Username' => 'Login',
        'Language' => 'Idioma',
        'Languages' => 'Idiomas',
        'Password' => 'Senha',
        'Salutation' => 'Tratamento (Sr./Sra.)',
        'Signature' => 'Assinatura',
        'Customer' => 'Cliente',
        'CustomerID' => 'ID. do Cliente',
        'CustomerIDs' => 'IDs do Cliente',
        'customer' => 'Cliente',
        'agent' => 'Atendente',
        'system' => 'Sistema',
        'Customer Info' => 'Informa��o do Cliente',
        'Customer Company' => 'Empresa de Clientes',
        'Company' => 'Empresa',
        'go!' => 'ir!',
        'go' => 'ir',
        'All' => 'Todas',
        'all' => 'todas',
        'Sorry' => 'Desculpe',
        'update!' => 'atualizar!',
        'update' => 'atualizar',
        'Update' => 'Atualizar',
        'Updated!' => 'Atualizado!',
        'submit!' => 'Enviar!',
        'submit' => 'enviar',
        'Submit' => 'Enviar',
        'change!' => 'alterar!',
        'Change' => 'Alterar',
        'change' => 'alterar',
        'click here' => 'clique aqui',
        'Comment' => 'Coment�rio',
        'Valid' => 'V�lido',
        'Invalid Option!' => 'Op��o Inv�lida',
        'Invalid time!' => 'Hora Inv�lida',
        'Invalid date!' => 'Data Inv�lida',
        'Name' => 'Nome',
        'Group' => 'Grupo',
        'Description' => 'Descri��o',
        'description' => 'descri��o',
        'Theme' => 'Tema',
        'Created' => 'Criado',
        'Created by' => 'Criado por',
        'Changed' => 'Alterado',
        'Changed by' => 'Alterado por',
        'Search' => 'Procurar',
        'and' => 'e',
        'between' => 'entre',
        'Fulltext Search' => 'Busca por texto completo',
        'Data' => 'Dado',
        'Options' => 'Op��es',
        'Title' => 'T�tulo',
        'Item' => '',
        'Delete' => 'Excluir',
        'Edit' => 'Editar',
        'View' => 'Ver',
        'Number' => 'N�mero',
        'System' => 'Sistema',
        'Contact' => 'Contato',
        'Contacts' => 'Contatos',
        'Export' => 'Exportar',
        'Up' => 'Acima',
        'Down' => 'Abaixo',
        'Add' => 'Adicionar',
        'Added!' => 'Adicionado!',
        'Category' => 'Categoria',
        'Viewer' => 'Visualiza��o',
        'Expand' => 'Expandir',
        'Small' => 'Pequeno',
        'Medium' => 'M�dio',
        'Large' => 'Grande',
        'New message' => 'Nova mensagem',
        'New message!' => 'Nova mensagem!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Por favor, responda esta(s) solicita��o(s) para retornar a fila!',
        'You got new message!' => 'Voc� recebeu uma nova mensagem',
        'You have %s new message(s)!' => 'Voc� tem %s nova(s) mensagem(s)!',
        'You have %s reminder ticket(s)!' => 'Voc� tem %s solicita��o(s) remanescente(s)',
        'The recommended charset for your language is %s!' => 'O conjunto de caracteres recomendado para o seu idioma � %s!',
        'Passwords doesn\'t match! Please try it again!' => 'Senhas n�o s�o equivalentes! Tente novamente!',
        'Password is already in use! Please use an other password!' => 'Senha em uso! Tente outra senha!',
        'Password is already used! Please use an other password!' => 'Senha est� sendo utilizada! Tente outra senha!',
        'You need to activate %s first to use it!' => 'Primeiramente ative %s, para uso!',
        'No suggestions' => 'Sem sugest�es',
        'Word' => 'Palavra',
        'Ignore' => 'Ignorar',
        'replace with' => 'substituir por',
        'There is no account with that login name.' => 'N�o existe conta com este nome de usu�rio',
        'Login failed! Your username or password was entered incorrectly.' => 'Login incorreto! Seu login ou senha foram informados incorretamente.',
        'Please contact your admin' => 'Por favor, contate administrador do sistema!',
        'Logout successful. Thank you for using OTRS!' => 'Encerrado com sucesso. Obrigado por utilizar nosso gerenciador de solicita��es!',
        'Invalid SessionID!' => 'Identifica��o de Sess�o Inv�lida',
        'Feature not active!' => 'Funcionalidade n�o ativada!',
        'Notification (Event)' => 'Notica��o (Evento)',
        'Login is needed!' => '',
        'Password is needed!' => 'Senha � obrigat�ria!',
        'License' => 'Licen�a',
        'Take this Customer' => 'Atenda este Cliente',
        'Take this User' => 'Atenda este Usu�rio',
        'possible' => 'poss�vel',
        'reject' => 'rejeitar',
        'reverse' => 'reverso',
        'Facility' => 'Facilidade',
        'Timeover' => 'Tempo esgotado',
        'Pending till' => 'Pendente at�',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'N�o trabalhe com o UserID 1(Conta do Sistema)! Crie novos usu�rios!',
        'Dispatching by email To: field.' => 'Despachar pelo PARA:  email',
        'Dispatching by selected Queue.' => 'Despachar pela fila selecionada',
        'No entry found!' => 'N�o h� entradas!',
        'Session has timed out. Please log in again.' => 'Tempo esgotado de sess�o. Entre novamente.',
        'No Permission!' => 'Sem permiss�o!',
        'To: (%s) replaced with database email!' => 'PARA: (%s) alterado!',
        'Cc: (%s) added database email!' => 'CC: (%s) adicionado! ',
        '(Click here to add)' => '(Clique aqui para adicionar)',
        'Preview' => 'Pr�-visualizar',
        'Package not correctly deployed! You should reinstall the Package again!' => 'O pacote n�o foi instalado coretamente! Voc� deve reinstal�-lo!',
        'Added User "%s"' => 'Usu�rio Adicionado "%s"',
        'Contract' => 'Contrato',
        'Online Customer: %s' => 'Clientes Online: %s',
        'Online Agent: %s' => 'Atendentes Online: %s',
        'Calendar' => 'Calend�rio',
        'File' => 'Arquivo',
        'Filename' => 'Nome do arquivo',
        'Type' => 'Tipo',
        'Size' => 'Tam',
        'Upload' => '',
        'Directory' => 'Diret�rio',
        'Signed' => 'Assinado',
        'Sign' => 'Assinar',
        'Crypted' => 'Criptografado',
        'Crypt' => 'Criptografar',
        'Office' => 'Escrit�rio',
        'Phone' => 'Telefone',
        'Fax' => '',
        'Mobile' => 'Celular',
        'Zip' => 'CEP',
        'City' => 'Cidade',
        'Street' => 'Rua',
        'Country' => 'Pa�s',
        'Location' => 'Loca��o',
        'installed' => 'instalado',
        'uninstalled' => 'desinstalado',
        'Security Note: You should activate %s because application is already running!' => '',
        'Unable to parse Online Repository index document!' => '',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => '',
        'No Packages or no new Packages in selected Online Repository!' => '',
        'printed at' => 'impresso em',
        'Dear Mr. %s,' => 'Caro Sr. %s,',
        'Dear Mrs. %s,' => 'Cara Sra. %s,',
        'Dear %s,' => 'Caro %s,',
        'Hello %s,' => 'Ol� %s,',
        'This account exists.' => 'Esta conta existe.',
        'New account created. Sent Login-Account to %s.' => 'Nova conta criada. Enviado Login para %s.',
        'Please press Back and try again.' => 'Por favor, pressione Voltar e tente novamente.',
        'Sent password token to: %s' => 'Enviado token de senha para: %s',
        'Sent new password to: %s' => 'Enviada nova senha para: %s',
        'Upcoming Events' => 'Pr�ximos Eventos',
        'Event' => 'Evento',
        'Events' => 'Eventos',
        'Invalid Token!' => 'Token Inv�lido!',
        'more' => 'mais',
        'For more info see:' => 'Para mais informa��es acesse',
        'Package verification failed!' => 'A verifica��o do pacote falhou!',
        'Collapse' => 'Recolher',
        'News' => 'Not�cias',
        'Product News' => 'Not�cias do Produto',
        'OTRS News' => 'Not�cias sobre o OTRS',
        '7 Day Stats' => 'Estat�sticas (7 Dias)',
        'Bold' => 'Negrito',
        'Italic' => 'It�lico',
        'Underline' => 'Sublinhado',
        'Font Color' => 'Cor da Fonte',
        'Background Color' => 'Cor do Plano de Fundo',
        'Remove Formatting' => 'Remover Formata��o',
        'Show/Hide Hidden Elements' => 'Mostrar/Esconder Formata��o',
        'Align Left' => 'Alinhar � Esquerda',
        'Align Center' => 'Centralizado',
        'Align Right' => 'Alinhar � Direita',
        'Justify' => 'Justificado',
        'Header' => 'Cabe�alho',
        'Indent' => 'Aumentar Recuo',
        'Outdent' => 'Diminuir Recuo',
        'Create an Unordered List' => 'Criar uma lista sem ordena��o',
        'Create an Ordered List' => 'Criar uma lista ordenada',
        'HTML Link' => 'Hiperlink',
        'Insert Image' => 'Inserir Imagem',
        'CTRL' => '',
        'SHIFT' => '',
        'Undo' => 'Desfazer',
        'Redo' => 'Refazer',

        # Template: AAAMonth
        'Jan' => '',
        'Feb' => 'Fev',
        'Mar' => '',
        'Apr' => 'Abr',
        'May' => 'Mai',
        'Jun' => '',
        'Jul' => '',
        'Aug' => 'Ago',
        'Sep' => 'Set',
        'Oct' => 'Out',
        'Nov' => '',
        'Dec' => 'Dez',
        'January' => 'Janeiro',
        'February' => 'Fevereiro',
        'March' => 'Mar�o',
        'April' => 'Abril',
        'May_long' => 'Maio',
        'June' => 'Junho',
        'July' => 'Julho',
        'August' => 'Agosto',
        'September' => 'Setembro',
        'October' => 'Outubro',
        'November' => 'Novembro',
        'December' => 'Dezembro',

        # Template: AAANavBar
        'Admin-Area' => '�rea de Administra��o',
        'Agent-Area' => '�rea de Atendente',
        'Ticket-Area' => '�rea de Solicita��o',
        'Logout' => 'Sair',
        'Agent Preferences' => 'Prefer�ncias Atendente',
        'Preferences' => 'Prefer�ncias',
        'Agent Mailbox' => 'Mailbox Atendente',
        'Stats' => 'Estat�sticas',
        'Stats-Area' => '�rea de Estat�sticas',
        'Admin' => '',
        'Customer Users' => 'Clientes',
        'Customer Users <-> Groups' => 'Clientes <-> Grupos',
        'Users <-> Groups' => 'Usu�rios <-> Grupos',
        'Roles' => 'Pap�is',
        'Roles <-> Users' => 'Pap�is <-> Usu�rios',
        'Roles <-> Groups' => 'Pap�is <-> Grupos',
        'Salutations' => 'Tratamentos (Sr./Sra.)',
        'Signatures' => 'Assinaturas',
        'Email Addresses' => 'E-mail',
        'Notifications' => 'Notifica��es',
        'Category Tree' => 'Categorias',
        'Admin Notification' => 'Notifica��o Administrativa',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Prefer�ncias atualizadas com sucesso!',
        'Mail Management' => 'Gerenciamento de E-mail',
        'Frontend' => 'Interface',
        'Other Options' => 'Outras Op��es',
        'Change Password' => 'Trocar senha',
        'New password' => 'Nova senha',
        'New password again' => 'Repita sua nova senha',
        'Select your QueueView refresh time.' => 'Selecione o tempo de atualiza��o das Filas',
        'Select your frontend language.' => 'Selecione o Idioma.',
        'Select your frontend Charset.' => 'Selecione o Conjunto de Caracteres.',
        'Select your frontend Theme.' => 'Selecione o Tema.',
        'Select your frontend QueueView.' => 'Selecione a Vis�o da Fila.',
        'Spelling Dictionary' => 'Dicion�rio (L�ngua)',
        'Select your default spelling dictionary.' => 'Escolha o seu corretor ortogr�fico padr�o.',
        'Max. shown Tickets a page in Overview.' => 'M�x. solicita��es em uma tela.',
        'Can\'t update password, your new passwords do not match! Please try again!' => 'Senha n�o atualizada, por que est�o diferentes! Tente novamente!',
        'Can\'t update password, invalid characters!' => 'Senha n�o atualizada, caracteres inv�lidos!',
        'Can\'t update password, must be at least %s characters!' => 'Senha n�o atualizada, digite no m�nimo %s caracteres!',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => 'Senha n�o atualizada, digite no m�nimo 2 caracteres min�sculos e 2 mai�sculos',
        'Can\'t update password, needs at least 1 digit!' => 'Senha n�o atualizada, digite no m�nimo 1 n�mero',
        'Can\'t update password, needs at least 2 characters!' => 'Senha n�o atualizada, digite no m�nimo 2 caracteres',

        # Template: AAAStats
        'Stat' => 'Status',
        'Please fill out the required fields!' => 'Por favor, preencha os campos obrigat�rios!',
        'Please select a file!' => 'Por favor, selecione um arquivo!',
        'Please select an object!' => 'Por favor, selecione um objeto!',
        'Please select a graph size!' => 'Por favor, selecione o tamanho do gr�fico!',
        'Please select one element for the X-axis!' => 'Por favor, selecione um elemento do eixo X!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Por favor, selecione somente um elemento ou desmarque o bot�o \'Fixo\' onde o campo selecionado est� marcado!',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Se voc� utiliza um checkbox, deves selecionar alguns atributos no campo \'selecionar\'!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Por favor, insira um valor no campo selecionado ou desmarque a checkbox \'Fixo\'!',
        'The selected end time is before the start time!' => 'A data final � anterior � data inicial!',
        'You have to select one or more attributes from the select field!' => 'Voc� deve selecionar ao menos um atributo no campo \'selecionar\'!',
        'The selected Date isn\'t valid!' => 'A data selecionada � inv�lida!',
        'Please select only one or two elements via the checkbox!' => 'Por favor, selecione apenas um ou dois elementos atrav�s da checkbox!',
        'If you use a time scale element you can only select one element!' => 'Se voc� usa um elemento como par�metro de tempo, deves selecionar apenas um elemento!',
        'You have an error in your time selection!' => 'Voc� tem um erro na hora selecionada!',
        'Your reporting time interval is too small, please use a larger time scale!' => 'O intervalo de tempo para o aviso � muito pequeno, por favor, utilize um per�odo maior!',
        'The selected start time is before the allowed start time!' => 'A data inicial selecionada � anterior � permitida!',
        'The selected end time is after the allowed end time!' => 'A data final selecionada � posterior � permitida!',
        'The selected time period is larger than the allowed time period!' => 'O per�odo de tempo selecionado � maior do que o permitido!',
        'Common Specification' => 'Especifica��o Comum',
        'Xaxis' => 'Eixo X',
        'Value Series' => 'Sequ�ncia de Valores',
        'Restrictions' => 'Restri��es',
        'graph-lines' => 'gr�fico de linhas',
        'graph-bars' => 'gr�fico de barras',
        'graph-hbars' => 'gr�fico de barras\(2\)',
        'graph-points' => 'gr�fico de pontos',
        'graph-lines-points' => 'gr�fico de linhas e pontos',
        'graph-area' => 'gr�fico de �rea',
        'graph-pie' => 'gr�fico de pizza',
        'extended' => 'extendido',
        'Agent/Owner' => 'Atendente/Propriet�rio',
        'Created by Agent/Owner' => 'Criado pelo Atendente/Propriet�rio',
        'Created Priority' => 'Prioridade',
        'Created State' => 'Status',
        'Create Time' => 'Data/Hora',
        'CustomerUserLogin' => 'Usu�rio do Cliente',
        'Close Time' => 'Data/Hora de Fechamento',
        'TicketAccumulation' => 'Acumula��o de Chamado',
        'Attributes to be printed' => 'Atributos a serem impressos',
        'Sort sequence' => 'Sequ�ncia de Ordenamento',
        'Order by' => 'Ordenar por',
        'Limit' => 'Limite',
        'Ticketlist' => 'ListaChamado',
        'ascending' => 'ascendente',
        'descending' => 'descendente',
        'First Lock' => 'Primeiro Bloqueio',
        'Evaluation by' => 'Avaliado por',
        'Total Time' => 'Tempo Total',
        'Ticket Average' => 'M�dia de Solicita��es',
        'Ticket Min Time' => 'Hor�rio M�nimo das Solicita��es',
        'Ticket Max Time' => 'Hor�rio M�ximo das Solicita��es',
        'Number of Tickets' => 'N�mero de Solicita��es',
        'Article Average' => 'M�dia de Artigos',
        'Article Min Time' => 'Hor�rio M�nimo dos Artigos',
        'Article Max Time' => 'Hor�rio M�ximo dos Artigos',
        'Number of Articles' => 'N�mero de Hist�ricos',
        'Accounted time by Agent' => 'Tempo contabilizado por Atendente',
        'Ticket/Article Accounted Time' => 'Tempo contabilizado por Solicita��o/Artigo',
        'TicketAccountedTime' => 'TempoContabilizadoSolicita��o',
        'Ticket Create Time' => 'Hor�rio de Cria��o da Solicita��o',
        'Ticket Close Time' => 'Hor�rio de Fechamento da Solicita��o',

        # Template: AAATicket
        'Lock' => 'Bloquear',
        'Unlock' => 'Desbloquear',
        'History' => 'Hist�rico',
        'Zoom' => 'Detalhes',
        'Age' => 'Idade',
        'Bounce' => 'Devolver',
        'Forward' => 'Encaminhar',
        'From' => 'De',
        'To' => 'Para',
        'Cc' => 'C�pia ',
        'Bcc' => 'C�pia Oculta',
        'Subject' => 'Assunto',
        'Move' => 'Mover',
        'Queue' => 'Fila',
        'Priority' => 'Prioridade',
        'Priority Update' => 'Atualiza��o de Prioridade',
        'State' => 'Estado',
        'Compose' => 'Compor',
        'Pending' => 'Pendente',
        'Owner' => 'Propriet�rio',
        'Owner Update' => 'Atualiza��o Propriet�rio',
        'Responsible' => 'Respons�vel',
        'Responsible Update' => 'Atualiza��o do Respons�vel',
        'Sender' => 'Remetente',
        'Article' => 'Artigo',
        'Ticket' => 'Solicita��o',
        'Createtime' => 'Hora de cria��o',
        'plain' => 'texto',
        'Email' => 'E-mail',
        'email' => 'e-mail',
        'Close' => 'Fechar',
        'Action' => 'A��o',
        'Attachment' => 'Anexo',
        'Attachments' => 'Anexos',
        'This message was written in a character set other than your own.' => 'Esta mensagem foi escrita utilizando um conjunto de caracteres diferente do seu.',
        'If it is not displayed correctly,' => 'Se ele n�o for exibido corretamente,',
        'This is a' => 'Este � um',
        'to open it in a new window.' => 'para abri-lo em uma nova janela.',
        'This is a HTML email. Click here to show it.' => 'Este e-mail est� em formato HTML. Clique aqui para exibi-lo.',
        'Free Fields' => 'Campos Livres',
        'Merge' => 'Agrupar',
        'merged' => 'agrupada',
        'closed successful' => 'fechada com �xito',
        'closed unsuccessful' => 'fechada sem �xito',
        'new' => 'nova',
        'open' => 'aberta',
        'Open' => 'Aberta',
        'closed' => 'fechada',
        'Closed' => 'Fechada',
        'removed' => 'removida',
        'pending reminder' => 'lembrete de pendente',
        'pending auto' => 'pendente autom�tico',
        'pending auto close+' => 'pendente auto fechamento+',
        'pending auto close-' => 'pendente auto fechamento-',
        'email-external' => 'email-externo',
        'email-internal' => 'email-interno',
        'note-external' => 'nota-externa',
        'note-internal' => 'nota-interna',
        'note-report' => 'nota-relat�rio',
        'phone' => 'telefone',
        'sms' => '',
        'webrequest' => 'solicita��o web',
        'lock' => 'bloqueada',
        'unlock' => 'desbloqueada',
        'very low' => 'muito baixo',
        'low' => 'baixo',
        'normal' => '',
        'high' => 'alto',
        'very high' => 'muito alto',
        '1 very low' => '1 muito baixo',
        '2 low' => '2 baixo',
        '3 normal' => '',
        '4 high' => '4 alto',
        '5 very high' => '5 muito alto',
        'Ticket "%s" created!' => 'Solicita��o "%s" criada!',
        'Ticket Number' => 'N�mero da Solicita��o',
        'Ticket Object' => 'Objeto da Solicita��o',
        'No such Ticket Number "%s"! Can\'t link it!' => 'N�o existe a solicita��o "%s"! N�o foi poss�vel associ�-la!',
        'Don\'t show closed Tickets' => 'N�o mostrar solicita��es fechadas',
        'Show closed Tickets' => 'Mostrar solicita��es fechadas',
        'New Article' => 'Novo Artigo',
        'Email-Ticket' => 'Solicita��o E-mail',
        'Create new Email Ticket' => 'Criar nova Solicita��o E-mail',
        'Phone-Ticket' => 'Solicita��o Fone',
        'Search Tickets' => 'Pesquisar Solicita��es',
        'Edit Customer Users' => 'Editar Clientes (Usu�rios)',
        'Edit Customer Company' => '',
        'Bulk Action' => 'Executar A��o',
        'Bulk Actions on Tickets' => 'A��es em massa em solicita��es',
        'Send Email and create a new Ticket' => 'Enviar e-mail e criar nova solicita��o',
        'Create new Email Ticket and send this out (Outbound)' => 'Criar nova solicita��o e-mail e envi�-la (sa�da)',
        'Create new Phone Ticket (Inbound)' => 'Criar nova solicita��o fone (entrada)',
        'Overview of all open Tickets' => 'Vis�o geral de todas as solicita��es abertas',
        'Locked Tickets' => 'Solicita��es Bloqueadas',
        'Watched Tickets' => 'Solicita��es Monitoradas',
        'Watched' => 'Monitorados',
        'Subscribe' => 'Monitorar',
        'Unsubscribe' => 'Desmonitorar',
        'Lock it to work on it!' => 'Bloquear para trabalhar com a solicita��o!',
        'Unlock to give it back to the queue!' => 'Desbloqueie para envi�-lo devolta � fila!',
        'Shows the ticket history!' => 'Apresentar hist�rico de solicita��es',
        'Print this ticket!' => 'Imprimir esta solicita��o!',
        'Change the ticket priority!' => 'Alterar a prioridade da solicita��o!',
        'Change the ticket free fields!' => 'Alterar os campos em branco na solicita��o!',
        'Link this ticket to an other objects!' => 'Associar esta solicita��o com outros objetos!',
        'Change the ticket owner!' => 'Alterar o propriet�rio da solicita��o!',
        'Change the ticket customer!' => 'Alterar o cliente da solicita��o',
        'Add a note to this ticket!' => 'Adicionar um nota a esta solicita��o!',
        'Merge this ticket!' => 'Agrupar esta solicita��o!',
        'Set this ticket to pending!' => 'Marcar esta solicita��o como pendente!',
        'Close this ticket!' => 'Fechar esta solicita��o!',
        'Look into a ticket!' => 'Examinar em detalhes o conte�do de uma solicita��o!',
        'Delete this ticket!' => 'Apagar esta solicita��o!',
        'Mark as Spam!' => 'Marque como Spam',
        'My Queues' => 'Minhas Filas',
        'Shown Tickets' => 'Mostrar Solicita��es',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'A sua mensagem com a solicita��o n�mero "<OTRS_TICKET>" foi agrupada com a solicita��o n�mero "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Solicita��o %s: primeiro tempo de solu��o est� ultrapassado (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Solicita��o %s: primeiro tempo de solu��o expirar� em %s!',
        'Ticket %s: update time is over (%s)!' => 'Solicita��o %s: tempo de atualiza��o est� ultrapassado (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Solicita��o %s: tempo de atualiza��o expirar� em %s!',
        'Ticket %s: solution time is over (%s)!' => 'Solicita��o %s: tempo de solu��o est� ultrapassado (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Solicita��o %s: tempo de solu��o expirar� em %s!',
        'There are more escalated tickets!' => 'H� mais solicita��es escaladas!',
        'New ticket notification' => 'Notifica��o de nova solicita��o',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Envie-me uma notifica��o se h� um nova solicita��o em "Minhas Filas".',
        'Follow up notification' => 'Notifica��o de continua��o',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' => 'Notifique-me se um cliente enviar uma continua��o e sou o propriet�rio da solicita��o.',
        'Ticket lock timeout notification' => 'Notifica��o de bloqueio por tempo expirado',
        'Send me a notification if a ticket is unlocked by the system.' => 'Notifique-me se uma solicita��o � desbloqueada pelo sistema.',
        'Move notification' => 'Notifica��o de movimentos',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Notifique-me se Solicita��es forem movimentadas para "Minhas Filas"',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Suas filas favoritas. Voc� tamb�m ser� notificado sobre estas filas via e-mail se habilitado.',
        'Custom Queue' => 'Fila Personalizada',
        'QueueView refresh time' => 'Tempo de atualiza��o das Filas',
        'Screen after new ticket' => 'Tela ap�s nova solicita��o',
        'Select your screen after creating a new ticket.' => 'Selecione a tela seguinte ap�s a cria��o de uma nova solicita��o.',
        'Closed Tickets' => 'Solicita��es Fechadas',
        'Show closed tickets.' => 'Apresentar solicita��es fechadas.',
        'Max. shown Tickets a page in QueueView.' => 'N� m�ximo de solicita��es apresentadas por p�gina.',
        'Watch notification' => 'Notifica��o de Monitoramento',
        'Send me a notification of an watched ticket like an owner of an ticket.' => 'Envie-me uma notifica��o de uma solicita��o monitorada como no caso de um propriet�rio de solicita��o.',
        'Out Of Office' => 'Aus�ncia do Escrit�rio',
        'Select your out of office time.' => 'Selecione seu hor�rio de aus�ncia do escrit�rio (f�rias, licen�as etc.).',
        'CompanyTickets' => 'Solicita��es da Empresa',
        'MyTickets' => 'Minhas Solicita��es',
        'New Ticket' => 'Nova Solicita��o',
        'Create new Ticket' => 'Criar nova Solicita��o',
        'Customer called' => 'O Cliente Telefonou',
        'phone call' => 'Chamada Telef�nica',
        'Reminder Reached' => 'Lembrete Expirado',
        'Reminder Tickets' => 'Solicita��es com Lembrete',
        'Escalated Tickets' => 'Solicita��es Escaladas',
        'New Tickets' => 'Solicita��es Novas',
        'Open Tickets / Need to be answered' => 'Solicita��es Abertas / Precisam ser respondidas',
        'Tickets which need to be answered!' => 'Solicita��es que precisam ser respondidas!',
        'All new tickets!' => 'Todas as novas solicita��es!',
        'All tickets which are escalated!' => 'Todas as olicita��es que foram escaladas!',
        'All tickets where the reminder date has reached!' => 'Todas as olicita��es cujos prazos de lembrete expiraram!',
        'Responses' => 'Respostas',
        'Responses <-> Queue' => 'Respostas <-> Fila',
        'Auto Responses' => 'Auto respostas',
        'Auto Responses <-> Queue' => 'Auto respostas <-> Fila',
        'Attachments <-> Responses' => 'Anexos <-> respostas',
        'History::Move' => 'Solicita��o foi movida para a Fila "%s" (%s) vinda da Fila "%s" (%s).',
        'History::TypeUpdate' => 'Updated Type to %s (ID=%s).',
        'History::ServiceUpdate' => 'Updated Service to %s (ID=%s).',
        'History::SLAUpdate' => 'Updated SLA to %s (ID=%s).',
        'History::NewTicket' => 'Nova Solicita��o [%s] foi criada (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Acompanhado por [%s]. %s',
        'History::SendAutoReject' => 'Rejei��o autom�tica enviada para "%s".',
        'History::SendAutoReply' => 'Auto Resposta enviada para "%s".',
        'History::SendAutoFollowUp' => 'AutoFollowUp sent to "%s".',
        'History::Forward' => 'Encaminhado para "%s".',
        'History::Bounce' => 'Devolvido a "%s".',
        'History::SendAnswer' => 'Email enviado para "%s".',
        'History::SendAgentNotification' => '"%s"-notifica��o enviada para "%s".',
        'History::SendCustomerNotification' => 'Notifica��o enviada para "%s".',
        'History::EmailAgent' => 'E-mail enviado para Cliente.',
        'History::EmailCustomer' => 'E-mail adicionado. %s',
        'History::PhoneCallAgent' => 'Atendente telefonou para cliente.',
        'History::PhoneCallCustomer' => 'Cliente telefonou para a equipe de suporte.',
        'History::AddNote' => 'Nota adicionada (%s)',
        'History::Lock' => 'Solicita��o Bloqueada.',
        'History::Unlock' => 'Solicita��o Desbloqueada.',
        'History::TimeAccounting' => '%s time unit(s) accounted. Now total %s time unit(s).',
        'Change the ticket responsible!' => 'Alterar o respons�vel pela solicita��o!',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Atualizado: %s',
        'History::PriorityUpdate' => 'Prioridade atualizada por "%s" (%s) to "%s" (%s).',
        'History::OwnerUpdate' => 'Novo propriet�rio � "%s" (ID=%s).',
        'History::LoopProtection' => 'Prote��o de Loop! Auto resposta enviada para "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Atualizado: %s',
        'History::StateUpdate' => 'Anterior: "%s" Novo: "%s"',
        'History::TicketFreeTextUpdate' => 'Atualizado: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Requisi��o do Cliente via web.',
        'History::TicketLinkAdd' => 'Adicionados associa��es � solicita��o "%s".',
        'History::TicketLinkDelete' => 'Associa��es da solicita��o Exclu�dos "%s".',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',

        # Template: AAAWeekDay
        'Sun' => 'Dom',
        'Mon' => 'Seg',
        'Tue' => 'Ter',
        'Wed' => 'Qua',
        'Thu' => 'Qui',
        'Fri' => 'Sex',
        'Sat' => 'Sab',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Gerenciamento de Anexos',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Administra��o de Auto-Respostas',
        'Response' => 'Resposta',
        'Auto Response From' => 'Auto-Resposta De',
        'Note' => 'Nota',
        'Useable options' => 'Op��es dispon�veis',
        'To get the first 20 character of the subject.' => 'Para buscar os primeiros 20 caracteres do assunto.',
        'To get the first 5 lines of the email.' => 'Para buscar as primeiras 5 linhas do e-mail.',
        'To get the realname of the sender (if given).' => 'Para buscar o nome real do remetente (se fornecido).',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Para buscar o atributo do artigo (ex.: (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Op��es de informa��es do usu�rio cliente (ex.: <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Op��es do propriet�rio do Chamado (ex.: <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Op��es do respons�vel pelo Chamado (ex.: <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Op��es do usu�rio atual que requisitou esta a��o (ex.: <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Op��es de informa��o do Chamado (ex.: <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Op��es de Configura��o (ex.: <OTRS_CONFIG_HttpType>).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Gerenciamento de Empresa de Clientes',
        'Search for' => 'Pesquisar por',
        'Add Customer Company' => 'Adicionar Empresa de Clientes',
        'Add a new Customer Company.' => 'Adicionar uma nova Empresa de Clientes.',
        'List' => 'Lista',
        'This values are required.' => 'Estes valores s�o obrigat�rios.',
        'This values are read only.' => 'Estes valores s�o apenas para leitura.',

        # Template: AdminCustomerUserForm
        'Title{CustomerUser}' => '',
        'Firstname{CustomerUser}' => '',
        'Lastname{CustomerUser}' => '',
        'Username{CustomerUser}' => '',
        'Email{CustomerUser}' => '',
        'CustomerID{CustomerUser}' => '',
        'Phone{CustomerUser}' => '',
        'Fax{CustomerUser}' => '',
        'Mobile{CustomerUser}' => '',
        'Street{CustomerUser}' => '',
        'Zip{CustomerUser}' => '',
        'City{CustomerUser}' => '',
        'Country{CustomerUser}' => '',
        'Comment{CustomerUser}' => '',
        'The message being composed has been closed.  Exiting.' => 'A mensagem sendo composta foi fechada. Saindo.',
        'This window must be called from compose window' => 'Esta janela deve ser chamada da janela de composi��o',
        'Customer User Management' => 'Administra��o de Clientes',
        'Add Customer User' => 'Adicionar Cliente',
        'Source' => 'Origem',
        'Create' => 'Criar',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'O usu�rio do cliente ser� necess�rio para que exista um hist�rico do cliente e para login na �rea de clientes.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Clientes <-> Admin Grupos',
        'Change %s settings' => 'Modificar %s configura��es',
        'Select the user:group permissions.' => 'Selecionar as permiss�es de  usu�rio:grupo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Se nada estiver selecionado, ent�o n�o h� nenhuma permiss�o neste grupo (as solicita��es n�o estar�o dispon�veis para o usu�rio).',
        'Permission' => 'Permiss�es',
        'ro' => 'somente leitura',
        'Read only access to the ticket in this group/queue.' => 'Acesso Somente com Leitura de solicita��es neste grupo/fila',
        'rw' => 'leitura e escrita',
        'Full read and write access to the tickets in this group/queue.' => 'Acesso leitura e escrita de solicita��es neste grupo/fila',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Clientes <-> Gerenciamento de Servi�os',
        'CustomerUser' => 'Usu�rio Cliente',
        'Service' => 'Servi�o',
        'Edit default services.' => 'Editar servi�os padr�o',
        'Search Result' => 'Resultado da Busca',
        'Allocate services to CustomerUser' => 'Alocar servi�os a usu�rio cliente',
        'Active' => 'Ativo',
        'Allocate CustomerUser to service' => 'Alocar usu�rio cliente a servi�o',

        # Template: AdminEmail
        'Message sent to' => 'Mensagem enviada para',
        'A message should have a subject!' => 'Uma mensagem deve conter um assunto!',
        'Recipients' => 'Destinat�rios',
        'Body' => 'Corpo',
        'Send' => 'Enviar',

        # Template: AdminGenericAgent
        'GenericAgent' => 'Atendente Gen�rico',
        'Job-List' => 'Lista de jobs',
        'Last run' => '�ltima execu��o',
        'Run Now!' => 'Executar Agora',
        'x' => '',
        'Save Job as?' => 'Salvar trabalho como?',
        'Is Job Valid?' => 'O trabalho � v�lido?',
        'Is Job Valid' => 'O trabalho � v�lido.',
        'Schedule' => 'Agenda',
        'Currently this generic agent job will not run automatically.' => '',
        'To enable automatic execution select at least one value from minutes, hours and days!' => '',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Busca por texto completo no Artigo (ex.: "Mar*in" or "Baue*")',
        '(e. g. 10*5155 or 105658*)' => '(ex.: 10*5155 or 105658*)',
        '(e. g. 234321)' => '(ex.: 234321)',
        'Customer User Login' => 'Cliente Login',
        '(e. g. U5150)' => '(ex.: U5150)',
        'SLA' => '',
        'Agent' => 'Atendente',
        'Ticket Lock' => 'Solicita��o bloqueada',
        'TicketFreeFields' => 'Campos livres da solicita��o',
        'Create Times' => 'Hor�rios de Cria��o',
        'No create time settings.' => 'Ignorar hor�rios de cria��o',
        'Ticket created' => 'Solicita��o criada',
        'Ticket created between' => 'Solicita��o criada entre',
        'Close Times' => 'Hor�rios de Fechamento',
        'No close time settings.' => 'Ignorar hor�rios de fechamento',
        'Ticket closed' => 'Solicita��o fechada',
        'Ticket closed between' => 'Solicita��o fechada entre',
        'Pending Times' => 'Hor�rios Pendentes',
        'No pending time settings.' => 'Ignorar hor�rios pendentes',
        'Ticket pending time reached' => 'Prazo de Solicita��o pendentes expirado',
        'Ticket pending time reached between' => 'Prazo de Solicita��o pendentes expirado entre',
        'Escalation Times' => 'Prazo de Escala��o',
        'No escalation time settings.' => 'Ignorar prazos de escala��o',
        'Ticket escalation time reached' => 'Prazos de escala��es expirado',
        'Ticket escalation time reached between' => 'Prazos de escala��o expirado entre',
        'Escalation - First Response Time' => 'Escala��o - Prazo da Primeira Resposta',
        'Ticket first response time reached' => 'Prazo de primeira resposta expirado',
        'Ticket first response time reached between' => 'Prazo de primeira resposta expirado entre',
        'Escalation - Update Time' => 'Escala��o - Prazo de Atualiza��o',
        'Ticket update time reached' => 'Prazo de atualiza��o expirado',
        'Ticket update time reached between' => 'Prazo de atualiza��o expirado entre',
        'Escalation - Solution Time' => 'Escala��o - Prazo de Solu��o',
        'Ticket solution time reached' => 'Prazo de solu��o expirado',
        'Ticket solution time reached between' => 'Prazo de solu��o expirado entre',
        'New Service' => 'Novo Servi�o',
        'New SLA' => 'Novo SLA',
        'New Priority' => 'Nova Prioridade',
        'New Queue' => 'Nova Fila',
        'New State' => 'Novo Estado',
        'New Agent' => 'Novo Atendente',
        'New Owner' => 'Novo Propriet�rio',
        'New Customer' => 'Novo Cliente',
        'New Ticket Lock' => 'Solicita��o nova bloqueada',
        'New Type' => 'Novo Tipo',
        'New Title' => 'Novo T�tulo',
        'New TicketFreeFields' => 'Novos campos livres da solicita��o',
        'Add Note' => 'Adicionar Nota',
        'Time units' => 'Unidades de tempo',
        'CMD' => 'Comando',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Este comando ser� executado. ARG[0] ser� o n�mero da solicita��o. ARG[1] o id da solicita��o.',
        'Delete tickets' => 'Excluir Solicita��es',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Alerta! Esta solicita��o ser� removida da base de dados! Esta solicita��o esr� perdida permanentemente!',
        'Send Notification' => 'Enviar Notifica��o',
        'Param 1' => 'Par�metro 1',
        'Param 2' => 'Par�metro 2',
        'Param 3' => 'Par�metro 3',
        'Param 4' => 'Par�matro 4',
        'Param 5' => 'Par�metro 5',
        'Param 6' => 'Par�metro 6',
        'Send agent/customer notifications on changes' => 'Enviar notifica��es de altera��es para agente/cliente',
        'Save' => 'Salvar',
        '%s Tickets affected! Do you really want to use this job?' => '%s Solicita��es afetadas! Voc� quer realmente utilizar este processo?',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => '',
        'Group Management' => 'Administra��o de Grupos',
        'Add Group' => 'Adicionar grupo',
        'Add a new Group.' => 'Adicionar um novo grupo',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'O grupo admin � para uso na �rea de administra��o e o grupo stats � para uso na �rea de estat�sticas.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Crie novos grupos para manipular as permiss�es de acesso para diferentes grupos de agentes (exemplos: departamento de compras, departamento de suporte, departamento de vendas, etc...).',
        'It\'s useful for ASP solutions.' => 'Isto � �til para solu��es ASP.',

        # Template: AdminLog
        'System Log' => 'Registro do Sistema',
        'Time' => 'Hora',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Gerenciamento de Contas de E-Mail',
        'Host' => 'Servidor',
        'Trusted' => 'Confi�vel',
        'Dispatching' => 'Despachando',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Todos os emails de entrada com uma conta ser� despachado na fila selecionada!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Se a sua conta for confi�vel, os headers "X-OTRS" existentes na recep��o (para prioridade, ...) ser�o utilizados! O filtro ser� utilizado mesmo assim.',

        # Template: AdminNavigationBar
        'Users' => 'Usu�rios',
        'Groups' => 'Grupos',
        'Misc' => 'Variedades',

        # Template: AdminNotificationEventForm
        'Notification Management' => 'Admin de Notifica��es',
        'Add Notification' => 'Adicionar Notifica��o',
        'Add a new Notification.' => 'Adicionar uma nova Notifica��o',
        'Name is required!' => 'O Nome � requerido',
        'Event is required!' => 'Evento � obrigat�rio!',
        'A message should have a body!' => 'A mensagem deve conter um texto!',
        'Recipient' => 'Destinat�rio',
        'Group based' => 'Baseado em Grupo',
        'Agent based' => 'Baseado em Agente',
        'Email based' => 'Baseado em E-Mail',
        'Article Type' => 'Tipo do Artigo',
        'Only for ArticleCreate Event.' => 'Somente para Eventos de Cria��o de Artigo.',
        'Subject match' => 'Casar Assunto',
        'Body match' => 'Casar Corpo',
        'Notifications are sent to an agent or a customer.' => 'Notifica��es ser�o enviadas para um Atedente ou Cliente.',
        'To get the first 20 character of the subject (of the latest agent article).' => 'Para buscar os primeiros 20 caracteres do assunto (do �ltimo artigo do agente)',
        'To get the first 5 lines of the body (of the latest agent article).' => 'Para buscar as primeiras 5 linhas do corpo (do �ltimo artigo do atendente)',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => 'Para buscar o atributo do artigo (ex.: (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).',
        'To get the first 20 character of the subject (of the latest customer article).' => 'Para buscar os primeiros 20 caracteres do assunto (do �ltimo artigo do cliente)',
        'To get the first 5 lines of the body (of the latest customer article).' => 'Para buscar as primeiras 5 linhas do corpo (do �ltimo artigo do cliente)',

        # Template: AdminNotificationForm
        'Notification' => 'Notifica��es',

        # Template: AdminPackageManager
        'Package Manager' => 'Gerenciador de Pacotes',
        'Uninstall' => 'Desinstalar',
        'Version' => 'Vers�o',
        'Do you really want to uninstall this package?' => 'Voc� quer realmente desinstalar este pacote?',
        'Reinstall' => 'Reinstalar',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Voc� quer realmente reinstalar este pacote?',
        'Continue' => 'Continuar',
        'Install' => 'Instalar',
        'Package' => 'Pacotes',
        'Online Repository' => 'Reposit�rio Online',
        'Vendor' => 'Fornecedor',
        'Module documentation' => 'Documenta��o do M�dulo',
        'Upgrade' => 'Atualizar Vers�o',
        'Local Repository' => 'Reposit�rio Local',
        'Status' => 'Estado',
        'Overview' => 'Vis�o Geral',
        'Download' => '',
        'Rebuild' => 'Reconstruir',
        'ChangeLog' => '',
        'Date' => 'Data',
        'Filelist' => 'Lista de arquivos',
        'Download file from package!' => 'Baixar arquivo do pacote!',
        'Required' => 'Requerido',
        'PrimaryKey' => 'Chave Prim�ria',
        'AutoIncrement' => 'Autoincremento',
        'SQL' => '',
        'Diff' => '',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log de Performance',
        'This feature is enabled!' => 'Esta funcionalidade foi habilitada!',
        'Just use this feature if you want to log each request.' => 'Use esta funcionalidade se voc� quiser logar cada requisi��o.',
        'Activating this feature might affect your system performance!' => 'Ao ativar esta funcionalidade pode-se afetar o desempenho do seu sistema!',
        'Disable it here!' => 'Desabilite-o aqui!',
        'This feature is disabled!' => 'Esta funcionalidade foi desabilitada!',
        'Enable it here!' => 'Habilite-o aqui!',
        'Logfile too large!' => 'Arquivo de log muito grande!',
        'Logfile too large, you need to reset it!' => 'Arquivo de log muito grande, voc� deve reinici�-lo!',
        'Range' => 'Intervalo',
        'Interface' => 'Interface',
        'Requests' => 'Requisi��es',
        'Min Response' => 'Tempo m�nimo de resposta',
        'Max Response' => 'Tempo m�ximo de resposta',
        'Average Response' => 'M�dia de tempo de resposta',
        'Period' => 'Per�odo',
        'Min' => 'M�n.',
        'Max' => 'M�x.',
        'Average' => 'M�dia',

        # Template: AdminPGPForm
        'PGP Management' => 'Gerenciamento do PGP',
        'Result' => 'Resultado',
        'Identifier' => 'Identificador',
        'Bit' => '',
        'Key' => 'Chave',
        'Fingerprint' => 'Impress�o Digital',
        'Expires' => 'Expira',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'Neste caso, voc� pode editar diretamente o "keyring" configurado no "SysConfig".',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Gerenciamento de Filtros (Postmaster)',
        'Filtername' => 'Nome do Filtro',
        'Stop after match' => 'Parar ap�s encontrar',
        'Match' => 'Busca',
        'Value' => 'Valor',
        'Set' => 'Configurar',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Para despachar ou filtrar os e-mails entrantes baseados em "X-Headers". Express�es regularos tamb�m podem ser utilizadas.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Se voc� quiser casar somente o endere�o de e-mail, use EMAILADDRESS:info@example.com em From, To or Cc.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Se utilizar express�es regulares, voc� pode usar o valor encontrado no () como [***] em \'Set\'.',

        # Template: AdminPriority
        'Priority Management' => 'Gerenciamento de Prioridade',
        'Add Priority' => 'Adicionar Prioridade',
        'Add a new Priority.' => 'Adicionar nova Prioridade',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Fila <-> Gerenciamento de Auto Respostas',
        'settings' => 'configura��es',

        # Template: AdminQueueForm
        'Queue Management' => 'Gerenciamento de Filas',
        'Sub-Queue of' => 'Subfila de',
        'Unlock timeout' => 'Tempo de expira��o de desbloqueio',
        '0 = no unlock' => '0 = sem desbloqueio',
        'Only business hours are counted.' => 'Apenas horas �teis s�o contadas.',
        '0 = no escalation' => '0 = sem escala��o',
        'Notify by' => 'Notificar por',
        'Follow up Option' => 'Op��o de continua��o',
        'Ticket lock after a follow up' => 'Bloqueio da solicita��o ap�s as continua��es',
        'Systemaddress' => 'Endere�o do Sistema',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Se um atendente bloquear uma solicita��o e ele n�o enviar uma resposta dentro deste tempo, a solicita��o ser� desbloqueada automaticamente. Ent�o a solicita��o ser� vis�vel para todos os atendentes.',
        'Escalation time' => 'Tempo de escala��o',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Se uma solicita��o n�o for respondida neste prazo, apenas esta solicita��o ser� exibida.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Se uma solicita��o est� fechada e um cliente envia uma continua��o, esta mesma solicita��o ser� bloqueada para o antigo propriet�rio.',
        'Will be the sender address of this queue for email answers.' => 'Ser� o endere�o de email de respostas desta fila.',
        'The salutation for email answers.' => 'A sauda��o para as respostas de emails.',
        'The signature for email answers.' => 'A assinatura para as respostas de emails.',
        'Customer Move Notify' => 'Cliente Notificar Altera��o',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'O OTRS envia uma notifica��o por e-mail ao cliente, caso a solicita��o seja movida.',
        'Customer State Notify' => 'Notificar Status do Cliente',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'O OTRS envia uma notifica��o por e-mail ao cliente, caso o status da solicita��o seja alterado.',
        'Customer Owner Notify' => 'Cliente Notificar Propriet�rio',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'O OTRS envia uma notifica��o por e-mail ao cliente, caso o dono da solicita��o seja alterado.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Respostas <-> Gerenciamento de Filas',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Resposta',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Respostas <-> Gerenciamento de Anexos',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Gerenciamento de Respostas',
        'A response is default text to write faster answer (with default text) to customers.' => 'Uma resposta padr�o � um texto para responder mais rapidamente aos clientes.',
        'Don\'t forget to add a new response a queue!' => 'N�o se esque�a de adicionar a nova resposta a uma fila!',
        'The current ticket state is' => 'O estado da solicita��o � ',
        'Your email address is new' => 'Seu e-mail � novo',

        # Template: AdminRoleForm
        'Role Management' => 'Gerenciamento de Pap�is',
        'Add Role' => 'Adicionar Papel',
        'Add a new Role.' => 'Adicionar um novo papel',
        'Create a role and put groups in it. Then add the role to the users.' => 'Crie um papel e relacione grupos a ele. Ent�o adicione regras aos usu�rios. ',
        'It\'s useful for a lot of users and groups.' => 'Isto � muito �til para uma grande quantidade de usu�rios e grupos.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Pap�is <-> Gerenciamento de Grupos',
        'move_into' => 'mover_para',
        'Permissions to move tickets into this group/queue.' => 'Permiss�es para movimento de Solicita��es neste grupo/fila.',
        'create' => 'criar',
        'Permissions to create tickets in this group/queue.' => 'Permiss�es para criar solicita��es neste grupo/fila. ',
        'owner' => 'propriet�rio',
        'Permissions to change the ticket owner in this group/queue.' => 'Permiss�es para alterar a solicita��o neste grupo/fila.  ',
        'priority' => 'prioridade',
        'Permissions to change the ticket priority in this group/queue.' => 'Permiss�es para alterar o propriet�rio neste grupo/fila.',

        # Template: AdminRoleGroupForm
        'Role' => 'Papel',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Papel <-> Gerenciamento de Usu�rios',
        'Select the role:user relations.' => 'Selecione a rela��o entre o papel/usu�rio.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Gerenciamento de Tratamento (Sr./Sra.)',
        'Add Salutation' => 'Adicionar Tratamento',
        'Add a new Salutation.' => 'Adicionar um novo Tratamento',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => 'Modo de Seguran�a deve ser ativado!',
        'Secure mode will (normally) be set after the initial installation is completed.' => 'Modo de Seguran�a ser� (normalmente) ativado ap�s a instala��o inicial.',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => 'Modo de Seguran�a deve estar desabilitado para reinstalar utilizando o instalador web.',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => 'Se o Modo de Seguran�a n�o estiver ativado, ative-o atrav�s do SysConfig, porque sua aplica��o j� est� rodando.',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'Comandos SQL',
        'Go' => 'Executar',
        'Select Box Result' => 'Selecione a Caixa de Resultado',

        # Template: AdminService
        'Service Management' => 'Gerenciamento de Servi�os',
        'Add Service' => 'Adicionar Servi�o',
        'Add a new Service.' => 'Adicionar um novo Servi�o',
        'Sub-Service of' => 'Subservi�o de',

        # Template: AdminSession
        'Session Management' => 'Gerenciamento de Sess�es',
        'Sessions' => 'Sess�es',
        'Uniq' => '�nico',
        'Kill all sessions' => 'Finalizar todas as sess�es',
        'Session' => 'Sess�o',
        'Content' => 'Conte�do',
        'kill session' => 'Finalizar sess�o',

        # Template: AdminSignatureForm
        'Signature Management' => 'Gerenciamento de Assinaturas',
        'Add Signature' => 'Adicionar Assinatura',
        'Add a new Signature.' => 'Adicionar uma nova Assinatura',

        # Template: AdminSLA
        'SLA Management' => 'Gerenciamento de SLA',
        'Add SLA' => 'Adicionar SLA',
        'Add a new SLA.' => 'Adicionar um novo SLA',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'Gerenciamento S/MIME',
        'Add Certificate' => 'Adicionar Certificado',
        'Add Private Key' => 'Adicionar Chave Privada',
        'Secret' => 'Senha',
        'Hash' => '',
        'In this way you can directly edit the certification and private keys in file system.' => 'Neste caso, voc� pode editar diretamente a certifica��o e chaves privadas no sistema de arquivos.',

        # Template: AdminStateForm
        'State Management' => 'Gerenciamento de Estado',
        'Add State' => 'Adicionar Estado',
        'Add a new State.' => 'Adicionar um novo Estado',
        'State Type' => 'Tipo de Estado',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Tenha cuidado se voc� tamb�m atualizou os estados padr�o no Kernel/Config.pm!',
        'See also' => 'Veja tamb�m',

        # Template: AdminSysConfig
        'SysConfig' => 'Configura��o do Sistema',
        'Group selection' => 'Sele��o de Grupo',
        'Show' => 'Visualizar',
        'Download Settings' => 'Baixar Configura��es',
        'Download all system config changes.' => 'Baixar todas as configura��es do sistema que foram alteradas.',
        'Load Settings' => 'Carregar Configura��es',
        'Subgroup' => 'Subgrupo',
        'Elements' => 'Elementos',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Op��es de Configura��o',
        'Default' => 'Padr�o',
        'New' => 'Novo',
        'New Group' => 'Novo Grupo',
        'Group Ro' => 'Grupo Somente Leitura',
        'New Group Ro' => 'Novo Grupo Somente Leitura',
        'NavBarName' => 'Nome da Barra de Navega��o',
        'NavBar' => 'Barra de Navega��o',
        'Image' => 'Imagem',
        'Prio' => 'Prioridade',
        'Block' => 'Bloquear',
        'AccessKey' => 'Chave de Acesso',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Gerenciamento dos Endere�os de E-mail do Sistema',
        'Add System Address' => 'Adicionar Endere�os do Sistema',
        'Add a new System Address.' => 'Adicionar um novo endere�o de sistema.',
        'Realname' => 'Nome real',
        'All email addresses get excluded on replaying on composing an email.' => '',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Todos os emails entrantes com este Email(To:) ser�o despachados na fila selecionada!',

        # Template: AdminTypeForm
        'Type Management' => 'Gerenciamento de Tipo',
        'Add Type' => 'Adicionar Tipo',
        'Add a new Type.' => 'Adicionar um novo Tipo',

        # Template: AdminUserForm
        'User Management' => 'Gerenciamento de Usu�rios',
        'Add User' => 'Adicionar Usu�rio',
        'Add a new Agent.' => 'Adicionar um novo Atendente',
        'Login as' => 'Logar-se como',
        'Firstname' => 'Nome',
        'Lastname' => 'Sobrenome',
        'Start' => 'In�cio',
        'End' => 'Fim',
        'User will be needed to handle tickets.' => 'Ser� necess�rio um usu�rio para manipular as solicita��es.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'N�o se esque�a de adicionar o novo usu�rio em grupos e/ou pap�is!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Usu�rios <-> Gerenciamento de Grupos',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Cat�logo de Endere�os',
        'Return to the compose screen' => 'Retornar para a tela de composi��o',
        'Discard all changes and return to the compose screen' => 'Descartar todas as modifica��es e retornar para a tela de composi��o',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerSearch

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Agent Dashboard' => 'Dashboard do Atendente',

        # Template: AgentDashboardCalendarOverview
        'in' => 'em',

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s est� dispon�vel!',
        'Please update now.' => 'Por favor atualize agora.',
        'Release Note' => 'Notas da Vers�o',
        'Level' => 'N�vel',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Postado h� %s atr�s.',

        # Template: AgentDashboardTicketOverview

        # Template: AgentDashboardTicketStats

        # Template: AgentInfo
        'Info' => 'Informa��o',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Objeto associado: %s',
        'Object' => 'Objeto',
        'Link Object' => 'Associar Objeto',
        'with' => 'com',
        'Select' => 'Selecionar',
        'Unlink Object: %s' => 'Desassociar Objeto',

        # Template: AgentLookup
        'Lookup' => 'Buscar',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Checar a Ortografia',
        'spelling error(s)' => 'erro(s) ortogr�ficos',
        'or' => 'ou',
        'Apply these changes' => 'Aplicar estas modifica��es',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Voc� quer realmente remover este objeto?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Selecione as restri��es para caracterizar o status',
        'Fixed' => 'Fixado',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Por favor, selecione apenas um elemento ou desmarque o bot�o \'Fixado\'.',
        'Absolut Period' => 'Per�odo Absoluto',
        'Between' => 'Entre',
        'Relative Period' => 'Per�odo Relativo',
        'The last' => 'O �ltimo',
        'Finish' => 'Finalizar',
        'Here you can make restrictions to your stat.' => 'Aqui voc� pode criar as restri��es do seu status',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Se voc� remover a sele��o da caixa \'Fixado\', o atendente que gerar a estat�stica pode alterar os atributos do elemento correspondente.',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Inser��o das especifica��es comuns',
        'Permissions' => 'Permiss�es',
        'Format' => 'Formato',
        'Graphsize' => 'Tamanho do Gr�fico',
        'Sum rows' => 'Somar linhas',
        'Sum columns' => 'Somar colunas',
        'Cache' => '',
        'Required Field' => 'Campo Requerido',
        'Selection needed' => '� necess�ria a sele��o',
        'Explanation' => 'Explana��o',
        'In this form you can select the basic specifications.' => 'Neste formul�rio voc� pode selecionar as especifica��es b�sicas.',
        'Attribute' => 'Atributo',
        'Title of the stat.' => 'T�tulo da estat�stica.',
        'Here you can insert a description of the stat.' => 'Aqui voc� pode inserir uma descri��o da estat�stica.',
        'Dynamic-Object' => 'Objeto-Din�mico',
        'Here you can select the dynamic object you want to use.' => 'Aqui voc� pode selecionar o objeto din�mico que voc� quer usar.',
        '(Note: It depends on your installation how many dynamic objects you can use)' => 'A quantidade de objetos din�micos depende da sua instala��o',
        'Static-File' => 'Arquivo-Est�tico',
        'For very complex stats it is possible to include a hardcoded file.' => 'Para estat�sticas muito complexas � poss�vel incluir um c�digo fonte.',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Se um novo c�digo estiver dispon�vel ele pode ser� exibido e voc� poder� escolh�-lo. ',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Configura��es de permiss�o. Voc� pode selecionar um ou mais grupos para que as estat�sticas configuradas sejam exibidas para agentes diferentes.',
        'Multiple selection of the output format.' => 'M�ltiplas escolhas de formato de sa�da.',
        'If you use a graph as output format you have to select at least one graph size.' => 'Se voc� utiliza um gr�fico como formato de sa�da, voc� deve selecionar ao menos um tamanho de gr�fico.',
        'If you need the sum of every row select yes' => 'Se voc� necessita da soma de todos as linhas selecione SIM',
        'If you need the sum of every column select yes.' => 'Se voc� necessita da soma de todas as colunas seleciona SIM',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'A maioria das estat�sticas podem ser mantidas em cache. Isto tornar� sua visualiza��o mais r�pida.',
        '(Note: Useful for big databases and low performance server)' => '(Nota: �til para base de dados grandes e servidores de baixa performance)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Com uma estat�stica no estado de inv�lida n�o � poss�vel ger�-la.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'Isso � �til se voc� n�o quer que ningu�m obtenha o resultado da estat�stica ou a estat�stica n�o est� configurada totalmente.',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Selecione os elementos para cada conjunto de valores',
        'Scale' => 'Escala',
        'minimal' => 'm�nimo',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'Lembre que a escala para o conjunto de valores deve ser mair que o eixo X (ex.: Eixo X => M�s, Conjunto de Valores => Ano).',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '� poss�vel escolher um ou dois elementos. Ent�o voc� pode selecionar os atributos dos elementos. Cada atributo ser� mostrado como um conjunto �nico de valores. Se voc� n�o selecionar nenhum atributo, todos os atributos do elemento ser�o utilizados para gerar a estat�stica. Assim como um novo atributo � adicionado desde a �ltima configura��o.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Selecione o elemento que ser� usado no eixo X',
        'maximal period' => 'per�odo m�ximo',
        'minimal scale' => 'per�odo m�nimo',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Aqui voc� pode definir o eixo-x. Voc� pode selecionar um elemento via bot�o de r�dio. Se voc� n�o fizer uma sele��o, todos os atributos do elemento ser�o usados se voc� gerar uma estat�stica. Assim como um novo atributo � adicionado desde a �ltima configura��o.',

        # Template: AgentStatsImport
        'Import' => 'Importar',
        'File is not a Stats config' => 'Este n�o � um arquivo de configura��o',
        'No File selected' => 'Nenhum arquivo selecionado',

        # Template: AgentStatsOverview
        'Results' => 'Resultados',
        'Total hits' => 'Total de acertos',
        'Page' => 'P�gina',

        # Template: AgentStatsPrint
        'Print' => 'Imprimir',
        'No Element selected.' => 'Nenhum elemento selecionado.',

        # Template: AgentStatsView
        'Export Config' => 'Exportar Configura��o',
        'Information about the Stat' => 'Informa��es sobre a Estat�stica',
        'Exchange Axis' => 'Trocar Eixo',
        'Configurable params of static stat' => 'Par�metros configur�veis da estat�stica est�tica',
        'No element selected.' => 'Nenhum elemento selecionado.',
        'maximal period from' => 'm�ximo per�do de',
        'to' => 'para',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'Com os campos de inser��o e sele��o, voc� pode configurar a estat�stica de acordo com a sua necessidade. Os elementos da estat�stica que voc� pode editar dependem das permiss�es concedidas a voc� pelo administrador do sistema.',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => 'Uma mensagem deve possuir um To: destinat�rio!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Voc� precisa de um endere�o de email (exemplo: cliente@exemplo.com.br) no To:!',
        'Bounce ticket' => 'Devolver solicita��o',
        'Ticket locked!' => 'Solicita��o bloqueada!',
        'Ticket unlock!' => 'Solicita��o desbloqueada!',
        'Bounce to' => 'Devolver para',
        'Next ticket state' => 'Pr�ximo estado da solicita��o',
        'Inform sender' => 'Informe o remetente',
        'Send mail!' => 'Enviar email!',

        # Template: AgentTicketBulk
        'You need to account time!' => 'Voc� deve contabilizar o tempo!',
        'Ticket Bulk Action' => 'A��o em Massa em Solicita��o',
        'Spell Check' => 'Checar Ortografia',
        'Note type' => 'Tipo de nota',
        'Next state' => 'Pr�ximo estado',
        'Pending date' => 'Data de pend�ncia',
        'Merge to' => 'Agrupar com',
        'Merge to oldest' => 'Agrupar com a mais antiga',
        'Link together' => 'Associar junto',
        'Link to Parent' => 'Associar a Pai',
        'Unlock Tickets' => 'Desbloquear Solicita��es',

        # Template: AgentTicketClose
        'Ticket Type is required!' => 'Tipo de solicita��o � requerido!',
        'A required field is:' => 'Campo requerido �:',
        'Close ticket' => 'Fechar a solicita��o',
        'Previous Owner' => 'Dono Anterior',
        'Inform Agent' => 'Informar Atendente',
        'Optional' => 'Opcional',
        'Inform involved Agents' => 'Informar os atendentes envolvidos',
        'Attach' => 'Anexo',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => 'A mensagem necessita ser verificada ortograficamente!',
        'Compose answer for ticket' => 'Comp�r uma resposta para a solicita��o',
        'Pending Date' => 'Data de Pend�ncia',
        'for pending* states' => 'em estado pendente*',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Modificar o cliente da solicita��o',
        'Set customer user and customer id of a ticket' => 'Configurar usu�rio e id do cliente na solicita��o',
        'Customer User' => 'Cliente',
        'Search Customer' => 'Busca do cliente',
        'Customer Data' => 'Dados do Cliente',
        'Customer history' => 'Hist�rico do cliente',
        'All customer tickets.' => 'Todas as solicita��es do cliente',

        # Template: AgentTicketEmail
        'Compose Email' => 'Compor E-mail',
        'new ticket' => 'Nova Solicita��o',
        'Refresh' => 'Atualizar',
        'Clear To' => 'Limpar',
        'All Agents' => 'Todos os Atendentes',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => 'Tipo de artigo',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Alterar os campos em branco na solicita��o',

        # Template: AgentTicketHistory
        'History of' => 'Hist�rico de',

        # Template: AgentTicketLocked
        'My Locked Tickets' => 'Minhas solicita��es bloqueadas',

        # Template: AgentTicketMerge
        'You need to use a ticket number!' => 'Voc� deve utilizar um n�mero da solicita��o!',
        'Ticket Merge' => 'Agrupar Solicita��o',

        # Template: AgentTicketMove
        'If you want to account time, please provide Subject and Text!' => '',
        'Move Ticket' => 'Mover Solicita��o',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Adicionar nota � solicita��o',

        # Template: AgentTicketOverviewMedium
        'First Response Time' => '',
        'Service Time' => '',
        'Update Time' => '',
        'Solution Time' => '',

        # Template: AgentTicketOverviewMediumMeta
        'You need min. one selected Ticket!' => 'Voc� deve selecionar ao menos 1(uma) solicita��o!',

        # Template: AgentTicketOverviewNavBar
        'Filter' => 'Filtro',
        'Change search options' => 'Alterar as o��es de busca',
        'Tickets' => 'Solicita��es',
        'of' => 'de',

        # Template: AgentTicketOverviewNavBarSmall

        # Template: AgentTicketOverviewPreview
        'Compose Answer' => 'Compor Resposta',
        'Contact customer' => 'Contatar cliente',
        'Change queue' => 'Modificar fila',

        # Template: AgentTicketOverviewPreviewMeta

        # Template: AgentTicketOverviewSmall
        'sort upward' => 'ordem crescente',
        'up' => 'normal',
        'sort downward' => 'ordem decrescente',
        'down' => 'inversa',
        'Escalation in' => 'Escalada em',
        'Locked' => 'Bloqueio',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Modificar o propriet�rio ds solicita��o',

        # Template: AgentTicketPending
        'Set Pending' => 'Marcar Pendente',

        # Template: AgentTicketPhone
        'Phone call' => 'Chamada telef�nica',
        'Clear From' => 'Limpar',
        'Next ticket state' => 'Pr�ximo status da solicita��o',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Texto',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Dados da Solicita��o',
        'Accounted time' => 'Tempo contabilizado',
        'Linked-Object' => 'Objeto "Linkado"',
        'by' => 'por',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Modificar a prioridade da solicita��o',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Solicita��es mostradas',
        'Tickets available' => 'Solicita��es dispon�veis',
        'All tickets' => 'Todas as solicita��es',
        'Queues' => 'Filas',
        'Ticket escalation!' => 'Escala��o de solicita��es!',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Alterar o respons�vel pela solicita��o',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Busca de Solicita��o',
        'Profile' => 'Perfil',
        'Search-Template' => 'Modelo de Busca',
        'TicketFreeText' => 'Texto livre Solicita��o',
        'Created in Queue' => 'Criado na Fila',
        'Article Create Times' => 'Hor�rio da Cria��o do Artigo',
        'Article created' => 'Artigo criado',
        'Article created between' => 'Artigo criado entre',
        'Change Times' => 'Hor�rio de Altera��o',
        'No change time settings.' => 'Ignorar hor�rios de altera��o.',
        'Ticket changed' => 'Solicita��o alterada',
        'Ticket changed between' => 'Solicita��o alterada entre',
        'Result Form' => 'Resultado',
        'Save Search-Profile as Template?' => 'Salvar o Perfil de Busca como Modelo?',
        'Yes, save it with name' => 'Sim, salve-o com o nome',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => 'Texto Completo',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => 'Vis�o Expandida',
        'Collapse View' => 'Vis�o Recolhida',
        'Split' => 'Dividir',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => 'Configura��es de filtro de artigos',
        'Save filter settings as default' => 'Salvar configura��es de filtro como padr�o',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => '',

        # Template: CustomerFooter
        'Powered by' => 'Desenvolvido por',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => '',
        'Lost your password?' => 'Esqueceu sua senha?',
        'Request new password' => 'Solicitar uma nova senha',
        'Create Account' => 'Criar Conta',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Bem-vindo %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Hora',
        'No time settings.' => 'Sem configura��es de hora.',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Clique aqui para relatar um erro!',

        # Template: Footer
        'Top of Page' => 'Topo da P�gina',

        # Template: FooterSmall

        # Template: Header
        'Home' => 'In�cio',

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Instalador Web',
        'Welcome to %s' => 'Bem-vindo ao %s',
        'Accept license' => 'Aceitar licen�a',
        'Don\'t accept license' => 'N�o aceitar licen�a',
        'Admin-User' => 'Usu�rio do Administrador',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => '',
        'Admin-Password' => 'Senha do Administrador',
        'Database-User' => 'Usu�rio da Base',
        'default \'hot\'' => 'padr�o \'hot\'',
        'DB connect host' => 'Servidor da Base',
        'Database' => 'Base de Dados',
        'Default Charset' => 'Conjunto de Caracteres Padr�o',
        'utf8' => '',
        'false' => 'falso',
        'SystemID' => 'ID do sistema',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(A identidade do sistema. Cada n�mero de solicita��o e cada id. da sess�o http, inicia com este n�mero)',
        'System FQDN' => 'FQDN do sistema',
        '(Full qualified domain name of your system)' => '(Nome completo do dom�nio de seu sistema)',
        'AdminEmail' => 'Email do Administrador',
        '(Email of the system admin)' => '(Email do administrador do sistema)',
        'Organization' => 'Organiza��o',
        'Log' => '',
        'LogModule' => 'M�dulo LOG',
        '(Used log backend)' => '(Utilizado LOG como base)',
        'Logfile' => 'Arquivo de registro',
        '(Logfile just needed for File-LogModule!)' => '(Arquivo de registro para File-LogModule)',
        'Webfrontend' => 'Interface Web',
        'Use utf-8 it your database supports it!' => 'Use UTF-8 se sua base de dados suportar!',
        'Default Language' => 'Idioma Padr�o',
        '(Used default language)' => '(Idioma padr�o utilizado)',
        'CheckMXRecord' => 'Averiguar MX',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => 'Checar os registros do MX de endere�os de e-mail utilizados na composi��o de uma resposta. N�o utilizar checagem de registros do MX se o seu servidor OTRS estiver sib um acesso discado $!',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Para poder utilizar o OTRS voc� deve',
        'Restart your webserver' => 'Reiniciar o Webserver',
        'After doing so your OTRS is up and running.' => 'Ap�s isto, ent�o seu OTRS est� funcionando.',
        'Start page' => 'Iniciar p�gina',
        'Your OTRS Team' => 'Sua Equipe de Suporte',

        # Template: LinkObject

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Sem Permiss�o',

        # Template: Notify
        'Important' => 'Importante',

        # Template: PrintFooter
        'URL' => '',

        # Template: PrintHeader
        'printed by' => 'Impresso por',

        # Template: PublicDefault

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'P�gina de Teste do Gerenciador de Solicita��es',
        'Counter' => 'Contador',

        # Template: Warning

        # Template: YUI

        # Misc
        'Create Database' => 'Criar Banco de Dados',
        'verified' => 'verificado',
        'File-Name' => 'Nome do Arquivo',
        'Ticket Number Generator' => 'Gerador de N�mero de Solicita��o',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificador da Solicita��o. Algumas pessoas gostam de usar por exemplo \'Solicita��o#\, \'Chamado#\' ou \'MinhaSolicita��o#\')',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Neste caso, voc� pode editar diretamente a "keyring" configurada no Kernel/Config.pm.',
        'Create new Phone Ticket' => 'Criar nova Solicita��o Fone',
        'U' => 'C',
        'Site' => 'Site',
        'Customer history search (e. g. "ID342425").' => 'Busca no Hist�rico do cliente (exemplo: "ID342425")',
        'Can not delete link with %s!' => 'N�o � poss�vel deletar associa��o com %s!',
        'Close!' => 'Fechar!',
        'for agent firstname' => 'Nome do Atendente',
        'Reporter' => 'Relator',
        'Process-Path' => 'Caminho do Processo',
        'to get the realname of the sender (if given)' => 'para obter o nome do remetente (se possuir no email)',
        'FAQ Search Result' => 'Resultado da procura por FAQ',
        'Notification (Customer)' => 'Notifica��o (Cliente)',
        'CSV' => 'CSV',
        'Select Source (for add)' => 'Selecione Origem (para adi��o)',
        'Node-Name' => 'Nome do N�',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
        'Child-Object' => 'Objeto Filho',
        'Workflow Groups' => 'Grupos de Fluxo de Trabalho',
        'Current Impact Rating' => 'Taxa de Impacto Atual',
        'FAQ System History' => 'Hist�rico do Sistema de FAQ',
        'customer realname' => 'Nome real do cliente',
        'Pending messages' => 'Mensagens pendentes',
        'Modules' => 'M�dulos',
        'for agent login' => 'Login do Atendente',
        'Keyword' => 'Palavra-Chave',
        'Reference' => 'Refer�ncia',
        'Close type' => 'Tipo de fechamento',
        'DB Admin User' => 'Usu�rio Administrador do DB',
        'for agent user id' => 'Id do Atendente',
        'Classification' => 'Classifica��o',
        'Change user <-> group settings' => 'Modificar configura��es de usu�rios <-> grupos',
        'Escalation' => 'Escala��o',
        'Order' => 'Ordem',
        'next step' => 'pr�ximo passo',
        'Follow up' => 'Continua��o',
        'Customer history search' => 'Busca no Hist�rico do cliente',
        'not verified' => 'n�o verificado',
        'Stat#' => 'Estat�stica N�:.',
        'Create new database' => 'Criar novo banco de dados',
        'Year' => 'Ano',
        'X-axis' => 'Eixo-X',
        'Keywords' => 'Palavras-Chave',
        'Ticket Escalation View' => 'Vis�o Escala��o de Solicita��es',
        'Today' => 'Hoje',
        'No * possible!' => 'N�o s�o poss�veis *!',
        'Load' => 'Carregar',
        'Change Time' => 'Hor�rio de Altera��o',
        'Options of the current user who requested this action (e.g. OTRS_CURRENT_USERFIRSTNAME)' => 'Op��es do usu�rio atual que requisitou esta a��o (ex.: OTRS_CURRENT_USERFIRSTNAME)',
        'Message for new Owner' => 'Mensagem para um novo Propriet�rio',
        'to get the first 5 lines of the email' => 'para obter as 5 primeiras linhas do email',
        'Sent new password to: ' => 'Enviada nova senha para: ',
        'Sort by' => 'Ordenado pela',
        'OTRS DB Password' => 'Password do OTRS DB',
        'Last update' => '�ltima Atualiza��o',
        'Tomorrow' => 'Amanh�',
        'not rated' => 'n�o avaliado',
        'to get the first 20 character of the subject' => 'para obter os 20 primeiros caracteres do assunto',
        'Select the customeruser:service relations.' => 'Selecione as rela��es cliente:servi�o.',
        'DB Admin Password' => 'Password de Administrador do DB',
        'Drop Database' => 'Deletar Database',
        'Options of the current customer user data (e. g. OTRS_CUSTOMER_DATA_USERFIRSTNAME)' => 'Op��es de dados do usu�rio do cliente atual (ex.: OTRS_CUSTOMER_DATA_USERFIRSTNAME)',
        'Pending type' => 'Tipo de pend�ncia',
        'Comment (internal)' => 'Coment�rio (interno)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Op��es do propriet�rio da solicita��o (z. B. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'User-Number' => 'N�mero-Usu�rio',
        'Options of the ticket data (e. g. OTRS_TICKET_TicketNumber, OTRS_TICKET_TicketID, OTRS_TICKET_Queue, OTRS_TICKET_State)' => 'Op��es de dados da solicita��o (e. g. OTRS_TICKET_TicketNumber, OTRS_TICKET_TicketID, OTRS_TICKET_Queue, OTRS_TICKET_State)',
        '(Used ticket number format)' => '(Formato usado do n�mero da solicita��o)',
        'Reminder' => 'Lembretes',
        'Month' => 'M�s',
        'Node-Address' => 'Endere�o-N�',
        'All Agent variables.' => 'Todas as vari�veis do Atendente',
        ' (work units)' => ' (unidades de trabalho)',
        'Next Week' => 'Pr�xima Semana',
        'You use the DELETE option! Take care, all deleted Tickets are lost!!!' => 'Voc� usou a op��o DELETAR! Cuidado, todas as solicita��o apagadas ser�o perdidas!!!',
        'All Customer variables like defined in config option CustomerUser.' => 'Todas as vari�veis do cliente como foram definidas nas op��es de configura��o de "usu�rio"',
        'for agent lastname' => 'Sobrenome do Atendente',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Op��es do atual usu�rio que solicitou a a��o (e. g. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Mensagens com lembretes',
        'Parent-Object' => 'Objeto-Pai',
        'Of couse this feature will take some system performance it self!' => 'Com certeza esta funcionalidade ir� consumir certa quantidade de recursos do sistema!',
        'Your own Ticket' => 'Sua pr�pria solicita��o',
        'Detail' => 'Detalhe',
        'TicketZoom' => 'Detalhe da Solicita��o',
        'Don\'t forget to add a new user to groups!' => 'N�o se esque�a de adicionar o novo usu�rio a grupos!',
        'Open Tickets' => 'Solicita��es Abertas',
        'CreateTicket' => 'Criar Solicita��o',
        'unknown' => 'desconhecido',
        'System Settings' => 'Configura��es Sistema',
        'Finished' => 'Finalizado',
        'Imported' => 'Importado',
        'unread' => 'n�o lida',
        'Ticket Number Generator' => 'Gerador de N�meros de Solicita��es',
        'Change roles <-> groups settings' => 'Alterar configura��es Pap�is <-> Grupos',
        'Edit Article' => 'Editar Artigo',
        'No means, send agent and customer notifications on changes.' => 'N�o siginifica \'envie notifica��es ao atendente e ao cliente nas altera��es\'.',
        'A web calendar' => 'Um calend�rio online',
        'Config options (e. g. OTRS_CONFIG_HttpType)' => 'Op��es de configura��o (ex.: OTRS_CONFIG_HttpType)',
        'Queue ID' => 'ID da Fila',
        'Locked tickets' => 'Solicita��es bloqueadas',
        'System History' => 'Hist�rico do Sistema',
        'Problem' => 'Problema',
        '"}' => '',
        'Admin-Email' => 'E-mail Admin.',
        'Options of the ticket data (e. g. OTRS_TICKET_Number, OTRS_TICKET_ID, OTRS_TICKET_Queue, OTRS_TICKET_State)' => 'Op��es de dados da solicita��o (ex.: OTRS_TICKET_Number, OTRS_TICKET_ID, OTRS_TICKET_Queue, OTRS_TICKET_State;)',
        'ArticleID' => 'Id. do Artigo',
        'Options ' => 'Op��es ',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
        'Advisory' => 'Aviso',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Aqui voc� pode definir o eixo X. Voc� pode selecionar um elemento atrav�s do \'radio button\'. Ent�o voc� deve selecionar dois ou mais atributos do elemento. Se n�o efetuou nenhum sele��o, todos os atributos do elemento ser�o utilizados se voc� gerar uma estat�stica. Assim como um novo atributo � adicionado desde a �ltima configura��o.',
        'FileManager' => 'Adm Arquivo',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Op��es de dono da solicita��o (ex.: &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'Incident' => 'Incidente',
        'accept license' => 'aceitar licen�a',
        'Of couse this feature will take some system performance it self!' => '',
        'Don\'t forget to add a new user to groups!' => 'N�o esque�a de adicionar um novo usu�rio nos grupos!',
        'You have to select two or more attributes from the select field!' => 'Voc� deve selecionar dois ou mais atributos no campo \'selecionar\'!',
        'WebWatcher' => 'Visitante',
        'D' => 'D',
        'All messages' => 'Todas as mensagens',
        'Artefact' => 'Artefato',
        'Object already linked as %s.' => 'Objeto j� associado como %s.',
        'A article should have a title!' => 'O Artigo dever� ter um T�tulo!',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
        'Customer Users <-> Services' => 'Clientes <-> Servi�os',
        'All email addresses get excluded on replaying on composing and email.' => '',
        'don\'t accept license' => 'n�o acentiar a licen�a',
        'A web mail client' => 'Webmail Cliente',
        'Compose Follow up' => 'Compor Continua��o',
        'WebMail' => '',
        'kill all sessions' => 'Finalizar todas as sess�es',
        'to get the from line of the email' => 'para obter a linha "From" do email',
        'Solution' => 'Solu��o',
        'QueueView' => 'Fila',
        'Options of the ticket data (e. g. OTRS_TICKET_TicketNumber, OTRS_TICKET_ID, OTRS_TICKET_Queue, OTRS_TICKET_State)' => 'Op��es de dados da solicita��o (ex.: OTRS_TICKET_TicketNumber, OTRS_TICKET_ID, OTRS_TICKET_Queue, OTRS_TICKET_State)',
        'Select Box' => 'Caixa de Sele��o',
        'New messages' => 'Mensagens novas',
        'Can not create link with %s!' => 'N�o foi poss�vel associar com %s!',
        'Linked as' => 'Associado como',
        'Welcome to OTRS' => 'Bem-vindo ao OTRS',
        'modified' => 'modificado',
        'A web file manager' => 'Gerenciador de Arquivos Web',
        'Have a lot of fun!' => 'Divirta-se!',
        'send' => 'enviar',
        'Send no notifications' => 'N�o enviar notifica��es',
        'Note Text' => 'Nota',
        'POP3 Account Management' => 'Gerenciamento de Contas POP3',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Op��es de informa��es do cliente (ex.: &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'System State Management' => 'Gerenciamento de Estados do Sistema',
        'Mailbox' => 'Caixa de Entrada',
        'PhoneView' => 'Chamada',
        'maximal period form' => 'formul�rio de per�odo m�ximo',
        'TicketID' => 'Id. da Solicita��o',
        'Escaladed Tickets' => 'Solicita��es Escaladas',
        'Yes means, send no agent and customer notifications on changes.' => 'Sim significa \'n�o envie notifica��es ao atendente e ao cliente nas altera��es\'.',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Seu email com o n�mero de solicita��o "<OTRS_TICKET>" foi devolvido para "<OTRS_BOUNCE_TO>". Contate este endere�o para mais informa��es.',
        'Ticket Status View' => 'Visualiza��o do Status da Solicita��o',
        'Modified' => 'Modificado',
        'Ticket selected for bulk action!' => 'Solicita��o selecionada para execu��o de a��o em massa!',
        '%s is not writable!' => '%s � somente leitura!',
        'Cannot create %s!' => 'N�o foi poss�vel criar %s!',
        'Symptom' => 'Sintoma',
    };
    # $$STOP$$
    return;
}

1;
