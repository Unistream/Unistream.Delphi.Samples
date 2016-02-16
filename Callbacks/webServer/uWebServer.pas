unit uWebServer;

interface
uses
  SysUtils, Classes,
  IdBaseComponent, IdComponent, IdTCPServer, IdHTTPServer,
  uTools,
  uCallbackProcessor;

type
  TWebServer = class
  private
    fServer: TIdHTTPServer;
    fProcessor: ICallbackProcessor;
    procedure CommandGet(AThread: TIdPeerThread; RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
    procedure OnGET(RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
    procedure OnPOST(RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
  public
    Constructor Create(port: Integer; processor: ICallbackProcessor);
    Destructor Destroy; override;
    Procedure Start;
    Procedure Stop;
  end;

implementation

{ TWebServer }

procedure TWebServer.CommandGet(AThread: TIdPeerThread;  RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
begin
  if RequestInfo.Command = 'GET' then
    onGET(RequestInfo, ResponseInfo)
  else if RequestInfo.Command = 'POST' then
    onPOST(RequestInfo, ResponseInfo);
end;

constructor TWebServer.Create(port: Integer; processor: ICallbackProcessor);
begin
  fProcessor := processor;

  fServer := TIdHTTPServer.Create(nil);
  fServer.DefaultPort := port;
  fServer.OnCommandGet := CommandGet;
  fServer.ServerSoftware := 'UnistreamSimpleServer';
end;

destructor TWebServer.Destroy;
begin
  Stop;
  fServer.Free;
  inherited;
end;

procedure TWebServer.OnGET(RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
var
  fileName: String;
begin
  // Process HTTP GET request

  if RequestInfo.Document <> '/' then
  begin
    fileName := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'data\sample.pdf';
    ResponseInfo.ContentType := 'application/pdf';
    ResponseInfo.ContentStream := TFileStream.Create(fileName, fmOpenRead);
    ResponseInfo.ContentLength := ResponseInfo.ContentStream.Size;
    ResponseInfo.WriteHeader;
    ResponseInfo.WriteContent;
    ResponseInfo.ContentStream.Free;
    ResponseInfo.ContentStream := nil;
    exit;
  end;
  
  ResponseInfo.ContentType := 'text/html; charset=windows-1251';
  ResponseInfo.ContentText := '<html>Simple callback processor</html>';
end;

procedure TWebServer.OnPOST(RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
var
  path: TStringList;
  request: String;
  response: String;
  method : String;
begin
  path := SplitString(RequestInfo.Document, ['\', '/']);
  path.Delimiter := '/';

  try
    method := '';
    if path.Count > 0 then
      method := path[path.Count-1];

    request := UTF8Decode(RequestInfo.UnparsedParams);

    ResponseInfo.ContentType := 'application/json';
    try
      response := fProcessor.Process(request, method);
      ResponseInfo.ContentText := UTF8Encode(response);
    except
      on E: Exception do
      begin
        ResponseInfo.ContentText := UTF8Encode(e.Message);
        ResponseInfo.ResponseNo := 500;
      end;
    end;
  finally
    path.Free;
  end;
end;

procedure TWebServer.Start;
begin
  fServer.Active := True;
end;

procedure TWebServer.Stop;
begin
  fServer.Active := False;
end;

end.
