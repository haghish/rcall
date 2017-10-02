


// -----------------------------------------------------------------------------
// Modes
// =============================================================================

R: try(rm(a))
R: a = 1
Rcall vanilla: a
R: a

// -----------------------------------------------------------------------------
// Data Communication Examples
// =============================================================================
global num 10
global str "my string"
R: print($num); print("$str");


scalar num = 10
R: (num = st.scalar(num)*st.scalar(num))
return list
display num

scalar str = "my string"
Rcall: (str = paste(st.scalar(str), "has changed"))

matrix A = (1,2\3,4) 
matrix B = (96,96\96,96)  
R: C <- st.matrix(A) + st.matrix(B) 

quietly sysuse auto, clear
R: (price_mean = mean(st.var(price)))
R: data = st.data()
R: data = data[,1:5]
R: load.data(data)
list in 1

R: data2 = st.data("/Applications/Stata/ado/base/l/lifeexp.dta")
R: load.data(data2)
list in 1

return list


