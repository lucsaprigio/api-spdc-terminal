unit Infra.Logger;

interface

uses
  System.SysUtils, System.SyncObjs, System.IOUtils, System.DateUtils;

type
  TLogger = class
  private
    class var FLock : TCriticalSection;
    class procedure SalvarLog(const AMsg: String);
  public
    class constructor Create;
    class destructor Destroy;

    class procedure Info(AMsg: String);
    class procedure Erro(AMsg: String);
  end;

implementation

{ TLogger }

class constructor TLogger.Create;
begin
    FLock := TCriticalSection.Create;
end;

class destructor TLogger.Destroy;
begin
    FLock.Free;
end;

class procedure TLogger.Erro(AMsg: String);
var
  LLinha: string;
begin
    
  
 LLinha := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' [ERRO]: ' + AMsg;

 Writeln(LLinha);
 SalvarLog(LLinha);
end;

class procedure TLogger.Info(AMsg: String);
begin
  Writeln(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' [INFO]: ' + AMsg);
end;

class procedure TLogger.SalvarLog(const AMsg: String);
var
  LCaminho, LPastaLogs: string;
  LArquivo : TextFile;
  LTime    : String;
begin
  FLock.Enter;

  try
    LPastaLogs := TPath.Combine(ExtractFilePath(ParamStr(0)), 'logs');

    if not DirectoryExists(LPastaLogs) then 
      ForceDirectories(LPastaLogs);

    LTime := FormatDateTime( 'yyyy-mm-dd', now);  
    LCaminho := TPath.Combine(LPastaLogs, LTime + '.log');

    AssignFile(LArquivo, LCaminho);

    if FileExists(LCaminho) then
      Append(LArquivo)
    else
      Rewrite(LArquivo);

    try
      Writeln(LArquivo, AMsg);
    finally
      CloseFile(LArquivo);
    end;
  finally
     FLock.Leave;
  end;
end;

end.
