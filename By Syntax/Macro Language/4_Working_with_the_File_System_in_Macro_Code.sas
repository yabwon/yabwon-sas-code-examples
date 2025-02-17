/************************************************************************************************
 Working with the File System in Macro Code
    1. Identifying the directory associated with a SAS libref.
    2. Creating a new directory.
    3. Writing to a text file in a directory.
    4. Reading all files from a directory.
    5. Copying a file from one directory to another.
    6. Deleting a file from a directory.
    7. Deleting all files from a directory and then deleting the empty directory.

    Keywords: MACRO                                                               
    SAS Versions: SAS 9, SAS Viya                                                    
    Documentation: https://go.documentation.sas.com/doc/en/pgmsascdc/default/mcrolref/titlepage.htm

    NOTES:
       1. This code should be executed in a fresh SAS session. In SAS Studio, you can press F9
          to reset the SAS session before starting work with this code.
       2. Execute the steps in thie exampl in sequence. Subsequent steps often rely on macro 
          variables, files, and macro programs created in previous steps.
************************************************************************************************/

/************************************************************************************************
 1. Identifying the directory associated with a SAS libref.
    a. Use the %QSYSFUNC function to execute the PATHNAME function. PATHNAME returns the
       fully-qualified physical name of an external file (fileref) or a SAS library (libref).
************************************************************************************************/
%let workPath=%qsysfunc(pathname(WORK));               /*a*/
%put NOTE: The WORK library is located in &=workPath;  
/************************************************************************************************
 2. Creating a new directory.
    a. Use the %QSYSFUNC function to execute the DCREATE function. DCREATE accepts a
       fully-qualified path to a new directory and creates that directory in the file system.
       This line creates a directory named mydir within the WORK library path. Macro variable 
       myNewDir will contain the path to the new directory.
    b. Use the %QSYSFUNC function to execute the DCREATE function. DCREATE accepts a
       fully-qualified path to a new directory and creates that directory in the file system.
       This line creates a directory named mydir2 within the WORK library path. Macro variable 
       myNewDir will contain the path to the new directory.
************************************************************************************************/
%let myNewDir=%qsysfunc(dcreate(mydir,%superq(workPath)));   /*a*/ 
%put NOTE: The new directory is &=myNewDir;                 
%let myNewDir2=%qsysfunc(dcreate(mydir2,%superq(workPath))); /*b*/ 
%put NOTE: The new directory is &=myNewDir2;

/************************************************************************************************
 3. Writing to a text file in a directory.
    See comments in the code.
************************************************************************************************/
/* Creating the macro program */
%macro write2File(directory,sourceFile,text2write);
   /* Here, we specify the fileref (myfile) to be assigned to the text file. */
   %let fileref=myfile;                                                        /*a*/                                                                                                                     
   /* Use the %SYSFUNC function to execute the FILENAME function, assigning the fileref 
   myfile to the text file to which we intend to write. */
   %let rc=%sysfunc(filename(fileref, %superq(directory)/%superq(sourceFile)));  /*b*/
   /* Use the %SYSFUNC function to execute the FOPEN function to open the test file. The update(U) 
   option will create a new file if the file does not exist, or update an existing file. If 
   successful, a numeric ID is assigned to fileID. If not successful, fileID will be 0. */
   %let fileId=%sysfunc(fopen(&fileref,u));                                    /*c*/

   /* If successful */
   %if &fileId > 0 %then %do;
      /* Use the %SYSFUNC function to execute the FPUT function to write text to the buffer. */
      %let rc=%sysfunc(fput(&fileId, %superq(text2write)));
      /* Use the %SYSFUNC function to execute the FAPPEND function to append the buffer text to the text file. */
      %let rc=%sysfunc(fappend(&fileId));
      /* Use the %SYSFUNC function to execute the FCLOSE function to close the text file. */
      %let rc=%sysfunc(fclose(&fileId));
   %end;
   /* If fileID was 0, the file could not be opened. Write messages and stop execution. */
   %else %do;
      %put ERROR: Could not open the file.;
      %put %sysfunc(sysmsg());
      %return;
   %end;
   /* Use the %SYSFUNC function to execute the FILENAME function and clear the myfile fileref. */
   %let rc=%sysfunc(filename(fileref));
%mend write2File;                                                                                                                             
  
/* Using the macro program */
/* Use the new write2File macro to write two lines of text to a file named myFile.txt. */
%write2File(%superq(myNewDir),myfile.txt,This is line 1.)
%write2File(%superq(myNewDir),myfile.txt,This is line 2.)

/* This DATA _NULL_ step wrties the contents of our new file to the log. */
data _null_;
	infile "%superq(myNewDir)/myfile.txt";
	input;
	put _infile_;
run;

/************************************************************************************************
 4. Listing the files in a directory.
    See comments in the code.
************************************************************************************************/
/* Use a DATA _NULL_ step to create three new text files containing SAS code. */
data _null_;
	file "%superq(myNewDir)/program1.sas";
	put '%put NOTE: This was written by program 1';
	file "%superq(myNewDir)/program2.sas";
	put '%put NOTE: This was written by program 2';
	file "%superq(myNewDir)/program3.sas";
	put '%put NOTE: This was written by program 3';
run;

/* Creating the macro program */
%macro listFiles(directory,outVar);
   /* If a macro variable is specified to hold the results, check to see if it already exists 
      in any symbol table. If not, declare the varable local to the listFiles macro. */
   %if &outVar ne %then %do;
      %if %symexist(&outVar)=0 %then %local &outvar;       
   %end;
   /* Specify the fileref (thisDir) to be assigned to the text file. */
   %let fileref=thisDir;
   /* Use the %SYSFUNC function to execute the FILENAME function, assigning the 
      fileref thisDir to the directory we intend to work with. */
   %let rc=%sysfunc(filename(fileref,%superq(directory)));
   /* If successful use the %SYSFUNC function to execute the DOPEN function to open the 
      directory, and assign a numeric directory ID to dirID. */
   %if &rc= 0 %then %do;
      %let dirID=%sysfunc(dopen(&fileref));
   %end;
   /* If unsuccessful assigning the fileref, provide an error message and stop execution. */
   %else %do; 
      %put ERROR: Could not assign fileref.;
      %put %sysfunc(sysmsg());
      %return;
   %end;
   /* If unsuccessful opening the directory, provide an error message and stop execution. */
   %if &dirID= 0 %then %do;
      %put ERROR: Could not locate this directory.;
      %put %sysfunc(sysmsg());
      %return;
   %end;
   /* Use the %SYSFUNC function to execute the DNUM function to determine the number of files in the directory.  */
   %let numFiles=%sysfunc(dnum(&dirID));
   /* If there are no files in the directory, write a note to the log. */
   %if &numFiles=0 or &numfiles=. %then %do; 
      %put NOTE: There are no files in the specified directory.;
      %put NOTE: &=numfiles;
   %end;
   /* Execute once for each file in the directory. */
   %else %do i=1 %to &numFiles;
      /* Use the %SYSFUNC function to execute the DREAD function to read the current 
         file name from the directory into the macro variable sourceFile. */
      %let sourceFile=%sysfunc(DREAD(&dirID,&i));
      /* If using an output macro variable list, add the name to the macro variable. */
      %if &outVar ne %then %let &outVar=&&&outVar &sourceFile;
      /* Otherwise, write the file name to the log. */
      %else %do;
	     %if &i=1 %then %put NOTE: &i.. &sourceFile;
    	 %else %put NOTE- &i.. &sourceFile;
      %end;
   %end;
   /* Use the %SYSFUNC function to execute the DCLOSE function to close the directory. */
   %let rc=%sysfunc(dclose(&dirID));
   /* Use the %SYSFUNC function to execute the FILENAME function to clear the fileref. */
   %let rc=%sysfunc(filename(fileref));
   /* If an output macro variable was specified, print the contents to the log. */
   %if &outVar ne %then %put NOTE: &outVar=&&&outVar;
%mend listFiles;

/* Using the macro program */
/* List a directory's contents to the log */
%listFiles(%superq(myNewDir))
/* List a directory's contents to a macro variable.  */
%listFiles(%superq(myNewDir),fileList)
/* List the contents of an empty directory to the log. */
%listFiles(%superq(myNewDir2))

/************************************************************************************************
 5. Copying a file from one directory to another.
    See comments in the code.
************************************************************************************************/
/* Creating the macro program */
%macro copyFile(sourceFile,from,to,destinationFile);
   /* If a new name is not specified, give the destination file the same name as the source file. */
   %if %superq(destinationFile)= %then %let destinationFile=%superq(sourceFile);
   /* Specify the fileref (source) to be assigned to the source file. */
   %let sourceFileref=source;
   /* Use the %SYSFUNC function to execute the FILENAME function, assigning the source
      filererf to the source file */
   %let rc=%sysfunc(filename(sourceFileref, %superq(from)/%superq(sourceFile)));
   /* If the filref can't be assigned, issue an error message and stop processing */
   %if &rc ne 0 %then %do;
      %put ERROR: Could not assign fileref to source file.;
      %put %sysfunc(sysmsg());
      %return;
   %end;
   /* Specify the fileref (dest) to be assigned to the destination file. */
   %let destinationFileref=dest;
   /* Use the %SYSFUNC function to execute the FILENAME function, assigning the dest
      filererf to the destination file */
   %let rc=%sysfunc(filename(destinationFileref, %superq(to)/%superq(destinationFile)));
   /* If the filref can't be assigned, issue an error message, got to the end of the 
      program where the source fileref is cleared, then stop processing */
   %if &rc ne 0 %then %do;
      %put ERROR: Could not assign fileref to the destination file.;
      %put %sysfunc(sysmsg());
      %goTo closeSource;
   %end;
   /* Use the %SYSFUNC function to execute the FCOPY function to copy the source 
      file to the destination.  */
   %let rc=%sysfunc(fcopy(source,dest));
   /* If the copy didn't work, issue an error message. */
   %if &rc ne 0 %then %do;
      %put ERROR: Could not copy the file.;
      %put %sysfunc(sysmsg());
   %end;
   /* Indicate how the success of the process in the log. */
   %PUT NOTE: File %superq(from)/%superq(sourceFile);
   %put NOTE- was copied to:;
   %PUT NOTE- File %superq(to)/%superq(destinationFile);
   /* Clear the dest fileref */
   %let rc=%sysfunc(filename(destinationFileref));
%closeSource:
   /* Clear the source fileref */
   %let rc=%sysfunc(filename(sourceFileref));
%mend copyFile;

/* Using the macro program */
/* Copy program1.sas from mydir to mydir2 */
%copyFile(program1.sas,%superq(myNewDir),%superq(myNewDir2))
/* List files in mydir and mydir2 */
%listFiles(%superq(myNewDir),fileList)
%listFiles(%superq(myNewDir2),fileList)

/************************************************************************************************
 6. Deleting a file from a directory.
    See comments in the code.
************************************************************************************************/
/* Creating the macro program */
%macro deleteFile(directory,targetFile);
   %if %superq(targetFile)= %then %do;
      /* Specify the fileref (tgtDir) to be assigned to the target directory. */
      %let fileref=tgtDir;
      /* Use the %SYSFUNC function to execute the FILENAME function to assign the fileref
         tgtDir to the target directory. */
      %let rc=%sysfunc(filename(fileref, %superq(directory)));
   %end;
   %else %do;
      /* Specify the fileref (tgtFile) to be assigned to the target file. */
      %let fileref=tgtFile;
      /* Use the %SYSFUNC function to execute the FILENAME function to assign the fileref
         tgtFile to the target file. */
      %let rc=%sysfunc(filename(fileref, %superq(directory)/%superq(targetFile)));
   %end;
   /* If the fileref was assigned OK */
   %if &rc = 0 %then %do;
      /* Use the %SYSFUNC function to execute the FDELETE function delete the target. */
      %let rc=%sysfunc(fdelete(&fileref));
   %end;
   %else %do;
      /* Otherwise, write and error message to the log and stop processing */
      %put ERROR: Could not assign fileref.;
      %put %sysfunc(sysmsg());
      %return;
   %end;
   /* If the target was not properly deleted */
   %if &rc ne 0 %then %do;
      /* Write and error message to the log */
      %put ERROR: Could not delete file.;
      %put %sysfunc(sysmsg());
   %end;
   
   /* Use the %SYSFUNC function to execute the FILENAME function clear the target fileref */
   %let rc=%sysfunc(filename(fileref));
   /* Write the appropriate completio note to the log */
   %if %superq(targetFile)= %then %PUT NOTE: Directory %superq(directory) was deleted.;
   %else %PUT NOTE: File %superq(directory)/%superq(targetFile) was deleted.;
%mend deleteFile;

/* Using the macro program */
/* Delete program1.sas from the mydir2 directory */
%deleteFile(%superq(myNewDir),program1.sas)
/* List files in the the mydir2 directory to prove it worked */
%listFiles(%superq(myNewDir),fileList)

/************************************************************************************************
 7. Deleting all files from a directory, then deleting the empty directory. We use the listFiles 
    macro from section 4 to list the file names in the specified directory, then the deleteFile 
    macro from section 6 to delete any files in the directory, and finally to delete the empty 
    directory.

    See comments in the code.
************************************************************************************************/
/* Creating the macro program */
%macro deleteDirectory(directory);
   /* Declare a local variable (fileList) to hold the list produced by the listFiles macro */
   %local fileList;
   /* Use the listFiles macro from section 4 to get a list of files in the target directory. */
   %listFiles(%superq(directory),fileList);
   /* If the target directory is already empty */ 
   %if %superq(fileList)= %then %do;
      /* Write a note to the log. */
      %put NOTE: No files were available in directory %superq(directory);
      /* Go to the section that deletes the empty directory */
      %goto deleteDir;
   %end;
   /* If the target directory is not empty, get the name of the first file */ 
   %let fileNum=1;
   %let thisFile=%qscan(%superq(fileList),&fileNum,%nrstr( ));
   /* Iterate these steps until there are no more filenames in the list */
   %do %while (%superq(thisFile) ne );
      /* Delete the current file using the deleteFile macro from section 6 */
      %deleteFile(%superq(directory),%superq(thisFile));
/*       %let rc=%sysfunc(filename(fileref)); */
      /* Add one to the counter */
      %let fileNum=%eval(&fileNum+1);
      /* Get the name of the next file on the list */
      %let thisFile=%qscan(%superq(fileList),&fileNum,%nrstr( ));
   %end;
%deleteDir:
   /* Delete the empty directory using the deleteFile macro from section 6 */
   %deleteFile(%superq(directory));
%mend deleteDirectory;

/* Using the macro program */
%listFiles(%superq(workPath))
%deleteDirectory(%superq(myNewDir2))
%listFiles(%superq(workPath))