unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdMessageClient, IdSMTP, StdCtrls, IdMessage, IdIOHandler,
  IdIOHandlerSocket, IdSSLOpenSSL;

type
  TForm1 = class(TForm)
    IdSMTP: TIdSMTP;
    Button1: TButton;
    IdMessage: TIdMessage;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocket;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  CaminhoAnexo: string;
begin
// instancia��o dos objetos
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocket.Create(Self);
  IdSMTP := TIdSMTP.Create(Self);
  IdMessage := TIdMessage.Create(Self);
 
  try
    // Configura��o do SSL
    IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
    IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;
 
    // Configura��o do SMTP
    IdSMTP.IOHandler := IdSSLIOHandlerSocket;
    IdSMTP.AuthenticationType := atLogin;
    IdSMTP.Port := 465;
    IdSMTP.Host := 'smtp.gmail.com';
    IdSMTP.Username := 'programador.marca';
    IdSMTP.Password := 'Umanovasenh@fort3';
 
    // Tentativa de conex�o e autentica��o
    try
      IdSMTP.Connect;
      IdSMTP.Authenticate;
    except
      on E:Exception do
      begin
        MessageDlg('Erro na conex�o e/ou autentica��o: ' +
                    E.Message, mtWarning, [mbOK], 0);
        Exit;
      end;
    end;
 
    // Configura��o da mensagem
    IdMessage.From.Address := 'programador.marca@gmail.com';
    IdMessage.From.Name := 'Programador';
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    IdMessage.Recipients.EMailAddresses := 'pececarvalho@gmail.com';
    IdMessage.Subject := 'Teste de envio via Delphi 7';
    IdMessage.Body.Text := 'Se voc� est� lendo este email � bingo!';
 
    // Anexo da mensagem (opcional)
    CaminhoAnexo := 'D:\Sistemas\TEST\MandaEmail\Unit1.pas';
    if FileExists(CaminhoAnexo) then
      TIdAttachment.Create(IdMessage.MessageParts, CaminhoAnexo);
 
    // Envio da mensagem
    try
      IdSMTP.Send(IdMessage);
      MessageDlg('Mensagem enviada com sucesso.', mtInformation, [mbOK], 0);
    except
      On E:Exception do
        MessageDlg('Erro ao enviar a mensagem: ' +
                    E.Message, mtWarning, [mbOK], 0);
    end;
  finally
    // libera��o dos objetos da mem�ria
    FreeAndNil(IdMessage);
    FreeAndNil(IdSSLIOHandlerSocket);
    FreeAndNil(IdSMTP);
  end;
end;

end.
