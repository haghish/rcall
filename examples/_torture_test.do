
// -----------------------------------------------------------------------------
// General Setup
// =============================================================================

// Install the package from GitHub
net install Rcall, force  from("https://raw.githubusercontent.com/haghish/Rcall/master/")

// Setup R path permanently
R setpath "/usr/bin/r"

// -----------------------------------------------------------------------------
// Vanilla (Non-Interactive)
// =============================================================================
R: rm(list=ls()) 
R vanilla : object <- print("this")
return list

// if you want to access the "object" you get an error that is not found
R: object


// -----------------------------------------------------------------------------
// From R to Stata (Interactive)
// =============================================================================

R: a <- print("Hello World")
R: q()						//does not remove the R objects in memory
R: print(ls())

R: rm(list=ls()) 			//remove the R objects in memory
R: print(ls())

//numeric and string objects
Rcall: a <- 10
R: b <- " and it can be string"
display "The object value is " r(a) r(b)

//define a matrix
R: A = matrix(1:6, nrow=2, byrow = TRUE) 
mat list r(A)

// SPECIAL CHARACTERS

R: attach(cars)
R: cars\$speed		  //the $ sign must be 

//Stata interprets $ sign in the middle of a word as global macro, use backslash
R: head(cars\$speed)
R: LIST <- lm(cars\$dist~cars\$speed)

return list

// -----------------------------------------------------------------------------
// From Stata to R (Interactive)
// =============================================================================
R: rm(list=ls()) 			//remove the R objects in memory

// NUMERIC and STRING LOCAL & GLOBAL
// ---------------------------------------
local  a = 99
global b = 99
Rcall: c <- `a' + $b
display r(c)

global a "thi is a string"
Rcall: b <- "$a"
display r(b)


// Passing a NUMERIC matrix from Stata to R
// ----------------------------------------
matrix A = (1,2\3,4) 
Rcall: A <- st.matrix(A) + st.matrix(A) + st.matrix(A) + st.matrix(A)
mat list r(A)

R: rm(list=ls())
matrix A = (1,2\3,4) 
matrix B = (96,96\96,96) 		
R: C <- st.matrix(A) + st.matrix(B)
R: C

// Passing a NUMERIC & STRING SCALAR to R
// ----------------------------------------
scalar a = 999
Rcall: a <- st.scalar(a)
display r(a)

scalar a = "or string scalar"
Rcall: a <- st.scalar(a)
display r(a)

// Passing Data to R
// ----------------------------------------

sysuse auto, clear
R: data <- st.data()
R: dim(data)

clear
R: rm(list=ls())
R: data <- st.data(/Applications/Stata/ado/base/a/auto.dta)



// -----------------------------------------------------------------------------
// Source an R script file and get all of the objects back to Stata
// =============================================================================
R: rm(list=ls())
R: source('https://raw.githubusercontent.com/haghish/Rcall/master/examples/get.R')
mat list r(matrixObject)
display r(mystr)




