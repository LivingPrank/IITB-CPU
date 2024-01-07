library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RF is
port (
		clk, w, rst: in std_logic; -- clock, write, reset signals
		
		wrega, rrega0, rrega1: in std_logic_vector(2 downto 0); -- write and read register address
		wregc: in std_logic_vector(15 downto 0); -- write register content
		rregc0, rregc1, reg7_ip, reg1, reg2, reg3: out std_logic_vector(15 downto 0)	-- read register contents
	);
end entity RF;

architecture behav of RF is

	type reg_arr is array(0 to 7) of std_logic_vector(15 downto 0);
	
	signal regf : reg_arr := (others => "0000000000000000");
	
	begin
	
	reg1 <= regf(1);
	reg2 <= regf(2);
	reg3 <= regf(3);
	reg7_ip <= regf(7);
	
	behv: process(clk, w, rst, wrega, rrega0, rrega1, wregc, regf)
		begin
		
		if (rst = '1') then
			regf <= (others => "0000000000000000");
		end if;
		
		for i in 0 to 7 loop
			if (unsigned(wrega) = i and w = '1') then
				if (clk'event and clk = '0') then
					regf(i) <= wregc;
				else
					regf(i) <= regf(i);
				end if;
			end if;
			if (unsigned(rrega0) = i) then
				rregc0 <= regf(i);
			end if;
			if (unsigned(rrega1) = i) then
				rregc1 <= regf(i);
			end if;
		end loop;
	
	end process;
	

end architecture;