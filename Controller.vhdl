library ieee;
use ieee.std_logic_1164.all;

entity Controller is
	port (ir: in std_logic_vector(3 downto 0); rst, clock: in std_logic; mem_w, mem_read, t1_w, t2_w, t3_w, mem_add_sel,
			--ip_w, 
			rf_w, z_w, ir_w: out std_logic; alu_sel: out std_logic_vector(2 downto 0); rf_sel, alu_aabbc_sel: out std_logic_vector (4 downto 0)
			);
end entity Controller;

-- t3 or IP: where to get address for reading memory
-- store: only time we write to memory

architecture Struct of Controller is
	type state is (rsts, s1,s2,s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17); 
	signal y_present, y_next: state:=s1;
begin
	clock_proc:process(clock,rst)
		begin
			if(rst='0') then
			if(clock='1' and clock' event) then
				y_present <= y_next;
				end if;
			else
				y_present<=rsts; 
			end if;
		end process;
		
		
	state_transition_proc:process(ir, y_present)
	begin
	case y_present is
	when rsts=>
		y_next <= s1;
		mem_w <= '0';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '0';
		--ip_w <= '1';
		rf_w <= '0';
		rf_sel <= "00000";
		z_w <= '0';
		alu_sel <= "000";
		alu_aabbc_sel <="01000";
		ir_w <= '0';

	when s1=>
		mem_w <= '0';
		mem_read <= '1';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '0';
		--ip_w <= '1';
		rf_w <= '1';
		rf_sel <= "01011";
		z_w <= '0';
		alu_sel <= "000";
		alu_aabbc_sel <="00000";
		ir_w <= '1';
		
		if(ir(3 downto 0) = "1000") then 
			y_next<=s10;
		elsif (ir(3 downto 0) = "1001") then
			y_next <= s16;
		else
			y_next <= s2;
		end if;
		
	when s2=>
		mem_w <= '0';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '1';
		t2_w <= '1';
		t3_w <= '0';
		--ip_w <= '0';
		rf_w <= '0';
		rf_sel <= "00100";
		z_w <= '0';
		alu_sel <= "111";
		alu_aabbc_sel <="00000";
		ir_w <= '0';

		if((ir(3 downto 2)= "00" and not (ir(1 downto 0)="01")) or (ir(3 downto 2) = "01" and not (ir(1 downto 0) = "11"))) then 
			y_next<=s3;
		elsif (ir(3 downto 2) = "11" and ir(0)='1') then
			y_next <= s12;
		elsif (ir(3 downto 0) = "1100") then
			y_next <= s9;
		elsif (ir(3 downto 0) = "0001") then
			y_next <= s5;
		else 
			y_next <= s7;
		end if;
	
	when s3=>
		mem_w <= '0';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '1';
		--ip_w <= '0';
		rf_w <= '0';
		rf_sel <= "00100";
		z_w <= '0';
		alu_sel <= ir(2 downto 0);
		alu_aabbc_sel <="01011";
		y_next <= s4;
		ir_w <= '0';
		
	
	when s4=>
		mem_w <= '0';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '0';
		--ip_w <= '0';
		rf_w <= '1';
		rf_sel <= "00001";
		z_w <= '0';
		alu_sel <= "000";
		alu_aabbc_sel <="00000";
		ir_w <= '0';

		y_next <= s1;
		
	when s5=>
		mem_w <= '0';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '1';
		--ip_w <= '0';
		rf_w <= '0';
		rf_sel <= "00100";
		z_w <= '0';
		alu_sel <= "000";
		alu_aabbc_sel <="01101";
		ir_w <= '0';
		y_next <= s17;
			
	when s6=>
		mem_w <= '0';
		mem_read <= '1';
		mem_add_sel <= '1';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '1';
		--ip_w <= '0';
		rf_w <= '0';
		rf_sel <= "00100";
		z_w <= '0';
		alu_sel <= "111";
		alu_aabbc_sel <="00000";
		ir_w <= '0';

		y_next <= s15;
	
	when s7=>
		mem_w <= '0';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '1';
		--ip_w <= '0';
		rf_w <= '0';
		rf_sel <= "00100";
		z_w <= '0';
		alu_sel <= "000";
		alu_aabbc_sel <= "11101";
		ir_w <= '0';
		if (ir(0) = '1') then
			y_next <= s8;
		else
			y_next <= s6;
		end if;
		
	when s8=>
		mem_w <= '1';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '0';
		--ip_w <= '0';
		rf_w <= '0';
		rf_sel <= "00100";
		z_w <= '0';
		alu_sel <= "111";
		alu_aabbc_sel <="00000";
		ir_w <= '0';

		y_next <= s1;
	
	when s9=>
		mem_w <= '0';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '0';
		--ip_w <= '0';
		rf_w <= '0';
		rf_sel <= "00100";
		z_w <= '1';
		alu_sel <= "010";
		alu_aabbc_sel <="01011";
		ir_w <= '0';

		y_next <= s11;
	
	when s10 =>
		mem_w <= '0';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '1';
		--ip_w <= '0';
		rf_w <= '0';
		rf_sel <= "00100";
		z_w <= '0';
		alu_sel <= "001";
		alu_aabbc_sel <="10011";
		ir_w <= '0';

		y_next <= s15;
	
	when s11 =>
		mem_w <= '0';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '0';
		--ip_w <= '1';
		rf_w <= '1';
		rf_sel <= "01111";
		z_w <= '0';
		alu_sel <= "000";
		alu_aabbc_sel <="00101";
		ir_w <= '0';

		y_next <= s1;

	when s12=>
		mem_w <= '0';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '0';
		--ip_w <= '0';
		rf_w <= '1';
		z_w <= '0';
		rf_sel <= "00110";
		alu_sel <= "111";
		alu_aabbc_sel <="00000";
		ir_w <= '0';

		if(ir(3 downto 0) = "1111") then
			y_next <= s13;
		else
			y_next <= s14;
		end if;
	
	when s13 =>
		mem_w <= '0';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '0';
		--ip_w <= '1';
		rf_w <= '1';
		rf_sel <= "10011";
		z_w <= '0';
		alu_sel <= "111";
		alu_aabbc_sel <="00000";
		ir_w <= '0';

		y_next <= s1;
		
	when s14 =>
		mem_w <= '0';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '0';
		--ip_w <= '1';
		rf_w <= '1';
		rf_sel <= "01011";
		z_w <= '0';
		alu_sel <= "000";
		alu_aabbc_sel <="00111";
		ir_w <= '0';

		y_next <= s1;

	when s15 =>
		mem_w <= '0';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '0';
		--ip_w <= '0';
		rf_w <= '1';
		rf_sel <= "00010";
		z_w <= '0';
		alu_sel <= "111";
		alu_aabbc_sel <="00000";
		ir_w <= '0';

		y_next <= s1;

	when s16 =>
		mem_w <= '0';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '1';
		--ip_w <= '0';
		rf_w <= '0';
		rf_sel <= "00100";
		z_w <= '0';
		alu_sel <= "111";
		alu_aabbc_sel <="10011";
		ir_w <= '0';

		y_next <= s15;

	when s17=>
		mem_w <= '0';
		mem_read <= '0';
		mem_add_sel <= '0';
		t1_w <= '0';
		t2_w <= '0';
		t3_w <= '0';
		--ip_w <= '0';
		rf_w <= '1';
		rf_sel <= "00000";
		z_w <= '0';
		alu_sel <= "000";
		alu_aabbc_sel <="00000";
		ir_w <= '0';

		y_next <= s1;
		
		end case;
	end process;

end Struct;
	
	
									 