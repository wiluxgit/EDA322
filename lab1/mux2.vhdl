library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_mux2 is
	port(
		mux2_i0, mux2_i1: in STD_LOGIC;
		mux2_sel: in STD_LOGIC;
		mux2_out: out STD_LOGIC
	);
end E_mux2;

architecture structural of E_mux2 is
	begin
		with mux2_sel select
			mux2_out <=
				mux2_i0 when '0',
				mux2_i1 when '1',
				'Z' when others;
end structural;