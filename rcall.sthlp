{smcl}
Version: 3.0.0 BETA


{title:rcall}

{p 4 4 2}
seamless interactive {bf: {browse "https://cran.r-project.org/":R}} in Stata.
The command automatically returns {help return:rclass} R objects with
{it:integer}, {it:numeric}, {it:character}, {it:logical}, {it:matrix}, {it:data.frame}, {it:list}, and {it:NULL}
classes to Stata. It also allows passing Stata variable, dataset,
macro, scalar, and matrix to R as well as load a dataframe from R
to Stata automatically,
which provides an automated reciprocal communication between Stata and R. For
more information and examples visit  {browse "http://www.haghish.com/packages/Rcall.php":rcall homepage}.


{title:Syntax}

{p 4 4 2}
To call R from Stata use the following syntax

{p 8 16 2}
rcall [{help rcall##modes:{it:mode}}] [{cmd::}] [{it:R-command}]
{p_end}

{p 4 4 2}
the package also includes a few subcommands to facilitate integrating R in Stata

{p 8 16 2}
rcall [{help rcall##subcommand:{it:subcommand}}]
{p_end}

{p 4 4 2}
the following functions can be used to communicate data from Stata to R:

{synoptset 22 tabbed}{...}
{synopthdr:Function}
{synoptline}
{synopt:{opt st.scalar(name)}}passes a scalar to R{p_end}
{synopt:{opt st.matrix(name)}}passes a matrix to R{p_end}
{synopt:{opt st.var(varname)}}passes a numeric or string variable to R{p_end}
{synopt:{opt st.data(filename)}}passes Stata data to R. without {it:filename}, the currently loaded data is used. {p_end}
{synopt:{opt st.load(dataframe)}}loads data from R dataframe to Stata{p_end}
{synoptline}
{p2colreset}{...}

{p 4 4 2}
programmers can use {bf:rcall_check} to evaluate the required version of R or R packages:

{p 8 16 2}
{browse "http://www.haghish.com/packages/Rcall.php#check":{bf:rcall_check}} [{it:pkgname>=ver}] [{it:pkgname>=ver}] [...] , {opt r:version(ver)}
{p_end}

{marker modes}{...}

{title:Modes}

{p 4 4 2}
The {it:mode} changes the behavior of the package and it can be {bf:vanilla} or {bf:sync}.
When the {it:mode} is not specified, R is called interactively which is the default
mode. Finally, when the [{it:R-command}] is not specified, the console mode
will be executed which simulates R console within Stata results window for interactive
use. In all of these modes, {bf:rcall} returns {it:rclass} objects from R to Stata. These
modes are summarized below:

{* the new Stata help format of putting detail before generality}{...}
{synoptset 22 tabbed}{...}
{synopthdr:Mode}
{synoptline}
{synopt: {bf: {browse "http://www.haghish.com/packages/Rcall.php#vanilla_mode":vanilla}} }Calls R non-interactively. This mode is advised for programmers
who wish to embed R in Stata packages{p_end}

{synopt: {bf: {browse "http://www.haghish.com/packages/Rcall.php#sync_mode":sync}} }executes R interactively and
synchronizes {it:matrices} and {it:scalars} between
R and Stata. Making a change in any of these objects in either Stata or
R will change the object in the other environment.
{p_end}

{synopt: {browse "http://www.haghish.com/packages/Rcall.php#interactive_mode":interactive}}when the mode is not specified, R is called interactively
which memorizes the actions, objects available in the R memory, the attached
datasets, and the loaded packages. {p_end}

{synopt: {browse "http://www.haghish.com/packages/Rcall.php#console_mode":console}}when the R command is not specified, R is called interactively
and in addition, R console is simulated within the results windows of Stata.
In the console mode users can type R commands directly in Stata and get the
results back interactively. Similarly, the results are returned to Stata
in the background and can be accessed in Stata when quiting the console
mode. {p_end}
{synoptline}
{p2colreset}{...}

{marker subcommand}{...}

{title:Subcommands}

{p 4 4 2}
{bf:rcall} allows a few subcommands which provide several features to facilitate
working with the package interactivey. The subcommands are summarized in the
table below:

{* the new Stata help format of putting detail before generality}{...}
{synoptset 22 tabbed}{...}
{synopthdr:Subcommand}
{synoptline}
{synopt: {browse "http://www.haghish.com/packages/Rcall.php#setpath_subcommand":setpath} {it:"path/to/R"}}permanently defines the path to executable
R on the machine.{p_end}
{synopt: {browse "http://www.haghish.com/packages/Rcall.php#clear_subcommand":clear}}erases
the R memory and history in the interactive mode. {p_end}
{synopt: {browse "http://www.haghish.com/packages/Rcall.php#warnings_subcommand":warnings}}shows
the warnings returned from R {p_end}
{synopt: {browse "http://www.haghish.com/packages/Rcall.php#describe_subcommand":describe}}returns
the R version and paths to R, RProfile, and Rhistory {p_end}
{synopt: {browse "http://www.haghish.com/packages/Rcall.php#history_subcommand":history}}opens
{bf:Rhistory.do} in do-file editor which stores the history of the
interactive R session. {p_end}
{synopt: {browse "http://www.haghish.com/packages/Rcall.php#site_subcommand":site}}opens
{bf:rprofile.site} in do-file editor which is
used for customizing R when is called from Stata. {p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{p 4 4 2}
{bf: {browse "https://cran.r-project.org/":R statistical language}} is a free software
and programming langage for statistical computing and graphics.
The rcall package combines the power of R with Stata, allowing the
Stata users to call R interactively within Stata and communicate
data and analysis results between R and Stata simultaniously.

{p 4 4 2}
In other words, anytime an R code is executed, the R objects are available
for further manipulation in Stata.
R objects with
{it:numeric}, {it:integer}, {it:character}, {it:logical}, {it:matrix}, {it:list}, and {it:NULL}
classes are automatically returned to Stata as {help return:rclass}.

{p 4 4 2}
R objects with {it:data.frame} class can be automatically loaded from R to
Stata using the {bf:st.load()} function (see below).

{p 4 4 2}
{bf:rcall} uses the {bf:try} function to evaluate the R code and
returns {bf:r(rc)} scalar which is an indicator for errors occuring in R. if {bf:r(rc)}
equals zero, R has successfully executed the code. Otherwise, if {bf:r(rc)} equals
one an error has occured and {bf:rcall} will return the error message and break the
execution.



{title:Communication from R to Stata}

{p 4 4 2}
Stata automatically receives R objects as {help return:rclass} anytime
the rcall is executed. If R is running interactively
(i.e. without {bf:vanilla} subcommand), the previous objects still remain accessable
to Stata, unless they are changed or erased from R. Moreover, the packages
that you load from Stata in R remain loaded until you detach them.

{p 4 4 2}
Accessing R objects in Stata is simultanious which makes working with
rcall convenient. For example a {it:numeric}, or {it:string} vector which is
defined in R, can be accessed in Stata as simple as calling the name of that
object withing {help rclass} i.e. {bf:r({it:objectname})}.

{p 4 4 2}
A {it:numeric} object example:

        . rcall: a <- 100
        . display r(a)
        100

{p 4 4 2}
Without the {bf:vanilla} subcommand, the defined object remains in the memory of
R and consequently, returned to Stata anytime R is called.

        . rcall: a
        [1] 100

{p 4 4 2}
A {it:string} object example:

        . rcall: str <- "Hello World"
        . display r(str)
        Hello World

        . rcall: str <- c("Hello", "World")
        . display r(str)
        "Hello"  "World"

{p 4 4 2}
A {it:vector} example:

        . rcall: v <- c(1,2,3,4,5)
        . display r(v)
        1 2 3 4 5

{p 4 4 2}
A {it:matrix} example:

        . rcall: A = matrix(1:6, nrow=2, byrow = TRUE)
        . mat list r(A)
        r(A)[2,3]
            c1  c2  c3
        r1   1   2   3
        r2   4   5   6

{p 4 4 2}
A {it:list} example:

        . rcall: mylist <- list(a=c(1:10))
        . display r(mylist_a)
        1 2 3 4 5 6 7 8 9 10

{p 4 4 2}
A {it:logical} example:

        . rcall: l <- T
        . display r(l)
        TRUE

{p 4 4 2}
A {it:NULL} example:

        . rcall: n <- NULL
        . display r(n)
        NULL

{p 4 4 2}
Regarding communicating R data set to Stata automatically, see the
{bf:st.load({it:dataframe})} function below.


{title:Communication from Stata to R}

{p 4 4 2}
For an ideal reciprocation between Stata and R, Stata should also easily
communicate variables to R. Local and global {help macro:macros} can be passed
within R code, since Stata automatically interprets them while it passes the
code to rcall command, as shown in the example below:

        . global a 99
        . rcall: (a <- $a)
        [1] 99

{p 4 4 2}
In order to pass a {help scalar} from Stata to R, you can
use the {bf:st.scalar()} function as shown below:

        . scalar a = 50
        . rcall: (a <- st.scalar(a))
        [1] 50

{p 4 4 2}
Similarly, Stata {help matrix:matrices} can be seamlessly passed to R using
the {bf:st.matrix()} function as shown below:

        . matrix A = (1,2\3,4)
        . matrix B = (96,96\96,96)
        . rcall: C <- st.matrix(A) + st.matrix(B)
        . rcall: C
             [,1] [,2]
        [1,]   97   98
        [2,]   99  100

{p 4 4 2}
And of course, you can access the matrix from R in Stata as well:

        . mat list r(C)
        r(C)[2,2]
             c1   c2
        r1   97   98
        r2   99  100

{p 4 4 2}
Passing variables from Stata to R is convenient, using the
{bf:st.var({it:varname})} function. Therefore, any analysis can be executed in R
simply by passing the variables required for the analysis from Stata to R:

        . sysuse auto, clear
        . rcall: dep <- st.var(price)
        . rcall: pre <- st.var(mpg)
        . rcall: lm(dep~pre)

        Call:
        lm(formula = dep ~ pre)

        Coefficients:
        (Intercept)          pre
            11267.3       -238.3

{p 4 4 2}
The rcall package also allows to pass Stata data to R within
{bf:st.data({it:filename})} function. This function relies on the {bf:readstata13}
package in R to load Stata data sets, without converting them to CSV or alike.
The {bf:readstata13} package
{browse "http://www.haghish.com/stata-blog/?p=21":is faster and more acurate then {bf:foreign} and {bf:haven} packages}
and read Stata 13 and 14 datasets. This R package can be installed within Stata as follows:

        . rcall: install.packages("readstata13", repos="http://cran.uk.r-project.org")

{p 4 4 2}
Specify the relative or absolute path to the data set to transporting data
from Stata to R. For example:

        . rcall: data <- st.data(/Applications/Stata/ado/base/a/auto.dta)
        . rcall: dim(data)

{p 4 4 2}
If the {it:filename} is not specified, the function passes the currently loaded
data to R.

        . sysuse auto, clear
        . rcall: data <- st.data()
        . rcall: dim(data)
        [1] 74 12

{p 4 4 2}
Finally, the data can be imported from R to Stata automatically, using the
{bf:st.load({it:dataframe})} function. This function will automatically save a
Stata data set from R and load it in Stata by clearing the current data set,
if there is any. Naturally, you can have more control over converting variable
types if you write a proper code in R for exporting Stata data sets. Nevertheless,
the function should work just fine in most occasions:

        . clear
        . rcall: st.load(cars)
        . list in 1/2
        {c TLC}{hline 14}{c TRC}
        {c |} speed   dist {c |}
        {c LT}{hline 14}{c RT}
     1. {c |}     4      2 {c |}
     2. {c |}     4     10 {c |}
        {c BLC}{hline 14}{c BRC}


{title:Remarks}

{p 4 4 2}
You should be careful with using Stata symbols in R. For example, the {bf:$}
sign in Stata is preserved for global macros. To use this sign in R, you
should place a backslash before it to pass it to R. For example:

        . rcall: head(cars\$speed)

{p 4 4 2}
Also, the object name in R can include a dot, for example:

        . rcall: a.name <- "anything"

{p 4 4 2}
The rcall package returns scalars and locals which can only include
underscore in the names (e.g. a_name). rcall automatically converts
dots to underscore in the name. In the example above, if you type {cmd:return list}
in Stata, you would get a macro as follos:

        . return list
        r(a_name) : "anything"

{p 4 4 2}
To maximize the speed of calling R from Stata,
detach the packages that are no longer needed and also, drop all the objects
that are of no use for you. The more objects you keep in R memory,
the more time needed to automatically communicate those objects between
R and Stata.


{title:Example}

{p 4 4 2}
Visit  {browse "http://www.haghish.com/packages/Rcall.php":rcall homepage} for more examples and
documentation.


{title:Author}

{p 4 4 2}
{bf:E. F. Haghish}    {break}
Department of Psychology    {break}
University of Oslo    {break}
haghish@uio.no    {break}

{p 4 4 2}
{browse "www.haghish.com/packages/Rcall.php":rcall Homepage}    {break}
Package Updates on  {browse "http://www.twitter.com/Haghish":Twitter}    {break}

{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by {help markdoc:MarkDoc Literate Programming package}


