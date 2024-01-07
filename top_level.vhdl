library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
	port
	(
		reset, clock: in std_logic;
		reg1, reg2, reg3, reg7: out std_logic_vector (15 downto 0)
	);
end entity;

architecture behav of top_level is

	--COMPONENTS LIST
	component alu16 is
	port (
		a16: in std_logic_vector(15 downto 0);
		b16: in std_logic_vector(15 downto 0);
		sel4: in std_logic_vector(2 downto 0);
		c16: out std_logic_vector(15 downto 0);
		z1: out std_logic
		);	
	end component;
	
	component Controller is
	port (ir: in std_logic_vector(3 downto 0); 
			rst, clock: in std_logic;
			mem_w, mem_read, t1_w, t2_w, t3_w, mem_add_sel,
			--ip_w, 
			rf_w, z_w, ir_w: out std_logic; 
			alu_sel: out std_logic_vector(2 downto 0); 
			rf_sel, alu_aabbc_sel: out std_logic_vector (4 downto 0)
			);
	end component;

	component Memoryb  is
	port (mem_w: in std_logic; 
			mem_add: in std_logic_vector(15 downto 0); 
			mem_val: in std_logic_vector(15 downto 0); 
			mem_radd: in std_logic_vector(15 downto 0); 
			mem_out: out std_logic_vector(15 downto 0));
	end component;
	
	
	component Mux2to1_16 is
	port (
		i0_16, i1_16: in std_logic_vector(15 downto 0);
		sel1: in std_logic;
		o_16: out std_logic_vector(15 downto 0)
		);
	end component;
	
	
	component Mux4to1_16 is
	port (
		i0_16, i1_16, i2_16, i3_16: in std_logic_vector(15 downto 0);
		sel2: in std_logic_vector(1 downto 0);
		o_16: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component Mux4to1_3 is
	port(
		i0_3, i1_3, i2_3, i3_3: in std_logic_vector(2 downto 0);
		sel2: in std_logic_vector(1 downto 0);
		o_3: out std_logic_vector(2 downto 0)
	);
	end component;
	
	component Mux8to1_16 is
	port (
		i0_16, i1_16, i2_16, i3_16, i4_16, i5_16, i6_16, i7_16: in std_logic_vector(15 downto 0);
		sel3: in std_logic_vector(2 downto 0);
		o_16: out std_logic_vector(15 downto 0)
		);
	end component;

	component Reg1b is
	port(Clk, Reset, Enable : in std_logic;
			data_in : in std_logic;
			data_out : out std_logic);
	end component;

	
	component Reg16 is
	port (Clk, Reset, Enable : in std_logic;
			data_in : in std_logic_vector(15 downto 0);
			data_out : out std_logic_vector(15 downto 0)
		);
	end component;

	
	component RF is
	port (
		clk, w, rst: in std_logic; -- clock, write, reset signals
		
		wrega, rrega0, rrega1: in std_logic_vector(2 downto 0); -- write and read register address
		wregc: in std_logic_vector(15 downto 0); -- write register content
		rregc0, rregc1, reg7_ip, reg1, reg2, reg3: out std_logic_vector(15 downto 0)	-- read register contents
		);
	end component;
	
	component SE6 is
	port (
		i6: in std_logic_vector(5 downto 0);
		o16: out std_logic_vector(15 downto 0)
		); 
	end component;
	
	component SE8 is
	port (
		i8: in std_logic_vector(7 downto 0);
		o16: out std_logic_vector(15 downto 0)
		);
	end component;

	component SE6_Module is
	port (ir_out: in std_logic_vector(15 downto 0); se6_out, mux_out: out std_logic_vector(15 downto 0));
	end component;
	
	--SIGNALS LIST
	signal 
		a16, b16, c16, se6_out, se8_out, lsb1_16_out, alu_ip_out, z_ip_out, 
		t1_in, t1_out, t2_in, t2_out, t3_in, t3_out, t3_mux_in, t3_mux_out,
		rf_in, rf_a_out, rf_b_out, mem_read_mux_out,
		mem_in, mem_out, reg3_rf, reg1_rf, reg2_rf,
		ip_in, ip_out, ir_in, ir_out: std_logic_vector (15 downto 0);
		
	signal
		w_rf_add, alu_sel: std_logic_vector (2 downto 0);
		
	signal
		alu_mux_sel: std_logic_vector (4 downto 0);
		
	signal 
		rf_sel: std_logic_vector (4 downto 0);
		
	signal 
		imm6: std_logic_vector (5 downto 0);
	
	signal 
		imm8, r_mem_add: std_logic_vector (7 downto 0);
	
	signal
		imm9: std_logic_vector (8 downto 0);
	
	signal 
		mem_w, 
		t1_w, t2_w, t3_w, mem_add_sel, mem_read,
		z_sel, z1, temp,
		ip_w, rf_w, z_w, ir_w, nrst: std_logic;
	
	begin
		--PORT MAPPINGS
		Control_Unit: Controller port map (
													ir => ir_out(15 downto 12),
													rst => reset,
													clock => clock,
													mem_w => mem_w,
													mem_read => mem_read,
													t1_w => t1_w,
													t2_w => t2_w,
													t3_w => t3_w,
													mem_add_sel => mem_add_sel,
													--ip_w => ip_w,
													rf_w => rf_w,
													z_w => z_w,
													ir_w => ir_w,
													alu_sel => alu_sel,
													rf_sel => rf_sel,
													alu_aabbc_sel => alu_mux_sel);
													
		Memory_Unit: Memoryb port map (
												mem_w => mem_w,
												mem_add => t3_out,
												mem_val => t1_out,
												mem_radd => mem_read_mux_out,
												mem_out => mem_out);
												
		Mem_Read_Mux: Mux2to1_16 port map (
													  i0_16 => ip_out, i1_16 => t3_out,
													  sel1 => mem_add_sel,
													  o_16 => mem_read_mux_out);
												
													
		Instruction_Register: Reg16 port map (Clk => clock,
														  Reset => reset,
														  Enable => ir_w, data_in => mem_out, data_out => ir_out);
														  
													
		RF_Source_Mux: Mux8to1_16 port map(i0_16 => t3_out, 
													  i1_16 => ip_out, 
													  i2_16 => alu_ip_out,
													  i3_16 => z_ip_out,
													  i4_16 => t2_out,
													  i5_16 => "0000000000000000",
													  i6_16 => "0000000000000000",
													  i7_16 => "0000000000000000",
													  sel3 => rf_sel (4 downto 2),
													  o_16 => rf_in);
													  
		RF_Add_Mux: Mux4to1_3 port map(i0_3 => ir_out(8 downto 6),
												 i1_3 => ir_out(5 downto 3),
												 i2_3 => ir_out(11 downto 9),
												 i3_3 => "111",
												 sel2 => rf_sel(1 downto 0),
												 o_3 => w_rf_add);
												 
													  
		ALU_A_Mux: Mux4to1_16 port map(i0_16 => ip_out,
												 i1_16 => t1_out,
												 i2_16 => se8_out,
												 i3_16 => t2_out,
												 sel2 => alu_mux_sel(4 downto 3),
												 o_16 => a16);
												 
		ALU_B_Mux: Mux4to1_16 port map(i0_16 => "0000000000000001",
												 i1_16 => t2_out,
												 i2_16 => se6_out,
												 i3_16 => lsb1_16_out,
												 sel2 => alu_mux_sel (2 downto 1),
												 o_16 => b16);
		
		t3_mux_in <= c16;
		alu_ip_out <= c16;
												 
		Configuration_Block: SE6_Module port map(ir_out => ir_out,
															  se6_out => se6_out,
															  mux_out => lsb1_16_out);
											 
		Sign_Extender8: SE8 port map(i8 => ir_out(7 downto 0),
											  o16 => se8_out
												);
													  
		
		Register_File: RF port map (clk => clock, w => rf_w, rst => reset,
											 wrega => w_rf_add,
											 rrega0 => ir_out (11 downto 9), rrega1 => ir_out(8 downto 6),
											 wregc => rf_in,
											 rregc0 => t1_in, rregc1 => t2_in, reg7_ip => ip_out,
											 reg1 => reg1_rf, reg2 => reg2_rf, reg3 => reg3_rf);
		
		ALU: alu16 port map(a16 => a16, b16 => b16, sel4 => alu_sel, c16 => c16, z1 => z1);
		
		T1: Reg16 port map (Clk => clock, Reset => reset, Enable => t1_w, 
								  data_in => t1_in, data_out => t1_out);
		
		T2: Reg16 port map (Clk => clock, Reset => reset, Enable => t2_w, 
								  data_in => t2_in, data_out => t2_out);
								  
		T3_Mux: Mux2to1_16 port map(i0_16 => t3_mux_in, i1_16 => mem_out,
											 sel1 => mem_read, o_16 => t3_mux_out);
								  
		T3: Reg16 port map (Clk => clock, Reset => reset, Enable => t3_w, 
								  data_in => t3_mux_out, data_out => t3_out);
		Z: reg1b port map (reset => reset, Enable => z_w, clk => clock, data_in => z1, data_out => z_sel);
		
		Z_mux: Mux2to1_16 port map(i0_16 => ip_out,
											i1_16 => c16,
											sel1 => z_sel,
											o_16 => z_ip_out);		
											
		
		reg7 <= ip_out;
		reg1 <= reg1_rf;
		reg2 <= reg2_rf;
		reg3 <= reg3_rf;
		--insw <= ir_out;
		
											 
end architecture behav;