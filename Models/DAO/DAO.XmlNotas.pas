unit DAO.XmlNotas;

interface

uses
  System.SysUtils, FireDAC.Comp.Client,
  Infra.Connection, Infra.Logger;

type
  TDAOXmlNotas = class
    class function BuscarXmlPorChave(aConexao: IControllerConnection; aListaChaves: String): TFDQuery;
  end;
implementation

{ TDAOXml }

class function TDAOXmlNotas.BuscarXmlPorChave(aConexao: IControllerConnection;  aListaChaves: String): TFDQuery;
begin
  Result := TFDQuery.Create(nil);

  try
    Result.Connection := aConexao.GetConnection;

    Result.SQL.Text := ' SELECT X.ARQUIVO,  I.E_S, I.MODELO, I.CHAVE FROM INDICE I ' +
                       ' INNER JOIN XML X ON I.ITEN = X.LANCAB' +
                       ' WHERE I.CHAVE IN (&Chaves)';

    Result.MacroByName('Chaves').AsRaw := aListaChaves;

    {$IFDEF DEBUG}
    TLogger.Info('1. SQL Base: ' + Result.SQL.Text);
    TLogger.Info('2. Macro Injetada: ' + aListaChaves);
    {$ENDIF}
    Result.Open;

    {$IFDEF DEBUG}
    TLogger.Info('3. Registros encontrados: ' + Result.RecordCount.ToString);
    TLogger.Info('-------------------------');
    {$ENDIF}
  except
    Result.Free;
    raise;
  end;
end;

end.
