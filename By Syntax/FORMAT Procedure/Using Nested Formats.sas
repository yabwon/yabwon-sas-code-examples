/************************************************************************************************
 USING NESTED FORMATS                                                                                   
     This program creates a format based on other formats for different ranges of data.                                                                         
     Keywords: PROC FORMAT, FORMAT, VALUE                                                               
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p1xidhqypi0fnwn1if8opjpqpbmn.htm
     1. Create a data set on which to test the new format. 
     2. Use PROC FORMAT with a value statement. This identifies the name of the new format. Provide ranges for which you
        want to assign different formats. 
     3. To nest formats use square brackets to identify the format to be applied to each range.
     4. In the PROC PRINT apply the format to see the results.
************************************************************************************************/
data payroll; /*1*/
   infile cards;
   input EmployeeID EmployeeGender : $1. Salary BirthDate : date9. HireDate : date9.;
cards;
120101 M 163040 18AUG1980 01JUL2007 
120102 M 108255 11AUG1973 01JUN1993 
120103 M 87975 22JAN1953 01JAN1978 
120104 F 46230 11MAY1958 01JAN1985 
120105 F 27110 21DEC1978 01MAY2003 
120106 M 26960 23DEC1948 01JAN1978 
120107 F 30475 21JAN1953 01FEB1978 
120108 F 27660 23FEB1988 01AUG2010 
120109 F 26495 15DEC1990 01OCT2010 
120110 M 28615 20NOV1953 01NOV1983 
;
run;

proc format; /*2*/
   value benefit low-'31dec60'd=[weekdate50.] /*3*/
                 '01jan61'd-'31dec93'd=[worddate20.]
                 '01jan94'd-high='** Not Eligible **'
   ;
run;

title "Display Dates using a Nested Custom Format";
proc print data=payroll;/*4*/
   format Birthdate Hiredate benefit.;
run;