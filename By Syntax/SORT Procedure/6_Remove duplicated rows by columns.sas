/************************************************************************************************
 REMOVE DUPLICATED ROWS by COLUMNS
     This program sort the input table by specified columns to ensure rows with same values in
         these columns are adjacent. Furthermore, the sorting ensures that the first record in
         the group has the highest value based on a column. Then, all subsequent (or duplicate)
         rows based on specified columns are removed.
     Keywords: PROC SORT, remove duplicates
     SAS Versions: SAS 9, SAS Viya
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p1nd17xr6wof4sn19zkmid81p926.htm
     1. Create the WORK.CLASSTEST table and print it.
     2. PROC SORT sorts rows by specified columns (here: Name) so that duplicated
        rows will be sequential, and the first record in the group has the highest value for a
        given column (here: Score).
     3. Another PROC SORT step with the NODUPKEY option deletes rows with duplicate BY values
        by the specified columns (here: Name), thus leaving only one row (here:the one with the
        highest Score for each Name).
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

proc sort data=classtest out=classtest_sort;                         /*2*/
    by Name descending Score;
run;

proc sort data=classtest_sort out=classtest_nodup nodupkey;          /*3*/
    by Name;
run;