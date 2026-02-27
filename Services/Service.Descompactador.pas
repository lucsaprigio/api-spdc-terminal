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
<<<<<<< HEAD
  try
   try
    // Prepara o decompression para o Blob Original
    LDecompressionStream := TZDecompressionStream.Create(LInput);
=======

  try
    // Prepara o decompression para o Blob Original
    LDecompressionStream := TZDecompressionStream.Create(LInput);

>>>>>>> 7147a264007f536c439881626a0d5a9840d9ed63
    try
      LOutput.CopyFrom(LDecompressionStream, 0);

      Result := TEncoding.UTF8.GetString(LOutput.Bytes, 0, LOutput.Size);
    finally
      LDecompressionStream.Free;
    end;
<<<<<<< HEAD

   except on E: EZDecompressionError do
   begin
     Result := TEncoding.UTF8.GetString(ABytes);

     if not Result.Contains('<') then
      Result := '';
   end;
   on E:Exception do
   begin
     Result := '';
   end;
  end;

=======
>>>>>>> 7147a264007f536c439881626a0d5a9840d9ed63
  finally
    LInput.Free;
    LOutput.Free;
  end;
end;

end.
