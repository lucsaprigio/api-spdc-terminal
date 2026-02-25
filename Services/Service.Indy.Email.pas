unit Service.Indy.Email;

interface

uses
  Infra.Email, System.Classes, System.SysUtils,
  IdMessage, IdSMTP, IdAttachmentMemory,
  IdExplicitTLSClientServerBase, IdSSLOpenSSL,
  IdMessageClient, IdSMTPBase, Utils.Configuracao;

type
  TIndyMailService = class(TInterfacedObject, IEmailService)
    public
    class function New: IEmailService;
    procedure Enviar(const ADestinatario, AAssunto, AMensagem: string; const  AAnexos : TArray<TAnexoEmail>);
  end;

implementation

{ TIndyMailService }

procedure TIndyMailService.Enviar(const ADestinatario, AAssunto,
  AMensagem: string; const AAnexos: TArray<TAnexoEmail>);
var
  LIdMessage: TIdMessage;
  LIdSMTP: TIdSMTP;
  LAnexo: TAnexoEmail;
  LStreamAnexo: TBytesStream;
  LSSLHandler : TIdSSLIOHandlerSocketOpenSSL;
begin
  LIdMessage := TIdMessage.Create(nil);
  LIdSMTP    := TIdSMTP.Create(nil);
  LSSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

  try
    LIdMessage.From.Address           := TAppConfig.MailHost;
    LIdMessage.Recipients.Add.Address := ADestinatario;
    LIdMessage.Subject                := AAssunto;
    LIdMessage.Body.Text              := AMensagem;

    for LAnexo in AAnexos do begin
      LStreamAnexo := TBytesStream.Create(LAnexo.ConteudoXML);
      try
       TIdAttachmentMemory.Create(LIdMessage.MessageParts, LStreamAnexo).FileName := LAnexo.NomeArquivo;
      finally
       LStreamAnexo.Free;
      end;
    end;

    LSSLHandler.SSLOptions.Method := sslvTLSv1_2;
    LSSLHandler.SSLOptions.Mode   := sslmClient;

    with LIdSMTP do begin
      IOHandler := LSSLHandler;
      UseTLS    := utUseExplicitTLS;

      Host := TAppConfig.MailHost;
      Port := TAppConfig.MailPort.ToInteger;
      Username := TAppConfig.MailUsername;
      Password := TAppConfig.MailPassword;

      Connect;
    try
      Send(LIdMessage);
    finally
      Disconnect;
    end;
   end;
  finally
     LIdMessage.Free;
     LIdSMTP.Free;
  end;
end;

class function TIndyMailService.New: IEmailService;
begin
    Result := Self.Create;
end;

end.
