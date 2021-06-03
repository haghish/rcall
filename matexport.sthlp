{smcl}
Version: 1.0.0


{title:matexport}

{p 4 4 2}
export matrices from Stata as a data set


{title:Syntax}

{p 4 4 2}
matexport {c 96}mat{c 39}, rnames(name) filename(filename) version(13)

{p 4 4 2}
the command exports a data set from a given matrix with the given name and 
includes the matrix row names in a column named


{title:Citation}

{p 4 4 2}
The program is based on a command written by {bf:Nicholas J. Cox}, in a package 
called {bf:dm79}, from which I read and borrowed a command named
{bf:svmat2}. I have used the version 1.2.2 

{p 4 4 2}
Since the package is hosted on SSC and cannot be specified as a dependency, 
I had to embed it in this package with a different name.


{title:Author}

{p 4 4 2}
{bf:E. F. Haghish}
Department of Psychology
University of Oslo
haghish@hotmail.com

{p 4 4 2}
{browse "www.haghish.com/packages/Rcall.php":rcall Homepage}
Package Updates on  {browse "http://www.twitter.com/Haghish":Twitter}

{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by {help markdoc:MarkDoc Literate Programming package}


