library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity E_xor is
	port(
		xor_i1: in STD_LOGIC;
		xor_i2: in STD_LOGIC;
		xor_out: out STD_LOGIC
	);
end E_xor;

architecture structural of E_xor is
	begin
		xor_out <= xor_i1 XOR xor_i1;
end structural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity E_nand is
	port(
		nand_i1: in STD_LOGIC;
		nand_i2: in STD_LOGIC;
		nand_out: out STD_LOGIC
	);
end E_nand;

architecture structural of E_nand is
	begin
		nand_out <= nand_i1 NAND nand_i1;
end structural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity E_mux4to1 is
	port(
		i0,i1,i2,i3: in STD_LOGIC;
		s: in STD_LOGIC_VECTOR(1 downto 0);
		mux_out: out STD_LOGIC
	);
end E_mux4to1;

architecture structural of E_mux4to1 is
	begin
		with s select
			mux_out <=
				i0 when "00",
				i1 when "01",
				i2 when "10",
				i3 when others;
end structural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity E_adder16bit is
	port(
		carry_in: in STD_LOGIC_VECTOR(0 downto 0);
		i0,i1: in STD_LOGIC_VECTOR(15 downto 0);
		
		sum: out STD_LOGIC_VECTOR(15 downto 0);
		carry_out: out STD_LOGIC
	);
end E_adder16bit;

architecture structural of E_adder16bit is
	signal Xu,Yu,Su: UNSIGNED(16 downto 0);
	signal Cinu: UNSIGNED(1 downto 0);
	begin
		Xu <= UNSIGNED("0" & i0);
		Yu <= UNSIGNED("0" & i1);
		Cinu <= UNSIGNED("0" & carry_in);
		
		Su <= Xu + Yu + Cinu;
		sum <= STD_LOGIC_VECTOR(Su(15 downto 0));
		carry_out <= Su(16);
end structural;