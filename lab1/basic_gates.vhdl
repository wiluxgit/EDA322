--XOR
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity E_xor is
	port(
		xor_i0: in STD_LOGIC;
		xor_i1: in STD_LOGIC;
		xor_out: out STD_LOGIC
	);
end E_xor;

architecture implem of E_xor is
	begin
		xor_out <= xor_i0 XOR xor_i1;
end implem;

--AND
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity E_and is
	port(
		and_i0: in STD_LOGIC;
		and_i1: in STD_LOGIC;
		and_out: out STD_LOGIC
	);
end E_and;

architecture implem of E_and is
	begin
		and_out <= and_i0 AND and_i1;
end implem;

--NOT
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity E_not is
	port(
		not_i: in STD_LOGIC;
		not_out: out STD_LOGIC
	);
end E_not;

architecture implem of E_not is
	begin
		not_out <= NOT not_i;
end implem;
