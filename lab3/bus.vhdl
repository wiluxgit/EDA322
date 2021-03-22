library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity E_PBus is
	Port ( 
		PBUS_INSTRUCTION : in STD_LOGIC_VECTOR (7 downto 0);
		PBUS_DATA : in STD_LOGIC_VECTOR (7 downto 0);
		PBUS_ACC : in STD_LOGIC_VECTOR (7 downto 0);
		PBUS_EXTDATA : in STD_LOGIC_VECTOR (7 downto 0);
		PBUS_OUTPUT : out STD_LOGIC_VECTOR (7 downto 0);
		PBUS_ERR : out STD_LOGIC;
		PBUS_instrSEL : in STD_LOGIC;
		PBUS_dataSEL : in STD_LOGIC;
		PBUS_accSEL : in STD_LOGIC;
		PBUS_extdataSEL : in STD_LOGIC
	);
end E_PBus;

architecture implem of E_PBus is	
	-- ── INSTRUCTION──/8────────────────╔═══╗   ╔═══╗
	-- ── DATA─────────/8────────────────║4-1║ ╭─║2-1║
	-- ── ACC──────────/8────────────────║MUX╟─┼─║MUX╟── PBUS_OUTPUT
	-- ── EXTDATA──────/8────────────────╚╤═╤╝ │ ╚═╤═╝
	--                                    │ │  │   │
	-- ── instrSEL ────╔════════╗         │ │  Z   │    
	-- ── dataSEL ─────║Priority╟─ sel 0 ─╯ │      │
	-- ── accSEL ──────║Encoder ╟─ sel 1 ───╯      │
	-- ── extdataSEL ──╚════╤╤══╝                  │
	--                      │╰─ input_exists ──┬─╮ │
	--                      │                  │&├─╯
	--                      ╰ error_mutiple ─▷∘┴─╯
	
	component E_priority_4to2
		port (
			priority_4to2_inp: in STD_LOGIC_VECTOR(3 downto 0);
			priority_4to2_out: out STD_LOGIC_VECTOR(1 downto 0);
			priority_4to2_input_exists: out STD_LOGIC;
			priority_4to2_error_mutiple: out STD_LOGIC
		);
	end component;
	
	component E_bytemux4 is
		port(
			bytemux4_i0, bytemux4_i1, bytemux4_i2, bytemux4_i3: in STD_LOGIC_VECTOR(7 downto 0);
			bytemux4_sel: in STD_LOGIC_VECTOR(1 downto 0);
			bytemux4_out: out STD_LOGIC
		);
	end component;
	
	component E_bytemux2 is
		port(
			bytemux2_i0: in STD_LOGIC_VECTOR(7 downto 0);
			bytemux2_i1: in STD_LOGIC_VECTOR(7 downto 0);
			bytemux2_sel: in STD_LOGIC;
			bytemux2_out: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	signal l_priority_bin: STD_LOGIC_VECTOR(1 downto 0);
	signal l_bus_has_input: STD_LOGIC;
	signal l_bus_has_mutiple_input: STD_LOGIC;
	signal l_allow_bus_to_open: STD_LOGIC;
	signal l_before_output: STD_LOGIC_VECTOR(7 downto 0);
	signal l_priorityInput: STD_LOGIC_VECTOR(3 downto 0);
	
	begin
		l_priorityInput <= PBUS_extdataSEL&PBUS_accSEL&PBUS_dataSEL&PBUS_instrSEL;
		PART_priority_select: 
		entity work.E_priority_4to2(behavioral)
		port map(
			priority_4to2_inp => l_priorityInput,
			priority_4to2_out => l_priority_bin,
			priority_4to2_error_mutiple => l_bus_has_mutiple_input,
			priority_4to2_input_exists => l_bus_has_input
		);
		
		PBUS_ERR <= l_bus_has_mutiple_input;
		
		PART_mux: 
		entity work.E_bytemux4(implem)
		port map(
			bytemux4_i0 => PBUS_INSTRUCTION,
			bytemux4_i1 => PBUS_DATA,
			bytemux4_i2 => PBUS_ACC,
			bytemux4_i3 => PBUS_EXTDATA,
			bytemux4_sel => l_priority_bin,
			bytemux4_out => l_before_output
		);
		
		l_allow_bus_to_open <= l_bus_has_input AND (NOT l_bus_has_mutiple_input);
		
		Part_ENABLE_mux:
		entity work.E_bytemux2(implem)
		port map(
			bytemux2_i0 => "ZZZZZZZZ", --makes sense
			bytemux2_i1 => l_before_output,
			bytemux2_sel => l_allow_bus_to_open,
			bytemux2_out => PBUS_OUTPUT
		);
end implem;