/*** DO NOT EDIT THIS LINE -----------------------------------------------------
Version: 1.0.0
Title: {opt R:call}
Description: Seemless interactive 
__[R](https://cran.r-project.org/)__ in  Stata. The package return 
{help return:rclass} __R__ objects (_numeric_, _character_, _list_, _matrix_, etc). It also 
allows passing Stata {help macro}, {help scalar}, and {help matrix} to __R__, 
which provides a reciprocal interaction between Stata and __R__. 
For more information visit [Rcall homepage](http://www.haghish.com/packages/Rcall.php).
----------------------------------------------------- DO NOT EDIT THIS LINE ***/


/***
Syntax
======

seemless interactive execution of __R__ in Stata. the __vanilla__ subcommand executes
__R__ non-interactively

{p 8 16 2}
{opt R:call} [{cmd:vanilla}] [{cmd::}] [{it:R code}]
{p_end}


permanently setup the path to executable R on the machine, if different with the 
default paths (see below)

{p 8 16 2}
{opt R:call} {cmd:setpath}  {it:"string"}
{p_end}

Debug mode
===========

You can run the package in _debug mode_ by adding __debug__ subcommand before 
any other subcommand or R code. For example:

        . R: debug vanilla print("Hello World") 
        . R: debug setpath "{it:/usr/bin/r}" 

Description
===========

The {opt R:call} package provides solution for Stata users who wish to run 
[R statistical software](https://cran.r-project.org/) within Stata. 
[R](https://cran.r-project.org/) is a free software environment for statistical 
computing and graphics. 
The package provides an interactive __R__ session within Stata, and  
returns __R__ objects into Stata simultaniously, i.e. anytime an R code is executed, 
the R objects are available for further manipulation in Stata. {opt R:call} 
not only returns _numeric_ and _charactor_ objects, but also _lists_ and 
_matrices_. 

Data communication between Stata and R
======================================

Stata automatically receives __R__ objects as {help return:rclass} anytime 
the {opt R:call} is executed. If __R__ is running interactively 
(i.e. without __vanilla__ subcommand), the previous objects still remain accessable 
to Stata, unless they are changed or erased from __R__. The table below shows the 
of the functions needed for data communication. 

{* the new Stata help format of putting detail before generality}{...}
{synoptset 22 tabbed}{...}
{synopthdr:Function}
{synoptline}
{synopt:{opt st.scalar()}}passes a scalar to R{p_end}
{synopt:{opt st.matrix()}}passes a matrix to R{p_end}
{synopt:{opt st.data(filename)}}passes data from Stata to R{p_end}
{synopt:{opt load.data(dataframe)}}loads data from R dataframe to Stata{p_end}
{synoptline}
{p2colreset}{...}

For an ideal reciprocation between Stata and __R__, Stata should also easily 
communicate variables to __R__. Local and global {help macro:macros} can be passed 
within __R__ code, since Stata automatically interprets them while it passes the 
code to {opt R:call} command, as shown in the example below:

        . global a 99 
        . R: (a <- $a)  	
        [1] 99 		

In order to pass a {help scalar} from Stata to __R__, you can 
use the __st.scalar() function as shown below:

        . scalar a = 50 
        . R: (a <- st.scalar(a))  	
        [1] 50 		

Similarly, Stata {help matrix:matrices} can be seemlessly passed to __R__ using 
the __st.matrix()__ function as shown below:

        . matrix A = (1,2\3,4) 
        . matrix B = (96,96\96,96) 		
        . R: C <- st.matrix(A) + st.matrix(B)
        . R: C 
             [,1] [,2]
        [1,]   97   98
        [2,]   99  100
 
And of course, you can access the matrix from __R__ in Stata as well: 

        . mat list r(C) 
        r(C)[2,2]
             c1   c2
        r1   97   98
        r2   99  100
		
The {opt R:call} package also allows to pass Stata data to __R__ within 
__st.data(_{help filename}_)__ function. This function relies on the __foreign__ 
package in __R__ to load Stata data sets, without converting them to CSV or alike. 
The __foreign__ package can be installed within Stata as follows:

        . R: install.packages("foreign", repos="http://cran.uk.r-project.org")

Specify the relative or absolute path to the data set to transporting data 
from Stata to __R__. For example: 

        . R: data <- st.data(/Applications/Stata/ado/base/a/auto.dta) 
        . R: dim(data)

If the _filename_ is not specified, the function passes the currently loaded 
data to __R__. 

        . sysuse auto, clear 
        . R: data <- st.data() 
        . R: dim(data) 
        [1] 74 12
		
Finally, the data can be imported from R to Stata automatically, using the 		
__load.data(_dataframe_)__ function. This function will automatically save a 
Stata data set from __R__ and load it in Stata by clearing the current data set, 
if there is any. Naturally, you can have more control over converting variable 
types if you write a proper code in R for exporting Stata data sets. Nevertheless, 
the function should work just fine in most occasions: 

        . clear 
        . R: data <- data.frame(cars) 
        . R: load.data(mydata) 
        . list in 1/2
        {c TLC}{hline 14}{c TRC}
        {c |} speed   dist {c |}
        {c LT}{hline 14}{c RT}
     1. {c |}     4      2 {c |}
     2. {c |}     4     10 {c |}
        {c BLC}{hline 14}{c BRC}

R path setup
============

The package requires [R](https://cran.r-project.org/) to be installed on the machine. 
The package detects __R__ in the default paths based on the operating system. 
The easiest way to see if __R__ is accessible is to execute a command in __R__

        . R: print("Hello World") 
        [1] "Hello World" 
 
If __R__ is not accessible, you can also permanently 
setup the path to __R__ using the __setpath__ subcommand. For example, the 
path to __R__ on Mac 10.10 could be:

    . {cmd:R setpath} "{it:/usr/bin/r}"

Remarks
=======

You should be careful with using Stata symbols in __R__. For example, the __$__ 
sign in Stata is preserved for global macros. To use this sign in __R__, you 
should place a backslash before it to pass it to __R__. For example:

        . R: head(cars\$speed)

Also, the object name in __R__ can include a dot, for example:
 
        . R: a.name <- "anything" 
		
The {opt R:call} package returns scalars and locals which can only include 
underscore in the names (e.g. a_name). {opt R:call} automatically converts 
dots to underscore in the name. In the example above, if you type {cmd:return list}, 
you would get a macro as follos:

        r(a_name) : "anything"

Erasing R memory
================

When you work with __Rcall__ interactively (without __vanilla__ subcommand), 
anything you do in __R__ is memorized and 
saved in a __.RData__ file automatically, even if you quit __R__ using __q()__ 
function. If you wish to clear the memory and erase everything defined in R, 
you should __unlink__ the __.RData__ file:

        . R: unlink(".RData") 		

Example(s)
=================

Visit [Rcall homepage](http://www.haghish.com/packages/Rcall.php) for more examples and 
documentation. 

Author
======

__E. F. Haghish__     
Center for Medical Biometry and Medical Informatics     
University of Freiburg, Germany     
_and_        
Department of Mathematics and Computer Science       
University of Southern Denmark     
haghish@imbi.uni-freiburg.de     
      
[http://www.haghish.com/markdoc](http://www.haghish.com/statistics/stata-blog/reproducible-research/markdoc.php)         
Package Updates on [Twitter](http://www.twitter.com/Haghish)     

- - -

This help file was dynamically produced by {help markdoc:MarkDoc Literate Programming package}
***/





*cap prog drop Rcall
program define Rcall , rclass
	
	version 12

	// -------------------------------------------------------------------------
	// Syntax processing
	// =========================================================================
	
	//Get R path, if defined
	capture prog drop Rpath
	capture Rpath
	
	
	// Check if the command includes Colon in the beginning
	if substr(trim(`"`macval(0)'"'),1,1) == ":" {
		local 0 : subinstr local 0 ":" ""
	}
	
	if substr(trim(`"`macval(0)'"'),1,5) == "debug" {
		local 0 : subinstr local 0 "debug" ""
		local debug 1
		
		if !missing("`debug'") {
			di _n "{title:[1/5] Debug mode}" _n										///
			"Running Rcall in debug mode"
		}	
	}
	if substr(trim(`"`macval(0)'"'),1,7) == "vanilla" {
		local 0 : subinstr local 0 "vanilla" ""
		local vanilla --vanilla
		if !missing("`debug'") {
			di _n "{title:Vanilla}" _n												///
			"Running R in non-interactive batch mode"
		}	
	}
	else if substr(trim(`"`macval(0)'"'),1,7) == "setpath" {
		local 0 : subinstr local 0 "setpath" ""
		confirm file `0'
		
		//Save an ado file
		tempfile Rpath
		tempname knot
		qui file open `knot' using "`Rpath'", write text replace
		file write `knot' "program define Rpath" _n
		file write `knot' `"	global Rpath `macval(0)'"' _n
		file write `knot' "end" _n
		qui file close `knot'
		qui copy "`Rpath'" "`c(sysdir_plus)'r/Rpath.ado", replace
		
		if !missing("`debug'") {
			di "{title:Memorizing R path}" _n									///
			`"the {bf:Rpath.ado} was created to memorize the path to `macval(0)'"' 
		}
		
		exit
	}
	
	// Check if the command includes Colon in the end
	if substr(trim(`"`macval(0)'"'),1,1) == ":" {
		local 0 : subinstr local 0 ":" ""
	}
	
	if !missing("`debug'") {
		di _n "{title:R command}" _n												///
		"The command that you wish to execute in {bf:R} is:" _n(2) `"{err:`macval(0)'}"' 
	}
		
	
	// Searching for Matrix
	// -------------------------------------------------------------------------
	while strpos(`"`macval(0)'"',"st.matrix(") != 0 {
		local br = strpos(`"`macval(0)'"',"st.matrix")
		local l1 = substr(`"`macval(0)'"',1, `br'-1)
		local l2 = substr(`"`macval(0)'"',`br',.)
		local l2 : subinstr local l2 "st.matrix(" ""
		local mt = strpos(`"`macval(l2)'"',")") 
		local mat = substr(`"`macval(l2)'"',1, `mt'-1)
		local l2 = substr(`"`macval(l2)'"',`mt'+1, .)
 		
		if !missing("`debug'") {
			di _n "{title:st.matrix() function}" _n								///
			"You wish to pass Matrix {bf:`mat'} to {bf:R}. This will call "  ///
			"the {bf:matconvert.ado} function, which returns:"
			matconvert `mat'
		}
		
		qui matconvert `mat'
		local l2 = "`r(`mat')'" + "`l2'"
		
		*local l2 = `r(`mat')' + "`l2'"
		
		*di as err "l1:`l1'"
		*di as err "l2:`l2'"
		
		
		local 0 = `"`macval(l1)'"' + `"`macval(l2)'"'
	}
	
	// Searching for Scalar
	// -------------------------------------------------------------------------
	while strpos(`"`macval(0)'"',"st.scalar(") != 0 {
		local br = strpos(`"`macval(0)'"',"st.scalar")
		local l1 = substr(`"`macval(0)'"',1, `br'-1)
		local l2 = substr(`"`macval(0)'"',`br',.)
		local l2 : subinstr local l2 "st.scalar(" ""
		local mt = strpos(`"`macval(l2)'"',")") 
		local sca = substr(`"`macval(l2)'"',1, `mt'-1)
		local l2 = substr(`"`macval(l2)'"',`mt'+1, .)
 		
		if !missing("`debug'") {
			di _n "{title:st.scalar() function}" _n								///
			"You wish to pass Scalar {bf:`sca'} to {bf:R}. This value is: "   
			display `sca'
		}
		
		local sca : display `sca'
		
		//If scalar is string, add double quote
		capture local test : display int(`sca')		
		if missing("`test'") & "`sca'" != "" {							
			local sca : display `"`sca'"'
			local l2 = `"""' + `"`macval(sca)'"' + `"""' + "`l2'"
		}
		else {
			local l2 = "`sca'" + "`l2'"
		}

		*di as err "l1:`l1'"
		*di as err `"l2:`macval(l2)'"'
		local 0 = `"`macval(l1)'"' + `"`macval(l2)'"'
		
	}
	
	
	// Searching for Data
	// -------------------------------------------------------------------------
	while strpos(`"`macval(0)'"',"st.data(") != 0 {
		local br = strpos(`"`macval(0)'"',"st.data")
		local l1 = substr(`"`macval(0)'"',1, `br'-1)
		local l2 = substr(`"`macval(0)'"',`br',.)
		local l2 : subinstr local l2 "st.data(" ""
		local mt = strpos(`"`macval(l2)'"',")") 
		local filename = substr(`"`macval(l2)'"',1, `mt'-1)
		local l2 = substr(`"`macval(l2)'"',`mt'+1, .)
		
		local foreign 1 						//load foreign package
		
		if !missing("`debug'") {
			di _n "{title:st.data() function}" _n								///
			"You wish to pass Stata data {bf:`filename'} to {bf:R}..."   
		}
		
		//IF FILENAME IS MISSING
		if missing("`filename'") {
			qui saveold _st.data.dta, version(11) replace 
			local dta : di "read.dta(" `"""' "_st.data.dta" `"""' ")"
		}
		else {
			confirm file "`filename'"
			preserve
			qui use "`filename'", clear
			qui saveold _st.data.dta, version(11) replace 
			local dta : di "read.dta(" `"""' "_st.data.dta" `"""' ")"
			restore
		}
		
		local l2 = `"`macval(dta)'"' + `"`macval(l2)'"'
		
		*di as err "l1:`l1'"
		*di as err `"l2:`macval(l2)'"'
		local 0 = `"`macval(l1)'"' + `"`macval(l2)'"'
		
	}
	
	// Searching for Load Data
	// -------------------------------------------------------------------------
	while strpos(`"`macval(0)'"',"load.data(") != 0 {
		local br = strpos(`"`macval(0)'"',"load.data")
		local l1 = substr(`"`macval(0)'"',1, `br'-1)
		local l2 = substr(`"`macval(0)'"',`br',.)
		local l2 : subinstr local l2 "load.data(" ""
		local mt = strpos(`"`macval(l2)'"',")") 
		local loaddata = substr(`"`macval(l2)'"',1, `mt'-1)
		local l2 = substr(`"`macval(l2)'"',`mt'+1, .)
		
		local foreign 1 						//load foreign package
		local forceload 1 						//load data to stata
		
		if !missing("`debug'") {
			di _n "{title:load.data() function}" _n								///
			"You wish to force loading R data {bf:`loaddata'} to {bf:Stata}..." _n  
		}
		
		//IF FILENAME IS MISSING
		if missing("`loaddata'") {
			display as err "data frame is not specified"
			err 198
		}

		
		local 0 = `"`macval(l1)'"' + `"`macval(l2)'"'
		
		if !missing("`debug'") di _n `"`macval(0)'"'
		
	}
	
	
	*local line : subinstr local line "$" "_", all //avoid "$" in name
	// -------------------------------------------------------------------------
	// Create temporary Rscript file
	// =========================================================================
	capture findfile stata.output.R, path("`c(sysdir_plus)'s")
	if _rc != 0 {
		di as err "stata.output.R script file not found. reinstall the package"
		err 198
	}
	
	//Change the stata.output.R path in Windows
	if "`c(os)'" == "Windows" {
		local source `r(fn)'
		local source : subinstr local source "/" "\", all				 
	}
	
	tempfile Rscript
	tempfile Rout
	tempname knot
	qui file open `knot' using "`Rscript'", write text replace
	if !missing("`foreign'") file write `knot' "library(foreign)" _n
	if !missing(`"`macval(0)'"') file write `knot' `"`macval(0)'"' _n
	file write `knot' "source('`source'')" _n
	file write `knot' "stata.output()" _n
	file write `knot' "rm(stata.output)" _n		//remove 
	if !missing("`forceload'") {
		file write `knot' `"write.dta(`loaddata', "'							///
		`"file = "_load.data.dta", version = 11) "' _n
	} 	
	*file write `knot' "save.image()" _n
	qui file close `knot'
	
	if !missing("`debug'") {
		di _n "{title:[2/5] Temporary R script}" _n								///
		"{p}A temporary Rscript file was created to execute your command in "		///
		"{bf:R}. The path to the temporary file is: "  _n				
		display `"`Rscript'"'
		
		di _n "{title:Investigate R script}" _n									///
		"You can investigate the temporary R script file in debug mode." _n
		
		capture erase _temporary_R_script.R
		copy "`Rscript'" _temporary_R_script.R, replace 
		di "{browse _temporary_R_script.R}"
	}
		
	*cap erase 0PROCESS0.txt
	*copy "`Rscript'" 0PROCESS0.txt, replace
	
	
	// -------------------------------------------------------------------------
	// Execute the command in R
	// =========================================================================
	
	//By default, the input commands are printed along with the output. 
	//To suppress this behavior, add options(echo = FALSE) at the beginning of 
	//infile, or use option --slave. 
	
	
	if missing("$Rpath") {
		local path = cond(c(os) == "Windows", "Rterm.exe", "/usr/bin/r")
		
		if !missing("`debug'") {
			di _n "{title:Path to R}" _n								///
			"The path to R was {err:guessed} to be:"  _n
			display `"{err:`path'}"'
		}
	}
	else {
		local path = "$Rpath"
		
		if !missing("`debug'") {
			di _n "{title:Path to R}" _n								///
			"The path to R was obtained from {err:Rpath.ado} to be:"  _n
			display `"{err:`path'}"'
		}
	}	
	
	local Rcommand `""`path'" `vanilla' --slave --save < "`Rscript'" > "`Rout'" "'
	
	*local Rcommand `""`path'" `vanilla' --save  < "`Rscript'" > "`Rout'" "'
	
	if !missing("`debug'") {
		di _n "{title:[3/5] Running R in batch mode}" _n								///
		"The following command is executed in Stata:"  _n
		display `"{p}{err:shell `Rcommand'}"'
	}
	
	quietly shell `Rcommand'
	
	capture confirm file stata.output
	if _rc != 0 {
		shell `Rcommand'
		exit
	}
	
	if !missing("`debug'") {
		di _n "{title:[4/5] R Output}" _n								///
		"R output was generated. A copy is made in the debug mode..." _n
		
		capture erase _temporary_R_output.R
		copy "`Rout'" _temporary_R_output.R, replace 
		di "{browse _temporary_R_output.R}"
	}
	
	// If data was loaded automatically, remove the temporary data file
	if !missing("`foreign'") capture qui erase _st.data.dta
	
	*cap erase 0PROCESS1.txt
	*copy "`Rout'" 0PROCESS1.txt, replace
	
	// -------------------------------------------------------------------------
	// Edit the output file & print it in Stata
	// =========================================================================
	
	//NOT IN SLAVE MODE, Because it doesn't include the command
	
	/*
	tempfile tmp
	tempname hitch
	qui file open `hitch' using `"`Rout'"', read
	qui file open `knot' using `"`tmp'"', write text replace
	file read `hitch' line
	
	// JUMP THE INTRO AND SOURCING THE FUNCTION
	
	// indicator1 is used for removing the intro
	// indicator2 is used for avoiding empty lines in the beginning of the file
	
	while r(eof) == 0 {
		
		// REMOVE R INTRO
		// ===============
		
		
		
		if missing("`indicator'") {
			while r(eof) == 0 & substr(`"`macval(line)'"',1,2) != "> " {
				file read `hitch' line
			}
			local indicator 1	
		}
		
		
		file read `hitch' line
		
		
		// REMOVE R Commands
		// =================	
		cap if substr(`"`macval(line)'"',1,2) != "> " { 
			if "`line'" != "" & !missing("`indicator2'") file write `knot'  _n
			if "`line'" != "" file write `knot' `"`macval(line)'"' 
			local indicator2 1
		}	
		file read `hitch' line
	}
	
	qui file close `knot'
	qui file close `hitch'
	
	type "`tmp'"
	copy "`tmp'" 0PROCESS2.txt, replace	
	*/
	
	type "`Rout'"
	
	*capture erase 0PROCESS2.txt
	*copy "`Rout'" 0PROCESS2.txt, replace
	
	if !missing("`debug'") {
		di _n "{title:[5/5] rclass return}" _n								///
		"The final step is returning objects from R to Stata" _n
	}
	
	// -------------------------------------------------------------------------
	// Returning objects to Stata
	// =========================================================================
	if substr(trim(`"`macval(0)'"'),1,3) != "q()" {
		tempname hitch
		qui file open `hitch' using "stata.output", read
		file read `hitch' line
		
		while r(eof) == 0 {
			
			local jump									// reset
			
			// NULL OBJECT 
			// ===========================
			if substr(`"`macval(line)'"',1,7) == "//NULL " {	
				local line : subinstr local line "//NULL " ""
				local line : subinstr local line "." "_", all //avoid "." in name
				local name : di `"`macval(line)'"'
				return local `name' "NULL"
			}
			
			// SCALAR OBJECT 
			// ===========================
			if substr(`"`macval(line)'"',1,9) == "//SCALAR " {
				local line : subinstr local line "//SCALAR " ""
				local line : subinstr local line "." "_", all //avoid "." in name
				local name : di `"`macval(line)'"'
				file read `hitch' line
				return scalar `name' = `line'
			}
			
			// NUMERIC OBJECT LENGTH > 1 
			// ===========================
			if substr(`"`macval(line)'"',1,14) == "//NUMERICLIST " {
				local line : subinstr local line "//NUMERICLIST " ""
				local line : subinstr local line "." "_", all //avoid "." in name
				local name : di `"`macval(line)'"'
				file read `hitch' line
				local content
				while r(eof) == 0 & substr(`"`macval(line)'"',1,2) != "//" {
					local content `content' `line' 
					file read `hitch' line
					local jump 1
				}
				return local `name' = "`content'"
			}
			
			// STRING OBJECT AND CLIST
			// ===========================
			if substr(`"`macval(line)'"',1,9) == "//STRING " |					///
			substr(`"`macval(line)'"',1,8) == "//CLIST " {
				local line : subinstr local line "//STRING " ""
				local line : subinstr local line "//CLIST " ""
				local line : subinstr local line "." "_", all //avoid "." in name
				local line : subinstr local line "$" "_", all //avoid "$" in name
				local name : di `"`macval(line)'"'
				file read `hitch' line
				local content
				while r(eof) == 0 & substr(`"`macval(line)'"',1,2) != "//" {
					if missing("`content'") local content : di "`content'`line'" 
					else local content : di "`content'`line'{break}" 
					file read `hitch' line
					local jump 1
				}
				return local `name' `"`macval(content)'"'
			}
			
			// LIST OBJECT (NUMERIC)
			// ===========================
			if substr(`"`macval(line)'"',1,7) == "//LIST " {
				local line : subinstr local line "//LIST " ""
				local line : subinstr local line "." "_", all //avoid "." in name
				local line : subinstr local line "$" "_", all //avoid "$" in name
				
				local name : di `"`macval(line)'"'
				
				file read `hitch' line
				local content
				while r(eof) == 0 & substr(`"`macval(line)'"',1,2) != "//" {
					if missing("`content'") local content : di "`content'`line'" 
					else local content : di "`content'`line'" 
					file read `hitch' line
					local jump 1
				}
				return local `name' "`content'"
			}
			
			// MATRIX OBJECT (NUMERIC)
			// ===========================
			if substr(`"`macval(line)'"',1,9) == "//MATRIX " {
				local line : subinstr local line "//MATRIX " ""
				local line : subinstr local line "." "_", all //avoid "." in name
				local line : subinstr local line "$" "_", all //avoid "$" in name
				local name : di `"`macval(line)'"'
				
				//GET NUMBER OF ROWS
				file read `hitch' line
				if substr(`"`macval(line)'"',1,11) == "rownumber: " {
					local line : subinstr local line "rownumber: " ""
					local rownumber : di `"`macval(line)'"'
				}
				
				file read `hitch' line
				local content
				while r(eof) == 0 & substr(`"`macval(line)'"',1,2) != "//" {
					local content `content' `line' 
					file read `hitch' line
					local jump 1
				}
				matrix define `name' = (`content')
				*mat list `name'
				mata: `name' = st_matrix("`name'") 
				*mata: `name'
				mata: st_matrix("`name'", rowshape(`name', `rownumber'))  
				return matrix `name' = `name'
			}
			
			if missing("`jump'") file read `hitch' line
		}
		*capture erase list.txt
		*copy stata.output list.txt, replace
		capture erase stata.output
	}
	
	
	
	// If data was loaded automatically, remove the temporary data file
	
	if !missing("`forceload'") {
		capture confirm file _load.data.dta
		if _rc != 0 {
			di as err "{bf:R} failed to export Stata data set"
			exit
		}
		else {
			quietly use _load.data.dta, clear
			capture qui erase _load.data.dta
		}
	}
	
end



// -------------------------------------------------------------------------
// CREATE THE R.ado, abbreviated command
// =========================================================================

/*
tempfile edited
tempname hitch knot
qui file open `hitch' using "Rcall.ado", read
qui file open `knot' using "`edited'", write text replace
file read `hitch' line
while r(eof) == 0 {
	local line : subinstr local line " Rcall" " R"
	file write `knot' `"`macval(line)'"' _n
	file read `hitch' line
	if substr(`"`macval(line)'"',1,3) == "end" {
		file write `knot' `"`macval(line)'"' _n
		exit
	}	
}
qui file close `knot'
copy "`edited'" R.ado, replace
cap prog drop R


// Create the dynamic help file
markdoc Rcall.ado, export(sthlp) replace
copy Rcall.sthlp R.sthlp, replace

