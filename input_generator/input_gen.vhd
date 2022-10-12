library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;


entity input_gen is
   port(
      clk: in std_logic;
      rst: in std_logic;
      sel: in std_logic_vector(1 downto 0);
      values_gen: out std_logic_vector(3 downto 0) 
   );
end;

architecture input_gen_arch of input_gen is
   constant LENGTH: positive := 1024;
   constant N: positive := 4;

   type rom is array(0 to LENGTH - 1) of std_logic_vector(3 downto 0);

   impure function init_rom_from_file(file_name: string) return rom is
      file input_file: text open read_mode is file_name;
      variable input_line: line;
      variable rom_values: rom;
   begin
      for i in rom'range loop
         readline(input_file, input_line);
         read(input_line, rom_values(i));
      end loop;
      return rom_values;
   end function;

   constant path_root: string := "/home/gianfranco/Documents/CESE/Circuitos Logicos Programables/Repositorio/CESE_Circuitos_Logicos_Programables/signals/";
   constant path_random: string := path_root & "input_random.data";
   constant path_tone: string := path_root & "input_tone.data";
   constant path_square: string := path_root & "input_square.data";

   constant values_random: rom :=  init_rom_from_file(path_random);
   constant values_tone: rom :=  init_rom_from_file(path_tone);
   constant values_square: rom :=  init_rom_from_file(path_square);

   signal counter: integer range 0 to 2**N - 1;
   signal pointer: integer range 0 to LENGTH - 1;
begin

   process (clk)
   begin
      if rising_edge(clk) then
         if rst then
            counter <= 0;
         elsif counter = 2**N - 1 then
            counter <= 0;
         else 
            counter <= counter + 1;
         end if;
      end if;
   end process;

   process (clk)
   begin
      if rising_edge(clk) then
         if rst then
            pointer <= 0;
         elsif counter = 2**N - 1 then
            if pointer = LENGTH - 1 then
               pointer <= 0;
            else 
               pointer <= pointer + 1;
            end if;
         end if;
      end if;
   end process;

   process (clk)
   begin
      if rising_edge(clk) then
         if rst then
            values_gen <= (others => '0');      
         else
            case sel is
               when "00" =>
                  values_gen <= values_random(pointer);    
               when "01" =>
                  values_gen <= values_tone(pointer);  
               when "10" =>
                  values_gen <= values_square(pointer);  
               when others =>
                  values_gen <= (others => '0');
               end case;
         end if;
      end if;
   end process;
   
end;
