// -------------------------------------------------------------------------
// CREATE THE R.ado, abbreviated command
// =========================================================================

tempfile edited
tempname hitch knot
qui file open `hitch' using "Rcall.ado", read
qui file open `knot' using "`edited'", write text replace
file read `hitch' line
while r(eof) == 0 {
	local line : subinstr local line "cap prog drop Rcall" "cap prog drop R"
	local line : subinstr local line "program define Rcall" "program define R"
	file write `knot' `"`macval(line)'"' _n
	file read `hitch' line
	if substr(`"`macval(line)'"',1,3) == "end" {
		file write `knot' `"`macval(line)'"' _n
		exit
	}	
}
qui file close `knot'
copy "`edited'" R.ado, replace
cap prog drop R


// -------------------------------------------------------------------------
// CREATE help file
// =========================================================================

markdoc Rcall.ado, export(sthlp) replace
