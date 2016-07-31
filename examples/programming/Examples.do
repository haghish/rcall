


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

