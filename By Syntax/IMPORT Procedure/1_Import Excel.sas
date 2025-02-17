/************************************************************************************************
 READ EXCEL DATA WITH PROC IMPORT                                                                                   
     This program uses PROC IMPORT to read spreadsheets within a Excel file.                                                                       
     Keywords: PROC IMPORT, Excel, import data                                                               
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation: https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=acpcref&docsetTarget=p0jf3o1i67m044n1j0kz51ifhpvs.htm
     1. Create a macro variable named PATH that stores the path of the WORK library in your
        environment. The value of PATH is written in the log.                           
     2. Generate an Excel file named Cars.xlsx and save it in the folder stored in the PATH
        macro variable. The Excel file includes two spreadsheets: AllCars and Europe. 
     3. The FILE= option on the PROC IMPORT statement provides the path and file name of the 
        Excel file to import. In this scenario, &PATH will be replaced with the previously 
        stored path to the WORK library location. 
     4. The DBMS= option identifies the data source type, XLSX. The first spreadsheet in the 
        file will be read by default.
     5. The OUT= option names the output SAS table.
     6. The REPLACE option overwrites an existing SAS data set. If you omit REPLACE, the 
        IMPORT procedure does not overwrite an existing file.    
     7. The SHEET= statement is used to read a specific sheet within the Excel workbook.
     8. Data set options can be used after the output SAS table. In this example, the WHERE=
        data set option filters the rows written to work.USA.                      
************************************************************************************************/

%let path = %sysfunc(pathname(work));          /*1*/
%put &=path;

libname xlout xlsx "&path/cars.xlsx";          /*2*/

data xlout.AllCars;
    set sashelp.cars;
run;

data xlout.Europe;
    set sashelp.cars;
    where Origin="Europe";
run;

proc import file="&path/cars.xlsx"             /*3*/
            dbms=xlsx                          /*4*/
            out=work.AllCars                   /*5*/
            replace;                           /*6*/
run;

proc import file="&path/cars.xlsx" 
            dbms=xlsx 
            out=work.Europe 
            replace;
    sheet=Europe;                              /*7*/
run;

proc import file="&path/cars.xlsx" 
            dbms=xlsx 
            out=work.USA(where=(Origin="USA")) /*8*/
            replace;
run;



