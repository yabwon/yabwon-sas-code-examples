/************************************************************************************************
 PRINT MULTIPLE TABLES TO ONE XLXS FILE USING ODS EXCEL
     This program illustrates how to use ODS EXCEL and PROC PRINT to create an XLSX file with one worksheet (Excel "tab") for each source table.
     Keywords: PROC PRINT, Excel, report                                                               
     SAS Versions: SAS 9, SAS Viya                                                    
     Documentation:
          - https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=odsug&docsetTarget=p09n5pw9ol0897n1qe04zeur27rv.htm
          - https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=odsug&docsetTarget=p14qidvs5xf7omn14ommvsuhvmzn.htm
          - https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=default&docsetId=proc&docsetTarget=p10qiuo2yicr4qn17rav8kptnjpu.htm
      1. Path to save Excel file to. Must be accessible by the SAS session. Include trailing slash appropriate for operating system. 
      2. The name of the output Excel file.
      3. The fileref, XLXPRT in this example, will be used to create the ODS Excel output.
      4. Create a macro variable named RUNDT that stores today's date in YYYY-MM-DD format.
      5. Open the ODS EXCEL output.
      6. Create the XLSX file on the path referenced by XLXPRT.
      7. Set the ODS style for output to DAISY.
      8. Freeze the header rows in the XLSX file such that they are always visible when scrolling.
      9. ROWBREAKS_INTERVAL determines when page breaks are added to the XLSX file. With OUTPUT, page breaks are added between output objects.
     10. SHEET_NAME sets the worksheet name in the XLSX file. In this example, the name will include the date the report was run by use of the RUNDT macro variable.
     11. PROC PRINT is used to print the CLASSFIT dataset to the current worksheet in the XSLX file.
     12. Column names in the header row will be left-justified and appear in a bold font.
     13. Provide a name for the second worksheet. All other settings from the previous OPTIONS statement are retained.
     14. PROC PRINT is used to print the CLASS dataset to the second worksheet in the XSLX file.
     15. CLOSE the ODS EXCEL output.
************************************************************************************************/

%let outFilePath = c:\temp\demo\; /*1*/
%let outFileName = class_data.xlsx; /*2*/
filename xlXprt "&outFilePath.&outFileName"; /*3*/
%let runDt = %sysfunc(today(),yymmdd10.); /*4*/

ods excel /*5*/
	file=xlXprt /*6*/
	style=daisy /*7*/
	options(
		frozen_headers="on" /*8*/
		rowbreaks_interval="output" /*9*/
		sheet_name="Class Fitness &runDt" /*10*/
	)
;
proc print data=sashelp.classfit /*11*/
	noobs
	label
	style(header)=[textalign=left font_weight=bold] /*12*/
;
run;

ods excel options(sheet_name="Class &runDt"); /*13*/
proc print data=sashelp.class /*14*/
	noobs
	label
	style(header)=[textalign=left font_weight=bold]
;
run;

ods excel close; /*15*/
