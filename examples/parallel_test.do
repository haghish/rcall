* Notes: Make sure this runs within Stata and in batch-mode on Windows
* %STATABATCH% do "examples/parallel_test.do"
* where STATABATCH is something like "StataSE-64.exe /e" in your path.

//make sure new-ish version of the -parallel- pkg is installed so that it comes with -bshell-.
cap findfile bshell.ado
_assert _rc==0, msg("need to install a new-ish version of parallel pkg")

loc debug debug
rcall `debug' shell(bshell cmd /c) vanilla: df=as.matrix(cars);
cap confirm matrix r(df)
_assert _rc==0, msg("command didn't run")
