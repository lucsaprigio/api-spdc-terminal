unit Infra.Horse;

interface

uses
<<<<<<< HEAD
  Horse, Horse.Jhonson, Horse.CORS, Infra.Logger, System.SysUtils, Router.ArquivosXml;
=======
  Horse, Horse.Jhonson, Infra.Logger, System.SysUtils, Router.ArquivosXml;
>>>>>>> 7147a264007f536c439881626a0d5a9840d9ed63

type
  TServerHorse = class
    class procedure Start(APort: integer);
    class procedure Stop;
  end;

implementation

{ TServerHorse }

class procedure TServerHorse.Start(APort: integer);
begin
<<<<<<< HEAD
   THorse.Use(Cors);
=======
>>>>>>> 7147a264007f536c439881626a0d5a9840d9ed63
   THorse.Use(Jhonson);

   Router.ArquivosXml.Registry;

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
