/************************************************************************************************
 PRINT FIRST N ROWS FROM EACH TABLE IN A LIBRARY (%PRINTALL MACRO)                            
     The %PRINTALL macro allows you to provide a library name and number of observations. The 
     macro executes a PROC PRINT for each table in the library and diplays the first N rows.  
     Examples:                                                                                
         %printall(lib=work, obs=10)                                                          
         %printall(lib=maps, obs=5)  
     Keywords: PROC PRINT, PROC DATASETS, MACRO                                                             
     SAS Versions: SAS 9, SAS Viya                                                    
     1. Create a macro named PRINTALL with parameters, Lib and Obs. 
     2. Define the parameters as local scope.      
     3. PROC DATASETS creates a table named TEMP1 that includes column metadata for each table
        in the selected library. One row is generated for each column in each table. Only the
        Memname column is kept, which captures all tables in the library. 
     4. The DATA _NULL_ step creates a series of macro variables - DS1, DS2, etc. - one for 
        each table in the library. 
     5. The %DO loop executes PROC PRINT for each DSn macro variable, or each table in the 
        library. 
     6. The %PRINTALL macro call executes the macro to print the first 5 rows in each table 
        in the WORK library. 
************************************************************************************************/

%macro printall(lib= , obs=5);                                    /*1*/
   %local obs num i;                                              /*2*/
   proc datasets library=&lib memtype=data nodetails;             /*3*/
      contents out=work.temp1(keep=memname) data=_all_ noprint;
   run;
   data _null_;                                                   /*4*/
      set work.temp1 end=final;
      by memname notsorted;
      if last.memname;
      n+1;
      call symput('ds'||left(put(n,8.)),trim(memname));
      if final then call symput('num',put(n,8.));
   run;
   %do i=1 %to &num;                                              /*5*/
      proc print data=&lib..&&ds&i(obs=&obs) noobs;
         title "Data Set &lib..&&ds&i";
      run;
   %end;
%mend printall;

%printall(lib=work, obs=5)                                        /*6*/
