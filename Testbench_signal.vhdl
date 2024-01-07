library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Testbench is
end entity;

architecture behav of Testbench is
	
component top_level is
	 port
	(
		reset, clock: in std_logic;
		reg1, reg2, reg3, reg7, insw: out std_logic_vector (15 downto 0)
	);
end component;		
		
	signal reset, clock, mem_r_test, ir_w_test: std_logic;
	--signal reg1, reg2, reg3, reg7, ir_o_test: std_logic_vector(15 downto 0);
	signal reg1, reg2, reg3, reg7: std_logic_vector(15 downto 0);
	signal insw: std_logic_vector(15 downto 0);
	--signal alu_t: std_logic_vector(4 downto 0);
	--signal testa, testb, testc, testd, teste, testf, 
		--	 testg, testh, testi, testj, testk, testl: std_logic_vector(15 downto 0);
	
	begin
	
		CKP: process 
			begin 
				CLOCK <= '1'; 
				wait for 10 ns; 
				CLOCK <= '0'; 
				wait for 10 ns; 
				--assert (NOW < 2000000 ns) 
					--report "Simulation completed successfully.";
					--severity ERROR;
		end process CKP; 
	RESET <= '1', '0' after 15ns; 
	-- Apply to entity under test: 			
	--balls: top_level port map(reset, clock, reg1, reg2, reg3, reg7, ir_o_test, mem_r_test, ir_w_test, alu_t,
		--							  testa, testb, testc, testd, teste, testf, testg, testh, testi, testj, testk, testl);
		
	balls: top_level port map( 
		reset, clock,
		reg1, reg2, reg3, reg7,	
		insw
	);
	
end architecture;