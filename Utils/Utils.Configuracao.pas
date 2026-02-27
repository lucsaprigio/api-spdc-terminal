unit Utils.Configuracao;

interface

uses
  System.IOUtils,
  System.SysUtils,
  System.IniFiles;

type
  TAppConfig = class
  private
    class var FServer: String;
    class var FPort: String;
    class var FDatabase: String;
    class var FDBXml: String;
    class var FDBUser: String;
    class var FDBPassword: String;

    class var FServerXml: String;
    class var FPortXml: String;
    class var FDBUserXml: String;
    class var FDBPasswordXml: String;
    class var FDriverID: string;

    // Configurações SMTP
    class var FMailPort: String;
    class var FMailPassword: String;
    class var FMailHost: String;
    class var FMailUsername: String;

  public
    class procedure CarregarIni;

    // Informações do Banco Spdc (Login e Usuário; Informações das Notas Fiscais)
    class property DriverID: string read FDriverID write FDriverID;
    class property Server: string read FServer write FServer;
    class property Port: string read FPort write FPort;
    class property Database: string read FDatabase write FDatabase;
    class property DBUser: string read FDBUser write FDBUser;
    class property DBPassword: string read FDBPassword write FDBPassword;

    // Banco onde está os Xml salvos das empresas.
    class property DBXml: string read FDBXml;
    class property ServerXml: String read FServerXml write FServerXml;
    class property PortXml: String read FPortXml write FPortXml;
    class property DBUserXml: String read FDBUserXml write FDBUserXml;
    class property DBPasswordXml: String read FDBPasswordXml write FDBPasswordXml;

    class property MailHost: String read FMailHost write FMailHost;
    class property MailPort: String read FMailPort write FMailPort;
    class property MailUsername: String read FMailUsername write FMailUsername;
    class property MailPassword: String read FMailPassword write FMailPassword;
  end;

implementation

{ TAppConfig }

class procedure TAppConfig.CarregarIni;
var
  LArquivoINI : TIniFile;
  LCaminhoINI : String;
begin
  // C:\MeuApp\config.Ini -> Facilitanto caso for para um Linux.
  LCaminhoINI := TPath.Combine(ExtractFilePath(ParamStr(0)), 'config.ini');

  if not FileExists(LCaminhoINI) then begin
       LArquivoINI := TIniFile.Create(LCaminhoINI);

       try
         LArquivoINI.WriteString('BancoConfig', 'DriverID', 'FB');
         LArquivoINI.WriteString('BancoConfig', 'Server', '127.0.0.1');
         LArquivoINI.WriteString('BancoConfig', 'Port', '3050');
         LArquivoINI.WriteString('BancoConfig', 'Database', '');
         LArquivoINI.WriteString('BancoConfig', 'User', 'sysdba');
         LArquivoINI.WriteString('BancoConfig', 'Password', 'masterkey');

         LArquivoINI.WriteString('BancoXml', 'ServerXml', '');
         LArquivoINI.WriteString('BancoXml', 'DatabaseXml', '');
         LArquivoINI.WriteString('BancoXml', 'PortXml', '');
         LArquivoINI.WriteString('BancoXml', 'UserXml', 'sysdba');
         LArquivoINI.WriteString('BancoXml', 'PasswordXml', 'masterkey');

         LArquivoINI.WriteString('SMTP', 'MailHost', '');
         LArquivoINI.WriteString('SMTP', 'MailPort', '');
         LArquivoINI.WriteString('SMTP', 'MailUsername', '');
         LArquivoINI.WriteString('SMTP', 'MailPassword', '');
       finally
        LArquivoINI.Free;
       end;
  end;

  LArquivoINI := TIniFile.Create(LCaminhoINI);

  try
    FDriverID   := LArquivoINI.ReadString('BancoConfig', 'DriverID', '');
    FServer     := LArquivoINI.ReadString('BancoConfig', 'Server', '127.0.0.1');
    FPort       := LArquivoINI.ReadString('BancoConfig', 'Port', '');
    FDatabase   := LArquivoINI.ReadString('BancoConfig', 'Database', '');
    FDBUser     := LArquivoINI.ReadString('BancoConfig', 'User', '');
    FDBPassword := LArquivoINI.ReadString('BancoConfig', 'Password', '');

    FServerXml     := LArquivoINI.ReadString('BancoXml', 'ServerXml', '127.0.0.1');
    FDBXml         := LArquivoINI.ReadString('BancoXml', 'DatabaseXml', '');
    FPortXml       := LArquivoINI.ReadString('BancoXml', 'PortXml', '');
    FDBUserXml     := LArquivoINI.ReadString('BancoXml', 'UserXml', 'sysdba');
    FDBPasswordXml := LArquivoINI.ReadString('BancoXml', 'PasswordXml', 'masterkey');

    FMailHost      := LArquivoINI.ReadString('SMTP', 'MailHost', '');
    FMailPort      := LArquivoINI.ReadString('SMTP', 'MailPort', '');
    FMailUsername  := LArquivoINI.ReadString('SMTP', 'MailUsername', '');
    FMailPassword  := LArquivoINI.ReadString('SMTP', 'MailPassword', '');
  finally
    LArquivoINI.Free;
  end;

end;

end.
