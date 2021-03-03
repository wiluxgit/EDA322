library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity E_alu is
	port(
		ALU_inA: in STD_LOGIC_VECTOR(7 downto 0);
		ALU_inB: in STD_LOGIC_VECTOR(7 downto 0);
		ALU_operation: in STD_LOGIC_VECTOR(1 downto 0);
		ALU_carry: out STD_LOGIC;
		ALU_isOutZero: out STD_LOGIC;
		ALU_out: out STD_LOGIC_VECTOR(7 downto 0);
		ALU_eq: out STD_LOGIC;
		ALU_neq: out STD_LOGIC
	);
end E_alu;

architecture structural of E_alu is
	signal l_andOut: STD_LOGIC_VECTOR(7 downto 0);
	signal l_notOut: STD_LOGIC_VECTOR(7 downto 0);
	signal l_sumOut: STD_LOGIC_VECTOR(7 downto 0);
	signal l_muxOut: STD_LOGIC_VECTOR(7 downto 0);
	
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
	
	component E_bytemux4 is
		port(
			bytemux4_i0, bytemux4_i1, bytemux4_i2, bytemux4_i3: in STD_LOGIC;
			bytemux4_sel: in STD_LOGIC_VECTOR(1 downto 0);
			bytemux4_out: out STD_LOGIC
		);
	end component;
	
	begin
		part_RCA: 
		entity work.E_rca(structural)
		port map(
			RCA_a => ALU_inA,
			RCA_b => ALU_inB, 
			RCA_cin => '0',
			RCA_sum => l_sumOut,
			RCA_cout => ALU_carry
		);		
		
		part_AND: 
		entity work.E_bitwise_and(structural)
		port map(
			bitwise_and_inpA => ALU_inA,
			bitwise_and_inpB => ALU_inB, 
			bitwise_and_out => l_andOut
		);
		
		part_NOT: 
		entity work.E_bitwise_not(structural)
		port map(
			bitwise_not_inp => ALU_inA,
			bitwise_not_out => l_notOut
		);
		
		part_CMP: 
		entity work.E_cmp_8bit(structural)
		port map(
			cmp_inpA => ALU_inA,
			cmp_inpB => ALU_inB,
			cmp_eq => ALU_eq,
			cmp_neq => ALU_neq
		);
		
		-- part_MUX:	
		-- for i in 0 to 7 generate
			-- gen:
			-- entity work.E_mux4(structural)
			-- port map(
				-- mux4_i0 => l_sumOut(i),
				-- mux4_i1 => l_sumOut(i),
				-- mux4_i2 => l_andOut(i),
				-- mux4_i3 => l_notOut(i),
				-- mux4_sel => ALU_operation,
				-- mux4_out => l_muxOut(i)
			-- );
		-- end generate;
		
		part_MUX:
		entity work.E_bytemux4(structural)
		port map(
			bytemux4_i0 => l_sumOut,
			bytemux4_i1 => l_sumOut,
			bytemux4_i2 => l_andOut,
			bytemux4_i3 => l_notOut,
			bytemux4_sel => ALU_operation,
			bytemux4_out => l_muxOut
		);
		
		
		--TODO isOutZero, hook up l_muxOut to some non zero detector
		--TODO subtraction
		
		ALU_out <= l_muxOut;
end structural;