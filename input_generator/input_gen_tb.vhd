library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity input_gen_tb is
end;

architecture input_gen_tb_arch of input_gen_tb is
   procedure waitn_re(signal clk: std_logic; constant n: positive) is
      begin
         for i in 1 to n loop
            wait until rising_edge(clk);
      end loop;
   end procedure;

   component input_gen is
      port(
         clk: in std_logic;
         rst: in std_logic;
         sel: in std_logic_vector(1 downto 0);
         values_gen: out std_logic_vector(3 downto 0)
      );
   end component;

   constant RANDON_SIGNAL: std_logic_vector(1 downto 0) := "00";
   constant TONE_SIGNAL: std_logic_vector(1 downto 0) := "01";
   constant SQUARE_SIGNAL: std_logic_vector(1 downto 0) := "10";

   signal clk_tb: std_logic;
   signal rst_tb: std_logic;
   signal values_gen_tb: std_logic_vector(3 downto 0);
begin

   input_gen_inst: input_gen port map(
      clk => clk_tb,
      rst => rst_tb,
      sel => TONE_SIGNAL,
      values_gen => values_gen_tb
   );

   reset: process
   begin
      rst_tb <= '1';
      waitn_re(clk_tb, 2);
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
