unit uAddress;

interface
uses
  Classes;
  
type
  TAddress = class(TPersistent)
  protected
    fAddressString: String;
    fApartment: String;
    fBuilding : String;
    fCity: String;
    fCountryCode: String;
    fHouse: String;
    fPostCode: String;
    fSate: String;
    fStreet: String;
  published
    property AddressString: String read fAddressString write fAddressString;
    property Apartment: String read fApartment write fApartment;
    property Building : String read fBuilding write fBuilding;
    property City: String read fCity write fCity;
    property CountryCode: String read fCountryCode write fCountryCode;
    property House: String read fHouse write fHouse;
    property PostCode: String read fPostCode write fPostCode;
    property State: String read fSate write fSate;
    property Street: String read fStreet write fStreet;
  end;

implementation

end.
