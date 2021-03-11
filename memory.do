## memory.do

#restart -f    	## Uncomment to restart simulation every time the script is executed
		## or,
restart -f nowave    	## Uncomment to restart simulation every time the script is executed. nowave: removes all signals from waveform
#view signals wave	    ## add signals from the simulated top-level (here mem_array) to waveform


force clk 0 0, 1 50ns -repeat 100ns
force we 1
force dIn b"000011000000"
force addr b"00001100"
run 100ns

force we 0
run 100ns

force addr b"00000001"
run 100ns

force addr b"00000010"
run 100ns

force addr b"00001100"
run 100ns

# etc...