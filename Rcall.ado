/*** DO NOT EDIT THIS LINE -----------------------------------------------------
Version: 1.1.5
Title: {opt R:call}
Description: seamless interactive __[R](https://cran.r-project.org/)__ in Stata.
The package automatically returns {help return:rclass} R objects with 
_numeric_, _integer_, _character_, _logical_, _matrix_, _data.frame_, _list_, and _NULL_ 
classes in Stata. It also allows passing Stata __variables__, __data set__, 
{help macro}, {help scalar}, and {help matrix} to R as well as load data from R 
to Stata automatically, 
which provides an automated reciprocal communication between Stata and R. 
For more information visit [Rcall homepage](http://www.haghish.com/packages/Rcall.php).
----------------------------------------------------- DO NOT EDIT THIS LINE ***/

/***
Syntax
======

In general, the syntax of the {opt R:call} package can be abbreviated as 
follows:

{p 8 16 2}
{opt R:call} [{it:mode}] [{cmd::}] [{it:command}]
{p_end}


The {opt R:call} package was designed to be interactive. However, additional _modes_ were 
designed to enhance the functionality of the package for embedding R script 
in _ado_ programs or using it for _exploratory analysis_. 
The table below summarizes the _mode_ subcommand

{* the new Stata help format of putting detail before generality}{...}
{synoptset 22 tabbed}{...}
{synopthdr:Mode}
{synoptline}
{synopt:{opt vanilla}}Calls R non-interactively. This mode is advised for programmers 
who wish to embed R in theis Stata packages{p_end}

{synopt:{opt sync}}synchronizes _data_, _matrices_, and _scalars_ between 
R and Stata. Making a change in any of these objects in either Stata or 
R will change the object in the other environment. Programmers are 
advised not to use this mode in ado programs. {p_end}

{synopt:{opt setpath}}permanently defines the path to executable 
R on the machine, which can be given as a string{p_end}
{synoptline}
{p2colreset}{...}


The colon sign [{cmd::}] is optional, only meant to separate the Stata command 
from R command. The [{it:mode}] is subcommand changes the behavior of {opt R:call} 
and can be __setpath__, __vanilla__, and __sync__. In addition to these modes, 
{opt R:call} also includes an _R console mode_ which can be evoked by 
executing {opt R:call} without any R command. 
{help Rcall##running_R:Read more about console mode...}

{p 8 16 2}
{opt R:call} [{cmd:sync}] [{cmd::}]
{p_end}


In contrast, executing {opt R:call} with an R command will avoid entering 
the _R console mode_. The __vanilla__ subcommand executes R non-interactively, but still 
communicates data from R to Stata after execution. The __sync__ mode synchronizes 
Stata and R objects which includes __data sets__, __matrices__, and __scalars__. 
Read more about {help Rcall##synchronize:sync} mode. 

{p 8 16 2}
{opt R:call} [{cmd:vanilla}] [{cmd::}] [{it:command}]
{p_end}


permanently setup the path to executable R on the machine, if different with the 
default paths ({help Rcall##Rpath:see below}).

{p 8 16 2}
{opt R:call} {cmd:setpath}  {it:"path/to/R"}
{p_end}

Description
===========

__[R statistical language](https://cran.r-project.org/)__ is a free software 
and programming langage for statistical computing and graphics. 
The {opt R:call} package combines the power of R with Stata, allowing the 
Stata users to call R interactively within Stata and communicate 
data and analysis results between R and Stata simultaniously. 

In other words, anytime an R code is executed, the R objects are available 
for further manipulation in Stata. 
R objects with 
_numeric_, _integer_, _character_, _logical_, _matrix_, _list_, and _NULL_ 
classes are automatically returned to Stata as {help return:rclass}. 

R objects with _data.frame_ class can be automatically loaded from R to 
Stata using the __load.data()__ function (see below).

Communication from R to Stata
======================================

Stata automatically receives R objects as {help return:rclass} anytime 
the {opt R:call} is executed. If R is running interactively 
(i.e. without __vanilla__ subcommand), the previous objects still remain accessable 
to Stata, unless they are changed or erased from R. Moreover, the packages 
that you load from Stata in R remain loaded until you detach them. 

Accessing R objects in Stata is simultanious which makes working with 
{opt R:call} convenient. For example a _numeric_, or _string_ vector which is 
defined in R, can be accessed in Stata as simple as calling the name of that 
object withing {help rclass} i.e. __r(_objectname_)__.  

A _numeric_ object example:

        . R: a <- 100 
        . display r(a)  	
        100 	
		
Without the __vanilla__ subcommand, the defined object remains in the memory of 
R and consequently, returned to Stata anytime R is called.

        . R: a 
        [1] 100 
		
A _string_ object example:
		
        . R: str <- "Hello World" 
        . display r(str)  	
        Hello World
		
        . R: str <- c("Hello", "World") 
        . display r(str)  	
        "Hello"  "World"
		
A _vector_ example:

        . R: v <- c(1,2,3,4,5)
        . display r(v)  	
        1 2 3 4 5

A _matrix_ example:

        . R: A = matrix(1:6, nrow=2, byrow = TRUE) 
        . mat list r(A) 
        r(A)[2,3]
            c1  c2  c3  	
        r1   1   2   3
        r2   4   5   6
		
A _list_ example:

        . R: mylist <- list(a=c(1:10))
        . display r(mylist_a) 
        1 2 3 4 5 6 7 8 9 10

A _logical_ example:

        . R: l <- T 
        . display r(l)
        TRUE
		
A _NULL_ example:

        . R: n <- NULL
        . display r(n)
        NULL	
		
Regarding communicating R data set to Stata automatically, see the 
__load.data(_dataframe_)__ function below. 
		
Communication from Stata to R
======================================

The table below shows the of the functions needed for data communication from 
Stata to R. 

{* the new Stata help format of putting detail before generality}{...}
{synoptset 22 tabbed}{...}
{synopthdr:Function}
{synoptline}
{synopt:{opt st.scalar()}}passes a scalar to R{p_end}
{synopt:{opt st.matrix()}}passes a matrix to R{p_end}
{synopt:{opt st.var(varname)}}passes a numeric or string variable to R{p_end}
{synopt:{opt st.data(filename)}}passes data from Stata to R{p_end}
{synopt:{opt load.data(dataframe)}}loads data from R dataframe to Stata{p_end}
{synoptline}
{p2colreset}{...}

For an ideal reciprocation between Stata and R, Stata should also easily 
communicate variables to R. Local and global {help macro:macros} can be passed 
within R code, since Stata automatically interprets them while it passes the 
code to {opt R:call} command, as shown in the example below:

        . global a 99 
        . R: (a <- $a)  	
        [1] 99 		

In order to pass a {help scalar} from Stata to R, you can 
use the __st.scalar()__ function as shown below:

        . scalar a = 50 
        . R: (a <- st.scalar(a))  	
        [1] 50 		

Similarly, Stata {help matrix:matrices} can be seamlessly passed to R using 
the __st.matrix()__ function as shown below:

        . matrix A = (1,2\3,4) 
        . matrix B = (96,96\96,96) 		
        . R: C <- st.matrix(A) + st.matrix(B)
        . R: C 
             [,1] [,2]
        [1,]   97   98
        [2,]   99  100
 
And of course, you can access the matrix from R in Stata as well: 

        . mat list r(C) 
        r(C)[2,2]
             c1   c2
        r1   97   98
        r2   99  100

Passing variables from Stata to R is convenient, using the  
__st.var(_varname_)__ function. Therefore, any analysis can be executed in R 
simply by passing the variables required for the analysis from Stata to R:

        . sysuse auto, clear 
        . R: dep <- st.var(price)		
        . R: pre <- st.var(mpg)	
        . R: lm(dep~pre)
        
        Call:
        lm(formula = dep ~ pre)
        
        Coefficients:
        (Intercept)          pre  
            11267.3       -238.3

The {opt R:call} package also allows to pass Stata data to R within 
__st.data(_{help filename}_)__ function. This function relies on the __foreign__ 
package in R to load Stata data sets, without converting them to CSV or alike. 
The __foreign__ package can be installed within Stata as follows:

        . R: install.packages("foreign", repos="http://cran.uk.r-project.org")

Specify the relative or absolute path to the data set to transporting data 
from Stata to R. For example: 

        . R: data <- st.data(/Applications/Stata/ado/base/a/auto.dta) 
        . R: dim(data)

If the _filename_ is not specified, the function passes the currently loaded 
data to R. 

        . sysuse auto, clear 
        . R: data <- st.data() 
        . R: dim(data) 
        [1] 74 12
		
Finally, the data can be imported from R to Stata automatically, using the 		
__load.data(_dataframe_)__ function. This function will automatically save a 
Stata data set from R and load it in Stata by clearing the current data set, 
if there is any. Naturally, you can have more control over converting variable 
types if you write a proper code in R for exporting Stata data sets. Nevertheless, 
the function should work just fine in most occasions: 

        . clear 
        . R: mydata <- data.frame(cars) 
        . R: load.data(mydata) 
        . list in 1/2
        {c TLC}{hline 14}{c TRC}
        {c |} speed   dist {c |}
        {c LT}{hline 14}{c RT}
     1. {c |}     4      2 {c |}
     2. {c |}     4     10 {c |}
        {c BLC}{hline 14}{c BRC}

{marker running_R}{...}
Running R environment
=====================

To enter the R environment within Stata, 
type {opt R:call}. This runs R in Stata 
interactively similar to running {help mata} environment. However, with 
every R command you execute, Stata obtains the objects from R 
simultaniously. Note that similar to mata environment, you cannot 
execute R commands from the Do-File Editor when the environment is 
running. To execute R from Do-File Editor, you should call R using the 
{opt R:call} command. Nevertheless, the 
__st.scalar()__, __st.matrix()__, __st.data()__, and __load.data()__ functions 
will continue to work when R environment is running. 

        . scalar a = 999
        . R:
	{hline 49} R (type {cmd:end} to exit) {hline}
        . a <- 2*(st.scalar(a))
        . a
        [1] 1998
        . end
	{hline}
		
        . display r(a)
        1998
		
		
The interactive mode also supports multi-line code. The __+__ sign is added 
automatically:

        . R:
	{hline 49} R (type {cmd:end} to exit) {hline}
        . myfunction <- function(x) {
        +
        . if (is.numeric(x)) {
            +
        .   return(x^2)
            +
        . }
        +
        . }
        . (a <- myfunction(199))
        . [1] 39601
        . end
	{hline}
		
        . display r(a)
        39601
		
{marker Rpath}{...}
R path setup
============

The package requires [R](https://cran.r-project.org/) to be installed on the machine. 
The package detects R in the default paths based on the operating system. 
The easiest way to see if R is accessible is to execute a command in R 

        . R: print("Hello World") 
        [1] "Hello World" 
 
If R is not accessible, you can also permanently 
setup the path to R using the __setpath__ subcommand. For example, the 
path to R on Mac 10.10 could be:

    . {cmd:R setpath} "{it:/usr/bin/r}"

{marker synchronize}{...}
sync mode
============

By default, {opt R:call} returns _rclass_ objects from R to Stata and allows passing 
Stata objects to R using several functions. However, the package also has a 
__sync__ mode where it __automatically synchronizes the global environments 
of Stata and R, allowing real-time synchronization between the two languages, 
which consequently __replaces__ the objects whenever they change in either of 
the environments. This mode is by default is __off__. 

The __sync__ mode allows maximum interactive experience for _numeric_ and 
_string_ scalars and _matrices_ in Stata. The mode 
___does not synchronize global macros___. See the examples below to see 
how a scalar or matrix change when the synchronization mode is __on__. 

In the example below, the value of __a__ changes from __1__ to __0__ after it 
is altered in R:

        . scalar a = 1
        . R sync: (a = 0)
        [1] 0
        . display a
        0

The same example is repeated __without__ sync mode:
		
        . scalar a = 1
        . R: (a = 0)
        [1] 0
        . display a
        1
		
The synchronize mode also replaces matrices in R and Stata, when there is a 
change in the matric in either of the environments. Naturally, new 
matrices also are synchronized:

        . mat drop _all
        . mat define A = (1,2,3 \ 4,5,6)
        . Rcall sync: B = A
        . mat list B
        
        B[2,3]
            c1  c2  c3 
        r1   1   2   3
        r2   4   5   6 
        
		. mat C = B/2
        . R sync: C
             [,1] [,2] [,3] 
        [1,]  0.5  1.0  1.5 
        [2,]  2.0  2.5  3.0 
		
As shown in the examples, any change made to the matrices, whether it has 
happened in R or Stata will be instantly available in the other environment. 
While such a level of integration between the two languages is __exciting__, 
it requires a lot of caution and testing. This is rather an exploratory 
feature which is not a main-stream approach to calling a foreign language 
in a programming language. 
__If you have suggestions or concerns in this regard, feel free to reach out to me for a discussion__.  
	
Remarks
=======

You should be careful with using Stata symbols in R. For example, the __$__ 
sign in Stata is preserved for global macros. To use this sign in R, you 
should place a backslash before it to pass it to R. For example:

        . R: head(cars\$speed)

Also, the object name in R can include a dot, for example:
 
        . R: a.name <- "anything" 
		
The {opt R:call} package returns scalars and locals which can only include 
underscore in the names (e.g. a_name). {opt R:call} automatically converts 
dots to underscore in the name. In the example above, if you type {cmd:return list} 
in Stata, you would get a macro as follos:

        . return list 
        r(a_name) : "anything"
		
To maximize the speed of calling R from Stata, 
detach the packages that are no longer needed and also, drop all the objects 
that are of no use for you. The more objects you keep in R memory, 
the more time needed to automatically communicate those objects between 
R and Stata.		

Erasing R memory and detaching objects
======================================

When you work with __Rcall__ interactively (without __vanilla__ subcommand), 
anything you do in R is memorized and 
saved in a __.RData__ file automatically, even if you quit R using __q()__ 
function. If you wish to clear the memory and erase everything defined in R, 
you should __unlink__ the __.RData__ file and erase the objects:

        . R: unlink(".RData") 	
        . R: rm(list=ls())
		
However, the commands above do not erase the __attached__ packages and data sets. 
you can view the attached objects in your R environment using the __search()__ 
function. To detach packages or objects, use the __detach()__ function. Note that 
packages are named as __"package:_name_"__. Here is an example of detaching a 
data set and a package 

        . R:
	{hline 49} R (type {cmd:end} to exit) {hline}
        . attach(cars)
        . library(Rcpp)               # make sure you have it installed
        . search()                    # Output is omitted ...
        .
        . detach(cars)
        . detach("package:Rcpp")
	{hline}

detach("package:graphics", unload=TRUE)

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
      
[Rcall Homepage](www.haghish.com/packages/Rcall.php)         
Package Updates on [Twitter](http://www.twitter.com/Haghish)     

- - -

This help file was dynamically produced by {help markdoc:MarkDoc Literate Programming package}
***/





*cap prog drop Rcall
program define Rcall , rclass
	
	version 12

	// =========================================================================
	// Syntax processing
	//   - Retreive memory files "R Path", "Synchronize mode"
	//   - Process the Rcall inputs
	//   - If R path not defined, and "setpath" not specified, search R path
	// =========================================================================
	
	capture prog drop Rpath
	capture Rpath
	
	// -------------------------------------------------------------------------
	// Input processing
	// =========================================================================
	
	// Check if the command includes Colon in the beginning
	if substr(trim(`"`macval(0)'"'),1,1) == ":" {
		local 0 : subinstr local 0 ":" ""
	}
	
	// clear R memory
	// ================
	if substr(trim(`"`macval(0)'"'),1,5) == "clear" & 							///
	trim(substr(trim(`"`macval(0)'"'),6,.)) == "" {
		
		capture erase .RData
		
		capture findfile RProfile.R, path("`c(sysdir_plus)'r")
		if _rc == 0 {
			capture erase "`r(fn)'"
		}
		exit
	}
	
	// debug mode
	// ================
	if substr(trim(`"`macval(0)'"'),1,5) == "debug" {
		local 0 : subinstr local 0 "debug" ""
		local debug 1
		
		if !missing("`debug'") {
			di _n "{title:[1/5] Debug mode}" _n									///
			"Running Rcall in debug mode"
		}	
	}
	
	// Synchronize mode
	// ================
	else if substr(trim(`"`macval(0)'"'),1,5) == "sync " |						///
		substr(trim(`"`macval(0)'"'),1,5) == "sync:" |							///
		substr(trim(`"`macval(0)'"'),1,4) == "sync" &							///
		trim(`"`macval(0)'"') == "sync" {
		local 0 : subinstr local 0 "sync" ""
		global Rcall_synchronize_mode on
	}

	
	// Vanilla mode
	// ============
	if substr(trim(`"`macval(0)'"'),1,7) == "vanilla" {
		local 0 : subinstr local 0 "vanilla" ""
		local vanilla --vanilla
		if !missing("`debug'") {
			di _n "{title:Vanilla}" _n											///
			"Running R in non-interactive batch mode"
		}	
	}
	
	// Setpath
	// =======
	else if substr(trim(`"`macval(0)'"'),1,7) == "setpath" {
		local 0 : subinstr local 0 "setpath" ""
		confirm file `0'
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
	
	// Synchronize mode
	// ================
	/*
	else if substr(trim(`"`macval(0)'"'),1,11) == "synchronize" {
		local 0 : subinstr local 0 "synchronize" ""
		if trim("`0'") != "on" & trim("`0'") != "off" {
			di as err "{bf:synchronize} can only be {bf:on} or {bf:off}"
			err 198
		}
		tempfile Rmode
		tempname knot
		qui file open `knot' using "`Rmode'", write text replace
		file write `knot' "program define Rcall_synchronize_mode" _n
		file write `knot' `"	global Rcall_synchronize_mode `0'"' _n
		file write `knot' "end" _n
		qui file close `knot'
		qui copy "`Rmode'" "`c(sysdir_plus)'r/Rcall_synchronize_mode.ado", replace
		if !missing("`debug'") {
			di "{title:Memorizing R mode}" _n									///
			`"the {bf:Rcall_synchronize.ado} is {bf:`0'}"' 
		}
		exit
	}
	*/
	
	// Check if the command includes Colon in the end
	if substr(trim(`"`macval(0)'"'),1,1) == ":" {
		local 0 : subinstr local 0 ":" ""
	}
	
	// -------------------------------------------------------------------------
	// Search R path, if not specified
	// =========================================================================
	if missing("$Rpath") {
		
		if "`c(os)'" == "Windows" {
			
			// 1- try both "Program Files" and "Program Files (86)" 
			// 2- Get the list of directories that begin with R-*
			// 3- select the last one
			
			local wd : pwd
			capture quietly cd "C:\Program Files\R"
			if _rc != 0 {
				capture quietly cd "C:\Program Files (x86)\R"
				if _rc != 0 {
					display as err "R was not found on your system. Setup R path manually"
					exit 198
				}
			}
			local folder : pwd
			local Rdir : dir "`folder'" dirs "R-*"
			tokenize `"`Rdir'"'
			while `"`1'"' != "" {
				local newest_R `"`1'"'
				macro shift
			}
			quietly cd `"`newest_R'\bin"'
			local path : pwd
			local path : display "`path'\R.exe"			
			quietly cd "`wd'"
		}
		else {
			local path "/usr/bin/r"
		}
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
	
	// -------------------------------------------------------------------------
	// Test R
	// =========================================================================
	capture confirm file "`path'"
	if _rc != 0 {
		di as txt "{p}R was expected in:    `path'"
		display as err "{bf:Rcall} could not find R on your system"
		err 198
	}
	
	// -------------------------------------------------------------------------
	// Execute interactive mode
	// =========================================================================
	if trim(`"`0'"') == "" {
		if missing("`vanilla'") Rcall_interactive
		else {
			di as err "the {bf:vanilla} mode cannot be called interactively"
			err 198
		}
	}
	if !missing("`debug'") {
		di _n "{title:R command}" _n											///
		"The command that you wish to execute in {bf:R} is:" _n(2) 				///
		`"{err:`macval(0)'}"' 
	}
		
	// -------------------------------------------------------------------------
	// Searching for Matrix
	// =========================================================================
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
			"You wish to pass Matrix {bf:`mat'} to {bf:R}. This will call "  	///
			"the {bf:matconvert.ado} function, which returns:"
			matconvert `mat'
		}
		qui matconvert `mat'
		local l2 = "`r(`mat')'" + "`l2'"		
		local 0 = `"`macval(l1)'"' + `"`macval(l2)'"'
	}
	
	// -------------------------------------------------------------------------
	// Searching for Scalar
	// =========================================================================
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
			local l2 = `"""' + `"`macval(sca)'"' + `"""' + `"`l2'"'
		}
		else if "`sca'" != "" {
			local l2 = "`sca'" + "`l2'"
		}
		else {
			local l2 = `"`sca'"' + "`l2'"
		}
		local 0 = `"`macval(l1)'"' + `"`macval(l2)'"'
	}
	
	// -------------------------------------------------------------------------
	// Searching for Data
	// =========================================================================
	while strpos(`"`macval(0)'"',"st.data(") != 0 {
		local br = strpos(`"`macval(0)'"',"st.data")
		local l1 = substr(`"`macval(0)'"',1, `br'-1)
		local l2 = substr(`"`macval(0)'"',`br',.)
		local l2 : subinstr local l2 "st.data(" ""
		local mt = strpos(`"`macval(l2)'"',")") 
		local filename = substr(`"`macval(l2)'"',1, `mt'-1)
		local l2 = substr(`"`macval(l2)'"',`mt'+1, .)
		local foreign 1 						//load foreign package
		
		//IF THE NAME HAS A PRANTHESIS...
		if strpos(`"`macval(filename)'"',"(") != 0 {
			local filename : di `"`macval(filename)')"'
			local mt = strpos(`"`macval(l2)'"',")") 
			local filename2 = substr(`"`macval(l2)'"',1, `mt'-1)
			local l2 = substr(`"`macval(l2)'"',`mt'+1, .)
			local filename : di `"`macval(filename)'`macval(filename2)'"'
		}
		if !missing("`debug'") {
			di _n "{title:st.data() function}" _n								///
			"You wish to pass Stata data {bf:`filename'} to {bf:R}..."   
		}
		
		// Get rid of double quotes or add them! 
		cap local filename : display "`macval(filename)'"
		if _rc != 0 local filename : display `macval(filename)'
		
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
		local 0 = `"`macval(l1)'"' + `"`macval(l2)'"'	
	}
	
	// -------------------------------------------------------------------------
	// Searching for Load Data
	// =========================================================================
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
	
	// -------------------------------------------------------------------------
	// Searching for variable
	// =========================================================================
	while strpos(`"`macval(0)'"',"st.var(") != 0 {
		local br = strpos(`"`macval(0)'"',"st.var")
		local l1 = substr(`"`macval(0)'"',1, `br'-1)
		local l2 = substr(`"`macval(0)'"',`br',.)
		local l2 : subinstr local l2 "st.var(" ""
		local mt = strpos(`"`macval(l2)'"',")") 
		local mat = substr(`"`macval(l2)'"',1, `mt'-1)
		local l2 = substr(`"`macval(l2)'"',`mt'+1, .)
 		
		if !missing("`debug'") {
			di _n "{title:st.var() function}" _n								///
			"You wish to pass variable {bf:`mat'} to {bf:R}. This will call "  	///
			"the {bf:varconvert.ado} function, which returns:"
			varconvert `mat'
		}
		qui varconvert `mat'
		if "`r(type)'" == "numeric" {
			local l2 = "`r(`mat')'" + "`l2'"
			local 0 = `"`macval(l1)'"' + `"`macval(l2)'"'
		}
		if "`r(type)'" == "string" {
			local l2 = `"`r(`mat')'"' + "`l2'"
			local 0 = `"`macval(l1)'"' + `"`macval(l2)'"'
		}
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
	local source `r(fn)'
	
	//Change the stata.output.R path in Windows
	if "`c(os)'" == "Windows" {
		local source : subinstr local source "\" "/", all				 
	}
	
	
	capture findfile Rprofile.site, path("`c(sysdir_plus)'r")
	if _rc == 0 {
		local RSite `r(fn)'
	}
	
	capture findfile RProfile.R, path("`c(sysdir_plus)'r")
	if _rc == 0 {
		local RProfile `r(fn)'
	}
	
	// get the path to PLUS/r
	local plusR "`c(sysdir_plus)'r"
	
	//Change the stata.output.R path in Windows
	if "`c(os)'" == "Windows" {
		local RProfile : subinstr local RProfile "\" "/", all
		local RSite : subinstr local RProfile "\" "/", all
		local plusR : subinstr local plusR "\" "/", all
	}

	
	
	
	tempfile Rscript
	tempfile Rout
	tempname knot
	qui file open `knot' using "`Rscript'", write text replace
	
	if "$Rcall_synchronize_mode" == "on" {	
		Rcall_synchronize
		file write `knot' "source('Rcall_synchronize')" _n
	}
	
	if !missing("`vanilla'") file write `knot' "rm(list=ls())" _n //erase memory temporarily
	
	if !missing("`foreign'") file write `knot' "library(foreign)" _n
	if !missing("`RSite'") & missing("`vanilla'") 								///
			file write `knot' "source('`RSite'')" _n			
	if !missing("`RProfile'") & missing("`vanilla'") 							///
			file write `knot' "source('`RProfile'')" _n							//load the libraries 
	
	file write `knot' `"`macval(0)'"' _n
	if missing("`vanilla'") file write `knot' "save.image()" _n  				//kills the vanilla
	file write `knot' "source('`source'')" _n
	*file write `knot' `"plusR <- "`plusR'""' _n		//source stata.output() before exit
	file write `knot' `"stata.output("`plusR'", "`vanilla'")"' _n
	//file write `knot' "rm(stata.output)" _n	
	//file write `knot' `"try(rm(stata.output, RProfile), silent=TRUE)"' _n	
	
	*if missing("`vanilla'") file write `knot' "save.image()" _n 
	
	if !missing("`forceload'") {
		file write `knot' `"write.dta(`loaddata', "'							///
		`"file = "_load.data.dta", version = 11) "' _n
	} 	
	
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
	
	
	
	
	if missing("`vanilla'") local save "--save"
	else local save "--no-save"
	
	local Rcommand `""`path'" `vanilla' --slave `save' < "`Rscript'" > "`Rout'" "'
	
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
		
		capture erase _temporary_R_output.txt
		copy "`Rout'" _temporary_R_output.txt, replace 
		di "{browse _temporary_R_output.txt}"
	}
	
	// If data was loaded automatically, remove the temporary data file
	if !missing("`foreign'") capture qui erase _st.data.dta
	
	type "`Rout'"
	
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
				
				if "$Rcall_synchronize_mode" == "on" {
					scalar `name' = "NULL"
				}
				else {
					return local `name' "NULL"
				}
				
			}
			
			// SCALAR OBJECT 
			// ===========================
			if substr(`"`macval(line)'"',1,9) == "//SCALAR " {
				local line : subinstr local line "//SCALAR " ""
				local line : subinstr local line "." "_", all //avoid "." in name
				local name : di `"`macval(line)'"'
				file read `hitch' line
				
				if "$Rcall_synchronize_mode" == "on" {
					scalar `name' = `line'
				}
				else {
					return scalar `name' = `line'
				}
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
				//CANNOT BE DEFINED IN STATA
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
				local multiline
				while r(eof) == 0 & substr(`"`macval(line)'"',1,2) != "//" & trim(`"`macval(line)'"') != "" {	
					
					if missing(`"`content'"') {
						local content 1
						local multiline : di `"`multiline'`line'"' 
					}	
					
					else {
						local multiline : di `"`multiline'{break}`line'"' 
					}	
					
					file read `hitch' line
					local jump 1
				}
				
				if "$Rcall_synchronize_mode" == "on" {
					local test
					capture local test : di `multiline'
					if !missing("`test'") scalar `name' = `multiline'
					else scalar `name' = "`multiline'"
					return local `name' `"`macval(multiline)'"'
				}
				else {
					return local `name' `"`macval(multiline)'"'
				}
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
					if missing(`"`content'"') local content : di `"`content'`line'"' 
					else local content : di `"`content'`line'"' 
					file read `hitch' line
					local jump 1
				}
				return local `name' "`content'"
				//CANNOT BE DEFINED IN STATA
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
				
				if "$Rcall_synchronize_mode" == "on" {
					mat define `name'_copy = `name'
					return matrix `name' = `name'
					mat `name' = `name'_copy
					mat drop `name'_copy
				}	
				else {
					return matrix `name' = `name'
				}	
			}
			
			if missing("`jump'") file read `hitch' line
		}
		*capture erase list.txt
		*copy stata.output list.txt, replace
		if missing("`debug'") capture erase stata.output
		if missing("`debug'") capture erase Rcall_synchronize
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
	
	// Erase globals
	macro drop Rpath
	macro drop Rcall_synchronize_mode
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



