unit uOperationTypes;

interface
uses
  SysUtils;

type
  TOperationType = (
    otUnknown,
    otCashToCard,
    otHomeMoney,
    otPayoutTransfer,
    otPayoutRevokedTransfer,
    otCancelTransfer,
    otSwiftTransfer,
    otTransfer,
    otWireTransfer
  );

function TryToParseOperationType(const StrType: String): TOperationType;
function OperationTypeAsText(operType: TOperationType): String;

implementation

function TryToParseOperationType(const StrType: String): TOperationType;
var
  typeUpper: String;
begin
  typeUpper := UpperCase(StrType);

  if typeUpper = 'CASHTOCARD' then
    Result := otCashToCard
  else if typeUpper = 'HOMEMONEY' then
    Result := otHomeMoney
  else if typeUpper = 'PAYOUTTRANSFER' then
    Result := otPayoutTransfer
  else if typeUpper = 'PAYOUTREVOKEDTRANSFER' then
    Result := otPayoutRevokedTransfer
  else if typeUpper = 'SWIFTTRANSFER' then
    Result := otSwiftTransfer
  else if typeUpper = 'TRANSFER' then
    Result := otTransfer
  else if typeUpper = 'WIRETRANSFER' then
    Result := otWireTransfer
  else
    raise Exception.Create('Unknown operation type: ' + StrType);
end;

function OperationTypeAsText(operType: TOperationType): String;
begin
  case operType of
    otUnknown        : Result := 'UNKNOWN';
    otCashToCard     : Result := 'CashToCard';
    otHomeMoney      : Result := 'HomeMoney';
    otPayoutTransfer : Result := 'PayoutTransfer';
    otSwiftTransfer  : Result := 'SwiftTransfer';
    otTransfer       : Result := 'Transfer';
    otWireTransfer   : Result := 'WireTransfer';
    otPayoutRevokedTransfer : Result := 'PayoutRevokedTransfer';
  end;
end;

end.
