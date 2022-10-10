library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity shift_register is
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
end;


architecture shift_register_arch of shift_register is
   type shift_reg is array(N - 1 downto 0) of std_logic_vector(WIDTH - 1 downto 0);
   signal data: shift_reg;
begin

   process (clk)
   begin
      if rising_edge(clk) then
         if rst then
            for i in data'range loop
               data(i) <= (others => '0');
            end loop;
         else
            for i in data'high downto data'low + 1 loop
               data(i) <= data(i - 1);
            end loop;  
            data(0) <= input; 
         end if;
      end if;
   end process;

   output <= data(data'high);

end; 
