
// 2.2
// ===
rcall: print("Hello World")

/* 3.2.1 console mode
   the example of section 3.2.1 is for the console mode and it has to be typed 
   or copy-pasted into stata console, when the rcall console mode is activated. 
   it CANNOT be executed from the do-file editor
*/

// -----------------------------------------------------------------------------
print.numeric <- function(x) {
	if (is.numeric(x) | is.integer(x)) {
         return(x)
    }
	else {
         stop("input of class ", class(x), " is not acceptable")
    }
}

print.numeric(1:10)
// -----------------------------------------------------------------------------


// 3.2.2 interactive mode : execute after the previous example
// ===========================================================
rcall: print.numeric(10)


// 3.2.4 sync mode 
// ===============
scalar str = "myname"
rcall sync: print(str)

// console mode (better to be typed manually, or copy-pasted into command line)
rcall sync
	str = "Hello World"
end

display str


// second example of this section
sysuse auto, clear
regress price mpg
matrix A = r(table)

// must be typed manually in the console
rcall sync:
	 print(A)
	 B = A[1:4, ]
end

matrix list B 



// 4: data communication between Stata and R
// =========================================
global num 10
global str "my string"
rcall: print($num); print("$str");


rcall clear
scalar num = 10
rcall: (num = st.scalar(num)*st.scalar(num))
return list

scalar str = "my string"
rcall: (str = paste(st.scalar(str), "has changed"))

matrix A = (1,2\3,4) 
matrix B = (96,96\96,96)  
rcall: (C = st.matrix(A) + st.matrix(B))

quietly sysuse auto, clear
rcall: (price_mean = mean(st.var(price)))

rcall: data = st.data()
clear
rcall: data = data[,1:5]
rcall: st.load(data)
list in 1

return list



// 4.1 Controling returned objects from R to Stata
// ===============================================
rcall clear
rcall: a = 1:10
return list

rcall: a = matrix(a)
return list

rcall vanilla : a = 1; b = 2; x = a + b; rm(a,b);
return list

rcall vanilla : a = 1; b = 2; x = a + b; st.return = "x";
return list


// 5.1.1 echo program
// ==================
program echo
	rcall vanilla: cat(`0')
end
	
echo "Hello World"

scalar a = "hello world" 
echo st.scalar(a)


// 5.1.2 summary program
// =====================
program summary, byable(recall)
	    version 14
	    syntax varlist [if] [in]
	    marksample touse
	    preserve
	    quietly keep if `touse'
	    quietly keep `varlist' 
	    rcall vanilla: sapply(st.data(), summary)
	    restore
end

sysuse auto, clear
by foreign: summary price mpg


// 5.1.3 Using ggplot2 R package
// =============================
program rplot
    version 12
    rcall vanilla : library(ggplot2); qplot(data=st.data(), `0')
end

sysuse auto, clear
rplot mpg, price, colour = foreign, shape = foreign



program drop rplot
program rplot
    version 12
    syntax varlist [, colour(name) shape(name) format(name)]
    	
    // selecting x and y
    tokenize `varlist'
    if !missing("`2'") {
        local x "`2'"
        local y "`1'"
    }
    else {
        local x "`1'" 
       	local y NULL
    }
    	
    // default options
    if !missing("`colour'") local colour ", colour = `colour'"
    if !missing("`shape'") local shape ", shape = `shape'"
    if missing("`format'") local format pdf
    	
    rcall vanilla : `format'("Rplot.`format'");                        ///
    library(ggplot2);                                                  ///
    qplot(data=st.data(),x=`2',y=`1' `colour' `shape')
end

rplot price mpg , colour(foreign) shape(foreign) format(png)



// 5.3 Returning stored results
// ============================

//load the lm.ado into Stata before running the next command
//----------------------------------------------------------
sysuse auto, clear
lm price mpg turn if price < 16000 
return list






