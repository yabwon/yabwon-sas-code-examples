/************************************************************************************************
 SPLIT TABLE BY COLUMN
    A macro program that splits a table by the unique values of a specified column.
    Keywords: Macro
    SAS Versions: SAS 9, SAS Viya
    Documentation: https://go.documentation.sas.com/doc/en/pgmsascdc/default/mcrolref/titlepage.htm
    1. Create a macro function called SplitTableByColumn that takes two parameters
    2. Use PROC SQL to extract all unique values from a specific column in a dataset and store them
       in a macro variable.
    3. Use the macro variable created in step 1 to split the input table into multiple datasets.
    4. End the macro definition.
    5. Example usage of the macro.
    Note: This macro does not work if the unique values in the specified column
          contain spaces or special characters that are not valid in SAS dataset names.
************************************************************************************************/

/************************************************************************************************
1. Create a macro function called SplitTableByColumn that takes two parameters:
   a. input_table: the name of the input dataset to be split.
   b. split_column: the name of the column whose unique values will determine how the table is split.
   The macro will create separate datasets for each unique value in the specified column.
************************************************************************************************/
%macro SplitTableByColumn(input_table, split_column);
/************************************************************************************************
2. use PROC SQL to extract all unique values from a specific column in a dataset and store them
   in a macro variable.
   a. proc sql starts a SQL procedure in SAS.
   b. The noprint option tells SAS not to display the usual output in the results window, as this
      PROC SQL is only to create macro variables.
   c. select distinct &split_column selects all unique (distinct) values from &split_column.
   d. into :unique_values separated by ' ' stores all the resulting unique values as a list in one
      macro variable called unique_values. The separated by ' ' part means that the values will be
      joined together in the macro variable, separated by spaces.
   e. from &input_table; specifies the source table, using the macro variable &input_table to
      refer to the dataset.
   f. quit; ends the PROC SQL step.
************************************************************************************************/
proc sql noprint;
    select distinct &split_column into :unique_values separated by ' '
    from &input_table;
quit;

/************************************************************************************************
3. Use the macro variable created in step 1 to split the input table into multiple datasets.
   a. A data step is used to create separate datasets for each unique value.
   b. The set statement reads from the input table specified by the macro variable input_table.
   c. A loop iterates over the list of unique values stored in the macro variable unique_values.
      It does this by using the %scan function to extract the first to the last unique value,
      represented by the macro variable sqlobs, which is automatically updated by PROC SQL. It
      assigns the current unique value to a local scope macro variable called current_value.
   d. The if statement checks if the current row's value in the macro variable split_column
      matches the current unique value, and if so, outputs that row to a new dataset named after
      the unique value.
************************************************************************************************/
data &unique_values;
    set &input_table;
    %do i=1 %to &sqlobs;
        %local current_value;
        %let current_value=%scan(&unique_values, &i);
        if &split_column = "&current_value" then output &current_value;
    %end;
run;
/************************************************************************************************
4. End the macro definition.
   a. The %mend statement marks the end of the macro definition.
************************************************************************************************/
%mend SplitTableByColumn;

/************************************************************************************************
5. Example usage of the macro.
   a. Call the macro with the input table SASHELP.CARS and split by the Origin
*************************************************************************************************/
%SplitTableByColumn(input_table=SASHELP.CARS, split_column=Origin)