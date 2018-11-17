/***
Installing package dependency
=============================

The following R packages are required by rcall. rcall attempts to detect R 
Statistical Software on your system automatically and install the dependency 
R packages. If the installation fails, read the rcall help file and install 
the dependencies manually.
***/

rcall_check
rcall: install.packages("readstata13", repos="http://cran.us.r-project.org")
