unit Service.ACBrMail.Email;

interface

uses Infra.Email, ACBrMail, Utils.Configuracao, System.SysUtils,
  System.Generics.Collections, System.Classes;

type
  TServiceACBrMail = class(TInterfacedObject, IEmailService)
      class function New: IEmailService;
      procedure Enviar(const ADestinatario, AAssunto, AMensagem: string; const  AAnexos : TArray<TAnexoEmail>);
  end;

implementation

{ TServiceACBrMail }

procedure TServiceACBrMail.Enviar(const ADestinatario, AAssunto,
  AMensagem: string; const AAnexos: TArray<TAnexoEmail>);
var
  acbrMail : TACBrMail ;
  LAnexo : TAnexoEmail;
  LListaStreams : TObjectList<TBytesStream>;
  LStreamTemp : TBytesStream;
begin
  acbrMail := TACBrMail.Create(nil);

  // Cria uma lista para segurar os arquivos na memória.
  // O parâmetro "True" avisa para a lista destruir os objetos quando ela mesma for destruída.
  LListaStreams := TObjectList<TBytesStream>.Create(True);
  try
        acbrMail.Host      := TAppConfig.MailHost;
        acbrMail.From      := TAppConfig.MailUsername;
        acbrMail.Username  := TAppConfig.MailUsername;
        acbrMail.Password  := TAppConfig.MailPassword;
        acbrMail.Port      := TAppConfig.MailPort;
        acbrMail.AddAddress(ADestinatario);
        acbrMail.Subject   := AAssunto;

        acbrMail.Body.Add(AMensagem);

        acbrMail.SetSSL    := False;
        acbrMail. SetTLS   := True;

  for LAnexo in AAnexos do
  begin
      LStreamTemp := TBytesStream.Create(LAnexo.ConteudoXML);

      LListaStreams.Add(LStreamTemp);

      acbrMail.AddAttachment(LStreamTemp, LAnexo.NomeArquivo);
  end;
    try
        acbrMail.Send;
    except on E: Exception do
      raise Exception.Create(E.Message);
    end;
  finally
    acbrMail.Free;
    LListaStreams.Free;
  end;
end;

class function TServiceACBrMail.New: IEmailService;
begin
  Result := Self.Create;
end;

end.
