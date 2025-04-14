/************************************************************************************************
 USING THE VALUE STATEMENT                                                                                   
     This program creates a format to display data or to use with a put statement or function.                                                                         
     Keywords: PROC FORMAT, FORMAT, VALUE                                                               
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p1xidhqypi0fnwn1if8opjpqpbmn.htm
     1. The VALUE statement creates a format that can be used to display data. Start by using 
        PROC FORMAT with two VALUE statements to create the new formats. 
     2. The VALUE statement identifies the name of the new format. For character formats the name 
        must begin with a $.
     3. For numeric formats, the name does not include the dollar sign. Use the LOW and HIGH to 
        keywords to indicate that the range includes everything from the lowest value to the highest.
     4. Apply the format in PROC PRINT to view the results.
************************************************************************************************/

proc format;                              /*1*/
   value $gen 'F' = 'Female'
              'M' = 'Male';               /*2*/
   value ht   low-<57 = 'Below Average'
              57-<67  = 'Average'
              67-high  = 'Above Average'; /*3*/
run;

title "Listing of SASHELP.CLASS";
title2 "With Formats Applied to Sex and Height Columns";
proc print data=sashelp.class noobs;   
    format sex $gen. height ht.;          /*4*/
run;
