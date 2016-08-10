
program Rcall_counter, rclass


local openbrackets 0
	
	// Remove string quotation to avoid open brackets that appear in quotations
	// ------------------------------------------------------------------------

	
	
	
	local line `"`macval(0)'"' 
	
	// Count open brackets
	// ------------------------------------------------------------------------
	while strpos(`"`macval(line)'"',"{") != 0 {
		local br = strpos(`"`macval(line)'"',"{")
		local l1 = substr(`"`macval(line)'"',1, `br')
		local l2 = substr(`"`macval(line)'"',`br'+1,.)
		local openbrackets `++openbrackets'
		local line `"`macval(l2)'"'
	}
	
	// count closed brackets
	// ------------------------------------------------------------------------
	while strpos(`"`macval(0)'"',"}") != 0 {
		local br = strpos(`"`macval(l2)'"',"}")
		local l1 = substr(`"`macval(l2)'"',1, `br'+1)
		local l2 = substr(`"`macval(l2)'"',`br'+2,.)
		local openbrackets `--openbrackets'
		local 0 `"`macval(l2)'"'
	}	

	return scalar Rcall_counter = `openbrackets'
	
end

*Rcall_counter	this is a line {} whatever comes next { {
