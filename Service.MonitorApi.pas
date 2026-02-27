unit Service.MonitorApi;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.SvcMgr,
  Vcl.Dialogs,
  Winapi.ShellAPI,
  TlHelp32,
  Vcl.ExtCtrls;

type
  TMonitorAPI = class(TService)
    Timer: TTimer;
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure TimerTimer(Sender: TObject);
  private
    function VerificarProcesso(const ANomeExe: string):Boolean;
    procedure IniciarAPI;
  public
    function GetServiceController: TServiceController; override;
  end;

var
  MonitorAPI: TMonitorAPI;

implementation

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  MonitorAPI.Controller(CtrlCode);
end;

function TMonitorAPI.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TMonitorAPI.IniciarAPI;
var
  LPathExe : String;
begin
  LPathExe := 'C:\SpdcAPI\ApiSpdc.exe';

  if FileExists(LPathExe) then begin
    ShellExecute(0, 'open', PChar(LPathExe), nil, PChar(ExtractFilePath(LPathExe)), SW_HIDE);
  end;
end;

procedure TMonitorAPI.ServiceStart(Sender: TService; var Started: Boolean);
begin
      Timer.Enabled := True;
      Started       := True;
end;

procedure TMonitorAPI.TimerTimer(Sender: TObject);
begin
    Timer.Enabled := False;

    try
      if not VerificarProcesso('ApiSpdc.exe') then begin
        IniciarAPI;
      end;
    finally
       Timer.Enabled := True;
    end;
end;

function TMonitorAPI.VerificarProcesso(const ANomeExe: string): Boolean;
var
  LSnapshot : THandle;
  LProcess  : TProcessEntry32;
begin
    Result := False;

    // Lista os processos rodando no windows no momento.
    LSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

    if LSnapshot <> INVALID_HANDLE_VALUE then begin
    try
      LProcess.dwSize := SizeOf(LProcess);
      if Process32First(LSnapshot, LProcess) then begin
        repeat
          if SameText(ExtractFileName(LProcess.szExeFile), ANomeExe) then begin
            Result := True;
            Break;
          end;
        until not Process32Next(LSnapshot, LProcess);
      end;
    finally
      CloseHandle(LSnapshot);
    end;
    end;

end;

end.
