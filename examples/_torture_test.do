// -----------------------------------------------------------------------------
// NOTES: 
//		* locals at the top allow running this completely unattendedly
//		* If your R path is different from default unix, comment out -rcall setpath- below
//		* The -github- install creates an 'rcall-X.X.X' folder that should be deleted meanually
// =============================================================================

// -----------------------------------------------------------------------------
// BUGS: 
//		should rcall convert NA objected to missing scalars in sync mode? 
//		* 
//		* 
//		* 
// =============================================================================

local run_errors 0 //0= No, 1=Yes
local run_interactive 0
local test_install_github 1
local run_setpath 1 

// -----------------------------------------------------------------------------
// General Setup
// =============================================================================

// Install the rcall package using the github command
if(`test_install_github'){
cap github uninstall rcall //Ensure we don't have 2 different entries in stata.trk from different sources.
github install haghish/rcall, stable
}

// =============================================================================
// RCALL SUBCOMMANDS 
// =============================================================================
rcall describe
rcall site
rcall history
rcall clear

rcall_check
rcall_check readstata13>=0.8.5

// Setup R path permanently (change the path on your system) YOU DO NOT NEED TO RUN THIS!
if(`run_setpath'){
rcall setpath "/usr/bin/r"
}

// =============================================================================
// RCALL MODES 
// =============================================================================


// Vanilla (Non-Interactive)
// -----------------------------------------------------------------------------
rcall clear
rcall vanilla : object <- print("this")
return list

// if you want to access the "object" you get an error that is not found because 
// it was defined in vanilla mode, i.e. no memory is preserved of the previous 
// r call
if(`run_errors'){
rcall: object
}

// Interactive mode
// -----------------------------------------------------------------------------
rcall clear 
rcall: a <- print("Hello World")
rcall: q()						//does not remove the R objects in memory
rcall: print(ls())

rcall clear           //clear the memory
rcall: print(ls())

//numeric and string objects
rcall: a <- 10
rcall: b <- " or it can be string"
display "The object value is can be numetic such as " r(a) r(b)

//define a matrix
rcall clear
rcall: A = matrix(1:6, nrow=2, byrow = TRUE) 
mat list r(A)

// SPECIAL CHARACTERS

rcall: attach(cars)
rcall: cars\$speed		  //the $ sign must be 

//Stata interprets $ sign in the middle of a word as global macro, use backslash
rcall: head(cars\$speed)
rcall: LM <- lm(cars\$dist~cars\$speed)
rcall: LM
return list //lm is not a list

// Consol mode
// -----------------------------------------------------------------------------
if(`run_interactive'){
rcall
}

// Synchronizing mode
// -----------------------------------------------------------------------------

// SCALAR
// -------------------------------

//with synchronization
drop _all
macro drop a b rcall_interactive_first_launch //remove all but the test file config macros
rcall clear
scalar a = 1
rcall sync: a = 0
di a

//without synchronization
scalar a = 1
rcall: a = 0
di a


//DEFENSIVE: missing scalar
// -------------------------------
//missing is converted to NA, but in string format
drop _all
rcall clear
scalar a = .
rcall: b = st.scalar(a) 
di a
return list    //r(b) = "NA"

//should NA be converted to . ? this is not implemented yet
drop _all
matrix drop _all
rcall clear
scalar a = 10
rcall sync: st.scalar(a) 
rcall sync: a <- NA
di a
rcall sync: a <- 100
di a

//multipline texts from R to Stata is not supported
scalar a = .
rcall sync: a = "this is \n multiline \n text"
di a



// matrix
// -------------------------------
rcall clear
mat drop _all
mat define A = (1,2,3 \ 4,5,6)
rcall sync: A
rcall sync: B = A
mat list r(B)

mat dir

return list

rcall sync: C = B+A
mat list C

mat D = C/2
mat list D

rcall sync: D





// -----------------------------------------------------------------------------
// Creating and Exporting Graphics!
// =============================================================================

// Since R is run from batch mode, you cannot view graphics. However, you can create and 
// export them, allowing you to use your favorite R packages for data visualization
// from Stata

// Creating a PDF file named Rplots.pdf
rcall: plot(1,1)

// Creating a PNG file named mypng.png
rcall: png("mypng.png");plot(rnorm(100), main="This is my PNG file");

// Creating a postscript file named whatever.eps
rcall: setEPS();postscript("postscript.eps");plot(rnorm(100), main="PostScript file"); 
//rcall: setEPS();postscript("postscript.eps");plot(rnorm(100), main="PostScript file"); dev.off();


*******************************************************************
// THIS WILL NOT WORK
rcall: setEPS()
rcall: postscript("postscript.eps")
rcall: plot(rnorm(100), main="PostScript file"); 

// this will work
rcall: setEPS();postscript("postscript.eps");plot(rnorm(100), main="PostScript file"); 
*******************************************************************





// -----------------------------------------------------------------------------
// From Stata to R (Interactive)
// =============================================================================
rcall clear			//remove the R objects in memory

// NUMERIC and STRING LOCAL & GLOBAL
// ---------------------------------------
local  a = 99
global b = 99
rcall: c <- `a' + $b
display r(c)

global a "thi is a string"
rcall: b <- "$a"
display r(b)


// st.matrix() : Passing a NUMERIC matrix from Stata to R
// ----------------------------------------
rcall clear
matrix A = (1,2\3,4) 
rcall : B <- st.matrix(A)
rcall: A <- st.matrix(A) + st.matrix(A) + st.matrix(A) + st.matrix(A)
mat list r(A)
//??? why "mat list A" fails here?

rcall clear
matrix A = (1,2\3,4) 
matrix B = (96,96\96,96) 		
rcall: C <- st.matrix(A) + st.matrix(B)
rcall: C

// Adding missing data to a matrix
rcall: C[1,1] <- NA
rcall: C
mat list r(C)

// st.scalar() : Passing a NUMERIC & STRING SCALAR to R
// ----------------------------------------
scalar a = 999
rcall: a <- st.scalar(a)
display r(a)

scalar a = "or string scalar"
rcall: a <- st.scalar(a)
display r(a)


// multiple-line string
// ----------------------------------------
rcall debug: A = list(a="hi there this is pretty long \n there \n and here")
return list


// st.data() : Passing Data to R
// ----------------------------------------

sysuse auto, clear
rcall: data <- st.data()
rcall: dim(data)

clear
rcall: rm(list=ls())
rcall: data <- st.data(`c(sysdir_base)'/a/auto.dta)


// load.data() : Passing Data from R to Stata 
// ----------------------------------------
clear 
rcall: mydata <- data.frame(cars) 
rcall: st.load(mydata) 
list in 1/2




// -----------------------------------------------------------------------------
// Trying Rcpp package (DO NOT RUN)
// =============================================================================
if(0){
/*
To compile the C++ code, use sourceCpp("path/to/file.cpp"). This will create 
the matching R functions and add them to your current session. Note that these 
functions can not be saved in a .Rdata file and reloaded in a later session; 
they must be recreated each time you restart R. 

But you can add several R commands separated by ";", or more better, create a 
script file and source it all at once. 
*/

cd "/Users/haghish/Documents/Packages/Rcall"
rcall: library(Rcpp)
rcall: Rcpp::sourceCpp('examples/Rcpp.cpp'); timesTwo(2);timesTwo(999);

rcall: Rcpp::sourceCpp('examples/Rcpp.cpp'); a <- timesTwo(10003)

//save the results of Rcpp in an R object, and get it back in Stata!
display r(a)

rcall: detach("package:Rcpp")
}
// -----------------------------------------------------------------------------
// RProfile : Detach packages, data, variables, etc..
// =============================================================================
/*
Anytime you close R in batch mode, it detaches all of the packages you have loaded. 
To make R really run interactively in Stata, the packages should remain loaded 
for each command. Rcall makes a global RProfile that remains active regardless 
of your working directory. 

However, anything that you leave in .RData, means extra loading time for every Rcall. So 
if you don't need a data set, package, etc, remove them from the R Workspace and 
detach the packages. 
*/

rcall: library(foreign)
rcall: search()
rcall: detach("package:foreign", unload=TRUE)
rcall: search()


// -----------------------------------------------------------------------------
// Multiple lines
//
// 1- Write multiple lines of code
// 2- It is easier to write a script file and source it! Stata will still get the 
//	  values back...
// =============================================================================



rcall:  timesTen <- function(x) { 												///
			return(x*10)														            ///
		}

rcall: timesTen(10)		


	
// -----------------------------------------------------------------------------
// Execution time
// =============================================================================
rcall clear

timer clear
timer on 1
	rcall vanilla: print("")
timer off 1
timer list

timer clear
timer on 1
	rcall: print("")
timer off 1
timer list

/* 
calling R from Stata without executing anything takes 0.41 seconds on average
on my Machine. Repeating the call for 10 times reveals simply the multiplication 
of this number. 

I SHOULD SPEED UP THIS PROCESS
*/




// -----------------------------------------------------------------------------
// The Vanilla mode should not influence the loaded functions
// =============================================================================
rcall vanilla library(foreign)
rcall library(foreign)
if(`run_errors') {
rcall vanilla: detach("package:foreign", unload=TRUE) //GET ERROR
}
rcall: detach("package:foreign", unload=TRUE)
rcall: search()


// -----------------------------------------------------------------------------
// passing variables from Stata to R
// =============================================================================

sysuse auto, clear
rcall: print(st.var(price))
rcall: print(st.var(make))



// -----------------------------------------------------------------------------
// Cleanup
// =============================================================================
erase _temporary_R_output.txt 
erase _temporary_R_script.R 
erase mypng.png 
erase postscript.eps 
erase Rplots.pdf
cap erase _load.matrix.D.dta 
cap erase _load.matrix.C.dta 


















