/************************************************************************************************
 CONTROLLING FREQUENCY REPORT ORDER                                                           
     This program uses the ORDER= option on the TABLES statement to control sort order of     
         the report.                                                                          
     Keywords: PROC FREQ, PROC FORMAT, frequency, aggregate                                   
     SAS Versions: SAS 9, SAS Viya                                                            
     Keywords: PROC FREQ, frequency, aggregate                                                
     Documentation:  https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=procstat&docsetTarget=procstat_freq_toc.htm                                                            */
     1. The default order is based on the sort sequence of the data values of TYPE.           
     2. The ORDER=FREQ option orders the report by descending frequency.                      
     3. The PROC FORMAT step creates a format to combine MPG values into 3 fuel efficiency    
        groups.                                                                               
     4. The FuelEff format is applied to the MPG_Highway column. The default sort order is    
        the sort sequence of the internal (or unformatted) values.                            
     5. The ORDER=FORMATTED option orders the report based on the alphabetic sequence of the  
        formatted values.                                                                     
     6. The ORDER=FREQ option orders the report based on the descending frequency counts.      
************************************************************************************************/

title "Ordered by Unformatted Values of TYPE (default)";
proc freq data=sashelp.cars;                         /*1*/
    tables type;             
run;

title "Ordered by Descending Frequency of TYPE";
proc freq data=sashelp.cars order=freq;              /*2*/
    tables type;             
run;

proc format;                                         /*3*/                      
    value FuelEff low-20="Low"
                  20<-30="Mid"
                  30<-high="High";
run;

title "Ordered by Unformatted Values of MPG_Highway";
proc freq data=sashelp.cars;                         /*4*/
    tables MPG_Highway;
    format MPG_Highway FuelEff.;
run;

title "Ordered by Formatted Values of MPG_Highway";
proc freq data=sashelp.cars order=formatted;         /*5*/
    tables MPG_Highway;
    format MPG_Highway FuelEff.;
run;

title "Ordered by Descending Frequency of Formatted values of MPG_Highway";
proc freq data=sashelp.cars order=freq;             /*6*/
    tables MPG_Highway;
    format MPG_Highway FuelEff.;
run;
    
