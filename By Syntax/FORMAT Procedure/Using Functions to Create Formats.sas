/************************************************************************************************
 USING FUNCTIONS TO CREATE FORMATS                                                                                   
     This program creates a format based on fuctions created by PROC FCMP.                                                                         
     Keywords: PROC FORMAT, PROC FCMP, FORMAT, VALUE                                                               
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p1xidhqypi0fnwn1if8opjpqpbmn.htm
     1. Use PROC FCMP to create two new functions, start and end. 
     2. The Start function will take a date as its argument and from that date will go to the beginning of the week 
        and then go forward to the next Monday (day 2 of the week.) 
     3. The End function will go to the end of the next week, a Saturday. One is subtracted from the result so that the
        End function returns a Friday.
     4. The options statement tells SAS where to look for the new functions.
     5. The value statements in PROC FORMAT first identifies the name of the new format. The keyword other tells SAS 
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
5 07MAY2011 1242140006 
5 09MAY2011 1242159212 
5 10JUN2011 1242493791 
10 14JAN2010 1238231237 
10 03FEB2010 1238393448 
10 12MAR2010 1238686430 
10 18SEP2010 1240201886 
10 07OCT2010 1240355393 
10 20OCT2010 1240461993 
10 20OCT2010 1240461993 
10 20OCT2010 1240461993 
10 19MAR2011 1241686210 
10 18APR2011 1242012259 
10 18APR2011 1242012259 
10 16MAY2011 1242265757 
10 06JUN2011 1242458099 
10 07JUL2011 1242736731 
10 17JUL2011 1242827683 
10 18JUL2011 1242836878 
10 08AUG2011 1243026971 
10 17AUG2011 1243110343 
10 17AUG2011 1243110343 
10 27AUG2011 1243198099 
10 27AUG2011 1243198099 
12 07MAR2010 1238646479 
12 11MAR2010 1238678581 
12 11MAR2010 1238678581 
12 27APR2010 1239057268 
12 03AUG2010 1239836937 
12 08AUG2010 1239874523 
12 05FEB2011 1241359997 
12 23JUN2011 1242610991 
13 28JUL2010 1239744161 
13 28JUL2010 1239744161 
16 20JUL2010 1239713046 
16 20JUL2010 1239713046 
16 20JUL2010 1239713046 
16 17AUG2010 1239932984 
16 17AUG2010 1239932984 
16 08NOV2010 1240599396 
16 08NOV2010 1240599396 
16 23DEC2010 1240961599 
16 23DEC2010 1240961599 
17 02OCT2010 1240314956 
18 17FEB2011 1241461856 
19 06FEB2010 1238370259 
19 13FEB2010 1238426415 
19 01MAR2010 1238553101 
19 26APR2010 1239003827 
19 08NOV2010 1240568966 
20 24MAY2010 1239226632 
20 08NOV2010 1240613362 
24 05JAN2011 1241054779 
24 09MAR2011 1241623505 
24 14JUL2011 1242773202 
27 02FEB2011 1241286432 
27 14MAR2011 1241652707 
27 14APR2011 1241930625 
27 14APR2011 1241930625 
27 14APR2011 1241930625 
27 10JUN2011 1242449327 
27 17JUL2011 1242782701 
27 10SEP2011 1243279343 
29 21APR2010 1238968334 
29 23APR2010 1238985782 
29 16MAY2010 1239172417 
29 22MAY2010 1239220388 
29 15JUN2010 1239410348 
29 21SEP2010 1240187143 
29 23OCT2010 1240446608 
29 23OCT2010 1240446608 
29 28OCT2010 1240485814 
31 31JAN2010 1238367238 
31 18MAR2011 1241731828 
31 18MAR2011 1241731828 
31 29APR2011 1242076538 
31 12JUN2011 1242477751 
31 12JUN2011 1242477751 
31 11JUN2011 1242502670 
31 11JUN2011 1242502670 
31 06SEP2011 1243290080 
34 13JUN2011 1242467585 
34 13JUN2011 1242467585 
39 04APR2010 1238870441 
39 17MAY2010 1239179935 
41 10JAN2010 1238161695 
41 02FEB2010 1238377562 
41 23MAY2010 1239258470 
41 19JUN2010 1239442095 
41 09FEB2011 1241390440 
41 08MAY2011 1242185055 
41 19JUL2011 1242838815 
41 19JUL2011 1242838815 
41 10AUG2011 1243039354 
45 29MAY2010 1239312711 
45 29MAY2010 1239312711 
45 06JUL2010 1239615368 
45 18APR2011 1242012269 
45 18APR2011 1242012269 
45 27JUN2011 1242647539 
;
run;

proc report data=orders nowd;/*9*/
 columns CustomerID OrderID DeliveryDate ('Expected Delivery Between' DeliveryDate=DD1 DeliveryDate=DD2);
 define CustomerID / order 'Customer ID/' ;
 define OrderID / 'Order ID/';
 define DeliveryDate / display 'Actual Delivery' format=weekdate.;
 define DD1 / display 'Start'  format=start12.;
 define DD2 / display 'End' format=end12.;
 title 'Expected Delivery for Current Orders';
run;

title;
