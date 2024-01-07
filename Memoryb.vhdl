library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all;

entity Memoryb  is
  port (mem_w: in std_logic; 
			mem_add: in std_logic_vector(15 downto 0); 
			mem_val: in std_logic_vector(15 downto 0); 
			mem_radd: in std_logic_vector(15 downto 0); 
			mem_out: out std_logic_vector(15 downto 0));
end entity;

architecture Struct of Memoryb is
	
	type mem_array is array(0 to 1023) of std_logic_vector(15 downto 0);
	
	signal outp: mem_array := (0 => "1001001000000111", 
										1 => "1001010000000101", 
										2 => "0000001010011000", 
										3 => "0010001010011000",
										4 => "0011001010011000",
										5 => "0001001011000011",
										6 => "0100001010011000",
										7 => "0101001010011000",
										8 => "0110001010011000",
										9 => "1000011000000110",
										10 => "1011001010011010",
										11 => "1010010001011000",
										12 => "1100001010001000",
										21 => "1101001000000011",
										22 => "1001011000001111",
										28 => "1111010001000000",
										others => "0000000000000000");
	signal en: std_logic_vector(1023 downto 0);
	
	begin
	in_assign:process(mem_add, mem_w)
	begin
		for i in 0 to 1023 loop
			if (unsigned(mem_add) = i and mem_w = '1') then
				outp(i) <= mem_val;
			end if;
		end loop;
	end process;
	
	assign_outp: process(outp, mem_radd)
	begin
		for i in 0 to 1023 loop
			if (unsigned(mem_radd) = i) then
				mem_out <= outp(i);
			end if;
		end loop;
	end process;

end Struct;