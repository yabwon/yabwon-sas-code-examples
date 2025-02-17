/************************************************************************************************
 SORT ROWS BY GROUPS AND IN DESCENDING ORDER                                                                                 
     This program sorts by multiple columns in both ascending and descending order.
     Keywords: PROC SORT                                                              
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p1nd17xr6wof4sn19zkmid81p926.htm
     1. Create the WORK.CLASSTEST table and print it.                            
     2. Read CLASSTEST, sort rows by Subject in ascending order, then within Subject by Score 
        in descending order. The sorted data is saved in a new table, WORK.CLASSTEST_SORT. 
        Note that the keyword DESCENDING changes the order for the variable it precedes.                                                           
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

proc sort data=classtest out=classtest_sort;                          /*2*/
    by Subject descending Score;
run;

title "CLASSTEST_SORT table sorted by descending Score within Subject";
proc print data=classtest_sort;
run;
title;
