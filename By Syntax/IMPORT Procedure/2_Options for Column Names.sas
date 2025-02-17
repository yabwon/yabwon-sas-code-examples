/************************************************************************************************
 OPTIONS FOR COLUMN NAMES WHEN READING DELIMITED FILES WITH PROC IMPORT                                                                                 
     This program shows how to read text files with no column names, or column names that not
     in the first line of the file. 
     Keywords: PROC IMPORT, csv, delimited data, import data                                                               
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=n1qn5sclnu2l9dn1w61ifw8wqhts.htm
     1. Create a macro variable named PATH that stores the path of the WORK library in your
        environment. The value of PATH is written in the log.                           
     2. Generate various CSV files, one with column names on line 1, one with no column names,
        and one with column names on line 3.   
     3. The default PROC IMPORT assumes column names are on line 1, and data begins on line 2. 
     4. If the text file does not include column names, the GETNAMES=NO statement specifies 
        that the IMPORT procedure generate SAS variable names as VAR1, VAR2, and so on.  
     5. The RENAME= data set option after the output table is used to rename VAR1, VAR2, and
        so on as alternative names.
     6. [SAS 9 only] If column names are on a line other than 1, PROC IMPORT cannot read the 
        names. 
        a. Use the GETNAMES=NO statement to generate variable names as VAR1, VAR2, etc. 
        b. Use the DATAROW= statement to indicate data begins on row 4.
        c. Use the RENAME= data set option after the output table to assign column names.  
     7. [SAS Viya] If column names are on a line other than 1, use the VARNAMEROW= option to 
        specify column names are on line 3, and the DATAROW= option to begin reading data from
        line 4.                      
************************************************************************************************/

/* CREATE TEMPORARY DELIMITED FILES */
%let path = %sysfunc(pathname(work));               /*1*/
%put &=path;

/* Column names on line 1 */
proc export data=sashelp.class                      /*2*/
            outfile="&path/class_withColNames.csv"
            dbms=csv
            replace;  
run;
        
/* No column names */
proc export data=sashelp.class                 
            outfile="&path/class_noColNames.csv"
            dbms=csv
            replace;            
    putnames=no;
run;

/* Column names on line 3 */
ods csvall file="&path/class_withTitle.csv";
title "Class Listing";
proc print data=sashelp.class noobs;
run;
title;
ods csvall close;

/* IMPORT DELIMITED FILE EXAMPLES */
proc import file="&path/class_withColNames.csv"     /*3*/      
            dbms=csv                     
            out=work.class_withColNames              
            replace;                     
run;