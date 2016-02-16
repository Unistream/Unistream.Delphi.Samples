unit uUnistreamParser;

interface
uses
  SysUtils, Classes, TypInfo, Contnrs,
  uOperation, uAddress, uDocument, uClient, uDocumentRef, uClientContext, uSecurityContext, uClearingContext, uContentLink,
  uJSONParser, uTools, uCommonTypes,
  superobject;

type
  EParserException = class(Exception);

  TUnistreamParser = class(TInterfacedObject, IJSonParser)
  private
    procedure MapData(instance: TObject; data: ISuperObject);
    procedure MapClient(client: TClient; data: ISuperObject);
    procedure MapClientAddress(clientAddress: TAddress; data: ISuperObject);
    procedure MapClientDocuments(client: TClient; data: ISuperObject);
    procedure MapClientContext(clientContext: TClientContext; data: ISuperObject);
    procedure MapOperation(operation: TOperation; data: ISuperObject);
    procedure MapSecurityContext(context:TSecurityContext; data: ISuperObject);
    procedure MapClearingContext(context: TClearingContext; data: ISuperObject);
    procedure MapDocuments(documents: TStringList; data: ISuperObject);
  public
    function ParseOperation(const src: String): TOperation;
    function ComposeResponse(const Code: string; const Number: string; documents: TObjectList): String;
    function ComposeError(const Code: string; const Msg: string): String;
    function GetClosureNumber(operation: TOperation):String;
    function GetStringData(const data: String; const Path: String): String;
    function GetIntData(const data: String; const Path: String): Integer;
    function GetOperationSymbols(const data: String): TKeyValue;
  end;

implementation

{ TUnistreamParser }

// -----------------------------------------------------------------------
// Fill data from JSON for matched published properties of instance
// -----------------------------------------------------------------------
procedure TUnistreamParser.MapData(instance: TObject; data: ISuperObject);
var
  cnt     : Integer;
  size    : Integer;
  list    : PPropList;
  propInfo: PPropInfo;
  propName: String;
  i       : Integer;
begin
  cnt := GetPropList(instance.ClassInfo, tkAny, nil);
  size := cnt * SizeOf(Pointer);
  GetMem(list, size);

  try
    cnt := GetPropList(instance.ClassInfo, tkAny, list);

    for i := 0 to cnt-1 do
    begin
      propInfo := list^[i];
      propName := propInfo^.Name;

      case propInfo^.PropType^.Kind of
        tkInteger:
          SetPropValue(instance, propName, data.I[propName]);
        tkFloat:
          SetPropValue(instance, propName, data.D[propName]);
        tkString, tkLString:
          begin
            if (data[propName] = nil) or (data.S[propName] = 'null') then
              SetPropValue(instance, propName, '')
            else
              SetPropValue(instance, propName, data.S[propName]);;
          end;
      end;
    end;
  finally
    FreeMem(list);
  end;
end;


procedure TUnistreamParser.MapClearingContext(context: TClearingContext;  data: ISuperObject);
begin
  if data = nil then exit;
  MapData(context, data);
end;

procedure TUnistreamParser.MapClient(client: TClient; data: ISuperObject);
begin
  if data = nil then exit;
  with client do
  begin
    MapData(client, data);
    MapClientAddress(Address, data['Address']);
    MapClientDocuments(client, data['Documents']);
  end;
end;

procedure TUnistreamParser.MapClientAddress(clientAddress: TAddress;  data: ISuperObject);
begin
  if data = nil then exit;
  MapData(clientAddress, data);
end;

procedure TUnistreamParser.MapClientContext(clientContext: TClientContext;  data: ISuperObject);
var
  cnt, i: Integer;
  docRef : TDocumentRef;
  jsDocRef : ISuperObject;
begin
  if data = nil then exit;

  clientContext.ClientId := data.S['ClientId'];

  cnt := data['Documents'].AsArray.Length;
  for i := 0 to cnt-1 do
  begin
    docRef := TDocumentRef.Create;
    jsDocRef := data['Documents'].AsArray[i];
    MapData(docRef, jsDocRef);
    clientContext.Documents.Add(docRef);
  end;
end;

procedure TUnistreamParser.MapClientDocuments(client: TClient;  data: ISuperObject);
var
  i          : Integer;
  cnt        : Integer;
  document   : TDocument;
  jsDocument : ISuperObject;
begin
  if data = nil then exit;

  cnt := data.AsArray.Length;

  for i := 0 to cnt-1 do
  begin
    document := TDocument.Create;
    jsDocument := data.AsArray[i];
    with document do
    begin
      MapData(document, jsDocument);
      TypeCode := jsDocument.I['Type'];
      client.Documents.Add(document);
    end;
  end;
end;

procedure TUnistreamParser.MapDocuments(documents: TStringList;  data: ISuperObject);
var
  i : Integer;
begin
  if data = nil then exit;

  for i := 0 to data.AsArray.Length - 1 do
    documents.Add(data.AsArray[i].AsString);
end;

procedure TUnistreamParser.MapOperation(operation: TOperation; data: ISuperObject);
begin
  MapData(operation, data);

  // in Delphi we cannot use "Type" for field name, so we have to map such fields directly
  operation.OperType := data.S['Type'];

  // map inner types
  MapClient(operation.Client, data['Client']);
  MapClientContext(operation.ClientContext, data['ClientContext']);
  MapSecurityContext(operation.SecurityContext, data['SecurityContext']);
  MapClearingContext(operation.ClearingContext, data['ClearingContext']);
  MapDocuments(operation.Documents, data['Documents']);
end;

procedure TUnistreamParser.MapSecurityContext(context: TSecurityContext;  data: ISuperObject);
begin
  if data = nil then exit;
  MapData(context, data);
end;

function TUnistreamParser.ParseOperation(const src: String): TOperation;
var
  jsData: ISuperObject;
begin
  Result := TOperation.Create;
  jsData := SO[src];

  if jsData = nil then
    raise EParserException.Create('Can''t parse file.');

  MapOperation(Result, jsData);
end;

function TUnistreamParser.ComposeResponse(const Code,  Number: string; documents: TObjectList): String;
var
  jsData: ISuperObject;
  i : Integer;
  document: TContentLink;
  jsDocument: ISuperObject;
begin
  jsData := TSuperObject.Create;
  jsData.S['Code'] := Code;

  if Number <> '' then
    jsData.S['Closure.Number'] := Number;

  if (documents <> nil) and (documents.Count > 0) then
    for i := 0 to documents.Count-1 do
    begin
      document := TContentLink(documents[i]);
      jsDocument := TSuperObject.Create;
      jsDocument.S['Url'] := document.Url;
      jsDocument.S['Name'] := document.Name;
      jsDocument.S['Description'] := document.Description;
      jsDocument.S['ContentType'] := document.ContentType;
      jsData['ContentLinks[]'] := jsDocument;
    end;

  Result := jsData.AsJSon(True);
end;

function TUnistreamParser.ComposeError(const Code, Msg: string): String;
var
  jsData: ISuperObject;
begin
  jsData := TSuperObject.Create;
  jsData.S['Code'] := Code;
  jsData.S['Message'] := Msg;
  Result := jsData.AsJSon(True);
end;

function TUnistreamParser.GetClosureNumber(operation: TOperation): String;
var
  jsData: ISuperObject;
begin
  Result := '';
  jsData := SO[operation.Data];

  if jsData = nil then exit;
  Result := jsData.S['Closure.Number'];
end;

function TUnistreamParser.GetStringData(const data, Path: String): String;
var
  jsData: ISuperObject;
begin
  jsData := SO[data];

  if jsData = nil then
    raise Exception.Create('Can''t parse config file');

  Result := jsData.S[Path];
end;

function TUnistreamParser.GetOperationSymbols(const data: String): TKeyValue;
var
  jsData: ISuperObject;
  i: Integer;
  symbolTable : ISuperObject;
begin
  Result := nil;

  jsData := SO[data];

  if jsData = nil then
    raise Exception.Create('Can''t parse config file');

  symbolTable := jsData['operationSymbols'];

  if symbolTable = nil then exit;

  Result := TKeyValue.Create;

  for i := 0 to symbolTable.AsArray.Length-1 do
    Result.Add(symbolTable.AsArray[i].S['Key'], symbolTable.AsArray[i].S['Value']);
end;

function TUnistreamParser.GetIntData(const data, Path: String): Integer;
var
  jsData: ISuperObject;
begin
  jsData := SO[data];

  if jsData = nil then
    raise Exception.Create('Can''t parse config file');

  Result := jsData.I[Path];
end;

end.
