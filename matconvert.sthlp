{smcl}
{title:Title}

{phang}
{cmd:matconvert} {hline 2} {bf:matconvert} belongs to {help Rcall} package. It takes the name of a Stata matrix and returns a code for constructing the same matrix in R. for more information visit  {browse "http://www.haghish.com/packages/Rcall.php":Rcall homepage}.


{title:Example(s)}

    convert Stata matrix to R code
	
        {bf:. matrix A = (1,2\3,4)}
        {bf:. matconvert A}
        matrix(c(1,2,3,4), nrow=2, byrow = TRUE)


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
{browse "http://www.haghish.com/packages/Rcall.php":http://www.haghish.com/packages/Rcall.php}           {break}
Package Updates on  {browse "http://www.twitter.com/Haghish":Twitter}      {break}

    {hline}

{p 4 4 2}
This help file was dynamically produced by {help markdoc:MarkDoc Literate Programming package}

