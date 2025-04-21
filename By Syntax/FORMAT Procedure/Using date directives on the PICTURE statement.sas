/************************************************************************************************
 USING DATE DIRECTIVES ON THE PICTURE STATEMENT                                                                                   
     This program creates formats to display dates in a customized way.                                                                         
     Keywords: PROC FORMAT, FORMAT, PICTURE, DATATYPE                                                               
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p1xidhqypi0fnwn1if8opjpqpbmn.htm
     1. The PICTURE statement can create formats that can be used to display dates. Start by using PROC FORMAT with a PICTURE
        statement that has a DATATYPE= option. 
     2. The PICTURE statement identifies the name of the new format. It then specifies the range of values to which a template 
        will be applied. Use the LOW and HIGH to keywords to indicate that the range includes everything from the lowest value 
        to the highest.
     3. The template or pattern for the format is specified. In this case we use date directives to define the template. The quoted
        template includes three date directives - %0d specifies that the day of the month be written out in one or two 
        digits, %b specifies that the month be written out in a three letter abbreviation, and %Y specifies that a 4-digit
        year be written out. These elements are separated by the tilde character (~). The pattern closes with extra spaces to account for
        the length of labels.
     4. The DATATYPE= option specifies that the format is a date, a time, or a datetime.  
     5. Apply the format in PROC PRINT to view the results.
     6. Text can be combined with picture templates to create truly customized formats. Text be can be used for some levels of a 
        format and date directives for other levels. 
     7. SAS date constants (as well as time constants and datetime constants) can be used to specify the beginning and end of
        a date range.
     8. When using date directives, remember that case can matter. A lower case 'b' results in a 3-letter abbreviation for month, while 
        an upper case 'B' spells out the whole month.
************************************************************************************************/

proc format;
   picture /*1*/ hirefmt   /*2*/ low-high = '%0d~%b~%Y    '  /*3*/  (datatype=date) /*4*/ ;
run;

data crew;
   infile cards;
   input FirstName : $35. LastName : $35. HireDate : date9.;
   cards;
SALLY BEAUMONT 07NOV1992 
CHRISTOPHER BERGAMASCO 12MAY1985 
BARBARA-ANN BETHEA 04AUG1988 
ROBERT BJURSTROM 22APR1987 
SUSAN BONDS 23SEP1982 
TERESA CHANG 03APR1994 
JOANN CHOPRA 31MAR1993 
ANNETTE CHRISTENSEN 12MAY1983 
JOHN CHRISTIAN 15JAN1982 
DOUGLAS CIAMPA 13JAN1984 
JOHN CLAYTON 12OCT1986 
WILLIAM DIELEMAN 26NOV1983 
DANIEL DOWELL 09FEB1994 
JOANNE DOWTY 05JUL1983 
KENNETH EATON 05JUL1993 
ANITA EHRISMAN 26JAN1984 
KAREN ELAM 26FEB1986 
GREGORY ELLIS 23FEB1981 
ROBERT EUNICE 15APR1994 
LISA FEENSTRA 04APR1993 
;
run;

proc print data=crew; /*5*/
   var firstname lastname hiredate;
   format hiredate hirefmt.;
   title 'Crew Hire Dates with Custom Date Format';
run;

proc format;                                         
   picture mrg /*6*/
      low-<'01apr1990'd = 'Pre-Merger' /*7*/
      '01apr1990'd-'31mar1993'd = '%B during Merger Process      ' (datatype=date) /*8*/
      other = 'Post-Merger'; 
run;
proc print data=crew(obs=20);
   var firstname lastname hiredate;
   format hiredate mrg.;
   title 'Crew Hire Dates with Text/Date Format';
run;  