/************************************************************************************************
 USING FUNCTIONS TO CREATE FORMATS                                                                                   
     This program creates a FORMAT based on functions created by PROC FCMP.                                                                         
     Keywords: PROC FORMAT, PROC FCMP, FORMAT, VALUE                                                               
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p1xidhqypi0fnwn1if8opjpqpbmn.htm
     1. Use PROC FCMP to create two new functions, START and END. 
     2. The START function will take a date as its argument and from that date will go to the beginning of the week 
        and then go forward to the next Monday (day 2 of the week.) 
     3. The END function will go to the end of the next week, a Saturday. One is subtracted from the result so that the
        End function returns a Friday.
     4. The options statement tells SAS where to look for the new functions.
     5. The VALUE statements in PROC FORMAT first identifies the name of the new format. The keyword OTHER tells SAS 
        to apply the format to all nonmissing values.
     6. The square brackets surround the function to be used to define the format. In the start format the START function
        is used so that any date will be labeled as the Monday of the week of the date. 
     7. Similarly the end format uses the END function to label the date as the next Friday. 
     8. Create data that includes dates to which the formats can be applied.
     9. In the PROC REPORT apply the format to see the results.
************************************************************************************************/

proc fcmp outlib=work.functions.DateType;/*1*/
   function START(Date) $ 9;/*2*/
      dt=intnx('week.2', Date, 0);/*3*/
      return(put(dt,date9.));
   endsub;
   function END(Date) $ 9;
      dt=intnx('week.7', Date, 1) - 1;
      return(put(dt,date9.));
   endsub;
quit;

options cmplib=work.functions;/*4*/

proc format;/*5*/
   value start other=[start()];/*6*/
   value end other=[end()]; /*7*/
run;

data orders;/*8*/
   infile cards;
   input CustomerID DeliveryDate : date9. OrderID;
   cards;
12 11MAR2010 1238678581 
12 23JUN2011 1242610991 
13 28JUL2010 1239744161 
16 20JUL2010 1239713046 
16 02OCT2010 1240314956 
18 17FEB2011 1241461856 
19 06FEB2010 1238370259 
20 08NOV2010 1240613362 
24 14JUL2011 1242773202 
24 21APR2010 1238968334 
;
run;

proc report data=orders nowd;/*9*/
 columns CustomerID OrderID DeliveryDate ('Expected Delivery Between' DeliveryDate=DD1 DeliveryDate=DD2);
 define CustomerID / order 'Customer ID/' ;
 define OrderID / 'Order ID/' format=10.;
 define DeliveryDate / display 'Actual Delivery' format=weekdate.;
 define DD1 / display 'Start'  format=start12.;
 define DD2 / display 'End' format=end12.;
 title 'Expected Delivery for Current Orders';
run;

title;
