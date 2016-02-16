unit uSimpleProcessor;

interface
uses
  SysUtils, Contnrs,
  uOperation, uOperationTypes, uCallbackProcessor, uRequestStages, uContentLink,
  uCommonTypes, uConfigManager,
  uJSONParser;

type
  TSimpleProcessor = class(TInterfacedObject, ICallbackProcessor)
  private
    fParser : IJSonParser;
    fStage: TRequestStages;
    fOperation: TOperation;
    function TransferNotice: String;
    function PayoutTransfer: String;
    function CancelTransfer: String;
    function PayoutRevokedTransfer: String;
    function DefaultMethod(operType: TOperationType): String;
    function GetOperationSymbol(operType: TOperationType): String;
    function Response(const Code: string; const Number: string; documents: TObjectList): String;
    function CreateCashInOrder(const Symbol: String; documents: TObjectList): String;
    procedure AddDocument(documents: TObjectList; const Number: String);
    procedure CreateAccounting();
    function ExecuteCashInOrder(const Number: String): String;
  protected
  public
    Constructor Create(parser: IJSonParser);
    function Process(operation: TOperation; const stage: String): String; overload;
    function Process(const rawData: String; const stage: String): String; overload;
  end;

implementation

{ TSimpleProcessor }

// ---------------------------------------------------------------------
// Process operation callback from text request
// ---------------------------------------------------------------------
function TSimpleProcessor.Process(const rawData, stage: String): String;
var
  operation: TOperation;
begin
  // Parse incoming JSON request
  operation := fParser.ParseOperation(rawData);

  // Process operation;
  Result := Process(operation, stage);
end;



// ---------------------------------------------------------------------
// Process operation callback
// ---------------------------------------------------------------------
function TSimpleProcessor.Process(operation: TOperation; const stage: String): String;
var
  opType: TOperationType;
begin
  try
    WriteLn('Processing opearation. Operation type: ', operation.OperType, ', Stage: ', Stage);

    fOperation := operation;
    fStage := TryToParseRequestStage(Stage);
    opType := TryToParseOperationType(fOperation.OperType);

    case opType of
      // You can process some operation type in special way
      otPayoutTransfer        : Result := PayoutTransfer;
      otPayoutRevokedTransfer : Result := PayoutRevokedTransfer;
      otCancelTransfer        : Result := CancelTransfer;
      else
        // or process any other operation types in common way.
        Result := DefaultMethod(opType);
    end;
  except
    on E: Exception do
    begin
      WriteLn('Error while processing operation: ' + E.Message);
      raise Exception.Create(fParser.ComposeError('ERROR', e.Message));
    end;
  end;
end;


// ---------------------------------------------------------------------
// Common behaviour
// ---------------------------------------------------------------------
function TSimpleProcessor.DefaultMethod(operType: TOperationType): String;
var
  number : String;
  documents: TObjectList;
begin
  Writeln('Processing Default');
  documents := TObjectList.Create(True);

  try
    case fStage of
      rsPreAccepted:
        begin
          // At this stage you can prepare your cash documents
          // and execute other activities, connected with operation
          // Also you can return unique id (Number) in response

          // Create cash order
          Number := CreateCashInOrder(GetOperationSymbol(operType), documents);

          // Compose response in JSON format
          Result := Response('OK', Number, documents);
        end;
      rsPostConfirmed:
        begin
          // extract data from opeation (the unique Id created in "PreAccepted" stage)
          Number := fParser.GetClosureNumber(fOperation);

          if Number = '' then
            raise Exception.Create('Filed [Number] not found in Closure data');

          // Execute cash order with received number
          ExecuteCashInOrder(Number);

          // Create accounting
          CreateAccounting;

          // compose response
          Result := Response('OK', Number, nil);
        end;
    end;
  finally
    documents.Free;
  end;
end;



// ---------------------------------------------------------------------
// Process PayoutRevokedTransfer callback request
// ---------------------------------------------------------------------
function TSimpleProcessor.PayoutRevokedTransfer: String;
begin
  Writeln('Processing PayoutRevokedTransfer callback request');
end;


// ---------------------------------------------------------------------
// Process CancelTransfer callback request
// ---------------------------------------------------------------------
function TSimpleProcessor.CancelTransfer: String;
begin
  Writeln('Processing CancelTransfer request callback');

  // Just retrun "OK" Response
  Result := Response('ok', '', nil);
end;


// ---------------------------------------------------------------------
// Process PayoutTransfer callback request
// ---------------------------------------------------------------------
function TSimpleProcessor.PayoutTransfer: String;
begin
  Writeln('Processing PayoutTransfer callback request');
  Result := Response('ok', '', nil);
end;


// ---------------------------------------------------------------------
// Process TransferNotice callback request
// ---------------------------------------------------------------------
function TSimpleProcessor.TransferNotice: String;
begin
  Writeln('Processing TransferNotice');
  Result := Response('ok', '', nil);
end;


//-------------------------------------------------------------
//  Get cash symbol for given operation
//-------------------------------------------------------------
function TSimpleProcessor.GetOperationSymbol(operType: TOperationType): String;
var
  symbolTable: TKeyValue;
begin
  WriteLn('Getting operation cash symbol');

  symbolTable := TConfigManager.GetInstance.OperationSymbols;

  Result := symbolTable.GetValue(OperationTypeAsText(operType));
end;


//-------------------------------------------------------------
//  compose response data (in JSON format)
//-------------------------------------------------------------
function TSimpleProcessor.Response(const Code, Number: string; documents: TObjectList): String;
begin
  Result := fParser.ComposeResponse(Code, Number, documents);
  WriteLn('Generated response: ' + #13#10 + Result);
end;



//-------------------------------------------------------------
//  Create Cash in order
//-------------------------------------------------------------
function TSimpleProcessor.CreateCashInOrder(const Symbol: String; documents: TObjectList): String;
var
  number: String;
begin
  Writeln('Creating CashOrder with Symbol: ', Symbol);
  Number := IntToStr(Random(1000000));

  // By default, response data doesn't contains document links, but
  // you can uncomment line bellow to add sample document

  //AddDocument(documents, Number);

  Result := Number;
end;


//-------------------------------------------------------------
// Execute Cash in order
//-------------------------------------------------------------
function TSimpleProcessor.ExecuteCashInOrder(const Number: String): String;
begin
  Writeln('Executing Cash Order with number: ', Number);
end;



//-------------------------------------------------------------
// Create accounting
//-------------------------------------------------------------
procedure TSimpleProcessor.CreateAccounting;
begin
  WriteLn('Creating accounting');
end;



//-------------------------------------------------------------
//  Add document link into response data
//-------------------------------------------------------------
procedure TSimpleProcessor.AddDocument(documents: TObjectList; const Number: String);
var
  content: TContentLink;
begin
  Writeln('Adding document link');

  content := TContentLink.Create;
  content.Url := TConfigManager.GetInstance.BaseURL + '/' + Number + '.pdf';
  content.Name := 'CashOrder-' + Number;
  content.Description := 'Cash order for ' + Number;
  content.ContentType := 'application/pdf';

  documents.Add(content);
end;



constructor TSimpleProcessor.Create(parser: IJSonParser);
begin
  fParser := parser;
end;

end.
