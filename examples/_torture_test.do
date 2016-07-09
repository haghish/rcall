
// -----------------------------------------------------------------------------
// General Setup
// =============================================================================

// Install the package from GitHub
net install Rcall, force  from("https://raw.githubusercontent.com/haghish/Rcall/master/")

// Setup R path permanently
R setpath "/usr/bin/r"


// -----------------------------------------------------------------------------
// Interactive work
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
