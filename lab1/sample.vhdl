library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sample is
	port(
		in1: in std_logic_vector(1 downto 0);
		out1: out std_logic_vector(1 downto 0)
	);
end sample;


architecture beh of sample is
	signal a: std_logic_vector(1 downto 0) := "11";
	begin
		out1	<=	a;
		a	<=	in1;

end beh;
