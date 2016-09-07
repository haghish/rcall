
*cap prog drop Rcall_check
program Rcall_check

	syntax [anything] [, Rversion(str) RCALLversion(str)]
	
	// Check Rcall version
	// -------------------------------------------------------------------------
	local CURRENTRCALLVERSION 1.33
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
		
		// return error if Rcall is old
		if `version' > `CURRENTRCALLVERSION' {
			display as err "{help Rcall} version `rcallversion' or newer is "	///
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
		di as err "{help Rcall} could not access R on your system"
		err 198
	}
	
	// Check R version 
	// -------------------------------------------------------------------------
	if "`rversion'" > "`r(version)'" {
		di as err "R version `rversion' or higher is required. {help Rcall} "	///
		"is using R `r(version)'"
		err 198
	}
	
end

