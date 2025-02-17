/************************************************************************************************
   PROC HTTP BASICS
   This program demonstrates the basic functionality of PROC HTTP 
    Primary Syntax: DATA step
    SAS Versions: SAS 9, SAS Viya
    Documentation: https://go.documentation.sas.com/doc/en/pgmsascdc/default/proc/n0bdg5vmrpyi7jn1pbgbje2atoov.htm
************************************************************************************************/

/************************************************************************************************
 1. A simple GET request:
    A GET request asks the API server to return a specified resource to the requestor.
************************************************************************************************/
filename resp TEMP;              /*a*/

proc http
   url="http://httpbin.org/get"  /*b*/
   out=resp;                     /*c*/
run;

data _null_;                     /*d*/
   rc = jsonpp('resp','log');
run;

filename resp clear;             /*e*/

/************************************************************************************************
 1. A simple GET request
    a. Assign the fileref "resp" to a TEMP file to receive the response from the server. A TEMP 
       file is automatically deleted when the fileref is cleared.
    b. httpbin.org is a simple HTTP request & response service that can freely be used for testing.
       the /get indicates this is a GET request.
    c. Specifies the server response should be stored in the temp file "resp".
    d. The DATA _NULL_ step uses the jsonpp (JSON Pretty Print) function to format the contents
       of the response file and print it in the log.
    e. Since the response file is no longer needed, clear the fileref. 
************************************************************************************************/
 
/************************************************************************************************
 2. A simple POST request:
    A POST request asks the API server to received and process information sent by the requestor.
************************************************************************************************/
filename resp TEMP;              /*a*/
filename input TEMP;             /*b*/

data _null_;                     /*c*/
   file input;
   put "Please accept this text as input.";
run;

proc http
   url="http://httpbin.org/post"  /*d*/
   in=input                       /*e*/
   out=resp                       /*f*/
   method=post;                   /*g*/
run;

data _null_;                      /*h*/
   rc = jsonpp('resp','log');
run;

filename input clear;             /*i*/
filename resp clear;

/************************************************************************************************
 2. A simple POST request
    a. Assign the fileref "resp" to a TEMP file to receive the response from the server. A TEMP 
       file is automatically deleted when the fileref is cleared.
    b. Assign the fileref "input" to a TEMP file to hold the text to be sent to the server.
    c. Use a DATA _NULL_ step to write some text to the input file. 
    d. httpbin.org is a simple HTTP request & response service that can freely be used for testing.
       In this URI, the /post indicates this is a POST request.
    e. The URI does not always indicate the method - in that case,  you can use the METHOD= option.
    f. Specifies the temp file "input" contains the text to be posted (sent).
    g. Specifies the server response should be stored in the temp file "resp".
    h. The DATA _NULL_ step uses the jsonpp (JSON Pretty Print) function to format the contents
       of the response file and print it in the log.
    i. Since the input and response files are no longer needed, clear the filerefs. 
************************************************************************************************/


/************************************************************************************************
 4. Using a proxy server:
    This POST request is sent to httpbin.org via a proxy server.
************************************************************************************************/

filename resp TEMP;              /*a*/
filename input TEMP;             /*b*/

data _null_;                     /*c*/
   file input;
   put "Please accept this text as input.";
run;

proc http
   url="http://httpbin.org/post"  /*d*/
   in=input                       /*e*/
   out=resp                       /*f*/
   proxyhost="23.247.137.142:80"; /*g*/
run;

data _null_;                      /*h*/
   rc = jsonpp('resp','log');
run;

filename input clear;             /*i*/
filename resp clear;

/************************************************************************************************
 4. Using a proxy server
    a. Assign the fileref "resp" to a TEMP file to receive the response from the server. A TEMP 
       file is automatically deleted when the fileref is cleared.
    b. Assign the fileref "input" to a TEMP file to hold the text to be sent to the server.
    c. Use a DATA _NULL_ step to write some text to the input file. 
    d. httpbin.org is a simple HTTP request & response service that can freely be used for testing.
       The /post indicates this is a POST request.
    e. Specifies the temp file "input" contains the text to be posted (sent).
    f. Specifies the server response should be stored in the temp file "resp".
    g. Specifies the IP address and port number for the proxy server.
    g. The DATA _NULL_ step uses the jsonpp (JSON Pretty Print) function to format the contents
       of the response file and print it in the log.
    h. Since the input and response files are no longer needed, clear the filerefs. 
************************************************************************************************/

