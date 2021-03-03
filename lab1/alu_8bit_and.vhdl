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
		bitwise: 
		for i in 0 to 7 generate
			gen:
			entity work.E_and(structural)
			port map (inp0(i), inp1(i), out_8bit_and(i));
		end generate;
end structural;