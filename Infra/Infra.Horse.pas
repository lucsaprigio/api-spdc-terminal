unit Infra.Horse;

interface

uses
  Horse, Horse.Jhonson, Infra.Logger, System.SysUtils;

type
  TServerHorse = class
    class procedure Start(APort: integer);
    class procedure Stop;
  end;

implementation

{ TServerHorse }

class procedure TServerHorse.Start(APort: integer);
begin
   THorse.Use(Jhonson);

   THorse.Listen(APort,
   procedure
     begin
       TLogger.Info('Servidor rodando na porta ' + APort.ToString());
     end);
end;

class procedure TServerHorse.Stop;
begin
    if THorse.IsRunning then begin
      THorse.StopListen;
    end;
end;

end.
