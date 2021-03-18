library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_wRCA is
	port(
		ALU_inA: in STD_LOGIC_VECTOR(7 downto 0);
		ALU_inB: in STD_LOGIC_VECTOR(7 downto 0);
		ALU_out: out STD_LOGIC_VECTOR(7 downto 0);
		Carry: out STD_LOGIC;
		NotEq: out STD_LOGIC;
		Eq: out STD_LOGIC;
		isOutZero: out STD_LOGIC;
		operation: in STD_LOGIC_VECTOR(1 downto 0)
	);
end alu_wRCA;

architecture implem of alu_wRCA is	
	component E_rca
		port (
			RCA_a:   in  STD_LOGIC_VECTOR(7 downto 0);
			RCA_b:   in  STD_LOGIC_VECTOR(7 downto 0);
			RCA_cin: in  STD_LOGIC;
			RCA_sum: out STD_LOGIC_VECTOR(7 downto 0);
			RCA_cout:out STD_LOGIC
		);
	end component;
	
	component E_bitwise_and is
		port(
			bitwise_and_inpA: in STD_LOGIC_VECTOR(7 downto 0);
			bitwise_and_inpB: in STD_LOGIC_VECTOR(7 downto 0);
			bitwise_and_out: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;	
	
	component E_bitwise_not is
		port(
			bitwise_not_inp: in STD_LOGIC_VECTOR(7 downto 0);
			bitwise_not_out: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	component E_cmp_8bit is
		port(
			cmp_inpA: in STD_LOGIC_VECTOR(7 downto 0);
			cmp_inpB: in STD_LOGIC_VECTOR(7 downto 0);
			cmp_eq: out STD_LOGIC;
			cmp_neq: out STD_LOGIC
		);
	end component;
	
	component E_or_fold is
		port(
			or_fold_inp: in STD_LOGIC_VECTOR(7 downto 0);
			or_fold_out: out STD_LOGIC
		);
	end component;
	
	component E_bytemux4 is
		port(
			bytemux4_i0, bytemux4_i1, bytemux4_i2, bytemux4_i3: in STD_LOGIC;
			bytemux4_sel: in STD_LOGIC_VECTOR(1 downto 0);
			bytemux4_out: out STD_LOGIC
		);
	end component;
	
	signal l_andOut: STD_LOGIC_VECTOR(7 downto 0);
	signal l_notOut: STD_LOGIC_VECTOR(7 downto 0);
	signal l_sumOut: STD_LOGIC_VECTOR(7 downto 0);
	signal l_muxOut: STD_LOGIC_VECTOR(7 downto 0);
	signal l_inverted_ALU_inB: STD_LOGIC_VECTOR(7 downto 0);
	signal l_adder_inB: STD_LOGIC_VECTOR(7 downto 0);
	signal l_subtractMode: STD_LOGIC;
	signal l_isOutNotZero: STD_LOGIC;
	
	begin
		-- ========== ADDER LOGIC ========= --
		-- subtract mode will be enabled for "operation"="01" and "11"
		l_subtractMode <= operation(0);
		
		part_ALU_B_INVERTER: 
		entity work.E_bitwise_not(implem)
		port map(
			bitwise_not_inp => ALU_inB,
			bitwise_not_out => l_inverted_ALU_inB
		);
		
		part_SUBTRACT_MUX: 
		entity work.E_bytemux2(implem)
		port map(		
			bytemux2_i0 => ALU_inB,
			bytemux2_i1 => l_inverted_ALU_inB,
			bytemux2_sel => l_subtractMode, 
			bytemux2_out => l_adder_inB
		);	
		
		part_RCA: 
		entity work.E_rca(implem)
		port map(
			RCA_a => ALU_inA,
			RCA_b => l_adder_inB, 
			RCA_cin => l_subtractMode,
			RCA_sum => l_sumOut,
			RCA_cout => Carry
		);		
		
		-- ===== BITWISE AND OPERATION ===== --
		part_AND: 
		entity work.E_bitwise_and(implem)
		port map(
			bitwise_and_inpA => ALU_inA,
			bitwise_and_inpB => ALU_inB, 
			bitwise_and_out => l_andOut
		);
		
		-- ===== BITWISE NOT OPERATION ===== --
		part_NOT: 
		entity work.E_bitwise_not(implem)
		port map(
			bitwise_not_inp => ALU_inA,
			bitwise_not_out => l_notOut
		);
		
		-- ========= CMP OPERATION ========= --
		part_CMP: 
		entity work.E_cmp_8bit(implem)
		port map(
			cmp_inpA => ALU_inA,
			cmp_inpB => ALU_inB,
			cmp_eq => Eq,
			cmp_neq => NotEq
		);
		
		-- ========= OUTPUT SELECT ========= 
		-- as to make this file less crowded the 4 to 1 mux is implemented in file "bytemux4.vhdl"
		part_MUX:
		entity work.E_bytemux4(implem)
		port map(
			bytemux4_i0 => l_sumOut,
			bytemux4_i1 => l_sumOut,
			bytemux4_i2 => l_andOut,
			bytemux4_i3 => l_notOut,
			bytemux4_sel => operation,
			bytemux4_out => l_muxOut
		);
		
		-- ========= isOutZero test =========
		-- this could be done with entity E_cmp_8bit but that is slower
		part_CMP_with0:
		entity work.E_or_fold(implem)
		port map(
			or_fold_inp => l_muxOut,
			or_fold_out => l_isOutNotZero
		);
		
		isOutZero <= NOT l_isOutNotZero;
		ALU_out <= l_muxOut;
end implem;