program define Rcall_interactive

	display  as txt "{hline 52} R (type {cmd:end} to exit) {hline}"
  
	while "`nextcommand'" != "end" {
		
		qui disp _request(_nextcommand)
		
		if "`nextcommand'" != "end" {
			Rcall: `nextcommand'
		}	
	}
	else {
		display as txt "{hline}"
	}

end
