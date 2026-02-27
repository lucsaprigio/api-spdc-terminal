program ApiSpdc;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
<<<<<<< HEAD
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  Utils.Startup in 'Utils\Utils.Startup.pas',
  {$ENDIF}
=======
>>>>>>> 7147a264007f536c439881626a0d5a9840d9ed63
  Infra.Horse in 'Infra\Infra.Horse.pas',
  Infra.Logger in 'Infra\Infra.Logger.pas',
  Utils.Configuracao in 'Utils\Utils.Configuracao.pas',
  Infra.Connection in 'Infra\Infra.Connection.pas',
  DAO.Notas in 'Models\DAO\DAO.Notas.pas',
  Service.NotasXml in 'Services\Service.NotasXml.pas',
  DAO.XmlNotas in 'Models\DAO\DAO.XmlNotas.pas',
  Service.Descompactador in 'Services\Service.Descompactador.pas',
  Infra.Email in 'Infra\Infra.Email.pas',
  Service.Indy.Email in 'Services\Service.Indy.Email.pas',
  Controller.Notas in 'Controllers\Controller.Notas.pas',
  Router.ArquivosXml in 'Routers\Router.ArquivosXml.pas',
  Service.ACBrMail.Email in 'Services\Service.ACBrMail.Email.pas';

<<<<<<< HEAD

var
  {$IFDEF MSWINDOWS}
  LMutex : THandle;
  {$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  LMutex := CreateMutex(nil, True, 'ApiSpdc_Terminal');

  if (LMutex = 0) or (GetLastError = ERROR_ALREADY_EXISTS) then
  begin
    Writeln('A API ja esta em execucao no momento!');
    Readln;
    Exit;
  end;
  {$ENDIF}
  try
     TAppConfig.CarregarIni;

     {$IFDEF MSWINDOWS}
      TUtilsStartup.RegistrarStartupWindows;
     {$ENDIF}

     TServerHorse.Start(9005);
=======
begin
  try
     TAppConfig.CarregarIni;
     TServerHorse.Start(9000);
>>>>>>> 7147a264007f536c439881626a0d5a9840d9ed63
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
<<<<<<< HEAD

  {$IFDEF MSWINDOWS}
  if LMutex <> 0 then
    ReleaseMutex(LMutex);
  {$ENDIF}
=======
>>>>>>> 7147a264007f536c439881626a0d5a9840d9ed63
end.
