unit Infra.Connection;

interface

uses
  FireDAC.UI.Intf, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Comp.UI, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, Data.DB, FireDAC.Comp.Client, FireDAC.DApt,
  System.SysUtils, Utils.Configuracao;

type
  IControllerConnection = interface
    ['{8D970CDA-4C32-4198-9866-C21B1EE28B6F}']
    function GetConnection: TFDConnection;
    function Connect: IControllerConnection;
    function Disconnect: IControllerConnection;
  end;

  TDBPath = (DBPrincipal, DBXml);

  TControllerConection = class(TInterfacedObject, IControllerConnection)
  private
    FConnection: TFDConnection;
    FDatabaseType : TDBPath;
    procedure ConfigurarConexao;
  public
    constructor Create(const DatabaseType : TDBPath); // Vou usar 2 bancos, então vou colocar um parâmetro opcional
    destructor destroy; override;

    class function New(const DatabaseType : TDBPath): IControllerConnection; // Preciso colocar no new pois é onde eu faço instancio a classe.

    function GetConnection: TFDConnection;
    function Connect: IControllerConnection;
    function Disconnect: IControllerConnection;
  end;

implementation

{ TControllerConection }

constructor TControllerConection.Create(const DatabaseType : TDBPath);
begin
  // No Constructor é onde vamos fazer a criação de conexão neste caso de Banco.
  FConnection   := TFDConnection.Create(nil);
  FDatabaseType := DatabaseType;
  ConfigurarConexao;
end;

destructor TControllerConection.destroy;
begin
  FConnection.Free;
  inherited;
end;

class function TControllerConection.New(const DatabaseType : TDBPath): IControllerConnection;
begin
  Result := Self.Create(DatabaseType);
end;

procedure TControllerConection.ConfigurarConexao;
begin
  // Colocar no INI
  with FConnection do
  begin
    Connected := False;
    Params.Clear;

   LoginPrompt                := False;


   case FDatabaseType of
    DBPrincipal:
    begin
      Params.DriverID           := TAppConfig.DriverID;
      Params.Values['Port']     := TAppConfig.Port;
      Params.Values['Server']   := TAppConfig.Server;
      Params.Database           := TAppConfig.Database;
      Params.UserName           := TAppConfig.DBUser;
      Params.Password           := TAppConfig.DBPassword;
    end;
    DBXml:
    begin
      Params.DriverID           := TAppConfig.DriverID;

      Params.Values['Port']     := TAppConfig.PortXml;
      Params.Values['Server']   := TAppConfig.ServerXml;
      Params.Database           := TAppConfig.DBXml;
      Params.UserName           := TAppConfig.DBUserXml;
      Params.Password           := TAppConfig.DBPasswordXml;
    end;
   end;

   Params.Values['Protocol'] := 'TCPIP';

   Connected := True;
  end;
end;

function TControllerConection.Connect: IControllerConnection;
begin
  Result := Self;

  try
    if not FConnection.Connected then
    begin
      FConnection.Connected := True;
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro fatal ao conectar no banco de dados: ' +
        E.Message);
    end;
  end;
end;

function TControllerConection.Disconnect: IControllerConnection;
begin
  Result := Self;
  FConnection.Connected := False;
end;

function TControllerConection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

end.
