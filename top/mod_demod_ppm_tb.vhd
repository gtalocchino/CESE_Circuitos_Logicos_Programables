library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;
use std.env.finish;


entity mod_demod_ppm_tb is
end mod_demod_ppm_tb;


architecture mod_demod_ppm_tb_arch of mod_demod_ppm_tb is
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

   component mod_ppm is
      generic(
         N: natural:= 4
      );
      port(
         clk: in std_logic;
         rst: in std_logic;
         input: in std_logic_vector(N - 1 downto 0);
         output: out std_logic
      );
   end component;

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

   component shift_register is
      generic(
         WIDTH: positive := 4;
         N: positive := 4
      );
      port(
         clk: in std_logic;
         rst: in std_logic;
         input: in std_logic_vector(WIDTH - 1 downto 0);
         output: out std_logic_vector(WIDTH - 1 downto 0)
      );
   end component;

   component input_gen is
      port(
         clk: in std_logic;
         rst: in std_logic;
         values_gen: out std_logic_vector(3 downto 0) 
      );
   end component;

   constant N: positive := 4;
   signal input_tb: std_logic_vector(N - 1 downto 0);
   signal clk_tb: std_logic;
   signal rst_tb: std_logic;
   signal output_mod_tb: std_logic;
   signal input_demod_tb: std_logic;
   signal output_demod_tb: std_logic_vector(N - 1 downto 0);
begin

   modulator: mod_ppm generic map (
      N => N
   )
   port map(
      clk => clk_tb,
      rst => rst_tb,
      input => input_tb,
      output => output_mod_tb
   );

   shift_reg: shift_register generic map (
      WIDTH => 1,
      N => 30
   )
   port map(
      clk => clk_tb,
      rst => rst_tb,
      input(0) => output_mod_tb,
      output(0) => input_demod_tb
   );

   demodulator: demod_ppm generic map(
      N => N
   )
   port map (
      clk => clk_tb,
      rst => rst_tb,
      input => input_demod_tb,
      output => output_demod_tb
   );

   input_generator: input_gen port map(
      clk => clk_tb,
      rst => rst_tb,
      values_gen => input_tb
   );

   reset: process
   begin
      rst_tb <= '1';
      waitne(clk_tb, 2, false);
      rst_tb <= '0';
      wait;
   end process;

   clock: process
   begin
      clk_tb <= '0';
      wait for 1 ns;
      clk_tb <= '1';
      wait for 1 ns;
   end process;

end;
