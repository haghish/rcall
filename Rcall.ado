/*** DO NOT EDIT THIS LINE -----------------------------------------------------
Version: 1.0.0
Title: {opt R:call}
Description: Seemless interactive __R__ in  Stata. The command also return 
rclass __R__ objects (_numeric_, _character_, _list_, _matrix_, etc). For more 
information visit [Rcall homepage](http://www.haghish.com/rcall).
----------------------------------------------------- DO NOT EDIT THIS LINE ***/


/***
Syntax
======

seemless interactive execution of R in Stata. the __vanilla__ subcommand executes
__R__ non-interactively

{p 8 16 2}
{opt R:call} [{cmd:vanilla}] [{cmd::}] [{it:R code}]
{p_end}


permanently setup the path to executable R on the machine, if different with the 
default paths (see below)

{p 8 16 2}
{opt R:call} {cmd:setpath}  {it:"string"}
{p_end}

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
		
Example(s)
=================

    permanently setup the path to R 
        . R setpath "/usr/bin/r" 

    execute an R code interactively
        . example command

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
	capture Rpath
	
	//remove vanilla 
	// Check if the command includes Colon
	if substr(trim(`"`macval(0)'"'),1,7) == "vanilla" {
		local 0 : subinstr local 0 "vanilla" ""
		local vanilla --vanilla
	}
	else if substr(trim(`"`macval(0)'"'),1,7) == "setpath" {
		local 0 : subinstr local 0 "setpath" ""
		confirm file `0'
		
		//Save an ado file
		tempfile Rpath
		tempname knot
		qui file open `knot' using `"`Rpath'"', write text replace
		file write `knot' "program define Rpath" _n
		file write `knot' `"global RpathGlobal `macval(0)'"' _n
		file write `knot' "end" _n
		qui file close `knot'
		qui copy "`Rpath'" "`c(sysdir_plus)'r/Rpath.ado", replace
		exit
	}
	
	// Check if the command includes Colon
	if substr(trim(`"`macval(0)'"'),1,2) == ": " {
		local 0 : subinstr local 0 ": " ""
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
	
	tempfile Rscript
	tempfile Rout
	tempname knot
	qui file open `knot' using `"`Rscript'"', write text replace
	file write `knot' `"`macval(0)'"' _n
	file write `knot' "source('`r(fn)'')" _n
	file write `knot' "stata.output()" _n
	file write `knot' "rm(stata.output)" _n		//remove 
	*file write `knot' "save.image()" _n
	qui file close `knot'
	// -------------------------------------------------------------------------
	// Execute the command in R
	// =========================================================================
	
	//By default, the input commands are printed along with the output. 
	//To suppress this behavior, add options(echo = FALSE) at the beginning of 
	//infile, or use option --slave. 
	
	
	if missing("$Rpath") {
		local path = cond(c(os) == "Windows", "Rterm.exe", "/usr/bin/r")
	}
	else local path = "$Rpath"
	
	local Rcommand `""`path'" `vanilla' --slave --save < "`Rscript'" > "`Rout'" "'
	
	*local Rcommand `""`path'" `vanilla' --save  < "`Rscript'" > "`Rout'" "'
	
	quietly shell `Rcommand'
	
	capture confirm file stata.output
	if _rc != 0 {
		shell `Rcommand'
		exit
	}
	
	*copy "`Rscript'" 0PROCESS0.txt, replace
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
				mata: `name' = st_matrix("`name'") 
				mata: st_matrix("`name'", rowshape(`name', `rownumber'))  
				return matrix `name' = `name'
			}
			
			if missing("`jump'") file read `hitch' line
		}
		*capture erase list.txt
		*qui copy stata.output list.txt, replace
		capture erase stata.output
	}
	
end




// -------------------------------------------------------------------------
// CREATE THE R.ado, abbreviated command
// =========================================================================
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


/*

//THIS IS HOW YOU CAN REMOVE THE STUFF, not q()
R: object <- NULL
R: char <- "this is some string"
R: listobject <- list(x = cars[,1], y = cars[,2], s="this is some lovely string")

R: q()
R: rm(list=ls())
R: yek <- print("this")
R: yek
R vanilla : do <- print("this")
return list
R: do

*R: source('~/Dropbox/STATA/MY PROGRAMS/rdo/get.R')

*return list



Rcall rm(list=ls())
R: z <- 9
Rcall print(z)
R print(ls())
return list

markdoc Rcall.ado, export(sthlp) replace 
