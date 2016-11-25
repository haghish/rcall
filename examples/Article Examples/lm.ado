
*cap program drop lm
program lm, rclass

	syntax varlist [if] [in]
	
	// Make sure the user is having Rcall installed and running
	// =========================================================================
	Rcall_check
	
	// Syntax processing
	// =========================================================================
	tokenize `varlist'
    local first `1'
    macro shift
    local rest `*'
    local rest : subinstr local rest " " "+", all	
	
	marksample touse
	preserve
	quietly keep if `touse'
	quietly keep `varlist' 
	
	// Run R function
	// =========================================================================
	Rcall vanilla: 										///
	///attach(read.csv("`RData'")); 					/// load temporary data
	attach(st.data()); 									/// load temporary data
	out = summary(lm(`first' ~ `rest')); 				/// fit the model
	print(out);											/// display output
	coefficients = as.matrix(out\$coefficients);		/// return coef
	res_se = out\$sigma;								/// residual SE
	res_df =  out\$df[2];								/// residual DF
	r_squared = out\$r.squared;							/// R-squared
	adj_r_squared = out\$adj.r.squared;					/// Adj R-squared
	f_statistic = as.matrix(out\$fstatistic);			/// F-statistics
	f_statistic_p = 1 - pf(out[[10]][1],				/// F-p value
					out[[10]][1],out[[10]][1]);			/// 
	rm(out);											/// erase stored results
	
	// restore the data
	restore
	
	// Return scalars and matrices to Stata. The magin happens here
	// =========================================================================
	return add
end


// test
/*
sysuse auto, clear
lm price mpg turn if price < 5000
return list


