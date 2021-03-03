library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_8bit_not is
	port(
		inp: in STD_LOGIC_VECTOR(7 downto 0);
		out_8bit_not: out STD_LOGIC_VECTOR(7 downto 0)
	);
end E_8bit_not;

architecture structural of E_8bit_not is
	
	component E_not
		port(
			not_i: in STD_LOGIC;
			not_out: out STD_LOGIC
		);	
	end component;
	
	begin
		bitwise: 
		for i in 0 to 7 generate
			gen:
			entity work.E_not(structural)
			port map (inp(i), out_8bit_not(i));
		end generate;
end structural;