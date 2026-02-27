unit Router.ArquivosXml;

interface

uses
  Horse, Controller.Notas;

procedure Registry;

implementation

procedure Registry;
begin
  THorse.Post('/api/xml', TControllerNotas.PostOrganizarNotas);
end;
end.
