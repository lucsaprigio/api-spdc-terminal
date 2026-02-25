program ApiSpdc;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
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

begin
  try
     TAppConfig.CarregarIni;
     TServerHorse.Start(9000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
