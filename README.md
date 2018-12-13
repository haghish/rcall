# rcall : seamless R in Stata

<a href="http://haghish.com/markdoc"><img src="./Documentation/Rcall.png" align="left" width="140" hspace="10" vspace="6"></a>

__`rcall`__ runs [__R__](https://cran.r-project.org/) commands in Stata, allowing the two software automatically communicate _variables_, 
_matrices_, and _data_. This is done based on a new interfacing paradigm that attempts to synchronize data between two distinct computer languages, particularly when coding is carried out interactively. For more information read the help file or 
[visit rcall homepage](http://www.haghish.com/packages/Rcall.php). 
__`rcall`__ simulates the R language inside Stata and returns _rclass_ scalars, macros, and matrices from R to Stata, anytime an [__R__](https://cran.r-project.org/) command is executed. 
Similarly, it allows passing _macro_, _matrix_, _scalar_, and _data frame_ from Stata to [__R__](https://cran.r-project.org/). As a result, Stata users can open an R window in the middle of a data analysis, execute the R commands, and continue the rest of the analysis with Stata, given the results of the R analysis already made available to Stata in the form of scalar, macro, matrix, or data frame.

__`rcall`__ makes it so easy to run [__R__](https://cran.r-project.org/) within Stata interactively, pass data or a matrix to R, 
and access the results (numeric, matrix, character, lists) automatically within Stata which simply brings the power of [__R__](https://cran.r-project.org/) as well as all other programming languages that can be used interactively in R (e.g. C++ using [Rcpp](http://rcpp.org/) or JavaScript using [V8](https://cran.r-project.org/web/packages/V8/index.html)) in Stata. 

# 1. Installation


The [__`github package`__](https://github.com/haghish/github) can be used to install any Stata package from GitHub conveniently. Once [__`github`__](https://github.com/haghish/github) is installed, type the following command to install __`rcall`__ 

```js
gitget rcall
```

Resources
---------

<a href="https://github.com/haghish/rcall/tree/master/examples"><img src="https://github.com/haghish/markdoc/raw/master/Resources/images/walk.png" width="30px" height="30px"  align="left">Examples</a>

<a href="https://github.com/haghish/rcall/releases"><img src="https://github.com/haghish/markdoc/raw/master/Resources/images/list.png" width="30px" height="30px"  align="left" >Release notes</a>

<a href="http://www.statalist.org"><img src="https://github.com/haghish/markdoc/raw/master/Resources/images/help2.png" width="30px" height="30px"  align="left">Need help? Ask your questions on statalist.org</a>

Author
------
  **E. F. Haghish**  
  Center for Medical Biometry and Medical Informatics    
  University of Freiburg, Germany        
  _haghish@imbi.uni-freiburg.de_       
  _http://www.haghish.com/packages/Rcall.php_      
  _[@Haghish](https://twitter.com/Haghish)_      
  


