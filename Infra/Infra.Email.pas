unit Infra.Email;

interface

uses System.SysUtils;

type
  TAnexoEmail = record
    NomeArquivo: string;
    ConteudoXML: TBytes;
  end;

  IEmailService = interface
    ['{53DC094C-7A72-48DB-8F2A-ED45BE2F0007}']
    procedure Enviar(const ADestinatario, AAssunto, AMensagem: string; const  AAnexos : TArray<TAnexoEmail>);
  end;

implementation

end.
