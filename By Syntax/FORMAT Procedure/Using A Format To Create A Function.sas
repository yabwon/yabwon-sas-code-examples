/************************************************************************************************
 USING A FORMAT TO CREATE A FUNCTION                                                                                   
     This program creates a format based on other formats for different ranges of data.                                                                         
     Keywords: PROC FORMAT, FORMAT, VALUE, PROC FCMP                                                               
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p1xidhqypi0fnwn1if8opjpqpbmn.htm
     1. Create a format to display Australian postal codes as state codes. 
     2. Use ranges with character values to define the format.
     3. In PROC FCMP define a function that will apply the format to Australian codes and uses
        the ZIPSTATE function for US States.
     4. Use PROC REPORT to display the results of the new function.
************************************************************************************************/
  
proc format;/*1*/
   value $postabb  '1000'-'1999', 
                   '2000'-'2599', 
                   '2619'-'2898', 
                   '2921'-'2999'='NSW'
                   '0200'-'0299', 
                   '2600'-'2618', 
                   '2900'-'2920'='ACT'
                   '3000'-'3999', 
                   '8000'-'8999'='VIC'
                   '4000'-'4999', 
                   '9000'-'9999'='QLD'
                   '5000'-'5799', 
                   '5800'-'5999'='SA'
                   '6000'-'6797', 
                   '6800'-'6999'='WA'
                   '7000'-'7799', 
                   '7800'-'7999'='TAS'
                   '0800'-'0899', 
                   '0900'-'0999'='NT';/*2*/
run;

title;

proc fcmp outlib=work.functions.char; /*3*/
   function StateProv(Country $,Code $) $ 5;
	   if upcase(country) ='AU' then stpr=put(code,$postabb.);
	   else if upcase(country)='US' then stpr=zipstate(code);
	   else stpr=' ';
      return(stpr);
   endsub;
quit;

options cmplib=work.functions;

data addresses;
   infile cards dlm=',' dsd;
   input EmployeeID : $10. EmployeeName : $30. City : $15. PostalCode : $5. Country : $2.;
   cards;
121044,"Abbott, Ray","Miami-Dade",33135,"US"
120145,"Aisbitt, Sandy","Melbourne",8001,"AU"
120761,"Akinfolarin, Tameaka","Philadelphia",19145,"US"
120656,"Amos, Salley","San Diego",92116,"US"
121107,"Anger, Rose","Philadelphia",19142,"US"
121038,"Anstey, David","Miami-Dade",33157,"US"
120273,"Antonini, Doris","Miami-Dade",33141,"US"
120759,"Apr, Nishan","San Diego",92071,"US"
120798,"Ardskin, Elizabeth","Miami-Dade",33177,"US"
121030,"Areu, Jeryl","Miami-Dade",33133,"US"
121017,"Arizmendi, Gilbert","San Diego",91950,"US"
121062,"Armant, Debra","San Diego",92025,"US"
121119,"Armogida, Bruce","Philadelphia",19119,"US"
120812,"Arruza, Fauver","Miami-Dade",33133,"US"
120756,"Asta, Wendy","Philadelphia",19145,"US"
120754,"Atkins, John","Miami-Dade",33161,"US"
120185,"Bahlman, Sharon","Sydney",2165,"AU"
120109,"Baker, Gabriele","Sydney",2119,"AU"
120710,"Baltzell, Timothy","Philadelphia",19140,"US"
121007,"Banaszak, John","Philadelphia",19139,"US"
121011,"Banchi, Steven","Miami-Dade",33031,"US"
120188,"Baran, Shanmuganathan","Sydney",1225,"AU"
120144,"Barbis, Viney","Sydney",2114,"AU"
120168,"Barcoe, Selina","Melbourne",8003,"AU"
120182,"Barreto, Geok-Seng","Sydney",1115,"AU"
;
run;

proc sort data= addresses;
   by country;
run;

proc report data=addresses nowd;/*4*/
   columns Country City PostalCode State EmployeeID EmployeeName; 
   by country;
   define State / computed 'State/Province';
   compute State / char length=5;
      State=StateProv(Country,PostalCode);
   endcomp;
   title 'Employees with State Codes';
run;

title;
