unit uOperation;

interface
uses
  Classes, Contnrs,
  uAddress, uClient, uClientContext, uSecurityContext, uClearingContext;

type
  TOperation = class(TPersistent)
  protected
    fClient: TClient;
    fClientContext: TClientContext;
    fSecurityContext: TSecurityContext;
    fData : String;
    fId: String;
    fType : String;
    fStatus: String;
    fStatusMessage: String;
    fTitle: String;
    fLegend: String;
    fDataErrors: String;
    fSignDocument: String;
    fDocuments: TStringList;
    fClearingContext: TClearingContext;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Client: TClient read fClient write fClient;
    property ClientContext: TClientContext read fClientContext;
    property SecurityContext: TSecurityContext read fSecurityContext;
    property Data: String read fData write fData;
    property Id: String read fId write fId;
    property OperType : String read fType write fType;
    property Status: String read fStatus write fStatus;
    property StatusMessage: String read fStatusMessage write fStatusMessage;
    property Title: String read fTitle write fTitle;
    property Legend: String read fLegend write fLegend;
    property DataErrors: String read fDataErrors write fDataErrors;
    property SignDocument: String read fSignDocument write fSignDocument;
    property Documents: TStringList read fDocuments write fDocuments;
    property ClearingContext: TClearingContext read fClearingContext;
  end;

implementation

{ TOperation }

constructor TOperation.Create;
begin
  fClient := TClient.Create;
  fClientContext := TClientContext.Create;
  fSecurityContext := TSecurityContext.Create;
  fClearingContext := TClearingContext.Create;
  fDocuments := TStringList.Create;
end;

destructor TOperation.Destroy;
begin
  fClient.Free;
  fClientContext.Free;
  fSecurityContext.Free;
  fClearingContext.Free;
  fDocuments.Free;
  inherited;
end;

end.
