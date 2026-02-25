unit Controller.Notas;

interface

uses
  Horse, System.JSON, Service.NotasXml, System.SysUtils, System.Classes,
  Infra.Logger;

type

 TControllerNotas = class
    class procedure PostOrganizarNotas(Req: THorseRequest; Res:THorseResponse; Next: TProc);
 end;

implementation

{ TControllerNotas }

class procedure TControllerNotas.PostOrganizarNotas(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  LBody, LRetorno: TJSONObject;
  LDataIni, LDataFin, LCnpj, LEmailDestino : String;

begin
  try
     LBody := Req.Body<TJSONObject>;

     if not Assigned(LBody) then begin
       Res.Status(400).Send('Corpo da requisição ausente.');
       Exit;
     end;

        LDataIni      := LBody.GetValue<String>('dataIni');
        LDataFin      := LBody.GetValue<String>('dataFin');
        LCnpj         := LBody.GetValue<String>('cnpj');
        LEmailDestino := LBody.GetValue<String>('emailDestino');

        TThread.CreateAnonymousThread(
          procedure
          var
            LRetornoService: TJSONObject;
          begin
            try
               LRetornoService := TServiceNotasXml.New.ProcessarEEnviarNotas(LDataIni, LDataFin, LCnpj, LEmailDestino);

               LRetornoService.Free;
            except on E: Exception do begin
               TLogger.Erro('Erro na thread de envio de XML : ' + E.Message);
            end;
            end;
          end
        ).Start;

        Res.Status(200).Send(
          TJSONObject.Create
          .AddPair('status', 'processando')
          .AddPair('mensagem', 'Os XMLs serão enviados por e-mail!')
        );

  except on E: Exception do begin
        Res.Status(400).Send(TJSONObject.Create.AddPair('erro', 'Falha ao processar: ' + E.Message));
  end;
 end;
end;
end.
