library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_8bit_and is
	port(
		inp0,inp1: in STD_LOGIC_VECTOR(7 downto 0);
		out_8bit_and: out STD_LOGIC_VECTOR(7 downto 0)
	);
end E_8bit_and;

architecture structural of E_8bit_and is
	
	-- signal inp0,inp1,out: STD_LOGIC_VECTOR(7 downto 0);
	component E_and
		port(
			and_i0: in STD_LOGIC;
			and_i1: in STD_LOGIC;
			and_out: out STD_LOGIC
		);	
	end component;
	
	begin
		U0: entity work.E_and(structural)
			port map (inp0(0), inp1(0), out_8bit_and(0));
		U1: entity work.E_and(structural)
			port map (inp0(1), inp1(1), out_8bit_and(1));
		U2: entity work.E_and(structural)
			port map (inp0(2), inp1(2), out_8bit_and(2));
		U3: entity work.E_and(structural)
			port map (inp0(3), inp1(3), out_8bit_and(3));
		U4: entity work.E_and(structural)
			port map (inp0(4), inp1(4), out_8bit_and(4));
		U5: entity work.E_and(structural)
			port map (inp0(5), inp1(5), out_8bit_and(5));
		U6: entity work.E_and(structural)
			port map (inp0(6), inp1(6), out_8bit_and(6));
		U7: entity work.E_and(structural)
			port map (inp0(7), inp1(7), out_8bit_and(7));
end structural;