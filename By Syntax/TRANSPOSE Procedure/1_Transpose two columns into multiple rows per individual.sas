proc transpose data=sashelp.class;
    by Name;
	var Height Weight;
run;