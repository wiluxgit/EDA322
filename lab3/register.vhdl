library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity E_register is
	generic (n : integer := 8);
	port ( 	dIn			: in  STD_LOGIC_VECTOR(n-1 downto 0);
		clk, aresetn, loadE 	: in  STD_LOGIC;
		output 			: out STD_LOGIC_VECTOR(n-1 downto 0));
end E_register;


architecture behavioral of E_register is
begin
	process(aresetn, clk)
	begin 
		if aresetn = '0' then
			output <= (others => '0');
		elsif rising_edge(clk) then
			if loadE = '1' then
			output <= dIn;
		end if;
	end if;
	end process;
end behavioral;