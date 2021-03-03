library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity E_alu_main is
	port(
		ALU_inA: in STD_LOGIC_VECTOR(7 downto 0);
		ALU_inB: in STD_LOGIC_VECTOR(7 downto 0);
		ALU_operation: in STD_LOGIC_VECTOR(1 downto 0)
	);
end E_alu_main;

architecture structural of E_alu_main is
	signal andOut: STD_LOGIC_VECTOR(7 downto 0);
	signal notOut: STD_LOGIC_VECTOR(7 downto 0);
	signal sumOut: STD_LOGIC_VECTOR(7 downto 0);
	
	component E_xor
		port(
			xor_i0: in STD_LOGIC;
			xor_i1: in STD_LOGIC;
			xor_out: out STD_LOGIC
		);	
	end component;
	
	begin
		--signal A,B,C,U1_out are local wires
		U1: entity work.E_xor(structural)
		port map(
			xor_i0 => xor3_i1, 		--connect wire "xor3_i1" with xor2 input
			xor_i1 => xor3_i2, 
			xor_out => xor1with2
		);
		--port map (xor3_i1, xor3_i2, xor1with2) does the same thing, be careful with the order
		U2: entity work.E_xor(structural)
		port map(
			xor_i0 => xor3_i3,
			xor_i1 => xor1with2, 
			xor_out => xor3_out
		);
		
		
end structural;