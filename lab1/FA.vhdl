library IEEE;
use IEEE.std_logic_1164.ALL;


entity E_fulladder is
	port (a		: in 	STD_LOGIC;
	      b		: in	STD_LOGIC;
	      cin	: in 	STD_LOGIC;
	      s		: out	STD_LOGIC;
	      cout	: out	STD_LOGIC
  	     );
end E_fulladder;

architecture structural of E_fulladder is
begin
	s <= a XOR b XOR cin;
	cout <= (a AND b) OR (cin AND (a XOR b));
end structural;
