*capture program drop import_stata

program call_return , rclass 
	
	syntax  using/ , [ debug ]
	
	// -------------------------------------------------------------------------
	// Syntax processing
	// =========================================================================
	
	// if "stata_output" is created, then continue the process. Otherwise, return 
	// an error, because "rc" must be returned anyway...
	
	capture confirm file "`using'"
	if _rc == 0 & substr(trim(`"`macval(0)'"'),1,3) != "q()" {
		tempname hitch
		qui file open `hitch' using "`using'", read
		file read `hitch' line
		while r(eof) == 0 {
			local jump									// reset
			
			// NULL OBJECT 
			// ===========================
			if substr(`"`macval(line)'"',1,7) == "//NULL " {	
				local line : subinstr local line "//NULL " ""
				local line : subinstr local line "." "_", all //avoid "." in name
				local name : di `"`macval(line)'"'
				if "$Rcall_synchronize_mode" == "on" {
					scalar `name' = "NULL"
				}
				else {
					return local `name' "NULL"
				}
			}
			
			// SCALAR OBJECT 
			// ===========================
			if substr(`"`macval(line)'"',1,9) == "//SCALAR " {
				local line : subinstr local line "//SCALAR " ""
				local line : subinstr local line "." "_", all //avoid "." in name
				local name : di `"`macval(line)'"'
				file read `hitch' line
				if "`name'" == "rc" & "`line'" == "1" local Rerror 1
				if "$Rcall_synchronize_mode" == "on" {
					scalar `name' = `line'
				}
				else {
					return scalar `name' = `line'
				}
			}
			
			// NUMERIC OBJECT LENGTH > 1 
			// ===========================
			if substr(`"`macval(line)'"',1,14) == "//NUMERICLIST " {
				local line : subinstr local line "//NUMERICLIST " ""
				local line : subinstr local line "." "_", all //avoid "." in name
				local name : di `"`macval(line)'"'
				file read `hitch' line
				local content
				while r(eof) == 0 & substr(`"`macval(line)'"',1,2) != "//" {
					local content `content' `line' 
					file read `hitch' line
					local jump 1
				}
				return local `name' = "`content'"
				//CANNOT BE DEFINED IN STATA
			}
			
			// STRING OBJECT AND CLIST
			// ===========================
			if substr(`"`macval(line)'"',1,9) == "//STRING " |					///
			substr(`"`macval(line)'"',1,8) == "//CLIST " {
				local line : subinstr local line "//STRING " ""
				local line : subinstr local line "//CLIST " ""
				local line : subinstr local line "." "_", all //avoid "." in name
				local line : subinstr local line "$" "_", all //avoid "$" in name
				local name : di `"`macval(line)'"'
				file read `hitch' line
				local content
				local multiline
				while r(eof) == 0 & substr(`"`macval(line)'"',1,2) != "//" & trim(`"`macval(line)'"') != "" {	
					
					if missing(`"`content'"') {
						local content 1
						local multiline : di `"`macval(multiline)'"' `"`macval(line)'"' 
					}	
					else {
						local multiline : di `"`macval(multiline){break}'"' `"`macval(line)'"' 
					}	
					file read `hitch' line
					local jump 1
				}	
				
				if "`name'" == "error" {
					local multiline : subinstr local multiline "$" "\\$", all
					local errorMessage = `"`macval(multiline)'"'
				}	
				
				if "$Rcall_synchronize_mode" == "on" {
					local test
					capture local test : di `multiline'
					if !missing("`test'") scalar `name' = `multiline'
					else scalar `name' = "`multiline'"
					return local `name' `"`macval(multiline)'"'
				}
				else {
					return local `name' `"`macval(multiline)'"'
				}
			}
			
			// LIST OBJECT (NUMERIC)
			// ===========================
			if substr(`"`macval(line)'"',1,7) == "//LIST " {
				local line : subinstr local line "//LIST " ""
				local line : subinstr local line "." "_", all //avoid "." in name
				local line : subinstr local line "$" "_", all //avoid "$" in name
				
				local name : di `"`macval(line)'"'
				
				file read `hitch' line
				local content
				while r(eof) == 0 & substr(`"`macval(line)'"',1,2) != "//" {
					if missing(`"`content'"') local content : di `"`content'`line'"' 
					else local content : di `"`content'`line'"' 
					file read `hitch' line
					local jump 1
				}
				return local `name' "`content'"
				//CANNOT BE DEFINED IN STATA
			}
			
			// MATRIX OBJECT (NUMERIC)
			// ===========================
			if substr(`"`macval(line)'"',1,9) == "//MATRIX " {
				local line : subinstr local line "//MATRIX " ""
				local line : subinstr local line "." "_", all //avoid "." in name
				local line : subinstr local line "$" "_", all //avoid "$" in name
				local name : di `"`macval(line)'"'
				
				//GET NUMBER OF ROWS
				file read `hitch' line
				if substr(`"`macval(line)'"',1,11) == "rownumber: " {
					local line : subinstr local line "rownumber: " ""
					local rownumber : di `"`macval(line)'"'
				}
				
				file read `hitch' line
				local content
				while r(eof) == 0 & substr(`"`macval(line)'"',1,2) != "//" {
					local content `content' `line' 
					file read `hitch' line
					local jump 1
				}
				matrix define `name' = (`content')
				*mat list `name'
				mata: `name' = st_matrix("`name'") 
				*mata: `name'
				mata: st_matrix("`name'", rowshape(`name', `rownumber'))  
				
				if "$Rcall_synchronize_mode" == "on" {
					mat define `name'_copy = `name'
					return matrix `name' = `name'
					mat `name' = `name'_copy
					mat drop `name'_copy
				}	
				else {
					return matrix `name' = `name'
				}	
			}
			if missing("`jump'") file read `hitch' line
		}
		*capture erase list.txt
		*copy `using' list.txt, replace
		if missing("`debug'") capture erase "`using'"
		if missing("`debug'") capture erase Rcall_synchronize
	}
	
	// return an error
	else {
		return scalar rc = 1
	}
	
	
	// generate error message
	// -------------------------------------------------------------------------
	// but do not stop Rcall, because error message should be returned by Rcall
	// or the main caller program
	if "`Rerror'" == "1" {
		global RcallError 1
		display as error `"{p}`macval(errorMessage)'"'
	}
	
end


