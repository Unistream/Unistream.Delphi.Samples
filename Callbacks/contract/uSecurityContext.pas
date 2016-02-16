unit uSecurityContext;

interface
uses
  Classes;

type
  TSecurityContext = class(TPersistent)
  protected
    fAgentId: Integer;
    fBankId : Integer;
    fCashierId : Integer;
    fCashWindow: Integer;
    fCashierUniqueId: String;
    fCashierLogin: String;
  published
    property AgentId: Integer read fAgentId write fAgentId;
    property BankId : Integer read fBankId write fBankId;
    property CashierId : Integer read fCashierId write fCashierId;
    property CashWindow: Integer read fCashWindow write fCashWindow;
    property CashierUniqueId: String read fCashierUniqueId write fCashierUniqueId;
    property CashierLogin: String read fCashierLogin write fCashierLogin;
  end;
  
implementation

end.
