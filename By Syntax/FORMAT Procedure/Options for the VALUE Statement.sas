/************************************************************************************************
 OPTIONS FOR THE VALUE STATEMENT                                                                                   
     This program creates a format to display data or to use with a put statement or function.                                                                         
     Keywords: PROC FORMAT, FORMAT, VALUE                                                               
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p1xidhqypi0fnwn1if8opjpqpbmn.htm
     1. The value statement creates a format that can be used to display data. Start by using PROC FORMAT with the 
        value statement to create two new formats. 
     2. Add the default= option to specify the length of the label. 
     3. For the second PROC FORMAT add the fuzz value to indicate how close values must be to the ranges defined.
        The results will be displayed in the PROC PRINT output.
     4. In the next PROC FORMAT create a height format that has two ranges and add the multilabel option to allow 
        both ranges to be selected.
     5. In the PROC MEANS use the mlf option with the order=option to generate statistics using both ranges.
************************************************************************************************/

proc format;                                       /*1*/
   value $gen (default=1) 'F' = 'Female'
              'M' = 'Male';                        /*2*/
   value ht   (fuzz=1) low-57 = 'Below Average'
              57-67  = 'Average'
              67-high  = 'Above Average';          /*3*/
run;

title "Listing of SASHELP.CLASS";
title2 "DEFAULT=1 Option Set for $GEN. Format Applied to Sex Column";
title3 "FUZZ=1 Option Set for HT. Format Applied to Height Column";
proc print data=sashelp.class noobs;   
    format sex $gen. height ht.;                   
run;

proc format;                                       /*4*/
   value height (multilabel)               
              low-57 = '1 Below Average'
              57-<67  = '2 Average'
              67-high  = '3 Above Average'
              low-65 = 'Shorter'
              65<-high  = 'Taller';
run;

title "Listing of SASHELP.CLASS";
title2 "MULTILABEL Option Groups Values into Multiple Formatted Categories";
proc means data=sashelp.class; 
    var weight; 
	class height / mlf order=formatted;
    format height height.;                         /*5*/
run;
