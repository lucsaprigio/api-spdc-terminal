program ApiSpdc;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Infra.Horse in 'Infra\Infra.Horse.pas',
  Infra.Logger in 'Infra\Infra.Logger.pas',
  Router in 'Routers\Router.ArquivosXml',
  Utils.Configuracao in 'Utils\Utils.Configuracao.pas',
  Infra.Connection in 'Infra\Infra.Connection.pas',
  DAO.Notas in 'Models\DAO\DAO.Notas.pas',
  Service.NotasXml in 'Services\Service.NotasXml.pas';

begin
  try
     TServerHorse.Start(9000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
