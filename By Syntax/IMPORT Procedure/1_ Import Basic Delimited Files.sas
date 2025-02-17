/************************************************************************************************
 READ BASIC DELIMITED FILES WITH PROC IMPORT                                                                                   
     This program uses PROC IMPORT to read delimited text files - including comma, tab, and 
     pipe-delimited values.                                                                       
     Keywords: PROC IMPORT, csv, delimited data, import data                                                               
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=n1qn5sclnu2l9dn1w61ifw8wqhts.htm
     1. Create a macro variable named PATH that stores the path of the WORK library in your
        environment. The value of PATH is written in the log.                           
     2. Generate various delimited text files, including comma, tab and pipe-delimited values
        and save them in the folder stored in the PATH macro variable.  
     3. This PROC IMPORT step imports a comma-delimited file. The FILE= option provides the 
        path and file name of the file to import. In this scenario, &PATH will be replaced with 
        the previously stored path to the WORK library location. 
     4. The DBMS= option identifies the data source type, CSV. The default import assumes
        the first row of the text file contains column names. 
     5. The OUT= option names the output SAS table.
     6. The REPLACE option overwrites an existing SAS data set. If you omit REPLACE, the 
        IMPORT procedure does not overwrite an existing file.    
     7. This PROC IMPORT step imports a tab-delimited file. The DBMS=TAB option specifies the
        delimiter. 
     8. This PROC IMPORT step imports a pipe-delimited file. The DBMS=DLM option is used to 
        specify any character as the delimiter. The DELIMITER= statement identifies the 
        delimiter character, which is "|" in this case.                      
************************************************************************************************/

/* CREATE TEMPORARY DELIMITED FILES */
%let path = %sysfunc(pathname(work));          /*1*/
%put &=path;

proc export data=sashelp.class                 /*2*/
            outfile="&path/class.csv"
            dbms=csv
            replace;  
run;
        
proc export data=sashelp.class                 
            outfile="&path/class.tab"
            dbms=tab
            replace;  
run;

proc export data=sashelp.class                 
            outfile="&path/class.txt"
            dbms=dlm
            replace;  
    delimiter="|";
run;

/* IMPORT DELIMITED FILE EXAMPLES */
proc import file="&path/class.csv"             /*3*/
            dbms=csv                           /*4*/
            out=work.class_csv                 /*5*/
            replace;                           /*6*/
run;

proc import file="&path/class.tab"             /*7*/
            dbms=tab                     
            out=work.class_tab               
            replace;                     
run;

proc import file="&path/class.txt"             /*8*/
            dbms=dlm                     
            out=work.class_pipe               
            replace;   
    delimiter="|";
run;