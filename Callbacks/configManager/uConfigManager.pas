unit uConfigManager;

interface
uses
  Classes, SysUtils,
  uJSONParser, uTools,
  uCommonTypes;

type
  TConfigManager = class
  private
    fParser: IJSonParser;
    fFileName: String;
    fData: String;
    function GetOperationSymbols: TKeyValue;
    function GetBaseUrl: String;
    function GetListenPort: Integer;
    procedure SetFileName(const Value: String);
    Constructor Create();
  public
    class function GetInstance: TConfigManager;

    property Parser: IJSonParser read fParser write fParser;
    property FileName: String read fFileName write SetFileName;
    property OperationSymbols: TKeyValue read GetOperationSymbols;
    property ListenPort: Integer read GetListenPort;
    property BaseURL: String read GetBaseUrl;
  end;

implementation

var
  configuratorInstance: TConfigManager;
{ TConfigManager }

constructor TConfigManager.Create();
begin
  fFileName := FileName;
end;

function TConfigManager.GetBaseUrl: String;
begin
  Result := fParser.GetStringData(fData, 'baseUrl');
end;

class function TConfigManager.GetInstance: TConfigManager;
begin
  if configuratorInstance = nil then
    configuratorInstance := TConfigManager.Create;

  Result := configuratorInstance;
end;

function TConfigManager.GetListenPort: Integer;
begin
  Result := fParser.GetIntData(fData, 'listenPort');
end;

function TConfigManager.GetOperationSymbols: TKeyValue;
begin
  Result := fParser.GetOperationSymbols(fData);
end;

procedure TConfigManager.SetFileName(const Value: String);
begin
  fFileName := Value;
  fData := ReadUTF8File(fileName);
end;

end.
