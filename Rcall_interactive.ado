*cap program drop Rcall_interactive
program define Rcall_interactive

	display  as txt "{hline 52} R (type {cmd:end} to exit) {hline}"
	

	
	scalar Rcall_counter = 0
	tempfile Rscript
	*tempname knot

	
	if "$Rcall_synchronize_mode" == "on" {
		Rcall_synchronize 	
		Rcall: source("Rcall_synchronize")
	}
	
			
	while `"`macval(nextcommand)'"' != "end" {
		
		qui disp _request(_nextcommand)
		
		if `"`macval(nextcommand)'"' != "end" {
			
			
	
			// Count opened brackets
			// -----------------------------------------------------------------
			Rcall_counter `nextcommand'
			
			scalar Rcall_counter = Rcall_counter + r(Rcall_counter)
			
			*di as err "::" Rcall_counter
			
			if Rcall_counter == 0 {
				
				if missing("`tempfile'") {
					Rcall: `nextcommand'
				}
				else {
					file write `knot' `"`macval(nextcommand)'"' _n
					qui file close `knot'
					local tempfile 				//reset
					copy "`Rscript'" "mytemp.R", replace
					Rcall: source("`Rscript'")
				}	
			}
			
			else {
				local indent = Rcall_counter - 1
				local a : display _dup(`indent') "    "
				display "`a'{bf:+}" 
				if missing("`tempfile'") {
					local tempfile 1
					tempname knot
					qui file open `knot' using "`Rscript'", write text replace
					file write `knot' `"`macval(nextcommand)'"' _n
				}
				else {
					file write `knot' `"`macval(nextcommand)'"' _n
				}
			}
		}	
	}
	
	else {
		display as txt "{hline}"
		
		// Erase memory
		// ============
		scalar drop Rcall_counter
		
	}

end
