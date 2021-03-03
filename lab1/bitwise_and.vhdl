library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_bitwise_and is
	port(
		bitwise_and_inpA, bitwise_and_inpB: in STD_LOGIC_VECTOR(7 downto 0);
		bitwise_and_out: out STD_LOGIC_VECTOR(7 downto 0)
	);
end E_bitwise_and;

architecture structural of E_bitwise_and is
	
	component E_and
		port(
			and_i0: in STD_LOGIC;
			and_i1: in STD_LOGIC;
			and_out: out STD_LOGIC
		);	
	end component;
	
	begin	
		bitwise: 
		for i in 0 to 7 generate
			gen:
			entity work.E_and(structural)
			port map(
				bitwise_and_inpA(i), 
				bitwise_and_inpB(i), 
				bitwise_and_out(i)
			);
		end generate;
end structural;