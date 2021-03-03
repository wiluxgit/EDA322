library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_xor3 is
	port(
		xor3_i1: in STD_LOGIC;
		xor3_i2: in STD_LOGIC;
		xor3_i3: in STD_LOGIC;
		xor3_out: out STD_LOGIC
	);
end E_xor3;

architecture structural of E_xor3 is
	signal xor1with2: STD_LOGIC;
	component E_xor
		port(
			xor_i1: in STD_LOGIC;
			xor_i2: in STD_LOGIC;
			xor_out: out STD_LOGIC
		);	
	end component;
	begin
		--signal A,B,C,U1_out are local wires
		U1: entity work.E_xor(structural)
		port map(
			xor_i1 => xor3_i1, 		--connect wire "xor3_i1" with xor2 input
			xor_i2 => xor3_i2, 
			xor_out => xor1with2
		);
		--port map (xor3_i1, xor3_i2, xor1with2) does the same thing, be careful with the order
		U2: entity work.E_xor(structural)
		port map(
			xor_i1 => xor3_i3,
			xor_i2 => xor1with2, 
			xor_out => xor3_out
		);
		
		
end structural;