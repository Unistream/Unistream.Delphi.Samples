unit uDocument;

interface
uses
  Classes;
  
type
  TDocument = class(TPersistent)
  protected
    fExpiryDate : String;
    fExtraValues: String;
    fIssueDate: String;
    fIssuer: String;
    fIssuerDepartmentCode: String;
    fNumber: String;
    fSeries: String;
    fType: Integer;
  published
    property ExpiryDate : String read fExpiryDate write fExpiryDate;
    property ExtraValues: String read fExtraValues write fExtraValues;
    property IssueDate: String read fIssueDate write fIssueDate;
    property Issuer: String read fIssuer write fIssuer;
    property IssuerDepartmentCode: String read fIssuerDepartmentCode write fIssuerDepartmentCode;
    property Number: String read fNumber write fNumber;
    property Series: String read fSeries write fSeries;
    property TypeCode: Integer read fType write fType;
  end;

implementation

end.
