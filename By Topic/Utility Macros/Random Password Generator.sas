/************************************************************************************************
 RANDOM PASSWORD GENERATION
    A macro program that generates a random password based on a list of allowed characters.
    Keywords: Macro
    SAS Versions: SAS 9, SAS Viya
    Documentation: https://go.documentation.sas.com/doc/en/pgmsascdc/default/mcrolref/titlepage.htm
    1. Define keyword arguments control the length and characters used in the password.
    2. Build a macro variable containing all allowed characters.
    3. In a loop, use %SUBSTR(%SYSFUNC(RAND)) to select random characters...
    4. ...and append them to the growing password.
    5. Test macro via a simple loop and various settings.
    6. Use a random password for an encryption key on a tempoarary dataset.
NOTE: Does not (currently) support unmatched single or double quote characters in the special 
      characterw string. Mismatched left or right parentheses have not been tested either.
************************************************************************************************/

/************************************************************************************************
 1. Define keyword arguments control the length and characters
    used in the password.
    a. len= is the desired length of the password, defaulting to 24
    b. digits= is a Boolean flag, defaulting to TRUE. When TRUE (non-zero),
       digits 0-9 are available for use in the password.
    c. special= is a set of special characters to also use in passwords. Defaults
       to those shown in the %NRSTR(). Use special= to not have any specials.
************************************************************************************************/

%MACRO RANDPASS(len=24,digits=1,special=%NRSTR(@%&#!?.-_+*,/;:));
%LOCAL pass;
%LOCAL chars;
%LOCAL numchars;
%LOCAL pick;
%LOCAL i;

/************************************************************************************************
 2. Build a macro variable containing all allowed characters.
    a. Add the lowercase letters.
    b. Add uppercase characters via %UPCASE().
    c. Add digits, if requested.
    d. Add special characters. Note the use of %SUPERQ() to avoid issues
       with &s and %s that may be present in the string.
************************************************************************************************/

%LET chars=abcdefghijklmnopqrstuvwxyz;
%LET chars=&chars%UPCASE(&chars);
%IF &digits %THEN
	%LET chars=&chars.0123456789;
%LET chars=&chars%SUPERQ(special);

%LET numchars=%length(&chars);

%DO i=1 %TO &len;

/************************************************************************************************
 3. In a loop, use %SUBSTR(%SYSFUNC(RAND)) to select random characters...
    a. RAND('INTEGER', n) produces a random intger between 1 and n, inclusive
       which is exactly what we need.
    b. %SYSFUNC() invokes it from Macro.
    c. %SUBSTR(string, N, 1) plucks the Nth character from the string.
************************************************************************************************/

    %LET pick=%SUBSTR(&chars,%SYSFUNC(RAND(INTEGER,&numchars)),1);

/************************************************************************************************
 4. ...and append them to the growing password.
    a. Note in particular the shenanigans here.
    b. Simply coding "%LET pass=%SUPERQ(pass)&pick" _does_not_work_. Hidden
       macro quoting characters end up in &pass, in a nested fashion, and
       this produces nested Macro function WARNINGs when the password length
       grows to about 12 characters, which is unacceptable.
    c. The %QSUBSTR() manages to avoid this problem, and also avoids attempts
       to resolve any &foo that might appear in the growing password.
    d. However, %QSUBSTR() can't work on an empty string, so we have to avoid
       it first time though, hence the %IF.
************************************************************************************************/

    %IF &i = 1 %THEN
        %LET pass=&pick;
    %ELSE
        %LET pass=%QSUBSTR(%SUPERQ(pass),1)&pick;
%END;

%* The result of the macro is this generated password;
%SUPERQ(pass)

%MEND;

/************************************************************************************************
 5. Test macro via a simple loop and various settings.
    a. We need to define a macro for this. Macro now allows %IF statements in
       "open code", but not loops.
    b. Just two cases here. All-defaults, plus longer-no-digits-no-specials.
    c. The "test" just prints them to the log, for eyeballing.
    d. Then we run the loop 3 times to get an idea as to what it's doing.
************************************************************************************************/

%MACRO TEST(n);
    %DO i=1 %TO &n;
        %PUT pw1=%RANDPASS();
        %PUT pw2=%RANDPASS(len=30,digits=0,special=);
	%END;
%MEND;

%TEST(3);

/************************************************************************************************
 6. Use a random password for an encryption key on a tempoarary dataset.
    a. Generate a longish (60 characters) password, safe from prying eyes.
    b. Import a list of NSA recruits from a secret location no one has
       ever heard of, and protect it with AES encryption with our generated
       password.
    c. Now we can run analytics on it safely. Run PROC MEANS, and
       then ponder why the recruits are all teenagers.
    d. Drop the table (I used PROC SQL), knowing that even if the
       data was recovered from the disk, the encryption renders it unreadable.
************************************************************************************************/

%LET pw=%randpass(len=60);
%*PUT pw=&pw   <== to see it, but its supposed to be a secret;

DATA nsaclass(ENCRYPT=aes ENCRYPTKEY="&pw");
    SET sashelp.class;
RUN;

PROC MEANS DATA=nsaclass(ENCRYPTKEY="&pw");
RUN;

PROC SQL;
    DROP TABLE nsaclass;
QUIT;
