{smcl}
{right:version 1.0.0}
{title:Title}

{phang}
{cmd:{opt R:call}} {hline 2} Seemless interactive {bf: {browse "https://cran.r-project.org/":R}} in  Stata. The package return  {help return:rclass} {bf:R} objects ({it:numeric}, {it:character}, {it:list}, {it:matrix}, etc). It also  allows passing Stata {help macro}, {help scalar}, and {help matrix} to {bf:R},  which provides a reciprocal interaction between Stata and {bf:R}.  For more information visit  {browse "http://www.haghish.com/packages/Rcall.php":Rcall homepage}.


{title:Syntax}

{p 4 4 2}
seemless interactive execution of {bf:R} in Stata. the {bf:vanilla} subcommand executes
{bf:R} non-interactively

{p 8 16 2}
{opt R:call} [{cmd:vanilla}] [{cmd::}] [{it:R code}]
{p_end}


{p 4 4 2}
permanently setup the path to executable R on the machine, if different with the 
default paths (see below)

{p 8 16 2}
{opt R:call} {cmd:setpath}  {it:"string"}
{p_end}


{title:Debug mode}

{p 4 4 2}
You can run the package in {it:debug mode} by adding {bf:debug} subcommand before 
any other subcommand or R code. For example:

        . R: debug vanilla print("Hello World") 
        . R: debug setpath "{it:/usr/bin/r}" 


{title:Description}

{p 4 4 2}
The {opt R:call} package provides solution for Stata users who wish to run 
{browse "https://cran.r-project.org/":R statistical software} within Stata. 
{browse "https://cran.r-project.org/":R} is a free software environment for statistical 
computing and graphics. 
The package provides an interactive {bf:R} session within Stata, and    {break}
returns {bf:R} objects into Stata simultaniously, i.e. anytime an R code is executed, 
the R objects are available for further manipulation in Stata. {opt R:call} 
not only returns {it:numeric} and {it:charactor} objects, but also {it:lists} and 
{it:matrices}. 


{title:Data communication between Stata and R}

{p 4 4 2}
Stata automatically receives {bf:R} objects as {help return:rclass} anytime 
the {opt R:call} is executed. If {bf:R} is running interactively 
(i.e. without {bf:vanilla} subcommand), the previous objects still remain accessable 
to Stata, unless they are changed or erased from {bf:R}. 

{p 4 4 2}
For an ideal reciprocation between Stata and {bf:R}, Stata should also easily 
communicate variables to {bf:R}. Local and global {help macro:macros} can be passed 
within {bf:R} code, since Stata automatically interprets them while it passes the 
code to {opt R:call} command, as shown in the example below:

        . global a 99 
        . R: (a <- $a)  	
        [1] 99 		

{p 4 4 2}
In order to pass a {help scalar} from Stata to {bf:R}, you can 
use the {bf:st.scalar() function as shown below:

        . scalar a = 50 
        . R: (a <- st.scalar(a))  	
        [1] 50 		

{p 4 4 2}
Similarly, Stata {help matrix:matrices} can be seemlessly passed to {bf:R} using 
the {bf:st.matrix()} function as shown below:

        . matrix A = (1,2\3,4) 
        . matrix B = (96,96\96,96) 		
        . R: C <- st.matrix(A) + st.matrix(B)
        . R: C 
             [,1] [,2]
        [1,]   97   98
        [2,]   99  100

{p 4 4 2}
And of course, you can access the matrix from {bf:R} in Stata as well: 

        . mat list r(C) 
        r(C)[2,2]
             c1   c2
        r1   97   98
        r2   99  100
		
{p 4 4 2}
Finally, {opt R:call} also allows to pass Stata data to {bf:R} within 
{bf:st.data({it:{help filename}})} function. This function relies on the {bf:foreign} 
package in {bf:R} to load Stata data sets, without converting them to CSV or alike. 
The {bf:foreign} package can be installed within Stata as follows:

        . R: install.packages("foreign", repos="http://cran.uk.r-project.org")

{p 4 4 2}
Specify the relative or absolute path to the data set to transporting data 
from Stata to {bf:R}. For example: 

        . R: data <- st.data(/Applications/Stata/ado/base/a/auto.dta) 
        . R: dim(data)

{p 4 4 2}
If the {it:filename} is not specified, the function passes the currently loaded 
data to {bf:R}. 

        . sysuse auto, clear 
        . R: data <- st.data() 
        . R: dim(data) 
        [1] 74 12
		

{title:R path setup}

{p 4 4 2}
The package requires  {browse "https://cran.r-project.org/":R} to be installed on the machine. 
The package detects {bf:R} in the default paths based on the operating system. 
The easiest way to see if {bf:R} is accessible is to execute a command in {bf:R__

        . R: print("Hello World") 
        [1] "Hello World" 

{p 4 4 2}
If {bf:R} is not accessible, you can also permanently 
setup the path to {bf:R} using the {bf:setpath} subcommand. For example, the 
path to {bf:R} on Mac 10.10 could be:

    . {cmd:R setpath} "{it:/usr/bin/r}"


{title:Remarks}

{p 4 4 2}
You should be careful with using Stata symbols in {bf:R}. For example, the {bf:$} 
sign in Stata is preserved for global macros. To use this sign in {bf:R}, you 
should place a backslash before it to pass it to {bf:R}. For example:

        . R: head(cars\$speed)

{p 4 4 2}
Also, the object name in {bf:R} can include a dot, for example:

        . R: a.name <- "anything" 
		
{p 4 4 2}
The {opt R:call} package returns scalars and locals which can only include 
underscore in the names (e.g. a_name). {opt R:call} automatically converts 
dots to underscore in the name. In the example above, if you type {cmd:return list}, 
you would get a macro as follos:

        r(a_name) : "anything"
		

{title:Example(s)}

{p 4 4 2}
Visit  {browse "http://www.haghish.com/packages/Rcall.php":Rcall homepage} for more examples and 
documentation. 


{title:Author}

{p 4 4 2}
{bf:E. F. Haghish}       {break}
Center for Medical Biometry and Medical Informatics       {break}
University of Freiburg, Germany       {break}
{it:and}          {break}
Department of Mathematics and Computer Science         {break}
University of Southern Denmark       {break}
haghish@imbi.uni-freiburg.de       {break}

{p 4 4 2}
{browse "http://www.haghish.com/statistics/stata-blog/reproducible-research/markdoc.php":http://www.haghish.com/markdoc}           {break}
Package Updates on  {browse "http://www.twitter.com/Haghish":Twitter}       {break}

    {hline}

{p 4 4 2}
This help file was dynamically produced by {help markdoc:MarkDoc Literate Programming package}

