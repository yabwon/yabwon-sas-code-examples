/************************************************************************************************
 USING THE BY GROUPFORMAT STATEMENT TO PROCESS DATA                                                                                   
     This program creates a format that can be used to group data. It shows the use of the groupformat option in the data step.                                                                         
     Keywords: PROC FORMAT, FORMAT, VALUE, GROUPFORMAT                                                               
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p1xidhqypi0fnwn1if8opjpqpbmn.htm
     1. Create a data set on which to test the new format. The data is sorted by the value to be formatted.
     2. Use PROC FORMAT with a value statement. Provide ranges for which you want to assign different grouping levels. 
     3. Use the groupformat option on the by statement to allow the data step to read the data by groups.  
     4. Because the data is being read with a by statement the first. and last. variables are created. In this example, the
        first.salary will be the lowest salary observation for a group and the last.salary observation will be the highest.
     5. In the PROC REPORT apply the format to see the results.
************************************************************************************************/
data payroll; /*1*/
   infile cards;
   input EmployeeID Salary BirthDate : date9. HireDate : date9.;
   cards;
120185 25080 07APR1978 01DEC2010 
121101 25390 28AUG1990 01NOV2010 
121092 25680 08MAR1978 01AUG2006 
121106 25880 02FEB1973 01FEB2000 
121072 26105 10JAN1983 01SEP2008 
120178 26165 23NOV1958 01APR1978 
121027 26165 05MAY1968 01DEC1993 
121096 26335 18MAY1973 01MAY1999 
120112 26550 17FEB1973 01JUL1994 
121002 26650 18SEP1958 01DEC1983 
120687 26800 25MAY1983 01AUG2008 
120183 26910 10SEP1973 01DEC2010 
120999 27215 28DEC1963 01APR1988 
120153 27260 07MAY1983 01JAN2002 
121059 27425 25OCT1963 01APR1985 
120164 27450 26NOV1963 01FEB1986 
120120 27645 05MAY1948 01JAN1978 
121139 27700 19AUG1963 01JUL1991 
121075 28395 23DEC1948 01JAN1978 
120715 28535 12JUN1983 01FEB2009 
121042 28845 04APR1983 01NOV2003 
120799 29070 23MAR1983 01NOV2002 
121105 29545 09MAY1983 01JAN2007 
121061 29815 16JUL1958 01JUL1988 
121062 30305 28OCT1988 01AUG2010 
121019 31320 25JUN1990 01JUN2008 
121032 31335 24FEB1992 01MAR2010 
121080 32235 24JAN1963 01SEP1991 
121099 32725 19MAR1983 01MAY2004 
120787 34000 22AUG1973 01JAN2000 
120731 34150 15MAR1963 01SEP1987 
120754 34760 02JUN1992 01MAY2010 
120683 36315 12NOV1958 01JAN1978 
120757 38545 18MAR1948 01JAN1978 
120789 39330 14JUL1968 01DEC1986 
120774 45155 17SEP1982 01MAR2006 
120796 47030 12MAY1958 01MAR1987 
120793 47155 08AUG1973 01JUN2000 
120668 47785 23OCT1953 01DEC1982 
120813 50865 14SEP1973 01JAN1997 
120804 55400 11FEB1948 01JAN1978 
120712 63640 12JUN1953 01JAN1978 
121145 84260 22NOV1953 01APR1980 
120260 207885 02DEC1968 01NOV1988 
120259 433800 25JAN1968 01SEP1993 
;
run;

proc format; /*2*/
   value salgrp low-<30000='Under $30,000'
                30000-<35000='$30,000 to $35,000'
				35000-<50000='$35,000 to $50,000'
				50000-high='Over $50,000';
run;

data highlowsal;
   set payroll;
   by groupformat salary; /*3*/
   format salary salgrp.;
   if first.salary then output; /*4*/
   if last.salary then output; 
run;

proc report data=highlowsal nowd; /*5*/
   columns EmployeeID Salary Salary=SalGrp HireDate;
   define salary / display format=dollar12.;
   define hiredate / format=date9.;
   define salgrp / format=salgrp. 'Salary Group';
   title 'Lowest and Highest Salary by Salary Group';
run;

title;
