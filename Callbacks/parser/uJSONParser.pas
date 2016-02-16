unit uJSONParser;

interface
uses
  Contnrs,
  uOperation,
  uCommonTypes;

type

  IJSonParser = interface
    function ParseOperation(const src: String): TOperation;
    function ComposeResponse(const Code: string; const Number: string; documents: TObjectList): String;
    function ComposeError(const Code: string; const Msg: string): String;
    function GetClosureNumber(operation: TOperation):String;
    function GetStringData(const data: String; const Path: String): String;
    function GetIntData(const data: String; const Path: String): Integer;
    function GetOperationSymbols(const data: String): TKeyValue;
  end;

implementation

end.
