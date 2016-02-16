unit uContentLink;

interface
uses
  Classes, SysUtils;

type
  TContentLink = class(TPersistent)
  protected
    fUrl: String;
    fName : String;
    fDescription: String;
    fContentType: String;
  published
    property Url: String read fUrl write fUrl;
    property Name : String read fName write fName;
    property Description: String read fDescription write fDescription;
    property ContentType: String read fContentType write fContentType;
  end;
implementation

end.
