/************************************************************************************************
  PROC SQL, GET A FULLY QUALIFIED LIST OF ALL COLUMN NAMES FROM A SAS DATA SET
     This program will print a list of all column names from a SAS data set suitable
     for a SELECT col1, col2, ... clause
     Keywords: PROC SQL                                                      
     SAS Versions: SAS 9, SAS Viya                                                            
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=sqlproc&docsetTarget=n0a693shdq473qn1svlwshfci9rg.htm#p134acmdl6qc9ln10ightascplv3
     1. The FEEDBACK will return qualified column names
     2. The NOEXEC will not execute the SELECT statement, but you still get the feedback
     3. Use an alias to get shorter names
************************************************************************************************/

proc sql
  FEEDBACK /* 1 */
  NOEXEC /* 2 */
 ;
 select *
 from sashelp.cars as c /* 3 */
 ;
 quit;