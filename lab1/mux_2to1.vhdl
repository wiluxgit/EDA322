library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_mux_2to1 is
	port(
		i0,i1: in STD_LOGIC;
		sel: in STD_LOGIC;
		mux_out: out STD_LOGIC
	);
end E_mux_2to1;

architecture structural of E_mux_2to1 is
	begin
		with sel select
			mux_out <=
				i0 when '0',
				i1 when '1',
				'Z' when others;
end structural;