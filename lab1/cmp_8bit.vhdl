library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_cmp_8bit is
	port(
		cmp_inpA, cmp_inpB: in STD_LOGIC_VECTOR(7 downto 0);
		cmp_eq, cmp_neq: out STD_LOGIC
	);
end E_cmp_8bit;

architecture implem of E_cmp_8bit is
	signal l_helper: STD_LOGIC;
	begin
		l_helper <= 
			(cmp_inpA(0) XNOR cmp_inpB(0)) AND
			(cmp_inpA(1) XNOR cmp_inpB(1)) AND
			(cmp_inpA(2) XNOR cmp_inpB(2)) AND
			(cmp_inpA(3) XNOR cmp_inpB(3)) AND
			(cmp_inpA(4) XNOR cmp_inpB(4)) AND
			(cmp_inpA(5) XNOR cmp_inpB(5)) AND
			(cmp_inpA(6) XNOR cmp_inpB(6)) AND
			(cmp_inpA(7) XNOR cmp_inpB(7));
			
		cmp_eq <= l_helper;
		cmp_neq <= NOT l_helper;
end implem;