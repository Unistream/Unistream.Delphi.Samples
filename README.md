# Callback processor

This is a simple example implementation of Unistream callback requests processor. 
It's a console application with HTTP server that listens for POST requests

## Compile
This project created in Delphi 6, but it should compile in later versions of Delphi with small essential changes.

## Running
You can run application in two modes:

* HTTP Server: run application without parameters. It will start HTTP server at port, specified in config file (./config/config.json)
* Test mode: run application with two parameters: <TestDataFile> <stage>. It will process request, stored in file "TestDataFile" with specified stage. 
For example: CallbackProcessor.exe ".///test/json/CashToCard.PreAccepted.json" PreAccepted

## Configuration
Configuration is a file in JSON format 
<pre><code>
{
	"operationSymbols": [
		{"Key": "CashToCard", "Value": "31"},
		{"Key": "WireTransfer", "Value": "32"},
		{"Key": "Allods", "Value": "33"},
		{"Key": "AnyOther", "Value": "34"},
	],
	"baseUrl": "http://127.0.0.1:12345",
	"listenPort": 12345
}
</pre></code>

Description: 
* **operationSybols**: This is an array of key/value pairs. You can use it for detecting correct Cash operation symbol for corresponding operation type
* **baseUrl**: Base part for constructing external link to documents in responses.
* **lisetnPort**: HTTP Server listenning port
