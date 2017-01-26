(function () {

  if (WScript.Arguments.Length != 1) {
    WScript.Echo("Usage: url.js <url>?parameter=value&also=another")
    WScript.Quit(1)
  }

  var url = WScript.Arguments(0)

    try {
      // Create the WinHTTPRequest ActiveX Object.
      var WinHttpReq = new ActiveXObject("WinHttp.WinHttpRequest.5.1");

      //  Create an HTTP request.
      var temp = WinHttpReq.Open("PUT", url, false); //"PUT"

      //  Send the HTTP request.
      WinHttpReq.Send();

      // Wait for the entire response.
      WinHttpReq.WaitForResponse();

      //  Retrieve the response text.
      //var strResult = WinHttpReq.ResponseText;
      //var Status = WinHttpReq.Status;
      //var statusText = WinHttpReq.statusText;

    } catch (objError) {
      var strResult = objError + "\n"
        strResult += "WinHTTP returned error: " +
        (objError.number & 0xFFFF).toString() + "\n\n";
      strResult += objError.description;
      WScript.Echo(strResult);
      WScript.Quit(1);
    }

  //WScript.Echo("Status - " + WinHttpReq.Status);
  //WScript.Echo("statusText - " + WinHttpReq.statusText);
  //WScript.Echo("ResponseText - " + WinHttpReq.ResponseText);

  if (WinHttpReq.Status == 200 && WinHttpReq.ResponseText == "OK") {
    WScript.Quit(0)
  } else {
    WScript.Quit(1);
  }

  //WScript.Echo(getText("http://localhost:8080/test?parameter=value&also=another"));

})();
