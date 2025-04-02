/***********************************************************************************************
 DEFAULT REPORT LISTING ALL ROWS AND COLUMNS                                                  
     This program lists all rows and columns from the SASHELP.CLASS table.                       
     Keywords: PROC PRINT, report                                                             
     SAS Versions: SAS 9, SAS Viya                                                   
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p10qiuo2yicr4qn17rav8kptnjpu.htm
     1. The PROC PRINT statement uses the DATA=option to select the table to list. By default,
        all rows and columns from the table are printed, along with an OBS column indicating 
        observation number.                                                         
************************************************************************************************/

title "Listing of SASHELP.CLASS";
proc print data=sashelp.class;   /*1*/
run;
title;

/*END*/
