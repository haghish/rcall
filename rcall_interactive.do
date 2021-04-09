*cap prog drop rcall_interactive

program define rcall_interactive
	display as txt "{hline 52} R (type {cmd:end} to exit) {hline}"
	scalar rcall_counter = 0
	tempfile Rscript
	
	if !missing("$debug") di as err "Debugging rcall_interactive:" _n
	
	if "$rcall_synchronize_mode" == "on" {
		rcall_synchronize 	
		rcall: source("rcall_synchronize")
		*local sync sync
		global rcall_synchronize_mode2 "on"
		macro drop rcall_synchronize_mode
	}
	
	
	while `"`macval(nextcommand)'"' != "end" {
		qui disp _request(_nextcommand)
		if `"`macval(nextcommand)'"' != "end" {
	
			global rcall_interactive_mode on
			
			// Count opened brackets
			// -----------------------------------------------------------------
			rcall_counter `nextcommand'
			
			// correct for the dollar sign
			local nextcommand: subinstr local nextcommand "$" "\$", all
			
			scalar rcall_counter = rcall_counter + r(rcall_counter)
			
			if !missing("$debug") di "rcall_counter IS: " rcall_counter
			
			if rcall_counter != 0 {
				local indent = rcall_counter - 1
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
				
				if !missing("$debug") di "this is part 2-->" rcall_counter
			}
			
			if rcall_counter == 0 {
				
				if !missing("$debug") di "current counter number: " rcall_counter
				
				if missing("`tempfile'") {
					if trim(`"`macval(nextcommand)'"') != "" {
						rcall `sync': `nextcommand'
						macro drop rcall_interactive_mode
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
					macro drop rcall_interactive_mode
					
					if !missing("$debug") di "this is the end of part 2"
				}	
			}
		}	
	}
	
	else {
		display as txt "{hline}"
		
		macro drop rcall_interactive_mode
		
		// Erase memory
		scalar drop rcall_counter
		
		// if the interactive mode was also synchronized, define the marker
		global rcall_synchronize_mode3 "on"
		if !missing("$debug") di as err "set rcall_synchronize_mode3 = $rcall_synchronize_mode3"		
	}

end
