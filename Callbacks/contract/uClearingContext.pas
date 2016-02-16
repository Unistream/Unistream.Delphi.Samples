unit uClearingContext;

interface
uses
  Classes;

type
  TClearingContext = class(TPersistent)
  protected
    fAgentFee: double;
    fAgentFeeCurrency: String;
    fAmount: double;
    fClearingRef: String;
    fCurrency: String;
    fTotalFee: double;
    fTotalFeeCurrency: String;
  published
    property AgentFee: double read fAgentFee write fAgentFee;
    property AgentFeeCurrency: String read fAgentFeeCurrency write fAgentFeeCurrency;
    property Amount: double read fAmount write fAmount;
    property ClearingRef: String read fClearingRef write fClearingRef;
    property Currency: String read fCurrency write fCurrency;
    property TotalFee: double read fTotalFee write fTotalFee;
    property TotalFeeCurrency: String read fTotalFeeCurrency write fTotalFeeCurrency;
  end;

implementation

end.
