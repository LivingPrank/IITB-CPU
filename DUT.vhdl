-- A DUT entity is used to wrap your design.
--  This example shows how you can do this for the
--  Full-adder.

library ieee;
use ieee.std_logic_1164.all;

entity DUT is
   port(input_vector: in std_logic_vector(1 downto 0);
       	output_vector: out std_logic_vector(63 downto 0));
end entity DUT;

architecture DutWrap of DUT is
	component top_level is
	port
		(
		reset, clock: in std_logic;
		reg7, reg1, reg2, reg3: out std_logic_vector (15 downto 0)
	);
	end component top_level;	

begin

   add_instance: top_level port map (reset => input_vector(1),
					clock => input_vector(0),
					reg7 => output_vector(63 downto 48),
					reg1 => output_vector(47 downto 32),
					reg2 => output_vector(31 downto 16),
					reg3 => output_vector(15 downto 0));

end DutWrap;

