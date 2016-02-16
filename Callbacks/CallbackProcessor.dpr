program CallbackProcessor;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  Variants,
  uOperation in 'contract\uOperation.pas',
  uCommonTypes in 'contract\uCommonTypes.pas',
  uUnistreamParser in 'parser\uUnistreamParser.pas',
  uJSONParser in 'parser\uJSONParser.pas',
  uTools in 'tools\uTools.pas',
  uSimpleProcessor in 'processors\uSimpleProcessor.pas',
  uAddress in 'contract\uAddress.pas',
  uDocument in 'contract\uDocument.pas',
  uClient in 'contract\uClient.pas',
  uDocumentRef in 'contract\uDocumentRef.pas',
  uClientContext in 'contract\uClientContext.pas',
  uSecurityContext in 'contract\uSecurityContext.pas',
  uClearingContext in 'contract\uClearingContext.pas',
  uOperationTypes in 'contract\uOperationTypes.pas',
  uWebServer in 'webServer\uWebServer.pas',
  uCallbackProcessor in 'processors\uCallbackProcessor.pas',
  uRequestStages in 'contract\uRequestStages.pas',
  uConfigManager in 'configManager\uConfigManager.pas',
  uContentLink in 'contract\uContentLink.pas';

// ----------------------------------------------
// Run program as http server
// ----------------------------------------------
procedure RunServer(processor: ICallbackProcessor);
var
  server: TWebServer;
begin
  // Start HTTP server. Listenning port should be specified in config.json file
  server := TWebServer.Create(TConfigManager.GetInstance.ListenPort, processor);
  try
    server.Start;
    WriteLn('Simple callback processing server started. Press any key to stop...');
    ReadLn;
  finally
    server.Free;
  end;
end;

// ----------------------------------------------
// Run program with prepared test file
// ----------------------------------------------
procedure ProcessFile(processor: ICallbackProcessor);
var
  strData: String;
  fileName: String;
  stage: String;
begin
  // Get request file name
  fileName := ParamStr(1);

  // get stage
  stage := ParamStr(2);

  // read file into string
  strData := ReadUTF8File(fileName);

  // process request
  processor.Process(strData, stage);
  
  Readln;
end;


procedure Run;
var
  parser : IJSonParser;
  processor : ICallbackProcessor;
begin
  parser := TUnistreamParser.Create;
  processor := TSimpleProcessor.Create(parser);

  TConfigManager.GetInstance.FileName := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'config\config.json';
  TConfigManager.GetInstance.Parser := parser;

  // You can run programm in two ways:
  // - without parameters: as HTTP server. It will serve incoming callback requests untill you press any key.
  // - with 2 parameters <prepared request file name> <stage>: program will process request, stored in specified file, once.
  try
    if ParamCount < 2 then
      RunServer(processor)
    else
      ProcessFile(processor);
  finally
    TConfigManager.GetInstance.Parser := nil;
  end;
end;


// ----------------------------------------------
//
//          Program Entry point
//
// ----------------------------------------------
begin
  // Initialize random generator
  randomize;

  // Run program
  Run;
end.
