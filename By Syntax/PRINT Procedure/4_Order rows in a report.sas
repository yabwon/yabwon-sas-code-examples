/************************************************************************************************
 ORDER ROWS IN A REPORT                                                                       
     Rows must first be arranged in the desired order using PROC SORT prior to PROC PRINT.    
     In this program, rows are first sorted by ascending Age, then within Age by descending   
     Height. Be sure to print the sorted table.       
     Keywords: PROC PRINT, PROC SORT, report                                                             
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p10qiuo2yicr4qn17rav8kptnjpu.htm  
     1. PROC SORT reads SASHELP.CLASS and creates a temporary sorted table named CLASS_SORT in 
        the default WORK library. Rows are ordered by ascending Age, and within Age by 
        descending Height.       
     2. PROC PRINT prints all rows and columns from the WORK.CLASS_SORT table.                                      
************************************************************************************************/

proc sort data=sashelp.class out=class_sort; 
    by Age desending Height;              /*1*/
run;

title "Listing of SASHELP.CLASS Sorted by Age, Height";
proc print data=class_sort;               /*2*/
run;
title;