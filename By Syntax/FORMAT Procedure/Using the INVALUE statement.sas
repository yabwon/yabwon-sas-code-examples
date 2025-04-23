/************************************************************************************************
 USING THE INVALUE STATEMENT                                                                                   
     This program creates an informat to read in or convert data with an INPUT statement or function.                                                                         
     Keywords: PROC FORMAT, INFORMAT, INVALUE                                                               
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p1xidhqypi0fnwn1if8opjpqpbmn.htm
     1. The INVALUE statement creates an informat that can be used to read data. 
     2. In the DATA step, the second field is first as a string and assigned to the column String. 
        The second field is read again using the EVAL informat and assigned to the column Evaluation. 
     3. View the results of using the informat in PROC PRINT and PROC MEANS.
************************************************************************************************/

proc format;                                        /*1*/
   invalue eval 
      'Excellent'=4
           'Good'=3
           'Fair'=2
           'Poor'=1
   ;                            
run;
 
data evals;
   input ID $ @6 String $9. @6 Evaluation eval.;    /*2*/
datalines;
2355 Good     
5889 2        
3878 Excellent
4409 Poor     
0740 Fair     
2398 Excellent
4421 3        
7385 Good     
;
run;
title 'Data Read using a Custom Informat';          /*3*/
proc print data=evals label noobs;
    label Evaluation="Value Read with Informat"
          String="Original Value";
run;
proc means data=evals;
run;
 
