unit uTools;

interface
uses
  TypInfo, Variants, Classes, SysUtils;

procedure DumpObject(instance: TObject);
function ReadUTF8File(const fileName: String): String;
function SplitString(const Source: String;  Delimeters: array of Char): TStringList;


implementation

function ReadUTF8File(const fileName: String): String;
var
  fs : TFileStream;
  src: UTF8String;
  data: WideString;
begin
  fs := TFileStream.Create(fileName, fmOpenRead);

  try
    SetLength(src, fs.Size);
    fs.Read((PUTF8String(src))^, fs.Size);
    data := UTF8Decode(src);
    if ord(data[1]) = 65279 then
      Result := Copy(data, 2, Length(data))
    else
      Result := data;
  finally
    fs.Free;
  end;
end;



procedure DumpObject(instance: TObject);
var
  cnt : Integer;
  Size: Integer;
  List : PPropList;
  PropInfo: PPropInfo;
  i : Integer;
begin
  cnt := GetPropList(instance.ClassInfo, tkAny, nil);
  writeln('Properties count: ', cnt);
  Size := cnt * SizeOf(Pointer);
  GetMem(List, Size);
  try
    cnt := GetPropList(instance.ClassInfo, tkAny, List);
    for i := 0 to cnt-1 do
    begin
      PropInfo := List^[i];
      writeln(PropInfo^.Name, ' : ', VarToStr(GetPropValue(Instance, PropInfo^.Name)));
    end;
  finally
    FreeMem(List);
  end;
end;

function SplitString(const Source: String;  Delimeters: array of Char): TStringList;
var
  i : Integer;
  currVal: String;
begin
  Result := TStringList.Create;
  currVal := Source;

  for i:=Low(Delimeters) to High(Delimeters) do
    currVal := StringReplace(currVal, Delimeters[i], #13#10, [rfReplaceAll]);

  Result.Text := currVal;
end;


end.
