library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_or_fold is
	generic(
		g_data_width : integer := 7
	);

	port(
		or_fold_inp: in STD_LOGIC_VECTOR(g_data_width downto 0);
		or_fold_out: out STD_LOGIC
	);
end E_or_fold;

architecture implem of E_or_fold is
	signal l_acc: STD_LOGIC_VECTOR(g_data_width downto 0);
	
	begin
		l_acc(0) <= or_fold_inp(0);
		
		Accumultate:
		for i in 1 to (g_data_width-1) generate
			gen:
			l_acc(i) <= l_acc(i-1) OR or_fold_inp(i);
		end generate;
		
		or_fold_out <= or_fold_inp(g_data_width);
end implem;