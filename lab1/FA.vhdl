library IEEE;
use IEEE.std_logic_1164.ALL;


entity E_fulladd is
	port (a		: in 	STD_LOGIC;
	      b		: in	STD_LOGIC;
	      cin	: in 	STD_LOGIC;
	      s		: out	STD_LOGIC;
	      cout	: out	STD_LOGIC
  	     );
end E_fulladd;

architecture dataflow of E_fulladd is
begin
	s 	<= a XOR b XOR cin;
	cout	<= (a AND b) OR (cin AND (a XOR b));
end dataflow;
