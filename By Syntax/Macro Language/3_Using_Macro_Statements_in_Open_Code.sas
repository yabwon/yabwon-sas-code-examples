/************************************************************************************************
 Using Macro Statements in Open Code
    Example of using macro statements in open code without creating a compiled macro program.

    Keywords: MACRO
    SAS Versions: SAS 9, SAS Viya                                                    
    Documentation: https://go.documentation.sas.com/doc/en/pgmsascdc/default/mcrolref/titlepage.htm
		
    1. Using macro statements in open code
    2. Using %IF with %DO and %END for conditional operations in open code
      
************************************************************************************************/
/************************************************************************************************
 1. Creating a macro variable using the %LET statement
    a. %qsysfunc executes the DATA step TODAY() function to retrieved today's date, formats the 
       result using the weekday format, and assigned the quoted result to the today macro variable.
************************************************************************************************/
%let today=%qsysfunc(today(),weekday.);                                     /*a*/
/************************************************************************************************
 2. Using %IF with %DO and %END for conditional operations in open code
    a. %IF enables conditional execution of code. You MUST use a %DO / %END block to enclose the
       code to be conditionally executed.
    b. The code to be executed if today=1 or today=7
    c. %END marks the end of the conditionally executed code block.
    d. The %ELSE statement enables conditional execution of code when the preceding %IF statement
       was not true. You MUST use a %DO / %END block to enclose the code to be conditionally executed.
    g. Prints a report when today is not equal to 1 or 7.
    f. %END marks the end of the conditionally executed code block.

    NOTE: Nesting %IF statements with %ELSE %IF is not permitted in open code.
************************************************************************************************/
%if &today=1 or &today=7 %then %do;                                         /*a*/
	%PUT NOTE- &=today - I love the weekend!;                               /*b*/
%end;                                                                       /*c*/
%else %do;                                                                  /*d*/
	%PUT NOTE- &=today - going to work.;
    title "Workday report";
    proc print data=sashelp.cars (obs=5 keep=Make Model Type MSRP Invoice); /*e*/
	run;
	title;
%end;                                                                       /*f*/

