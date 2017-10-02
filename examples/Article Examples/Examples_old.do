


// -----------------------------------------------------------------------------
// Modes
// =============================================================================

rcall: try(rm(a))
rcall: a = 1
rcall vanilla: a //returns an error! it's not defined in vanilla mode.
rcall: a

// -----------------------------------------------------------------------------
// Data Communication Examples
// =============================================================================
global num 10
global str "my string"
rcall: print($num); print("$str");


scalar num = 10
rcall: (num = st.scalar(num)*st.scalar(num))
return list
display num

scalar str = "my string"
rcall: (str = paste(st.scalar(str), "has changed"))

matrix A = (1,2\3,4) 
matrix B = (96,96\96,96)  
rcall: C <- st.matrix(A) + st.matrix(B) 
return list

quietly sysuse auto, clear
rcall: (price_mean = mean(st.var(price)))
rcall: data = st.data()
rcall: data = data[,1:5]
rcall: st.load(data)
list in 1

//BEFORE RUNNING THE NEXT EXAMPLE make sure the path to "lifeexp.dta" is correct. 
// this depends on your OS. 
rcall: data2 = st.data("/Applications/Stata/ado/base/l/lifeexp.dta")
rcall: st.load(data2)
list in 1

return list


