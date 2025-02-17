/************************************************************************************************
 Creating a Series of User-Defined Macro Variables
    Example of three different ways to create a series of macro variables.

    Keywords: MACRO                                                               
    SAS Versions: SAS 9, SAS Viya                                                    
    Documentation: https://go.documentation.sas.com/doc/en/pgmsascdc/default/mcrolref/titlepage.htm
		
    1. Using the %LET macro statement
    2. Using PROC SQL
    3. Using the DATA step
************************************************************************************************/
/************************************************************************************************
 1. Creating a series of macro variable using the %LET statement
    a. Ensure the scope of variable I is local to the macro program. You can use the %GLOBAL
       statement to instead add the variable to the global symbol table. 
    b. The %DO loop will execute 7 times, creating a series of 7 macro variables.
    c. Ensures the scope of the new variable being created is local to the macro program. You 
       can use the %GLOBAL statement instead to add the variable to the global symbol table. 
    d. Select the approprite value for the macro variable using the %SCAN function.
    e. The %DO loop will execute 7 times.
    f. Use indirect referencing to sequentially resolve the values of all seven macro variables
       in the series.
************************************************************************************************/
%macro makeSeries;
   %local I;                                                                 /*a*/
   /* Make the variables */
   %do i=1 %to 7;                                                            /*b*/
      %local macVar&i;                                                       /*c*/
      %let macVar&i=%scan(Bream Parkki Perch Pike Roach Smelt Whitefish,&i); /*d*/
   %end;
   /* Display the variable values*/
   %do i=1 %to 7;                                                            /*e*/
      %put NOTE- macVar&i=&&macVar&i;                                        /*f*/
   %end;
%mend;
%makeSeries


/************************************************************************************************
 2. Creating series of macro variables using PROC SQL
    NOTE: PROC SQL does not allow you to specify the scope of the macro variables you create.
          If a same-named macro variable exists in the global symbol table, it will be 
          overwritten. Otherwise, the variable is created with local scope.
    a. In the SQL query, do any processing to make the resulting text look as you desire. You 
       do calculations, concatenations, apply formats, etc. This query selects only distinct 
       values for Species, and strips leading and trailing blanks.
    b. The INTO clause inserts the result of a column into the macro in the same position on the 
       variable list. A colon must precede each macro variable name. The dash (-) implies a 
       numbered series of same-named variables, auto-incrementing the serial portion by 1. Only
       the number of variables necessary to contain all forw from the query results are created.
    c. The %DO loop will execute 7 times.
    d. Use indirect referencing to sequentially resolve the values of all seven macro variables
       in the series.
************************************************************************************************/
%macro makeSeriesSQL;
proc sql noprint;
select distinct strip(Species)         /*a*/
   into :macVar1 -                     /*b*/   
   from sashelp.fish
;
quit;
   /* Display the variable values*/
   %do i=1 %to 7;                      /*c*/
      %put NOTE- macVar&i=&&macVar&i;  /*d*/
   %end;
%mend;
%makeSeriesSQL


/************************************************************************************************
 3. Creating series of macro variables using the DATA step.
    a. To get only distinct values of Species, sort the data using the NODUPKEY option.
       Use the OUT= option to write the result to the WORK library to avoid overwriting the
       original data.
    b. Read the sorted data into the DATA step. 
    c. Add 1 to Serial for each record read. We'll use this to construct the new macro
       variable's name. 
    d. The first SYMPUTX parameter is the macro variable's name, constructed by concatenating
       text'macVar' with the Serial number.
       The second SYMPUTX parameter is the macor variable value. We get this from the DATA step 
       variable Species. Leading and trailing blanks are automatically trimmed. 
       The third SYMPUTX parameter controls the scope of the new macor variable - 'L' for Local,
       'G' for Global.
    e. The %DO loop will execute 7 times.
    f. Use indirect referencing to sequentially resolve the values of all seven macro variables
       in the series.
************************************************************************************************/
%macro makeSeriesDS;
proc sort data=sashelp.fish(keep=Species) out=fish nodupkey; /*a*/
   by species;
run;
data _null_;
   set fish;                                                 /*b*/
   Serial+1;                                                 /*c*/
   call symputx(cats('macVar',Serial),Species,'L');          /*d*/
run;
   /* Display the variable values*/
   %do i=1 %to 7;                                            /*e*/
      %put NOTE- macVar&i=&&macVar&i;                        /*f*/
   %end;
%mend;
%makeSeriesDS


