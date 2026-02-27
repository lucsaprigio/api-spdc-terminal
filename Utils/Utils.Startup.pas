unit Utils.Startup;

interface

uses
 System.Win.Registry, Winapi.Windows, System.SysUtils;

type
  TUtilsStartup = class
    class procedure RegistrarStartupWindows;
  end;

implementation

{ TUtilsStartup }

class procedure TUtilsStartup.RegistrarStartupWindows;
var
  LReg : TRegistry;
  LPathExe : string;
begin
  LReg := TRegistry.Create(KEY_WRITE);

  try
    LReg.RootKey := HKEY_CURRENT_USER;
  if LReg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', True) then
  begin
     LPathExe := ParamStr(0);

     LReg.WriteString('ApiSpdcTerminal', LPathExe);

     LReg.CloseKey;
  end;
  finally
    LReg.Free;
  end;
end;

end.
