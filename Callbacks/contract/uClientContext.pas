unit uClientContext;

interface
uses
  Classes, Contnrs;

type
  TClientContext = class(TPersistent)
  protected
    fClientId: String;
    fDocuments: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property ClientId: String read fClientId write fClientId;
    property Documents: TObjectList read fDocuments;
  end;

implementation

{ TClientContext }

constructor TClientContext.Create;
begin
  fDocuments := TObjectList.Create(True);
end;

destructor TClientContext.Destroy;
begin
  fDocuments.Free;
  inherited;
end;


end.
