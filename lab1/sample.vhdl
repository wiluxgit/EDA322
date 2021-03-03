library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sample is
	port(
		in1: in STD_LOGIC_VECTOR(1 downto 0);
		out1: out STD_LOGIC_VECTOR(1 downto 0)
	);
end sample;


architecture structural of sample is
	signal a: STD_LOGIC_VECTOR(1 downto 0) := "11";
	begin
		out1	<=	a;
		a		<=	in1;	--order does not matter
end structural;