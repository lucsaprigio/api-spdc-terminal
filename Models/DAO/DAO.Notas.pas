unit DAO.Notas;

interface

uses Infra.Connection, System.JSON,
FireDAC.Comp.Client, DataSet.Serialize, system.SysUtils, System.StrUtils;

type
  TDAONotas = class
     class function BuscarNotas(aDataIni, aDataFin, aCnpj : String): TJSONArray;
  end;

implementation

{ TDAONotas }

class function TDAONotas.BuscarNotas(aDataIni, aDataFin, aCnpj : String): TJSONArray;
var
  LConexao : IControllerConnection;
  Query    : TFDQuery;
begin
  LConexao := TControllerConection.New(DBPrincipal);
  Query    := TFDQuery.Create(nil);

  aDataIni := aDataIni.Replace('/', '.');
  aDataFin := aDataFin.Replace('/', '.');

  try
    Query.Connection := LConexao.GetConnection;

    Query.SQL.Text := ' SELECT CHAVE, E_S, CNPJ_NF' +
                      ' FROM DB_LISTA_XML_GERAL' +
                      ' WHERE DATA BETWEEN :DT_INI AND :DT_FIN' +
                      ' AND CNPJ_NF = :CNPJ_NF' +
                      ' ORDER BY E_S, DATA' ;

    Query.ParamByName('DT_INI').AsString  := aDataIni;
    Query.ParamByName('DT_FIN').AsString  := aDataFin;
    Query.ParamByName('CNPJ_NF').AsString := aCnpj;

    Query.Open;

    Result := Query.ToJSONArray();

  finally
    Query.Free;
  end;
end;

end.
