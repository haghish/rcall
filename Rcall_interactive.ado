*cap prog drop Rcall_interactive

program define Rcall_interactive
	display  as txt "{hline 52} R (type {cmd:end} to exit) {hline}"
	scalar Rcall_counter = 0
	tempfile Rscript
	
	if !missing("$debug") di as err "Debugging Rcall_interactive:" _n
	
	if "$Rcall_synchronize_mode" == "on" {
		Rcall_synchronize 	
		rcall: source("Rcall_synchronize")
		*local sync sync
		global Rcall_synchronize_mode2 "on"
		macro drop Rcall_synchronize_mode
	}
	
	
	while `"`macval(nextcommand)'"' != "end" {
		qui disp _request(_nextcommand)
		if `"`macval(nextcommand)'"' != "end" {
	
			global Rcall_interactive_mode on
			
			// Count opened brackets
			// -----------------------------------------------------------------
			Rcall_counter `nextcommand'
			
			// correct for the dollar sign
			local nextcommand: subinstr local nextcommand "$" "\$", all
			
			scalar Rcall_counter = Rcall_counter + r(Rcall_counter)
			
			if !missing("$debug") di "rcall_counter IS: " Rcall_counter
			
			if Rcall_counter != 0 {
				local indent = Rcall_counter - 1
				local a : display _dup(`indent') "    "
				display "`a'{bf:+}" 
				if missing("`tempfile'") {
					local tempfile 1
					tempname knot
					qui file open `knot' using "`Rscript'", write text replace
					file write `knot' `"`macval(nextcommand)'"' _n
					if !missing("$debug") copy "`Rscript'" "mytemp.R", replace
				}
				else {
					file write `knot' `"`macval(nextcommand)'"' _n
					if !missing("$debug") copy "`Rscript'" "mytemp.R", replace
				}
				
				if !missing("$debug") di "this is part 2-->" Rcall_counter
			}
			
			if Rcall_counter == 0 {
				
				if !missing("$debug") di "current counter number: " Rcall_counter
				
				if missing("`tempfile'") {
					if trim(`"`macval(nextcommand)'"') != "" {
						rcall `sync': `nextcommand'
						macro drop Rcall_interactive_mode
					}	
					if !missing("$debug") di "this is part 1 A"
				}
				else {
					file write `knot' `"`macval(nextcommand)'"' _n
					qui file close `knot'
					
					if !missing("$debug") copy "`Rscript'" "mytemp.R", replace
					if !missing("$debug") di "`Rscript'"
					
					// Make sure R on Windows can manage to source the file
					if "`c(os)'" == "Windows" {
						local Rscript : subinstr local Rscript "\" "/", all				 
					}
					
					if trim(`"`macval(nextcommand)'"') != "" {
						rcall `sync': source("`Rscript'")
					}
					
					local tempfile 				                         //reset
					macro drop Rcall_interactive_mode
					
					if !missing("$debug") di "this is the end of part 2"
				}	
			}
		}	
	}
	
	else {
		display as txt "{hline}"
		
		macro drop Rcall_interactive_mode
		
		// Erase memory
		scalar drop Rcall_counter
		
		// if the interactive mode was also synchronized, define the marker
		global Rcall_synchronize_mode3 "on"
		if !missing("$debug") di as err "set Rcall_synchronize_mode3 = $Rcall_synchronize_mode3"		
	}

end
