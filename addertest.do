#restart -f -nowave
#add wave RCA_a RCA_b RCA_cin

force RCA_a "00000010"
force RCA_b "00000010"
force RCA_cin "0" 
run 500ns