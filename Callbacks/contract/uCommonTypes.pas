unit uCommonTypes;

interface
uses
  Classes, SysUtils;

type
  TKeyValue = class
  private
    fList : TStringList;
    fCaseSensitive: Boolean;
    function getKeyName(const Key: String): String;
  public
    constructor Create;
    destructor Destroy; override;
    property CaseSensitive: Boolean read fCaseSensitive write fCaseSensitive;
    procedure Add(const Key, Value :String);
    function GetValue(const Key: String): String;
  end;

implementation
const
  NameValueSeparator = '=';
{ TKeyValue }

procedure TKeyValue.Add(const Key, Value: String);
var
  index : Integer;
  keyName : String;
begin
  keyName := getKeyName(Key);
  index := fList.IndexOfName(KeyName);

  if index = -1 then
     fList.Add(KeyName + NameValueSeparator + Value)
  else
     fList[index] := KeyName + NameValueSeparator + Value;
end;

constructor TKeyValue.Create;
begin
  fList := TStringList.Create;
end;

destructor TKeyValue.Destroy;
begin
  fList.Free;
  inherited;
end;

function TKeyValue.getKeyName(const Key: String): String;
begin
  Result := Key;

  if fCaseSensitive then
    Result := AnsiUpperCase(Result);
end;

function TKeyValue.GetValue(const Key: String): String;
var
  keyName : String;
begin
  keyName := getKeyName(Key);

  if fList.IndexOfName(KeyName) = -1 then
    raise Exception.Create(Format('Key [%s] not found.', [KeyName]));

  Result := fList.Values[KeyName];
end;

end.
