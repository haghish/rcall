// -----------------------------------------------------------------------------
// BUGS: 
//		* 
//		* 
//		* 
//		* 
// =============================================================================


********************************************************************************


// -----------------------------------------------------------------------------
// General Setup
// =============================================================================

// Install the package from GitHub
*net install rcall, force  from("https://raw.githubusercontent.com/haghish/Rcall/master/")
github install haghish/rcall

// Setup R path permanently (change the path on your system)
rcall setpath "/usr/bin/r"



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
rcall: object


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

// Synchronizing mode
// -----------------------------------------------------------------------------

// SCALAR
// -------------------------------

//with synchronization
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
scalar a = .
rcall: a 
di a

scalar a = 10
rcall sync: a 
rcall sync: a <- NA
di a


scalar a = .
rcall sync: a = "this is \n multiline \n text"
di a



// matrix
// -------------------------------
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
rcall: setEPS();postscript("postscriot.eps");plot(rnorm(100), main="PostScript file"); 
//rcall: setEPS();postscript("postscriot.eps");plot(rnorm(100), main="PostScript file"); dev.off();


*******************************************************************
// THIS WILL NOT WORK
rcall: setEPS()
rcall: postscript("postscriot.eps")
rcall: plot(rnorm(100), main="PostScript file"); //CREATES A PDF INSTEAD
*******************************************************************





// -----------------------------------------------------------------------------
// From Stata to R (Interactive)
// =============================================================================
rcall: rm(list=ls()) 			//remove the R objects in memory

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
matrix A = (1,2\3,4) 
rcall: A <- st.matrix(A) + st.matrix(A) + st.matrix(A) + st.matrix(A)
mat list r(A)

rcall: rm(list=ls())
matrix A = (1,2\3,4) 
matrix B = (96,96\96,96) 		
rcall: C <- st.matrix(A) + st.matrix(B)
rcall: C

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
rcall: data <- st.data(/Applications/Stata/ado/base/a/auto.dta)


// load.data() : Passing Data from R to Stata 
// ----------------------------------------
clear 
rcall: mydata <- data.frame(cars) 
rcall: load.data(mydata) 
list in 1/2


// -----------------------------------------------------------------------------
// Source an R script file and get all of the objects back to Stata
// =============================================================================
rcall: rm(list=ls())
rcall: source('https://raw.githubusercontent.com/haghish/Rcall/master/examples/get.R')
mat list r(matrixObject)
display r(mystr)


rcall: unlink(".RData") //This deletes the workspace file
rcall: rm(list=ls())

// -----------------------------------------------------------------------------
// Trying Rcpp package
// =============================================================================

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

rcall: search()
rcall: detach("package:Rcpp", unload=TRUE)
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
			return(x*10)														///
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
rcall vanilla: detach("package:foreign", unload=TRUE) //GET ERROR
rcall: detach("package:foreign", unload=TRUE)
rcall: search()


// -----------------------------------------------------------------------------
// passing variables from Stata to R
// =============================================================================

sysuse auto, clear
rcall: print(st.var(price))
rcall: print(st.var(make))






















