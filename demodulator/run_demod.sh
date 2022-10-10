ghdl -a --std=08 demod_ppm.vhd demod_ppm_tb.vhd
ghdl -s --std=08 demod_ppm.vhd demod_ppm_tb.vhd
ghdl -e --std=08 demod_ppm_tb
ghdl -r --std=08 demod_ppm_tb --vcd=demod_ppm_tb.vcd --stop-time=100000ns