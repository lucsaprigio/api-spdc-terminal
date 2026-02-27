unit Infra.Logger;

interface

uses
<<<<<<< HEAD
  System.SysUtils, System.SyncObjs, System.IOUtils, System.DateUtils;

type
  TLogger = class
  private
    class var FLock : TCriticalSection;
    class procedure SalvarLog(const AMsg: String);
  public
    class constructor Create;
    class destructor Destroy;

=======
  System.SysUtils;

type
  TLogger = class
>>>>>>> 7147a264007f536c439881626a0d5a9840d9ed63
    class procedure Info(AMsg: String);
    class procedure Erro(AMsg: String);
  end;

implementation

{ TLogger }

<<<<<<< HEAD
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
=======
class procedure TLogger.Erro(AMsg: String);
begin
  Writeln(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' [ERRO]: ' + AMsg);
>>>>>>> 7147a264007f536c439881626a0d5a9840d9ed63
end;

class procedure TLogger.Info(AMsg: String);
begin
  Writeln(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' [INFO]: ' + AMsg);
end;

<<<<<<< HEAD
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

=======
>>>>>>> 7147a264007f536c439881626a0d5a9840d9ed63
end.
