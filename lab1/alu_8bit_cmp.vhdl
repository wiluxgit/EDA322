library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_8bit_and is
	port(
		inp0,inp1: in STD_LOGIC_VECTOR(7 downto 0);
		eq,neq: out STD_LOGIC
	);
end E_8bit_and;

architecture structural of E_8bit_and is
	signal helper: STD_LOGIC;
	begin
		helper <= 
			(inp0(0) XNOR inp1(0)) AND
			(inp0(1) XNOR inp1(1)) AND
			(inp0(2) XNOR inp1(2)) AND
			(inp0(3) XNOR inp1(3)) AND
			(inp0(4) XNOR inp1(4)) AND
			(inp0(5) XNOR inp1(5)) AND
			(inp0(6) XNOR inp1(6)) AND
			(inp0(7) XNOR inp1(7));
			
		eq <= helper;
		neq <= NOT helper;
end structural;