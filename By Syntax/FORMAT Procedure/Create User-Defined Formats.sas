/************************************************************************************************
 CREATE USER-DEFINED FORMATS TO CHANGE DISPLAYED COLUMN VALUES                                                                                  
     This program generates user-defined/custom formats using PROC FORMAT. 
     Keywords: PROC FORMAT, FORMAT, PROC CATALOG, FMTLIB, custom format                                                             
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p1xidhqypi0fnwn1if8opjpqpbmn.htm
     1. VALUE statements are used to assign the source value or range to the displayed value.
     2. The Data Step with a FORMAT statement is utilized to apply the custom formats to the relevant columns.
        The FORMAT statement can also be used in Procedures.
     3. PROC CATALOG creates a summary listing of the user-defined format entries in a library.                           
     4. The FMTLIB option added to PROC FORMAT creates a list report of the user-defined format 
		definitions.                           
     Note: Formats do not change the stored value in the input table.                                                          
************************************************************************************************/


proc format; 
    value cyl                                   /*1*/
    . = "N/A"
    2 = "2 Cylinders - Motorcyles"
	3 = "3 Cylinders - Compact Cars"
    4 = "4 Cylinders - Compact Cars and Midsize Sedans"
    5 = "5 Cylinders - Midsize Cars and SUVs"
    6 = "6 Cylinders - Mid to Large Cars, SUVs and Trucks"
    8 = "8 Cylinders - Performance Cars, Large SUVs and Trucks"
    10 = "10 Cylinders - High-Performance Sports Cars and Trucks"
    12 = "12 Cylinders - Luxury and High-Performance Vehicles"
    ;

    value esize
    low-1.5 = "Small Engines"
    1.6-2.5 = "Medium Engines"
    2.6-4.0 = "Large Engines"
    4.1-high ="Extra-Large Engines"
    ;
 	
    value mpg
    low-19 = "Low Efficiency"
    20-29 = "Moderate Efficiency"
    30-39 = "High Efficiency"
    40-high ="Ultra Effciency"
    ;

    value msrp    	
    low-30000 = "Budget-Friendly"
    30001-50000 = "Mid-Range"
    50001-100000 = "Premium"
    100001-high = "Luxury"
    ;
		
    value weight
    low-3000 = "Lightweight Vehicles"
    3001-5000 = "Midweight Vehicles"
    5001-7500 = "Heavyweight Vehicles"
    7501-high = "Super Heavy-Duty Vehicles"
    ;

run;


data cars_formatted;                            /*2*/
    set sashelp.cars;
    keep Model MSRP EngineSize MPG_Highway Weight Cylinders;
    format  Cylinders cyl. EngineSize esize. MPG_Highway mpg. MSRP msrp. Weight weight.;
 
run;


proc catalog cat=work.formats;                  /*3*/
    contents;

run;


proc format lib=work fmtlib;                    /*4*/     

run;
