/************************************************************************************************
 Creating User-Defined Macro Variables
    Examples of several different ways to create macro variables.

    Keywords: MACRO                                                               
    SAS Versions: SAS 9, SAS Viya                                                    
    Documentation: https://go.documentation.sas.com/doc/en/pgmsascdc/default/mcrolref/titlepage.htm
		
    1. Using the %LET macro statement
    2. Using PROC SQL
    3. Using the DATA step
************************************************************************************************/
/************************************************************************************************
 1. Creating macro variables using the %LET statement
    a. All of the text between the = sign and the semicolon is assigned to macro variable macVar.
    b. &=macVar is a shorthand instruction to print the name of the macro variable and equal
       sign followed by the value of the macro variable.
    c. When executed, &macVar resolves to the value of the macro variable.
    d. The %SYMDEL statement deletes the named macro variable(s) from the 
       macro symbol table. 
************************************************************************************************/
%let macVar=Now is the time;                                              /*a*/
%put NOTE: &=macVar;                                                      /*b*/
%put NOTE: &macVar for all good men to come to the aid of their country.; /*c*/
%SYMDEL macVar;                                                           /*d*/

/************************************************************************************************
 2. Creating macro variables using PROC SQL
    a. In the SQL query, do any processing to make the resulting text look as you desire. You 
       do calculations, concatenations, apply formats, etc. This query calcualtes two individual
       values - min(msrp) and max(msrp)
    b. The INTO clause inserts the result of the positionally corresponding column into the macro
       variable named after the colon. The colon is required. The TRIMMED operator removes all
       leading and trailing blanks before storing the value in the macro variable. 
    c. The %SYMDEL statement deletes the named macro variable(s) from the 
       macro symbol table. 
************************************************************************************************/
proc sql noprint;
select min(msrp) format=dollar10.
      ,max(msrp) format=dollar10. /*a*/
   into :macroMin trimmed         /*b*/
       ,:macroMax trimmed        
	from sashelp.cars
;
quit;
%put NOTE: In 2004, the cheapest car list price was &macroMin, and the most expensive &macroMax..;
%SYMDEL macroMin macroMax;       /*c*/

/************************************************************************************************
 3. Creating macro variables using the DATA step.
    a. RETAIN prevents the values of minPrice and maxPrice from being reinitialized to missing
       whenever the DATA step iterates.
    b. The END= option set the value of automatic variable LAST to 0 if there is another 
       observation available after the one you are reading, and to 1 if this is the last 
       observation in the input data set. 
    c. If the MSRP is larger than the current maxPrice, save the value of MSRP as maxPrice. 
    d. If the MSRP is less than the current minPrice, or minPrice is currently missing, save the 
       value of MSRP as minPrice. 
    e. After reading the last observation, DO these steps:
    f. The SYMPUTX call routine removes leading and trailing blanks from the value before storing
       it in the specified macro variable. 
************************************************************************************************/
data _null_;
   retain minPrice maxPrice;                                       /*a*/
	set sashelp.cars end=last;                                      /*b*/
	if MSRP > maxPrice then maxPrice=MSRP;                          /*c*/
	if MSRP < minPrice or missing(minPrice) then minPrice=MSRP;     /*d*/
	if last then do;                                                /*e*/ 
		call symputx('macroMin',put(minPrice,dollar10.));            /*f*/
		call symputx('macroMax',put(maxPrice,dollar10.));           
	end;
run;

%put NOTE: In 2004, the cheapest car list price was &macroMin, and the most expensive &macroMax..;
%SYMDEL macroMin macroMax;                                         /*g*/
