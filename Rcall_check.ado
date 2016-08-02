* July 2016
* E. F. Haghish
* Department of Mathematics and Computer Science
* University of Southern Denmark
* @haghish 

program Rcall_check
	
	syntax [anything] [, Rversion(real 0.0)]
	
	// Check that Rcall is installed
	// -------------------------------------------------------------------------
	capture findfile Rcall.ado
	if _rc != 0 {
	    di as err "Rcall package is required"	
	    err 198
	}
	
	// Check that R is executable
	// -------------------------------------------------------------------------
	Rcall vanilla:                                                           ///
	version = R.Version()\$minor;                                            ///
	if ("`anything'" != "") {                                                ///
		pkglist = unlist(strsplit("`anything'", " +"));                      ///
		for (i in 1:length(pkglist)) {                                       ///
			pkg = unlist(strsplit(pkglist[i], ">="));                        ///      
			if (try(require(pkg[1], character.only = TRUE)) == FALSE) {      ///
				error = paste(pkg[1], "is required");                        ///
				break;                                                       ///
			};                                                               ///
			if (packageVersion(pkg[1]) < pkg[2]) {                           ///
				error = paste(pkg[1], pkg[2], "or newer is required");       ///
				break;                                                       ///
			};                                                               ///
		};                                                                   ///
		rm(i, pkg, pkglist);                                                 ///
    };
	
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
	
end




