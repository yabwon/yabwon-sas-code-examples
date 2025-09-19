/************************************************************************************************
 PRINT EXTREME OBSERVATIONS
     This program prints a specified amount of observations with the highest and lowest values
     in a specified variable. It labels these observations with an identifier variable.
     Keywords: PROC UNIVARIATE
     SAS Versions: SAS 9, SAS Viya
     Documentation: https://documentation.sas.com/doc/en/pgmsascdc/v_066/procstat/procstat_univariate_toc.htm
     1. Specify the output table ODS should display from the following PROC UNIVARIATE step.
     2. PROC UNIVARIATE prints the N (here: 3) observations from the specified input
        (here: SASHELP.CLASS) table
     3. Specify the variable based on which the highest and lowest observations are selected
     (here: Height).
     4. A specified (here: Name) variable is used to identify these observations.
************************************************************************************************/

ods select ExtremeObs;                                                /*1*/
proc univariate data=sashelp.class nextrobs=3;                        /*2*/
    var Height;                                                       /*3*/
    id Name;                                                          /*4*/
run;