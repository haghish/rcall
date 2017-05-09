
// synchronizing from Stata to R
// =============================

*capture program drop Rcall_synchronize
program Rcall_synchronize
	
	if !missing("`debug'") di as err "entering Rcall_synchronize"
	
	tempfile Rscript
	tempname knot
	qui file open `knot' using "`Rscript'", write text replace
	
	// -------------------------------------------------------------------------
	// List the global macros
	// =========================================================================
	
	/*
	local ignorelist S_FNDATE S_FN S_level F1 F2 F7 F8 S_ADO S_StataSE S_FLAVOR	///
	S_OS S_OSDTL S_MACH
	
	local allglobals : all globals
	foreach lname in `allglobals' {
		local equal											// reset
		foreach lname2 in `ignorelist' {
			if "`lname'" == "`lname2'" local equal 1
		}
		if missing("`equal'") {
			local glo : display `"$`lname'"'
			
			local test										// reset
			capture local test : display int(`glo')	
			if missing("`test'") & "`glo'" != "" {							
				file write `knot' `"`lname'_ <- "`macval(glo)'""' _n
			}
			else {
				file write `knot' `"`lname'_ <- `macval(glo)'"' _n
			}
		}
	}
	*/
	
	// -------------------------------------------------------------------------
	// List the scalars
	// =========================================================================
	local allscalars : all scalars
	*di as err `"SCALARS:`allscalars'"'

	foreach lname in `allscalars' {
		
		local sca : display `lname'
		
		local test										// reset
		capture local test : display int(`sca')	
		if missing("`test'") & "`sca'" != "" {							
			file write `knot' `"`lname' <- "`macval(sca)'""' _n
		}
		else if trim("`sca'") == "." {
			file write `knot' `"`lname' <- NA"' _n
		}	
		else if trim("`sca'") != "" {
			file write `knot' `"`lname' <- `macval(sca)'"' _n
		}	
		else if trim("`sca'") == "" {
			file write `knot' `"`lname' <- "`macval(sca)'" "' _n
		}
	}
	
	
	// -------------------------------------------------------------------------
	// List the matrices
	// =========================================================================
	local allmats : all matrices
	
	foreach lname in `allmats' {
		qui matconvert `lname'
		file write `knot' `"`lname' <- `r(`lname')'"' _n 	
	}
	
	qui file close `knot'
	
	// -------------------------------------------------------------------------
	// Create a Source file
	// =========================================================================
	quietly copy "`Rscript'" "Rcall_synchronize", replace

end
