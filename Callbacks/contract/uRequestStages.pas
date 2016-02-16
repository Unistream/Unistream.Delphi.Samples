unit uRequestStages;

interface
uses
  SysUtils;

type
  TRequestStages = (
    rsPreAccepted,
    rsPostAccepted,
    rsPreConfirmed,
    rsPostConfirmed
  );

function TryToParseRequestStage(const stage: String): TRequestStages;

implementation

function TryToParseRequestStage(const stage: String): TRequestStages;
var
  stageUpper: String;
begin
  stageUpper := UpperCase(stage);
  if stageUpper = 'PREACCEPTED' then
    Result := rsPreAccepted
  else if stageUpper = 'POSTACCEPTED' then
    Result := rsPostAccepted
  else if stageUpper = 'PRECONFIRMED' then
    Result := rsPreConfirmed
  else if stageUpper = 'POSTCONFIRMED' then
    Result := rsPostConfirmed
  else
    Raise Exception.Create('Unknown processing stage: ' + stage);  
end;

end.
