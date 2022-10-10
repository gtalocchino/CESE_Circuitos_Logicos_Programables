library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity demod_ppm is
   generic(
      N: positive:= 4
   );
   port (
      clk: in std_logic;
      rst: in std_logic;
      input: in std_logic;
      output: out std_logic_vector(N - 1 downto 0)
   );
end;


architecture demod_ppm_arch of demod_ppm is
   constant MAX: integer := 2**(N - 1) - 1;
   constant MIN: integer := -2**(N - 1);

   signal input_reg: std_logic;
   signal sawtooth_sample: std_logic_vector(N - 1 downto 0);
   signal output_reg: std_logic_vector(N - 1 downto 0);
   signal sawtooth: signed(N - 1 downto 0);
begin

   input_register: process (clk)
   begin
      if rising_edge(clk) then
         if rst then
            input_reg <= '0';
         else
            input_reg <= input;
         end if;
      end if;
   end process;

   sawthooth_gen: process (clk)
   begin
      if rising_edge(clk) then
         if rst then
            sawtooth <= to_signed(MAX, N);
         else
            sawtooth <= sawtooth + 1;
         end if;
      end if;
   end process;

   sawtooth_sampling: process (clk)
   begin
      if rising_edge(clk) then
         if rst then
            sawtooth_sample <= (others => '0');
         elsif input_reg then
            sawtooth_sample <= std_logic_vector(sawtooth);
         end if;
      end if;
   end process;

   output_registers: process (clk)
   begin
      if rising_edge(clk) then
         if rst then
            output_reg <= (others => '0');
         elsif sawtooth = MIN then
            output_reg <= sawtooth_sample;
         end if;
      end if;
   end process;

   output <= output_reg;
   
end;
