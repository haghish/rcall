
program varconvert, rclass
	
	// -------------------------------------------------------------------------
	// Check the variable type
	// =========================================================================
	
	capture confirm variable `0'
	if _rc != 0 {
		display as err "variable `0' was not found"
		error 198
	}
	
	capture confirm numeric variable `0'
	if _rc == 0 {
		local type numeric
	}
	else {
		local type string
	}

	local data
	local N = _N
	
	// Converting numeric variable
	// -------------------------------------------------------------------------
	
	if "`type'" == "numeric" {
		forval i = 1/`N' {
			
			//avoid the first comma
			if !missing("`data'") local data "`data',"
			
			//turn missing to NA
			if !missing(`0'[`i']) {
				local data : display "`data'" `0'[`i']
			}
			else {
				local data : display "`data'" "NA"
			}
		}
	}
	
	// Converting string variable
	// -------------------------------------------------------------------------
	else {
		forval i = 1/`N' {

			//avoid the first comma
			if !missing(`"`macval(data)'"') local data "`data',"
			
			//turn missing to NA
			if !missing(`0'[`i']) {
				local data : display `"`macval(data)'"' `"""' `0'[`i'] `"""'
			}
			else {
				local data : display `"`macval(data)'"' "NA"
			}
		}
	}
	
	// Return R code to reconstruct the variable
	// -------------------------------------------------------------------------
	local code "c(`data')"
	display as txt `"{p}`code'"'

	if "`type'" == "numeric" {
		return local `0' "`code'"
		return local type "numeric"
	}	
	else {
		return local `0' `"`macval(code)'"'
		return local type "string"
	}	
end
