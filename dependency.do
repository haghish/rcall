/***
Installing package dependency
=============================

The following R packages are required by rcall. rcall attempts to detect R 
Statistical Software on your system automatically and install the dependency 
R packages. If the installation fails, read the rcall help file and install 
the dependencies manually.
***/

// check github version and require minimum of version 2.3.0
quietly github version github
if "`r(version)'" < "2.2.0" {
  di as err "please update your GitHub package"
  di as txt "type:  github update github"
}

rcall_check
rcall: install.packages("readstata13", repos="http://cran.us.r-project.org")
