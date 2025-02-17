/************************************************************************************************
 ONE-WAY FREQUENCY REPORT STATISTICS                                                          
     This program uses options on the TABLES statement to control the statistics included in  
         the one-way frequency report.                                                        
      Keywords: PROC FREQ, frequency, aggregate                                                
      SAS Versions: SAS 9, SAS Viya                                                            
      Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=procstat&docsetTarget=procstat_freq_toc.htm                                                            */
      1. The default one-way frequency report for TYPE includes frequency, percent,           
         cumulative frequency, and cumulative percent.                                        
      2. Options on the TABLES statement are listed after a forward slash. NOCUM supresses the 
         cumulative statistics and NOPERCENT suppresses the percent statistic.                 
************************************************************************************************/

title "Default Report: Frequency, Percent, Cumulative Frequency, and Cumulative Percent";
proc freq data=sashelp.cars;    
    tables type;                     /*1*/
run;
title;

title "Frequency Counts Only";
proc freq data=sashelp.cars;    
    tables type / nocum nopercent;   /*2*/
run;
title; 
