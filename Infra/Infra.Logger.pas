unit Infra.Logger;

interface

uses
  System.SysUtils;

type
  TLogger = class
    class procedure Info(AMsg: String);
    class procedure Erro(AMsg: String);
  end;

implementation

{ TLogger }

class procedure TLogger.Erro(AMsg: String);
begin
  Writeln(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' [ERRO]: ' + AMsg);
end;

class procedure TLogger.Info(AMsg: String);
begin
  Writeln(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' [INFO]: ' + AMsg);
end;

end.
