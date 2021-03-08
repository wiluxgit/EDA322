library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity E_procBus is
	Port ( 
		BUS_INSTRUCTION : in STD_LOGIC_VECTOR (7 downto 0);
		BUS_DATA : in STD_LOGIC_VECTOR (7 downto 0);
		BUS_ACC : in STD_LOGIC_VECTOR (7 downto 0);
		BUS_EXTDATA : in STD_LOGIC_VECTOR (7 downto 0);
		BUS_OUTPUT : out STD_LOGIC_VECTOR (7 downto 0);
		BUS_ERR : out STD_LOGIC;
		BUS_instrSEL : in STD_LOGIC;
		BUS_dataSEL : in STD_LOGIC;
		BUS_accSEL : in STD_LOGIC;
		BUS_extdataSEL : in STD_LOGIC
	);
end E_procBus;

architecture implem of E_procBus is	
	-- ── BUS_INSTRUCTION────────────────────╔═══╗
	-- ── BUS_DATA───────────────────────────║MUX║
	-- ── BUS_ACC────────────────────────────║   ║
	-- ── BUS_EXTDATA────────────────────────╚╤═╤╝
	--                                        │ │
	-- ── BUS_instrSEL ────╔════════╗         │ │
	-- ── BUS_dataSEL ─────║Priority╟─sel 0───╯ │
	-- ── BUS_accSEL ──────║Encoder ╟─sel 1─────╯
	-- ── BUS_extdataSEL ──╚════╤╤══╝
	--                          │╰── invalid_input
	--                          ╰─── input exists
	
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
	
	begin
		PART_priority_select: 
		entity work.E_priority_4to2(behavioral)
		port map(
			priority_4to2_inp(0) => BUS_instrSEL,
			priority_4to2_inp(1) => BUS_dataSEL,
			priority_4to2_inp(2) => BUS_accSEL,
			priority_4to2_inp(3) => BUS_extdataSEL,
			priority_4to2_out => l_priority_bin,
			priority_4to2_error_mutiple => l_bus_has_mutiple_input,
			priority_4to2_input_exists => l_bus_has_input
		);
		
		BUS_ERR <= l_bus_has_mutiple_input;
		
		PART_mux: 
		entity work.E_bytemux4(implem)
		port map(
			bytemux4_i0 => BUS_INSTRUCTION,
			bytemux4_i1 => BUS_DATA,
			bytemux4_i2 => BUS_ACC,
			bytemux4_i3 => BUS_EXTDATA,
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
			bytemux2_out => BUS_OUTPUT
		);
end implem;