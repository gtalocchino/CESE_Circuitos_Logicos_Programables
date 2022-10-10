ghdl -a --std=08 input_gen.vhd input_gen_tb.vhd 
ghdl -s --std=08 input_gen.vhd input_gen_tb.vhd 
ghdl -e --std=08 input_gen_tb
ghdl -r --std=08 input_gen_tb --vcd=input_gen_tb.vcd --stop-time=4000ns