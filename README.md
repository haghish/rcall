# Rcall : seamless R in Stata

__`Rcall`__ runs [__R__](https://cran.r-project.org/) commands in Stata and allow the two software automatically communicate _variables_, 
_matrices_, and _data_. more information read the help file or 
[visit diagram homepage](http://www.haghish.com/packages/Rcall.php). 
__`Rcall`__ returns _rclass_ scalars, macros, and matrices to Stata, anytime an [__R__](https://cran.r-project.org/) command is executed. 
Similarly, it allows passing _macro_, _matrix_, _scalar_, and _data_ from Stata to [__R__](https://cran.r-project.org/). 

__`Rcall`__ makes it so easy to run [__R__](https://cran.r-project.org/) within Stata interactively, pass data or a matrix to R, 
and access the results (numeric, matrix, character, lists) wutomatically within Stata which simply brings the power of [__R__](https://cran.r-project.org/) as well as all other programming languages that can be used interactively in R (e.g. C++ using [Rcpp](http://rcpp.org/) or JavaScript using [V8](https://cran.r-project.org/web/packages/V8/index.html)) in Stata. 

        
Author
------
  **E. F. Haghish**  
  Center for Medical Biometry and Medical Informatics    
  University of Freiburg, Germany        
  _haghish@imbi.uni-freiburg.de_       
  _http://www.haghish.com/packages/Rcall.php_      
  _[@Haghish](https://twitter.com/Haghish)_      
  
Installation
------------

<!--
The __diagram__ releases are also hosted on SSC server. So you can download the latest release as follows:

    ssc install diagram   //NOT YET RELEASED ON SSC
    ssc install webimage  //NOT YET RELEASED ON SSC               


You can also directly download __diagram__ from GitHub which includes the latest beta version (unreleased). -->
To install from GitHub, the `force` 
option ensures that you _reinstall_ the package, even if the release date is not yet changed. The release date only is changed for new releases and not for the current development.  
  
    net install Rcall, replace  from("https://raw.githubusercontent.com/haghish/Rcall/master/")
    


Examples
------------

The __examples__ directory includes the torture test file that can serve as a good example. 
