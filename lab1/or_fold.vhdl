library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_or_fold is
	port(
		or_fold_inp: in STD_LOGIC_VECTOR(7 downto 0);
		or_fold_out: out STD_LOGIC;
	);
end E_or_fold;

architecture structural of E_or_fold is
	begin
		or_fold_out <= 
			or_fold_inp(0) OR
			or_fold_inp(1) OR
			or_fold_inp(2) OR
			or_fold_inp(3) OR
			or_fold_inp(4) OR
			or_fold_inp(5) OR
			or_fold_inp(6) OR
			or_fold_inp(7);
end structural;