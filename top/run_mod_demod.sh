ghdl -a --std=08 ../input_generator/input_gen.vhd ../shift_register/shift_register.vhd ../modulator/mod_ppm.vhd ../demodulator/demod_ppm.vhd ../top/mod_demod_ppm_tb.vhd
ghdl -s --std=08 ../input_generator/input_gen.vhd ../shift_register/shift_register.vhd ../modulator/mod_ppm.vhd ../demodulator/demod_ppm.vhd ../top/mod_demod_ppm_tb.vhd
ghdl -e --std=08 mod_demod_ppm_tb
ghdl -r --std=08 mod_demod_ppm_tb --vcd=mod_demod_ppm_tb.vcd --stop-time=400000ns