library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mod_ppm is
   generic(
      N: positive := 4
   );
   port(
      clk: in std_logic;
      rst: in std_logic;
      input: in std_logic_vector(N - 1 downto 0);
      output: out std_logic
   );
end;


architecture mod_ppm_arch of mod_ppm is
   constant MAX: integer := 2**(N - 1) - 1;
   constant MIN: integer := -2**(N - 1);

   signal output_reg: std_logic;
   signal input_reg: std_logic_vector(N - 1 downto 0);
   signal sawtooth: signed(N - 1 downto 0);
begin
   
   input_registers: process (clk)
   begin
      if rising_edge(clk) then
         if rst then
            input_reg <= (others => '0');
         elsif sawtooth = MAX then
            input_reg <= input;
         end if;
      end if;
   end process;

   sawtooth_generator: process (clk)
   begin
      if rising_edge(clk) then
         if rst then
            sawtooth <= to_signed(MAX, N);
         else
            sawtooth <= sawtooth + 1;
         end if;
      end if;
   end process;

   output_regsiter: process (clk)
   begin
      if rising_edge(clk) then
         if rst then
            output_reg <= '0';
         elsif signed(input_reg) = sawtooth then 
            output_reg <= '1';
         else
            output_reg <= '0';
         end if;
      end if;
   end process;

   output <= output_reg;

end;
