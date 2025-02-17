/************************************************************************************************
 PROC HTTP - INTRO TO DEBUGGING - V1.0
    This program demonstrates basic debugging techniques for PROC HTTP 
    Keywords: PROC HTTP, debug
    SAS Versions: SAS 9, SAS Viya
    Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=n0i2ek87s12e7mn1h2q3h0mywkl1.htm
************************************************************************************************/

/************************************************************************************************
 1. A GET request gone wrong.
    a. Assign the fileref "resp" to a TEMP file to receive the response from the server. A TEMP 
       file is automatically deleted when the fileref is cleared.
    b. httpbin.org is a simple HTTP request & response service that can freely be used for testing.
       the /get indicates this is a GET request.
    c. Specifies the server response should be stored in the temp file "resp".
    d. The DATA _NULL_ step uses the jsonpp (JSON Pretty Print) function to format the contents
       of the response file and print it in the log.
    e. Since the response file is no longer needed, clear the fileref. 
************************************************************************************************/
filename resp TEMP;                     /*a*/

proc http
   url="http://httpbin.org/get/badURI"  /*b*/
   out=resp                             /*c*/
   ;                     
run;

data _null_;                            /*d*/
   rc = jsonpp('resp','log');
run;

proc http
   url="http://httpbin.org/get/badURI"  /*b*/
   out=resp;                            /*c*/
   debug level=1;
run;

proc http
   url="http://httpbin.org/get/badURI"  /*b*/
   out=resp;                            /*c*/
   debug level=2;
run;

proc http
   url="http://httpbin.org/get/badURI"  /*b*/
   out=resp;                            /*c*/
   debug level=3 OUTPUT_TEXT;
   ;                     
run;

filename resp clear;                    /*e*/
