
// Using the qplot R function in Stata
// ===================================

program rplot
	version 14
	syntax varlist [, filename(name) colour(name) shape(name) format(name)]
	
	// check for the required packages and versions
	// -------------------------------------------------------------------------
	rcall_check ggplot2>=2.1.0 , r(3.1.0) rcall(2.5.0)
	
	// Checking the variables
	// -------------------------------------------------------------------------
	tokenize `varlist'
	if !missing("`3'") {
		di as err "maximum of 2 variables (y & x) are allowed"
		err 198
	}
	
	if !missing("`2'") {
		local x "`2'"
		local y "`1'"
	}
	else {
		local x "`1'" 
		local y NULL
	}
	
	// Processing the options' syntax
	// -------------------------------------------------------------------------
	if !missing("`colour'") {
		confirm variable `colour'						// is it a variable? 
		local colour ", colour = `colour'"
	}	
	if !missing("`shape'") local shape ", shape = `shape'"
  if missing("`filename'") local filename Rplot
	if missing("`format'") local format pdf
	
	rcall vanilla : `format'("`filename'.`format'"); library(ggplot2); 				///
	      qplot(data=st.data(), x =`2', y =`1' `colour' `shape')
	
	di as txt "({browse Rplot.`format'} was produced)" 
end

*rplot price mpg , filename(graph) colour(foreign) shape(foreign) format(png)
