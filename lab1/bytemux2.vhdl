library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_bytemux2 is
	port(
		bytemux2_i0, bytemux2_i1: in STD_LOGIC_VECTOR(7 downto 0);
		bytemux2_sel: in STD_LOGIC;
		bytemux2_out: out STD_LOGIC_VECTOR(7 downto 0)
	);
end E_bytemux2;

architecture structural of E_bytemux2 is
	begin
		with bytemux2_sel select
			bytemux2_out <=
				bytemux2_i0 when '0',
				bytemux2_i1 when others;
end structural;