


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
