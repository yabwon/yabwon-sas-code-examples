/************************************************************************************************
 PROC HTTP AUTHENTICATION AND PROXY SERVER BASICS
    This program demonstrates basic authentication and proxy srever use with PROC HTTP 
    Keywords: PROC HTTP
    SAS Versions: SAS 9, SAS Viya
    Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=n0bdg5vmrpyi7jn1pbgbje2atoov.htm
************************************************************************************************/

/************************************************************************************************
 1. Authenticating to the server (username/password):
    This GET request requires authentication to httpbin.org 
    *** This code passes the username and password in clear-text ***
    *** This is not an acceptable practice for production code.  ***
    a. Assign the fileref "resp" to a TEMP file to receive the response from the server. A TEMP 
       file is automatically deleted when the fileref is cleared.
    b. httpbin.org is a simple HTTP request & response service that can freely be used for testing.
       In this case, the URI does not specify the type of request.
    c. We use the METHOD= option to specify that this is a GET request.
    d. Specifies the username for authentication to httpbin.org
    e. Specifies the password for authentication to httpbin.org
    f. Specifies the server response should be stored in the temp file "resp".
    g. The DATA _NULL_ step uses the jsonpp (JSON Pretty Print) function to format the contents
       of the response file and print it in the log.
    h. Since the response file is no longer needed, clear the fileref. 
************************************************************************************************/
filename resp TEMP;                                         /*a*/

proc http
   url="https://httpbin.org/basic-auth/myusername/pAssw0rd" /*b*/
   method="GET"                                             /*c*/
   webusername="myusername"                                 /*d*/
   webpassword="pAssw0rd"                                   /*e*/
   out=resp;                                                /*f*/
run;

data _null_;                                                /*h*/
   rc = jsonpp('resp','log');
run;

filename resp clear;                                        /*i*/

/************************************************************************************************
 2. Authenticating to the server (bearer token):
    This GET request requires authentication to httpbin.org 
    a. Assign the fileref "resp" to a TEMP file to receive the response from the server. A TEMP 
       file is automatically deleted when the fileref is cleared.
    b. httpbin.org is a simple HTTP request & response service that can freely be used for testing.
       In this case, the URI does not specify the type of request.
    c. We use the METHOD= option to specify that this is a GET request.
    d. Specifies the bearer token value for authentication to httpbin.org
    e. Specifies the server response should be stored in the temp file "resp".
    f. The DATA _NULL_ step uses the jsonpp (JSON Pretty Print) function to format the contents
       of the response file and print it in the log.
    g. Since the response file is no longer needed, clear the fileref. 
************************************************************************************************/
filename resp TEMP;                     /*a*/

proc http
   url="https://httpbin.org/bearer"     /*b*/
   method="GET"                         /*c*/
   oauth_bearer="gakdfdadfkae213913"    /*d*/
   out=resp;                            /*e*/
run;

data _null_;                            /*f*/
   rc = jsonpp('resp','log');
run;

filename resp clear;                    /*g*/

/************************************************************************************************
 3. Using a proxy server:
    This POST request is sent to httpbin.org via a proxy server.
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
