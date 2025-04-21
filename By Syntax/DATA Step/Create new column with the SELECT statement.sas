/************************************************************************************************
 CREATE NEW COLUMN WITH THE SELECT STATEMENT
     This program illustrates how to use the SELECT statement in a DATA step to assign values to a 
         given variable based on values of another variable or expression. This is an alternative to 
         IF/THEN/ELSE syntax and may be preferred, especially when assigning many values. SELECT is 
         similar to a CASE expression in a PROC SQL query.
     Keywords: DATA STEP, SELECT, calculated columns
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=lestmtsref&docsetTarget=p09213s9jc2t99n1vx0omk2rh9ps.htm
      1. Create a new dataset named CARS_ORIG_COUNTRY in the WORK library.
      2. Read the existing SASHELP.CARS dataset, but KEEP only the MAKE, MODEL, and ORIGIN variables.
      3. Create a variable named ORIGIN_COUNTRY as a character variable with a length of 25.
      4. SELECT the value of the MAKE variable as each observation is processed in the PROGRAM DATA VECTOR (PDV).
      5. Assign a value to the ORIGIN_COUNTRY variable based on the current value of MAKE, Japan and Acura in this case.
	     Values are contained in quotation marks (single quotes in this example) since both variables are of type character.
      6. Use OTHERWISE to assign a missing value to ORIGIN_COUNTRY for cases when the value of MAKE is not specified in
	     the SELECT statement.
      7. END specifies the end of the SELECT values.
	  8. RENAME the ORIGIN variable to ORIGIN_REGION for clarity between the 2 ORIGIN variables in the resulting dataset.
      9. An alternate approach allows multiple values listed inside the parentheses, separated by commas. 
************************************************************************************************/

data work.cars_orig_country;                                         /*1*/
    set sashelp.cars(keep=Make Model Origin);                        /*2*/
    length Origin_Country $25;                                       /*3*/
    select (Make);                                                   /*4*/
        when ('Acura') Origin_Country = 'Japan';                     /*5*/
        when ('Honda') Origin_Country = 'Japan';
        when ('Hyundai') Origin_Country = 'South Korea';
        when ('Infiniti') Origin_Country = 'Japan';
        when ('Isuzu') Origin_Country = 'Japan';
        when ('Kia') Origin_Country = 'South Korea';
        when ('Lexus') Origin_Country = 'Japan';
        when ('Mazda') Origin_Country = 'Japan';
        when ('Mitsubishi') Origin_Country = 'Japan';
        when ('Nissan') Origin_Country = 'Japan';
        when ('Scion') Origin_Country = 'Japan';
        when ('Subaru') Origin_Country = 'Japan';
        when ('Suzuki') Origin_Country = 'Japan';
        when ('Toyota') Origin_Country = 'Japan';
        when ('Audi') Origin_Country = 'Germany';
        when ('BMW') Origin_Country = 'Germany';
        when ('Jaguar') Origin_Country = 'England';
        when ('Land Rover') Origin_Country = 'England';
        when ('Mercedes-Benz') Origin_Country = 'Germany';
        when ('MINI') Origin_Country = 'England';
        when ('Porsche') Origin_Country = 'Germany';
        when ('Saab') Origin_Country = 'Sweden';
        when ('Volkswagen') Origin_Country = 'Germany';
        when ('Volvo') Origin_Country = 'Sweden';
        when ('Buick') Origin_Country = 'United States of America';
        when ('Cadillac') Origin_Country = 'United States of America';
        when ('Chevrolet') Origin_Country = 'United States of America';
        when ('Chrysler') Origin_Country = 'United States of America';
        when ('Dodge') Origin_Country = 'United States of America';
        when ('Ford') Origin_Country = 'United States of America';
        when ('GMC') Origin_Country = 'United States of America';
        when ('Hummer') Origin_Country = 'United States of America';
        when ('Jeep') Origin_Country = 'United States of America';
        when ('Lincoln') Origin_Country = 'United States of America';
        when ('Mercury') Origin_Country = 'United States of America';
        when ('Oldsmobile') Origin_Country = 'United States of America';
        when ('Pontiac') Origin_Country = 'United States of America';
        when ('Saturn') Origin_Country = 'United States of America';
        otherwise Origin_Country = '';                               /*6*/
    end;                                                             /*7*/
    rename Origin = Origin_Region;                                   /*8*/
run;


data work.cars_orig_country;                                         /*9*/
    set sashelp.cars(keep=Make Model Origin);
    length Origin_Country $25; 
    select (Make); 
        when ('Acura', 'Honda', 'Infiniti', 'Isuzu', 'Lexus', 'Mazda', 'Mitsubishi', 'Nissan', 'Scion', 'Subaru', 'Suzuki', 'Toyota') 
            Origin_Country = 'Japan'; 
        when ('Hyundai', 'Kia') 
            Origin_Country = 'South Korea';
        when ('Audi', 'BMW', 'Mercedes-Benz', 'Volkswagen', 'Porsche')  
            Origin_Country = 'Germany';
        when ('Jaguar', 'Land Rover', 'MINI') 
            Origin_Country = 'England';
        when ('Saab', 'Volvo') 
            Origin_Country = 'Sweden';
        when ('Buick', 'Cadillac', 'Chevrolet', 'Chrysler', 'Dodge', 'Ford', 'GMC', 'Hummer', 'Jeep', 'Lincoln', 'Mercury', 'Oldsmobile', 'Pontiac', 'Saturn') 
            Origin_Country = 'United States of America';
        otherwise Origin_Country = '';
    end; 
    rename Origin = Origin_Region; 
run;
