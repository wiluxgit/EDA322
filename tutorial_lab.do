#restart -f -nowave
#add wave clk aresetn a b c d sel output


force clk 0 0, 1 50ns -repeat 100ns
force aresetn 0 0, 1 120ns
force a "'b000"
force b "'b001"
force c "'b111"
force d "'b101"
force sel "'b11" 
run 300ns
force sel "'b10"
run 100ns
force sel "'b00"
run 100ns
force sel "'b01"
run 100ns
