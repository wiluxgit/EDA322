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
		U0: entity work.E_not(structural)
			port map (inp(0), out_8bit_not(0));
		U1: entity work.E_not(structural)
			port map (inp(1), out_8bit_not(1));
		U2: entity work.E_not(structural)
			port map (inp(2), out_8bit_not(2));
		U3: entity work.E_not(structural)
			port map (inp(3), out_8bit_not(3));
		U4: entity work.E_not(structural)
			port map (inp(4), out_8bit_not(4));
		U5: entity work.E_not(structural)
			port map (inp(5), out_8bit_not(5));
		U6: entity work.E_not(structural)
			port map (inp(6), out_8bit_not(6));
		U7: entity work.E_not(structural)
			port map (inp(7), out_8bit_not(7));
end structural;