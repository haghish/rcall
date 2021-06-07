
program define rcallscript, rclass
	
	syntax [anything] using/ , [Args(string asis)] [vanilla]
  
  // check that the last character of the args is not ";"
  if (substr(`"`macval(args)'"',-1,.)) != ";" {
    local args = `"`macval(args)';"'
  } 
  
  confirm file `"`using'"'
  
  *rcall vanilla debug: `args' source("`macval(using)'")
  rcall: `args' source("`macval(using)'")
  return add
end


/*
drop _all
rcall clear
capture prog drop rcall
sysuse auto, clear
rcall: df<-st.data()

// create an r script named rscriptexample
rcall script rscriptexample.R  , args(df<-st.data();mat<-as.matrix(df[,c("price","mpg")])) 
rcall script rscriptexample.R  , args(df<-st.data();mat<-as.matrix(df[,c("price","mpg")]);) 
rcall script: rscriptexample.R  , args(df<-st.data()) 
rcall script: rscriptexample.R  , args(df<-st.data()) vanilla
rcall script: rscriptexample.R  , args(df<-st.data();) 
rcall script: rscriptexample.R  , args(df<-st.data();) vanilla
rcall script : "rscriptexample.R", args(df<-st.data();) 
rcall script : "rscriptexample.R", args(df<-st.data();) vanilla
rcall script  : "rscriptexample.R" , args(df<-st.data();) 
rcall script  : "rscriptexample.R"   , args(df<-st.data();) vanilla
return list
*/


