library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;
use std.env.finish;


entity demod_ppm_tb is
end demod_ppm_tb;


architecture demod_ppm_tb_arch of demod_ppm_tb is
   procedure waitne(signal clk: std_logic; constant n: positive; constant rising: boolean) is
      begin
         for i in 1 to n loop
         if rising then
            wait until rising_edge(clk);
         else
            wait until falling_edge(clk);
         end if;
      end loop;
   end procedure;

   component demod_ppm is
      generic(
         N: positive:= 4
      );
      port (
         clk: in std_logic;
         rst: in std_logic;
         input: in std_logic;
         output: out std_logic_vector(N - 1 downto 0)
      );
   end component;

   constant N: positive := 4;

   signal clk_tb: std_logic;
   signal rst_tb: std_logic;
   signal input_tb: std_logic;
   signal output_tb: std_logic_vector(N - 1 downto 0);
   signal reference: integer range 0 to 2**N - 1 := 0;
begin

   demodulator: demod_ppm generic map (
      N => N
   )
   port map(
      input => input_tb,
      clk => clk_tb,
      rst => rst_tb,
      output => output_tb
   );

   input_signal: process
      file input_file: text open read_mode is "ppm_signal.data";
		variable input_line: line;
      variable input_data: std_logic;
	begin
      loop 
         if not endfile(input_file) then
            readline(input_file, input_line);
            read(input_line, input_data);
            input_tb <= input_data;
         else
            finish;
         end if;
         waitne(clk_tb, 1, true);
      end loop;
	end process;

   refernce_signal: process
   begin
      wait until not rst_tb;
      loop
         waitne(clk_tb, 1, true);
         if reference = 2**N - 1 then
            reference <= 0;
         else 
            reference <= reference + 1;
         end if;
      end loop;
   end process;

   reset_generation: process
   begin
      rst_tb <= '1';
      waitne(clk_tb, 2, false);
      rst_tb <= '0';
      wait;
   end process;

   clock_generation: process
   begin
      clk_tb <= '0';
      wait for 1 ns;
      clk_tb <= '1';
      wait for 1 ns;
   end process;

end;
