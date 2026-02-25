unit Service.NotasXml;

interface

uses
  System.JSON, Dataset.Serialize, DAO.Notas, System.SysUtils, DAO.XmlNotas,
  FireDAC.Comp.Client, System.Generics.Collections, IdMessage,
  IdSMTP, IdAttachmentMemory, IdExplicitTLSClientServerBase,
  IdMessageClient, IdSMTPBase, System.Classes, Service.Indy.Email, Infra.Email, System.Zip,
  Service.Descompactador, Infra.Logger, Infra.Connection, Service.ACBrMail.Email;

type
  IServiceNotasXml = interface
    ['{37463C4A-9C73-4EC5-B1BF-A26C739963E3}']
    function BuscarNotasSpdc(const aDataIni, aDataFin, aCnpj: String) : TJSONObject;
    function ProcessarEEnviarNotas(const aDataIni, aDataFin, aCnpj, aEmailDestino: String) : TJSONObject;
  end;

  TServiceNotasXml = class(TInterfacedObject, IServiceNotasXml)

   class function New: IServiceNotasXml;
    function BuscarNotasSpdc(const aDataIni, aDataFin, aCnpj: String) : TJSONObject;
    function ProcessarEEnviarNotas(const aDataIni, aDataFin, aCnpj, aEmailDestino: String) : TJSONObject;
  end;

implementation

{ TServiceNotasXml }

function TServiceNotasXml.BuscarNotasSpdc(const aDataIni, aDataFin,
  aCnpj: String): TJSONObject;
var
  LNotas : TJSONArray;
  LQueryXml : TFDQuery;
  I: Integer;
  LObjectNota : TJSONObject;
  LChave, LEntSaida, LModelo, LListaChaves : String;
  LJsonES : TJSONObject; // "E" : { }  "S": { } - Vão ser agrupados dessa forma
  LArrayModelo : TJSONArray;
  LMapaNotas : TDictionary<String, TJSONObject>;
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

    // Aqui busca os BLOBS das NFe de acordo com a outra tabela do Banco : SPDC
//    LQueryXml := TDAOXmlNotas.BuscarXmlPorChave(LConexaoXml, LListaChaves);

    Result := LJsonES;

    // Implementar depois se quiser enviar os BLOB's
  finally
    LNotas.Free;
  end;
end;

class function TServiceNotasXml.New: IServiceNotasXml;
begin
  Result := Self.Create;
end;

function TServiceNotasXml.ProcessarEEnviarNotas(const aDataIni, aDataFin,
  aCnpj, aEmailDestino: String): TJSONObject;
var
  LNotas: TJSONArray;
  LQueryXml: TFDQuery;
  I: Integer;
  LChaveStr, LListaChaves, LXmlDescompactado, LES, LModelo, LPasta: string;

  LZipStream : TMemoryStream;
  LZipFile   : TZipFile;
  LXmlStream : TStringStream;

  LEmailService : IEmailService;
  LAnexoZip     : TAnexoEmail;

  LConexaoXml : IControllerConnection;
begin
  Result := TJSONObject.Create;
  LListaChaves := '';

  LConexaoXml := TControllerConection.New(DBXml).Connect;

  LNotas := TDAONotas.BuscarNotas(aDataIni, aDataFin, aCnpj);

  TLogger.Info('Notas consultadas');

  try
    if LNotas.Count = 0 then begin
      Result.AddPair('status', 'vazio');
      Exit;
    end;

    for I := 0 to LNotas.Count - 1 do begin
      LChaveStr := LNotas.Items[I].GetValue<String>('chave');
      LListaChaves := LListaChaves + QuotedStr(LChaveStr) + ',';
    end;
    LListaChaves := LListaChaves.Remove(LListaChaves.Length -1, 1);

    LZipStream := TMemoryStream.Create;
    LZipFile := TZipFile.Create;

    LQueryXml := TDAOXmlNotas.BuscarXmlPorChave(LConexaoXml, LListaChaves);

    try
      LZipFile.Open(LZipStream, zmWrite);

      if LQueryXml.IsEmpty then begin
          TLogger.Info('Não foram achados arquivos XML.');
          Result.AddPair('status', 'vazio');
          Exit;
      end;

      lQueryXml.First;
      while not LQueryXml.Eof do begin
        LChaveStr := LQueryXml.FieldByName('CHAVE').AsString;
        LES       := LQueryXml.FieldByName('E_S').AsString;
        LModelo   := LQueryXml.FieldByName('MODELO').AsString;

        if LES = 'E' then
          LPasta := 'Entradas/' + LModelo + '/'
        else
          LPasta := 'Saidas/' + LModelo + '/';

       LXmlDescompactado := TServiceDescompactador.DescompactarBlob(LQueryXml.FieldByName('ARQUIVO').AsBytes);

       LXmlStream := TStringStream.Create(LXmlDescompactado, TEncoding.UTF8);

       try
         LZipFile.Add(LXmlStream, LPasta + LChaveStr + '.xml');
       finally
         LXmlStream.Free;
       end;

       LQueryXml.Next;
      end;

      LZipFile.Close;


      // Preparar o Anexo
      LAnexoZip.NomeArquivo  := 'Notas_Processadas.zip' ;

      SetLength(LAnexoZip.ConteudoXML, LZipStream.Size);
      LZipStream.Position := 0;
      LZipStream.ReadBuffer(LAnexoZip.ConteudoXML[0], LZipStream.Size);
    finally
      LQueryXml.Free;
      LZipFile.Free;
      LZipStream.Free;
    end;

    TLogger.Info('Enviando para o E-mail ' + aEmailDestino);

    LEmailService := TServiceACBrMail.New;

    LEmailService.Enviar(
      aEmailDestino,
      'Envio de XMLs - CNPJ: ' + aCnpj,
      'Olá, segue em anexo os XMLs organizados',
      [LAnexoZip]
    );

    Result.AddPair('status', 'sucesso');
    Result.AddPair('mensagem', 'E-mail enviado com sucesso');
  finally
    LNotas.Free;
  end;
end;

end.
