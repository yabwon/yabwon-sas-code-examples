/************************************************************************************************
 PROC HTTP BASICS
    This program demonstrates the basic functionality of PROC HTTP 
    Keywords: PROC HTTP, read data
    SAS Versions: SAS 9, SAS Viya
    Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=n0bdg5vmrpyi7jn1pbgbje2atoov.htm
************************************************************************************************/

/************************************************************************************************
 1. A simple GET request:
    A GET request asks the API server to return a specified resource to the requestor.
    a. Assign the fileref "resp" to a TEMP file to receive the response from the server. A TEMP 
       file is automatically deleted when the fileref is cleared.
    b. httpbin.org is a simple HTTP request & response service that can freely be used for testing.
       the /get indicates this is a GET request.
    c. Specifies the server response should be stored in the temp file "resp".
    d. The DATA _NULL_ step uses the jsonpp (JSON Pretty Print) function to format the contents
       of the response file and print it in the log.
    e. Since the response file is no longer needed, clear the fileref. 
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
 2. A simple POST request:
    A POST request asks the API server to received and process information sent by the requestor.
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
 3. A simple PUT request:
    A PUT request asks the API server to update an existing resource with new data. If the 
    resource does not yet exist, PUT will create it. 
    a. Assign the fileref "resp" to a TEMP file to receive the response from the server. A TEMP 
       file is automatically deleted when the fileref is cleared.
    b. httpbin.org is a simple HTTP request & response service that can freely be used for testing.
       In this URI, the /pur indicates this is a PUT request. The ? indicates parameters 
       follow. Employee=123 specifies the employee ID to be modified, and Name= and Address= 
       specify the values for the Name and Address fields, respectively.
    c. The METHOD= option specifies PUT, overriding the default GET.
    d. Specifies the server response should be stored in the temp file "resp".
    e. The DATA _NULL_ step uses the jsonpp (JSON Pretty Print) function to format the contents
       of the response file and print it in the log.
    f. Since the response file is no longer needed, clear the fileref. 
************************************************************************************************/
filename resp TEMP;                                                                           /*a*/

proc http
   url='http://httpbin.org/put?Employee=123&Name=Jane Doe&Address=123 Main St., Anytown, USA' /*b*/
   out=resp                                                                                   /*c*/
   method=put;                                                                                /*d*/
run;

data _null_;                                                                                  /*e*/
   rc = jsonpp('resp','log');
run;

filename resp clear;                                                                          /*f*/

/************************************************************************************************
 4. A simple DELETE request:
    A DELETE request asks the API server to delete a resource.
    a. Assign the fileref "resp" to a TEMP file to receive the response from the server. A TEMP 
       file is automatically deleted when the fileref is cleared.
    b. httpbin.org is a simple HTTP request & response service that can freely be used for testing.
       In this URI, the /delete indicates this is a DELETE request. The ? indicates parameters 
       follow, and the file=trash.html parameter specifies the file to be deleted.
    c. The METHOD= option specifies DELETE, overriding the default GET.
    d. Specifies the server response should be stored in the temp file "resp".
    e. The DATA _NULL_ step uses the jsonpp (JSON Pretty Print) function to format the contents
       of the response file and print it in the log.
    f. Since the response file is no longer needed, clear the fileref. 
************************************************************************************************/
filename resp TEMP;                                 /*a*/

proc http
   url="http://httpbin.org/delete?file=trash.html"  /*b*/
   out=resp                                         /*c*/
   method=delete;                                   /*d*/
run;

data _null_;                                        /*e*/
   rc = jsonpp('resp','log');
run;

filename resp clear;                                /*f*/

