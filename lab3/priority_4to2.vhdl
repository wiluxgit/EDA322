library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_priority_4to2 is
	port(
		priority_4to2_inp: in STD_LOGIC_VECTOR(3 downto 0);
		priority_4to2_out: out STD_LOGIC_VECTOR(1 downto 0);
		priority_4to2_input_exists: out STD_LOGIC;
		priority_4to2_error_mutiple: out STD_LOGIC
	);
end E_priority_4to2;

architecture behavioral of E_priority_4to2 is
	
	begin
		process(priority_4to2_inp) begin
			if (priority_4to2_inp = "0001") then
				priority_4to2_out <= "00";
				priority_4to2_input_exists <= '1';
				priority_4to2_error_mutiple <= '0';
				
			elsif (priority_4to2_inp = "0010") then
				priority_4to2_out <= "01";
				priority_4to2_input_exists <= '1';
				priority_4to2_error_mutiple <= '0';
				
			elsif (priority_4to2_inp = "0100") then
				priority_4to2_out <= "10";
				priority_4to2_input_exists <= '1';
				priority_4to2_error_mutiple <= '0';
				
			elsif (priority_4to2_inp = "1000") then
				priority_4to2_out <= "11";
				priority_4to2_input_exists <= '1';
				priority_4to2_error_mutiple <= '0';
				
			elsif (priority_4to2_inp = "0000") then
				priority_4to2_input_exists <= '0';
				priority_4to2_error_mutiple <= '0';
				
			else 
				priority_4to2_input_exists <= '1';
				priority_4to2_error_mutiple <= '1';
			end if;
		end process;
end behavioral;