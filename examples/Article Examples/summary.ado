
// summary program
// ===============
//
// carring the "summary" function in R to summarize data in Stata

program summary, byable(recall)
	version 12
	syntax varlist [if] [in]
	marksample touse
	preserve
	quietly keep if `touse'
	quietly keep `varlist' 
	rcall vanilla: sapply(st.data(), summary)
	restore
end

// Examples
/*
by foreign: summary price mpg
summary price mpg if price < 4500
summary mpg weight if foreign==1
summary price mpg if mpg>25 & mpg<30
summary price mpg in 1/20
