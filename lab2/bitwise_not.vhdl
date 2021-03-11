library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_bitwise_not is
	port(
		bitwise_not_inp: in STD_LOGIC_VECTOR(7 downto 0);
		bitwise_not_out: out STD_LOGIC_VECTOR(7 downto 0)
	);
end E_bitwise_not;

architecture implem of E_bitwise_not is
	
	component E_not
		port(
			not_i: in STD_LOGIC;
			not_out: out STD_LOGIC
		);	
	end component;
	
	begin
		bitwise: 
		for i in 0 to 7 generate
			gen:
			entity work.E_not(implem)
			port map (bitwise_not_inp(i), bitwise_not_out(i));
		end generate;
end implem;