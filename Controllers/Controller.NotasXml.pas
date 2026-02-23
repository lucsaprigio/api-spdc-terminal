unit Controller.NotasXml;

interface

uses
  Horse, System.JSON;

type
  TControllerNotas = class
    class procedure EmpacotarXml(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TControllerNotas }

class procedure TControllerNotas.EmpacotarXml(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  LBody : TJSONObject;
  LCnpj : String;
begin
  LBody := Req.Body<TJSONObject>;
  LCnpj := Req.Params.Field('cnpj').AsString;

  // Procedimentos de buscar as NF
end;

end.
