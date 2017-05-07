
*cap prog drop rcall_check
program rcall_check

	syntax [anything] [, Rversion(str) RCALLversion(str)]
	
	// Check rcall version from the rcall.ado
	// -------------------------------------------------------------------------
	qui local location "`c(pwd)'"
	qui cd "`c(sysdir_plus)'"
	qui cd r
	tempname hitch
	file open `hitch' using "rcall.ado", read
	file read `hitch' line
	while r(eof)==0 & substr(`"`macval(line)'"',1,8) != "Version:" {
		file read `hitch' line
	}
	if substr(trim(`"`macval(line)'"'),1,8) == "Version:" {
		local line = substr(`"`macval(line)'"',9,.)
		local line : subinstr local line "." " ", all
		tokenize "`line'"		
		local CURRENTRCALLVERSION `1'	
		macro shift
		while !missing("`1'") {
			local sub `sub'`1'
			macro shift
		}
		local CURRENTRCALLVERSION `CURRENTRCALLVERSION'.`sub'
	}
	cap qui cd "`location'"
				

	// Prepare the required rcall version
	// -------------------------------------------------------------------------
	if !missing("`rcallversion'") {
		local requiredversion `rcallversion'
		local requiredversion : subinstr local requiredversion "." " ", all
		tokenize `requiredversion'
		local version `1'
		macro shift
		while !missing("`1'") {
			local secondary `secondary'`1'
			macro shift
		}
		local version `version'.`secondary'
		
		// return error if rcall is old
		if `version' > `CURRENTRCALLVERSION' {
			display as err "{help rcall} version `rcallversion' or newer is "	///
			"required"
			err 198
		}
	}	
	
	
	// Check that R is executable
	// -------------------------------------------------------------------------
	Rcall vanilla:                                                           	///
	major = R.Version()\$major; minor = R.Version()\$minor; 				 	///
	version = paste(major,minor, sep=".");                                   	///
	if ("`anything'" != "") {                                                	///
		pkglist = unlist(strsplit("`anything'", " +"));                      	///
		for (i in 1:length(pkglist)) {                                       	///
			pkg = unlist(strsplit(pkglist[i], ">="));                        	///      
			if (try(require(pkg[1], character.only = TRUE)) == FALSE) {      	///
				error = paste("R package", pkg[1], "is required");           	///
				break;                                                       	///
			};                                                               	///
			if (packageVersion(pkg[1]) < pkg[2]) {                           	///
				error = paste("R package", pkg[1], pkg[2], 						///
				"or newer is required"); 										///
				break;                                                       	///
			};                                                               	///
		};                                                                   	///
    };																		 	///
	rm(i, pkg, pkglist, major, minor);                                   
	
	// Return propper error
	// -------------------------------------------------------------------------
	if !missing(r(error)) {
		display as err "`r(error)'"
		err 198
	} 
	else if missing(r(version)) {
		di as err "{help rcall} could not access R on your system"
		err 198
	}
	
	// Check R version 
	// -------------------------------------------------------------------------
	if "`rversion'" > "`r(version)'" {
		di as err "R version `rversion' or higher is required. {help rcall} "	///
		"is using R `r(version)'"
		err 198
	}
	
end

