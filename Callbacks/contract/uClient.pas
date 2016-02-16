unit uClient;

interface
uses
  Classes,Contnrs,
  uAddress, uDocument;

type
  TClient = class(TPersistent)
  protected
    fId: String;
    fCountryOfResidence: String;
    fFirstName: String;
    fLastName: String;
    fMiddleName: String;
    fGender: Integer;
    fBirthPlace: String;
    fBirthDate: String;
    fPhoneNumber: String;
    fTaxPayerIIN : String;
    fAddress: TAddress;
    fDocuments: TObjectList;
    fSource: String;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Id: String read fId write fId;
    property CountryOfResidence: String read fCountryOfResidence write fCountryOfResidence;
    property FirstName: String read fFirstName write fFirstName;
    property LastName: String read fLastName write fLastName;
    property MiddleName: String read fMiddleName write fMiddleName;
    property Gender: Integer read fGender write fGender;
    property BirthPlace: String read fBirthPlace write fBirthPlace;
    property BirthDate: String read fBirthDate write fBirthDate;
    property PhoneNumber: String read fPhoneNumber write fPhoneNumber;
    property TaxpayerIndividualIdentificationNumber : String read fTaxPayerIIN write fTaxPayerIIN;
    property Address: TAddress read fAddress;
    property Documents: TObjectList read fDocuments;
    property Source: String read fSource write fSource;
  end;

implementation

{ TClient }

constructor TClient.Create;
begin
  fDocuments := TObjectList.Create(True);
  fAddress := TAddress.Create;
end;


destructor TClient.Destroy;
begin
  fDocuments.Free;
  inherited;
end;

end.
