# Contributing
Maintainers are accepting patches and contributions to this project.

Please note the following contribution guidelines.

## Contributor License Agreement
Contributions to this project must be accompanied by a signed [Contributor Agreement](ContributorAgreement.txt).
You (or your employer) retain the copyright to your contribution.
This simply permits the project maintainers to use and redistribute your contributions as part of the project.

## Requirements for Sample Program Contributions

* Each program must include the [standard comment block](comment-template.txt) at the top of the program. The comment includes the following information:
  - **TITLE**: Brief program description in ALL CAPS
  - **Description**: Detailed explanation of the objective of the program
  - **Keywords**: comma-delimited keywords from [KEYWORDS.txt](KEYWORDS.txt)   
  - **SAS Version**: List the versions of SAS for the program, such as SAS 9 or SAS Viya. Note that most programs will run in both SAS 9 and Viya.
  - **Documentation**: Provide a link to SAS documentation that supports the key objective of the program.
  - **Numbered list describing numbered comments in the program**: Use /\*1\*/ comment notation in the program to identify the corresponding part of the program.  
* Each program should execute successfully regardless of the programming interface, including SAS Studio, Enterprise Guide, Visual Studio Code, etc. If there are exceptions or requirements, note them in the comment.
* When possible, use SASHELP tables. If other data is necessary, create the input table(s) in the code using a DATA step with DATALINES. If data is embedded in the program, it must be approved by SAS Legal.
* Be sure to reference [KEYWORDS.txt](KEYWORDS.txt) for valid keywords. If you would like to suggest additional keywords, you may include a modification to the KEYWORDS.txt file in your pull request. Please add new keywords in alphabetic sequence within the existing list. 

## Code Reviews
All submissions, including submissions by project members, require review.
Project maintainers use GitHub pull requests for this purpose.
Consult [GitHub Help](https://help.github.com/articles/about-pull-requests/) for more information about using pull requests.

