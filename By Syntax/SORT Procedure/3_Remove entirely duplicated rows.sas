/************************************************************************************************
 REMOVE ENTIRELY DUPLICATED ROWS                                                                                
     This program sort the input table by all columns to ensure fully duplicated rows are 
         adjacent. Then duplicate rows are removed from the output table. 
     Keywords: PROC SORT, remove duplicates                                                              
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p1nd17xr6wof4sn19zkmid81p926.htm
     1. Create the WORK.CLASSTEST table and print it.                            
     2. PROC SORT sorts rows by all columns so that duplicated rows will be sequential.       
        The NODUPKEY option deletes rows with duplicate BY values, thus eliminating entirely     
        duplicated rows.                                                              
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

proc sort data=classtest out=classtest_sort nodupkey;                 /*2*/
    by _all_;
run;

title "CLASSTEST_SORT table with duplicated rows removed";
proc print data=classtest_sort;
run;
title;
