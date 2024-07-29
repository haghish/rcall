> __Cite__: [Haghish, E. F. (2019). Seamless interactive language interfacing between R and Stata. The Stata Journal, 19(1), 61-82](https://journals.sagepub.com/doi/full/10.1177/1536867X19830891).  
> __NOTE__: The __`R:`__ command is a synonym of __`rcall:`__ and can be used exchangably. 

![GitHub release (latest by date)](https://img.shields.io/github/v/release/haghish/rcall?label=last%20version)

---

# rcall : Seamless interactive language interfacing between R and Stata

<a href="http://haghish.com/markdoc"><img src="./Documentation/Rcall.png" align="left" width="140" hspace="10" vspace="6"></a>

__`rcall`__ runs [__R__](https://cran.r-project.org/) commands in Stata, allowing the two software automatically communicate _variables_, 
_matrices_, and _data_. This is done based on a new interfacing paradigm that attempts to synchronize data between two distinct computer languages, particularly when coding is carried out interactively. For more information read the help file or 
[visit rcall homepage](http://www.haghish.com/packages/Rcall.php). 
__`rcall`__ simulates the R language inside Stata and returns _rclass_ scalars, macros, and matrices from R to Stata, anytime an [__R__](https://cran.r-project.org/) command is executed. 
Similarly, it allows passing _macro_, _matrix_, _scalar_, and _data frame_ from Stata to [__R__](https://cran.r-project.org/). As a result, Stata users can open an R window in the middle of a data analysis, execute the R commands, and continue the rest of the analysis with Stata, given the results of the R analysis already made available to Stata in the form of scalar, macro, matrix, or data frame.

__`rcall`__ makes it so easy to run [__R__](https://cran.r-project.org/) within Stata interactively, pass data or a matrix to R, 
and access the results (numeric, matrix, character, lists) automatically within Stata which simply brings the power of [__R__](https://cran.r-project.org/) as well as all other programming languages that can be used interactively in R (e.g. C++ using [Rcpp](http://rcpp.org/) or JavaScript using [V8](https://cran.r-project.org/web/packages/V8/index.html)) in Stata. 

The `rcall` package is **much more than calling R within Stata**! It implements a veriety of procedures for quality check and making sure that the R code can proprly gets executed within Stata and it also provides functions to allow Stata programmers evaluate the satisfactory versions of R and R packages in their programs. Moreover, it **automatically returns the results of the analysis from R into Stata, in an accessible formats such as matrices, scalars, data sets, etc**. Here is a quick and dirty diagram, showing the huge potential of `rcall` to enhance your Stata:

![Summary of the `rcall` modes of data communication](./Documentation/whatfor.jpg)

# 1. Installation


The [__`github package`__](https://github.com/haghish/github) is the only recommended way for installing **`rcall`**. Once [__`github`__](https://github.com/haghish/github) is installed, you can install either the development version or the stable version of the package. 

if you like to help testing the newst development, install the development vesion:

```js
github install haghish/rcall
```

Otherwise, install the latest stable release (recommended for general users)

```js
github install haghish/rcall, stable
```

# 2. rcall modes of data communication

Language interfacing is done for a veriety of purposes. For example, you may call R within Stata to:

- perform a particular analysis on your data 
- develop a Stata program that relies on some functionalities provided in R or its add-on packages

Both require data communication back and forth between Stata and R and this is where `rcall` stands out. `rcall` excells in a few modes to facilitates data communication based on your needs. These modes are summarized in the graph below:

![Summary of the `rcall` modes of data communication](./Documentation/rcallmodes.png)


In general, it offers 2 modes of data communication which are 

1. **interactive**, often used for data analysis when the user might call R frequently and interactively. This general mode includes a memory that preserves the history of your R session. This mode itself can be used in two ways:
     1. *interactive*, where the R session can be continued command by command. **this mode allows you call R interactively within Stata do-files**
     2. *console*, where Stata console is converted to R console. this mode allows you to work with R interactively within Stata, but cannot be called from do-files. However, it provides a much more fun experience, namely to have R console within Stata console!

2. **non-interactive**, which is the recommended mode for integrating R into Stata programs. This mode does not have a memory and every call will begin a fresh R session

# 3. Examples

`rcall` is very powerful, yeat very easy to work with. In the following examples, I simply use R to define a scalar or print a text, just to show you how easy it is to use `rcall` and to get data back into Stata. But to stand by the traditions, I start with a *Hello World* example with **interactive mode**

_interactive mode: calling R to print a text_

<img src="./Documentation/example-interactive.png" align="center" width="700">

We can also open the R console within Stata to have fun with R without exiting Stata! You notice that working with R interactively in the console mode **is even easier than working with MATA within Stata** because `rcall` automatically returns the data from R to Stata. 

_interactive console mode: defining object `a = 99` in R and getting it back in Stata_

<img src="./Documentation/example-console.png" align="center" width="700">

Type `return list` to see what objects have ben transfered from R to Stata. This is one of the biggest advantages of `rcall`, namely, the objects you define in R can be automatically accessed within Stata! Of course, you can control what objects to return (especially if you are programming a Stata ado-program that embeds R). Read the manuscript published by Stata Journal for details. 

# 4. Development

Requirements: The [-GitHub-](https://github.com/haghish/github) package is required for testing and the [-markdoc-](https://github.com/haghish/markdoc) is required for building the documentation.

Building: To update `R.ado` from a modified `rcall.ado`, run `make_R_abb.do`. To build the installation files and documentation, run `make.do`.


Resources
---------

<a href="https://github.com/haghish/rcall/tree/master/examples"><img src="https://github.com/haghish/markdoc/raw/master/Resources/images/walk.png" width="30px" height="30px"  align="left">Examples</a>

<a href="https://github.com/haghish/rcall/releases"><img src="https://github.com/haghish/markdoc/raw/master/Resources/images/list.png" width="30px" height="30px"  align="left" >Release notes</a>

<a href="http://www.statalist.org"><img src="https://github.com/haghish/markdoc/raw/master/Resources/images/help2.png" width="30px" height="30px"  align="left">Need help? Ask your questions on statalist.org</a>

Author
------
  **E. F. Haghish**  
  Department of Psychology,  
  University of Oslo, Norway        
  _haghish@uio.no_       
  _http://www.haghish.com/packages/Rcall.php_      
  _[@Haghish](https://twitter.com/Haghish)_      
  


