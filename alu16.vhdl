library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity alu16 is
	port (
	a16: in std_logic_vector(15 downto 0);
	b16: in std_logic_vector(15 downto 0);
	sel4: in std_logic_vector(2 downto 0);
	c16: out std_logic_vector(15 downto 0);
	z1: out std_logic
	);	
end entity alu16;

architecture behav of alu16 is
	
	component mul16_4lsb is
		   port(
			   a16, b16: in std_logic_vector(15 downto 0);
		   	s16: out std_logic_vector(15 downto 0)
	   	);
	 end component mul16_4lsb;
	 
	 component AS16 is
		port (A16,B16 : in std_logic_vector(15 downto 0); M1: in std_logic;
		S16 : out std_logic_vector(15 downto 0); Cout1: out std_logic);	
	end component AS16;
	
	signal sum16, diff16, prod16 : std_logic_vector(15 downto 0) := (others => '0');
	
	begin
	-- carry mapped to 'Z' because it is unused
	cAS16_sum: AS16 port map (a16, b16, '0', sum16, open);
	cAS16_diff: AS16 port map (a16, b16, '1', diff16, open);
	cmul16_4lsb_prod: mul16_4lsb port map (a16, b16, prod16);

	
	c16 <= sum16 when (sel4 = "000") else
			  a16(7 downto 0) & "00000000" when (sel4 = "001") else
			  diff16 when (sel4 = "010") else
			  prod16 when (sel4 = "011") else
			  (a16 and b16) when (sel4 = "100") else
			  (a16 or b16) when (sel4 = "101") else
			  (not b16) or a16 when (sel4 = "110") else
			  a16 when (sel4 = "111") else
			  (others => '0');


	alumux: process (sel4, a16, b16)
	
		begin
		
		
		if a16 = b16 then -- z flag
				z1 <= '1';
		else
				z1 <= '0';
		end if;
		
	end process alumux; 
	
end architecture behav;




