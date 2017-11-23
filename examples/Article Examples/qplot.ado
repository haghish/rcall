
// summary program
// ===============
//
// carring the "summary" function in R to summarize data in Stata

cap prog drop qplot
program qplot
	version 12
	syntax varlist [, colour(name) size(name) shape(name) format(name)]
	
	// selecting x and y
	tokenize `varlist'
	if !missing("`2'") {
		local x "`2'"
		local y "`1'"
	}
	else {
		local x "`1'" 
		local y NULL
	}
	
	// default options
	if !missing("`colour'") local colour ", colour = `colour'"
	if !missing("`shape'") local shape ", shape = `shape'"
	if missing("`format'") local format pdf
	
	rcall vanilla : `format'("Rplot.`format'"); library(ggplot2); 				///
	qplot(data=st.data(), x =`2', y =`1' `colour' `shape')

end

*sysuse auto, clear
*qplot price mpg , colour(foreign) shape(foreign) format(pdf)
