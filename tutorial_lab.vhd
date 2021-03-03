----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:36:57 01/18/2013 
-- Design Name: 
-- Module Name:    tutorial_lab - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tutorial_lab is
    Port ( a : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
           b : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
           c : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
           d : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  clk: in STD_LOGIC;
			  aresetn: in STD_LOGIC;
           sel : in  STD_LOGIC_VECTOR (1 downto 0);
           output : out  STD_LOGIC_VECTOR(2 DOWNTO 0));
end tutorial_lab;



architecture Behavioral of tutorial_lab is


signal a_r:  STD_LOGIC_VECTOR(2 DOWNTO 0);
signal b_r:  STD_LOGIC_VECTOR(2 DOWNTO 0);
signal c_r:  STD_LOGIC_VECTOR(2 DOWNTO 0);
signal d_r:  STD_LOGIC_VECTOR(2 DOWNTO 0);
signal sel_r:  STD_LOGIC_VECTOR(1 downto 0);

signal out_i : STD_LOGIC_VECTOR(2 DOWNTO 0);
signal out_r : STD_LOGIC_VECTOR(2 DOWNTO 0);

begin

output <= out_r;

with sel_r select 
	out_i <= a_r when "00",
				b_r when "01",
				c_r when "10",
				d_r when others;

process(clk, aresetn)
begin
	if (aresetn = '0') then
		a_r <= "000";
		b_r <= "000";
		c_r <= "000";
		d_r <= "000";
		sel_r <= "00";
		out_r <= "000";
	elsif rising_edge(clk) then
		a_r <= a;
		b_r <= b;
		c_r <= c;
		d_r <= d;
		sel_r <= sel;
		out_r <= out_i;
	end if;
end process;

end Behavioral;

