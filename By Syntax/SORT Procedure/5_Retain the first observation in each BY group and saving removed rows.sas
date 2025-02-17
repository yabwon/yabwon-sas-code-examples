/************************************************************************************************
 RETAIN THE FIRST OBSERVATION IN EACH BY GROUP AND SAVE REMOVED ROWS                                                                             
     This program keeps only the first row for each unique value of a variable. 
     Keywords: PROC SORT, remove duplicates                                                              
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p1nd17xr6wof4sn19zkmid81p926.htm
     1. Create the WORK.CLASSTEST table and print it.                            
     2. The first PROC SORT arranges rows by desending scores for each Name and Subject. 
     3. The second PROC SORT keeps only the first occurence of each Name and Subject combination.    
        The DUPOUT= options saves rows that are removed in a separate table named CLASSTEST_DUPS.                                                                     
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
    by Name Subject descending Score;
run;

proc sort data=classtest_sort dupout=classtest_dups nodupkey;         /*3*/
    by Name Subject;
run;

title "CLASSTEST_SORT table keeping the high Score for each Name and Subject";
proc print data=classtest_sort;
run;

title "CLASSTEST_DUPS table with the removed lower test scores";
proc print data=classtest_dups;
run;
title;
