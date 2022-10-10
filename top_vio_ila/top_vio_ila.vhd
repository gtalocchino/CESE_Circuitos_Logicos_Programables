library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top_vio_ila is
   port(
      clk: in std_logic
   );
end;


architecture top_vio_arch of top_vio_ila is
   component vio_0
      port (
         clk: in std_logic;
         probe_out0: out std_logic_vector(0 downto 0);
         probe_out1: out std_logic_vector(1 downto 0)
      );
   end component;

   component ila_0
      port (
	      clk: in std_logic;
         probe0: in std_logic_vector(3 downto 0); 
         probe1: in std_logic_vector(0 downto 0); 
         probe2: in std_logic_vector(0 downto 0);
         probe3: in std_logic_vector(3 downto 0);
         probe4: in std_logic_vector(0 downto 0)
      );
   end component;

   component input_gen is
      port(
         clk: in std_logic;
         rst: in std_logic;
         sel: in std_logic_vector(1 downto 0);
         values_gen: out std_logic_vector(3 downto 0) 
      );
   end component;

   component mod_ppm is
      generic(
         N: natural:= 4
      );
      port(
         input: in std_logic_vector(N - 1 downto 0);
         clk: in std_logic;
         rst: in std_logic;
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

   signal rst: std_logic;
   signal output_mod: std_logic;
   signal input_demod: std_logic;
   signal sel: std_logic_vector(1 downto 0);
   signal input_values: std_logic_vector(3 downto 0);
   signal output_demod: std_logic_vector(3 downto 0);
begin

   vio: vio_0 port map(
      clk => clk,
     probe_out0(0) => rst,
     probe_out1 => sel
   );
   
   ila: ila_0 port map(
      clk => clk,
      probe0 => input_values,
      probe1(0) => output_mod,
      probe2(0) => input_demod,
      probe3 => output_demod,
      probe4(0) => rst
   );

   input_generator: input_gen port map(
      clk => clk,
      rst => rst,
      sel => sel,
      values_gen => input_values
   );

   demodulator: demod_ppm port map (
      clk => clk,
      rst => rst,
      input => input_demod,
      output => output_demod
   );

   modulator: mod_ppm port map(
      clk => clk,
      rst => rst,
      input => input_values,
      output => output_mod
   );
   
   shift_reg: shift_register generic map (
      WIDTH => 1,
      N => 30
   )
   port map(
      clk => clk,
      rst => rst,
      input(0) => output_mod,
      output(0) => input_demod
   );

end;
