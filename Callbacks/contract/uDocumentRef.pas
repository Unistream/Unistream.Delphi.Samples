unit uDocumentRef;

interface
uses
  Classes;
  
type
  TDocumentRef = class(TPersistent)
  protected
    fSeries: String;
    fNumber: String;
  published
    property Series : String read fSeries write fSeries;
    property Number : string read fNumber write fNumber;
  end;

implementation

end.
