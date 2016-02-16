unit uCallbackProcessor;

interface
uses
  uOperation;
  
type
  ICallbackProcessor = interface
    function Process(operation: TOperation; const stage: String): String; overload;
    function Process(const rawData: String; const stage: String): String; overload;
  end;

implementation

end.
