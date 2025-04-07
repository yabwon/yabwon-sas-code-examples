/************************************************************************************************
 SELECT COLUMNS TO PRINT AND CUSTOMIZE COLUMN HEADINGS  
     This program lists selected columns and assigns custom labels for each column heading.                                       
     Keywords: PROC PRINT, report                                                             
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p10qiuo2yicr4qn17rav8kptnjpu.htm  
     1. The NOOBS option suppresses the OBS column. The LABEL option displays labels instead  
        of column names.                                                                      
     2. The VAR statement lists the columns to print and the display order.                   
     3. The LABEL statement assigns column labels.                                             
************************************************************************************************/


title "Listing of SASHELP.CLASS";
proc print data=sashelp.class noobs label;   /*1*/
    var Name Age Height;                     /*2*/
    label Name="First Name"                  /*3*/
          Height="Height (in)";
run;
title;
