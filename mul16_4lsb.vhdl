
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

-- potentially add the most significant 16 bits in later

entity mul16_4lsb is
	port(
		a16, b16: in std_logic_vector(15 downto 0);
		s16: out std_logic_vector(15 downto 0)
	);
end entity mul16_4lsb;

architecture behav of mul16_4lsb is
	
	component fa1
		port(A1, B1, Cin1: in std_logic;
    	S1, Cout1: out std_logic); 
	end component fa1;
	
	--signals for 4 lsb
	signal alsb4, blsb4 : std_logic_vector(3 downto 0) := (others => '0');
	
	--signals for 4 bit multiplication
	signal AB0, AB1, AB2, AB3: std_logic_vector (3 downto 0);
	signal C1, C2, C3: std_logic_vector (3 downto 0);
	signal P1, P2, P3: std_logic_vector (3 downto 0);
	
	begin
	--get 4 lsb of A and B
	alsb4 <= a16(3 downto 0);
	blsb4 <= b16(3 downto 0);
	
	
	--and all bits of B with A
	gen0: for i in 0 to 3 generate
		AB0(i) <= alsb4(i) and blsb4(0);
	end generate;

	gen1: for i in 0 to 3 generate
		AB1(i) <= alsb4(i) and blsb4(1);
	end generate;

	gen2: for i in 0 to 3 generate
		AB2(i) <= alsb4(i) and blsb4(2);
	end generate;

	gen3: for i in 0 to 3 generate
		AB3(i) <= alsb4(i) and blsb4(3);
	end generate;

	--Outputs
	cFA1: fa1 port map( AB0(2), AB1(1), C1(0), P1(1), C1(1));
	cFA2: fa1 port map( AB0(3), AB1(2), C1(1), P1(2), C1(2));
	
	cFA3: fa1 port map( P1(2), AB2(1), C2(0), P2(1), C2(1));
	cFA4: fa1 port map( P1(3), AB2(2), C2(1), P2(2), C2(2));
	cFA5: fa1 port map( C1(3), AB2(3), C2(2), P2(3), C2(3));
	cFA6: fa1 port map( P2(2), AB3(1), C3(0), P3(1), C3(1));
	cFA7: fa1 port map( P2(3), AB3(2), C3(1), P3(2), C3(2));
	cFA8: fa1 port map( C2(3), AB3(3), C3(2), P3(3), C3(3));
	
	cHA1: fa1 port map( AB0(1), AB1(0),'0', P1(0), C1(0));
	cHA2: fa1 port map( AB1(3), C1(2), '0', P1(3), C1(3));
	cHA3: fa1 port map( P1(1), AB2(0), '0', P2(0), C2(0));
	cHA4: fa1 port map( P2(1), AB3(0), '0', P3(0), C3(0));

	-- final output
	s16(0)<= AB0(0);
	s16(1)<= P1(0);
	s16(2)<= P2(0);
	s16(3)<= P3(0);
	s16(4)<= P3(1);
	s16(5)<= P3(2);
	s16(6)<= P3(3);
	s16(7)<= C3(3);

end architecture behav;