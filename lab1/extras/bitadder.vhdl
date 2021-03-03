library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_bitadder is
	port(
		i0,i1,carry_in: in STD_LOGIC;
		sum,carry_out: out STD_LOGIC
	);
end E_bitadder;

architecture structural of E_bitadder is
	signal xorInput: STD_LOGIC;
	signal andInput: STD_LOGIC;
	
	begin
		xorInput <= i0 XOR i1;
		andInput <= i0 AND i1;
		
		carry_out <= (xorInput AND carry_in) OR andInput;
		sum <= xorInput XOR carry_in;
end structural;