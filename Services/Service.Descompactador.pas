unit Service.Descompactador;

interface

uses
  System.SysUtils, System.ZLib, System.Classes;
type
  TServiceDescompactador = class
    class function DescompactarBlob(const ABytes: TBytes): string;
  end;

implementation

{ TServiceDescompactador }

class function TServiceDescompactador.DescompactarBlob(const ABytes: TBytes): string;
var
  LInput, LOutput: TBytesStream;
  LDecompressionStream : TZDecompressionStream;
begin
  if Length(ABytes) = 0 then Exit('');

  LInput  := TBytesStream.Create(ABytes);
  LOutput := TBytesStream.Create;

  try
    // Prepara o decompression para o Blob Original
    LDecompressionStream := TZDecompressionStream.Create(LInput);

    try
      LOutput.CopyFrom(LDecompressionStream, 0);

      Result := TEncoding.UTF8.GetString(LOutput.Bytes, 0, LOutput.Size);
    finally
      LDecompressionStream.Free;
    end;
  finally
    LInput.Free;
    LOutput.Free;
  end;
end;

end.
