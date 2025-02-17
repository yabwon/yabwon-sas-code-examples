/************************************************************************************************
/* SELECT ROWS TO PRINT AND FORMAT DISPLAYED VALUES                                             
     This program lists selected rows and formats the data values in a report.                                       
     Keywords: PROC PRINT, report                                                             
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p10qiuo2yicr4qn17rav8kptnjpu.htm  
     1. The WHERE statement filters rows to only display rows with Age greater than 13.       
     2. The FORMAT statement applies the numeric 3.0 format to Height and Weight. 3           
        represents the width of the display field and 0 indicates the number of decimal       
        places to show. Values are rounded to the nearest integer. The $UPCASE format         
        displays all Name values as upper case in the report. Formats do not change           
        the stored value in the input table.                                                    
/************************************************************************************************/

title "Listing of SASHELP.CLASS";
proc print data=sashelp.class noobs;   
    where Age > 13;            /*1*/       
    format Height Weight 3.0   /*2*/
           Name $upcase8.;
run;
title;