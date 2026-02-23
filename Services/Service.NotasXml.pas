unit Service.NotasXml;

interface

uses
  System.JSON, Dataset.Serialize, DAO.Notas, System.SysUtils;

type
  IServiceNotasXml = interface
    ['{37463C4A-9C73-4EC5-B1BF-A26C739963E3}']
    function BuscarNotasSpdc(const aDataIni, aDataFin, aCnpj: String) : TJSONObject;
  end;

  TServiceNotasXml = class(TInterfacedObject, IServiceNotasXml)

   class function New: IServiceNotasXml;
    function BuscarNotasSpdc(const aDataIni, aDataFin, aCnpj: String) : TJSONObject;
  end;

implementation

{ TServiceNotasXml }

function TServiceNotasXml.BuscarNotasSpdc(const aDataIni, aDataFin,
  aCnpj: String): TJSONObject;
var
  LNotas : TJSONArray;
  I: Integer;
  LObjectNota : TJSONObject;
  LChave, LEntSaida, LModelo, LListaChaves : String;
  LJsonES : TJSONObject; // "E" : { }  "S": { } - Vão ser agrupados dessa forma
  LArrayModelo : TJSONArray;
begin
// O JSON vai Retornar desta forma.

//{
//  "E": {
//    "55": [ { "CHAVE": "...", "CNPJ_NF": "..." } ]
//  },
//  "S": {
//    "55": [ { "CHAVE": "...", "CNPJ_NF": "..." } ],
//    "65": [ { "CHAVE": "...", "CNPJ_NF": "..." } ]
//  }
//}
  Result := TJSONObject.Create;

  Result.AddPair('E', TJSONObject.Create);
  Result.AddPair('S', TJSONObject.Create);

  LListaChaves := '';

  LNotas := TDAONotas.BuscarNotas(aDataIni, aDataFin, aCnpj);

  try
    for I := 0 to LNotas.Count - 1 do begin
      LObjectNota := LNotas.Items[I].Clone as TJSONObject;

      LChave    := LNotas.GetValue<String>('CHAVE');
      LEntSaida := LNotas.GetValue<String>('E_S');

      // Pegando a posição do modelo na String do XML
      LModelo := Copy(LChave, 21, 2);

      LListaChaves := LListachaves + QuotedStr(LChave) + ',';

      // Pegando dentro do Result do AddPair que usamos la em cima
      LJsonES := Result.GetValue<TJSONObject>(LEntSaida);

      if LJsonES.GetValue(LModelo) = nil  then
         LJsonES.AddPair(LModelo, TJSONArray.Create);

      LArrayModelo := LJsonES.GetValue<TJSONArray>(LModelo);
      LArrayModelo.AddElement(LObjectNota);
    end;

    if LListaChaves <> '' then
      LListaChaves := LListaChaves.Remove(LListaChaves.Length - 1, 1);

  finally
    LNotas.Free;
  end;
end;

class function TServiceNotasXml.New: IServiceNotasXml;
begin
  Result := Self.Create;
end;

end.
