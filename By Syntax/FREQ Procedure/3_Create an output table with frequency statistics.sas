/************************************************************************************************
 CREATE OUTPUT TABLE WITH FREQUENCY STATISTICS                                                
     This program uses options on the TABLES statement to generate an output table and        
         suppress the displayed report.                                                       
     Keywords: PROC FREQ, frequency, aggregate                                                
     Documentation:  https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=procstat&docsetTarget=procstat_freq_toc.htm                                                            */
     SAS Versions: SAS 9, SAS Viya                                                            
     1. The OUT= option names the output dataset. The NOPRINT option suppresses the report.   
************************************************************************************************/

proc freq data=sashelp.cars;    
    tables type / out=work.typefreq noprint;  /*1*/        
run;
