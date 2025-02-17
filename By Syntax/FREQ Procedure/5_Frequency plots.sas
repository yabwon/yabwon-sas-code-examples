/************************************************************************************************
 CREATE FREQUENCY PLOTS                                                                       
     This program uses the PLOT= option on the TABLES statement to generate a frequency plot. 
     Primary Syntax: PROC FREQ                                                                
     SAS Versions: SAS 9, SAS Viya                                                            
     Keywords: PROC FREQ, frequency, aggregate, graph, plot                                   
     Documentation:  https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=procstat&docsetTarget=procstat_freq_toc.htm                                                            */
     1. The PLOT=FREQPLOT option generates a bar chart representing the frequency of each     
        unique value of TYPE.                                                                 
     2. The ORDER=FREQ option controls the sort order of both the report and the plot. Values 
        are ordered by descending frequency.                                                  
     3. Several plot options are available to customize the display of the graph.             
        ORIENT=HORIZONTAL produces a horizontal bar chart.                                    
     4. For a two-way frequency plot, a separate bar chart is produced for each unique value  
        of the first variable listed.                                                         
     5. Additional two-way plot options are available to customize the graph. For example,    
        TWOWAY=STACKED produces a stacked bar chart where each segment corresponds to the     
        unique values of the first variable listed.                                           
************************************************************************************************/

title "Frequency Distribution of TYPE";
proc freq data=sashelp.cars;      
    tables type / plots=freqplot;                                          /*1*/          
run;

title "Descending Frequency Distribution of TYPE";
proc freq data=sashelp.cars order=freq;                                    /*2*/
    tables type / plots=freqplot(orient=horizontal);                       /*3*/          
run;

title "Two-way Frequency Distribution of TYPE and ORIGIN";
title2 "Separate Plots";
proc freq data=sashelp.cars;
    tables origin*type / plots=freqplot;                                   /*4*/  
run;

title "Two-way Descending Frequency Distribution of TYPE and ORIGIN";
title2 "Stacked Bars";
proc freq data=sashelp.cars order=freq;
    tables origin*type / plots=freqplot(twoway=stacked orient=horizontal); /*5*/  
run;

/* END */