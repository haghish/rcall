//capture program drop call_return

program call_return , rclass 
	
	syntax  using/ , [ debug ]
	
	// -------------------------------------------------------------------------
	// Syntax processing
	// =========================================================================
	
	// if "stata_output" is created, then continue the process. Otherwise, return 
	// an error, because "rc" must be returned anyway...
	
	/*
	Point for future maintenance:
	----------------------------
	
	Stata has a limit in terms of number of arguments, number of vector's numbers, 
	literals, etc. Therefore, if the MATRIX returned from R has more than 550 
	numbers, break the matrix and combine it in Stata. 
	
	THIS IS NOT A MATSIZE LIMIT. 
	*/
	
	capture confirm file "`using'"
	if _rc == 0 & substr(trim(`"`macval(0)'"'),1,3) != "q()" {
		tempname hitch
		qui file open `hitch' using "`using'", read
		file read `hitch' line
		while r(eof) == 0 {
			local jump									// reset
			
			
			if !missing("`debug'") di as err " rcall_synchronize_mode is : $rcall_synchronize_mode"
			if !missing("`debug'") di as err "rcall_synchronize_mode3 is : $rcall_synchronize_mode3"
			
			// NULL OBJECT 
			// ===========================
			if substr(`"`macval(line)'"',1,7) == "//NULL " {	
				local line : subinstr local line "//NULL " ""
				local line : subinstr local line "." "_", all //avoid "." in name
				local name : di `"`macval(line)'"'
				if "$rcall_synchronize_mode" == "on" | "$rcall_synchronize_mode3" == "on" {
					scalar `name' = "NULL"
					return local `name' "NULL"
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
				local line : subinstr local line "-Inf" "." // Avoid -Inf error, return missing
				if "`name'" != "rcall_counter" {
					if "`name'" == "rc" & "`line'" == "1" local Rerror 1
					if "$rcall_synchronize_mode" == "on" | "$rcall_synchronize_mode3" == "on" {
						scalar `name' = `line'
						return scalar `name' = `line'
					}
					else {
						return scalar `name' = `line'
					}
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
				
				if "$rcall_synchronize_mode" == "on" | "$rcall_synchronize_mode3" == "on" {
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
			
			// -----------------------------------------------------------------
			// MATRIX OBJECT (NUMERIC)
			// =================================================================
			if substr(`"`macval(line)'"',1,9) == "//MATRIX " {
        
        // get the name of the matrix
				local line : subinstr local line "//MATRIX " ""
				local line : subinstr local line "." "_", all //avoid "." in name
				local line : subinstr local line "$" "_", all //avoid "$" in name
				local name : di `"`macval(line)'"'
				
        // make sure that it exists
        capture confirm file "_load.matrix.`name'.dta"
        if _rc == 0 {
          preserve
          
          // load the matrix as data frame
          qui use "_load.matrix.`name'.dta", clear
          
          // extract the column names
          quietly describe, fullname varlist 
          
          tokenize "`r(varlist)'"
          if "`1'" == "rownames" {
            local rownames "rownames"
            macro shift
          }
          
          *foreach var of varlist `mylist' {
          *local len = length("`var'")
          *local head = substr("`var'",1,`len'-2)
          *local tail = substr("`var'",`len'-1,`len')
          *}
           local variablelist
					while !missing("`1'") {
            local variablelist `variablelist' `1'
						macro shift
					}
					
          mkmat `variablelist' ,  matrix(`name') rownames("`rownames'") 
          restore
        }
        
        // return an error
        else {
          return scalar rc = 1
          display as err "{bf:`name'} was not transported properly"
        }
        
        /*
				//GET NUMBER OF ROWS
				file read `hitch' line
				if substr(`"`macval(line)'"',1,11) == "rownumber: " {
					local line : subinstr local line "rownumber: " ""
					local rownumber : di `"`macval(line)'"'
				}
				
				file read `hitch' line
				
				//GET COLUMN NAMES
				if substr(`"`macval(line)'"',1,9) == "colnames:" {
					local line : subinstr local line "colnames:" ""
					local colname : di `"`macval(line)'"'
					file read `hitch' line
				}
				
				//GET ROW NAMES
				if substr(`"`macval(line)'"',1,9) == "rownames:" {
					local line : subinstr local line "rownames:" ""
					local rowname : di `"`macval(line)'"'
					file read `hitch' line
				}
				
				// READ THE MATRIX
				local content
				while r(eof) == 0 & substr(`"`macval(line)'"',1,2) != "//" {
					local content `content' `line' 
					file read `hitch' line
					local jump 1
				}
				
				
				// AVOID STATA LIMITS IN TERMS OF NUMBER OF ARGUMENTS	
				// ------------------------------------------------------------
				if wordcount(`"`macval(content)'"') <= 500  {
					matrix define `name' = (`content')
				}
				else {
					tokenize "`content'"
					while !missing("`1'") {
						local n 0      //RESET
						local content2 //RESET
						while `n' <= 500 {
							local n `++n'
							local content2 `content2' `1'
							macro shift
						}
						
						// append pieces of the long returned matrix
						if missing("`name'") {
							matrix define `name' = (`content2') 
						}
						else {
							matrix `name' = `name' , `content2'
						}
						macro shift
					}
				}
				
				// CREATE THE MATRIX IN MATA
				*mat list `name'
				mata: `name' = st_matrix("`name'") 
				*mata: `name'
				mata: st_matrix("`name'", rowshape(`name', `rownumber')) 
				
				// ADD COLUMN NAME
				if !missing("`colname'") {
					matrix colnames `name' = `colname'
				}
				
				// ADD ROW NAME
				if !missing("`rowname'") {
					matrix rownames `name' = `rowname'
				}
        */

				

				if "$rcall_synchronize_mode" == "on" | "$rcall_synchronize_mode3" == "on" {
					mat define `name'_copy = `name'
					return matrix `name' = `name'
					mat `name' = `name'_copy				
					mat drop `name'_copy
				}	
				else {
					return matrix `name' = `name'
				}	
        
        // Erase the temporary matrix file generated by R
        if missing("`debug'") capture erase "_load.matrix.`name'.dta"
			}
      
			if missing("`jump'") file read `hitch' line
		}
		*capture erase list.txt
		*copy `using' list.txt, replace
		if missing("`debug'") capture erase "`using'"
		if missing("`debug'") capture erase rcall_synchronize
	}
	
	// return an error
	else {
		return scalar rc = 1
	}
	
	
	// generate error message
	// -------------------------------------------------------------------------
	// but do not stop rcall, because error message should be returned by rcall
	// or the main caller program
	if "`Rerror'" == "1" {
		global RcallError 1
		display as error `"{p}`macval(errorMessage)'"'
	}
	
	macro drop rcall_synchronize_mode3
	
end


