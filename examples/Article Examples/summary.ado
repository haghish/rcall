
// summary program
// ===============
//
// Using the "summary" function in R to summarize data in Stata

program summary, byable(recall)
	version 12
	syntax varlist [if] [in]
	marksample touse
  
  rcall_check , rversion(3.0) rcall(2.5.0) //required rcall version and R version
  
	preserve
	quietly keep if `touse'
	quietly keep `varlist' 
	rcall vanilla: sapply(st.data(), summary)
	restore
end

// Examples
/*
sysuse auto, clear
by foreign: summary price mpg if price < 4500
summary mpg weight if foreign==1
summary price mpg if mpg>25 & mpg<30
summary price mpg in 1/20
*/

