ghdl -a --std=08 mod_ppm.vhd mod_ppm_tb.vhd
ghdl -s --std=08 mod_ppm.vhd mod_ppm_tb.vhd
ghdl -e --std=08 mod_ppm_tb
ghdl -r --std=08 mod_ppm_tb --vcd=mod_ppm_tb.vcd --stop-time=100000ns