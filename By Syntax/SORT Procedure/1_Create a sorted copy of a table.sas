/************************************************************************************************
 CREATE A SORTED COPY OF A TABLE                                                                                  
     This program creates a sorted copy of the WORK.CLASSTEST table.
     Keywords: PROC SORT                                                              
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p1nd17xr6wof4sn19zkmid81p926.htm
     1. Create the WORK.CLASSTEST table and print it.                            
     2. Read the SASHELP.CLASSTEST table, sort rows by ascending Name, and then Subject within 
        each Name. The sorted data is saved in a new table WORK.CLASSTEST_SORT. Note that if 
        you don't use the OUT= option, the original table is overwritten with a sorted version. 
     3. Print the sorted CLASSTEST_SORT table to view it.                                                           
************************************************************************************************/

data classtest;                                                       /*1*/
   infile datalines dsd;
   input
      Name :$7.
      Subject :$7.
      Score;
datalines4;
Judy,Reading,91
Judy,Math,79
Barbara,Math,90
Barbara,Reading,86
Barbara,Math,90
Louise,Math,72
Louise,Reading,65
William,Math,61
William,Reading,71
Henry,Math,62
Henry,Reading,75
Henry,Reading,84
Jane,Math,94
Jane,Reading,96
;;;;
run;

title "CLASSTEST table before sorting";
proc print data=classtest;
run;
title;

proc sort data=classtest out=classtest_sort;                          /*2*/
    by Name Subject;
run;

title "CLASSTEST_SORT table sorted by ascending Name and Subject";    /*3*/
proc print data=classtest_sort;
run;
title;
