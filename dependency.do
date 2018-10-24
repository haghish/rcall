/***
Installing package dependency
=============================

The following R packages are required by rcall. rcall requires access to R 
Statistical Software on your system to install the dependencies. rcall attempts 
to detect R on your system automatically. If the installation fails, read the 
rcall help file and install the dependencies manually after defining the path to
R manually. 

***/

rcall_check
rcall: install.packages("readstata13", repos="http://cran.us.r-project.org")
