library IEEE;
use IEEE.std_logic_1164.ALL;


entity E_rca is
	port (
		RCA_a		: in  STD_LOGIC_VECTOR(7 downto 0);
		RCA_b		: in  STD_LOGIC_VECTOR(7 downto 0);
		RCA_cin	: in  STD_LOGIC;
		RCA_sum	: out STD_LOGIC_VECTOR(7 downto 0);
		RCA_cout	: out STD_LOGIC
	);
end E_rca;


architecture structural of E_rca is

	component E_fulladder
		port (
			a	: in	STD_LOGIC;
			b	: in	STD_LOGIC;
			cin	: in 	STD_LOGIC;
			s	: out	STD_LOGIC;
			cout: out	STD_LOGIC
		);
	end component;

SIGNAL carry : STD_LOGIC_VECTOR(6 downto 0);

begin
	E0: 
	entity work.E_fulladder(structural)
	port map(RCA_a(0), RCA_b(0), RCA_cin, RCA_sum(0), carry(0));
	
	E1_E6: 
	for i in 1 to 6 generate
		gen: 
		entity work.E_fulladder(structural)
		port map(RCA_a(i), RCA_b(i), carry(i-1), RCA_sum(i), carry(i));
	end generate;
	
	E7:
	entity work.E_fulladder(structural)
	PORT MAP(RCA_a(7), RCA_b(7), carry(6), RCA_sum(7), RCA_cout);
	

end structural;