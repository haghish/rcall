// the 'make.do' file is automatically created by 'github' package.
// execute the code below to generate the package installation files.
// DO NOT FORGET to update the version of the package, if changed!
// for more information visit http://github.com/haghish/github

make rcall, replace toc pkg  version(3.0.5)                                 ///
     license("MIT")                                                         ///
     author("E. F. Haghish")                                                ///
     email("haghish@med.uni-goettingen.de")                                 ///
     url("http://github.com/haghish")                                       ///
     title("seamless R in Stata")                                           ///
     description("call R in Stata and enable automated data communication") ///
     install("call_return.ado;"                                             ///
             "matconvert.ado;matconvert.sthlp;"                             /// 
             "matexport.ado;matexport.sthlp;"                               ///
             "R.ado;rcall_check.ado;rcall_check.sthlp;rcall_counter.ado;"   ///
             "rcall_interactive.ado;rcall_synchronize.ado;rcall.ado;"       ///
             "rcall.sthlp;rprofile.site;stata.output.r;varconvert.ado")     ///
     ancillary("")                                                        


/*
Generating the package documentation
====================================

The package documentation is written in Markdown language. The MARKDOC package 
extract these documentation and create the Stata help files as well as Markdown 
documentation for GitHub Wiki. Learn more about MARKDOC here: 
https://github.com/haghish/markdoc

Generating Stata Help Files
---------------------------
*/

markdoc "rcall.ado", export(sthlp) replace 
markdoc "rcall_check.ado", export(sthlp) replace 
markdoc "matexport.ado", export(sthlp) replace 
markdoc "matconvert.ado", export(sthlp) replace 

// generate the Markdown documentation for GitHub
markdoc "rcall.ado",     mini export(md) replace
markdoc "rcall_check.ado",        mini export(md) replace
markdoc "matexport.ado",   mini export(md) replace
markdoc "matconvert.ado",     mini export(md) replace


markdoc "vignette.do", export(tex) toc replace master                        ///
        title("rcall v. 3.0 package vignette")                               ///
				author("E. F. Haghish")
