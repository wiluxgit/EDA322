library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_mux_4to1 is
	port(
		i0,i1,i2,i3: in STD_LOGIC;
		sel: in STD_LOGIC_VECTOR(1 downto 0);
		mux_out: out STD_LOGIC
	);
end E_mux_4to1;

architecture structural of E_mux_4to1 is
	component E_mux_2to1
		port(
			mux2_i0,mux2_i1: in STD_LOGIC;
			mux2_sel: in STD_LOGIC;
			mux2_out: out STD_LOGIC
		);
	end component;
	signal topMuxOut, botMuxOut, finalMuxOut: STD_LOGIC;
	begin
		TOPMUX: entity work.E_mux_2to1(structural)
			port map (i0, i1, sel(0), topMuxOut);
			
		BOTMUX: entity work.E_mux_2to1(structural)
			port map (i2, i3, sel(0), botMuxOut);
			
		FINALMUX: entity work.E_mux_2to1(structural)
			port map (topMuxOut, botMuxOut, sel(1), mux_out);
			
		-- i0──╔═══╗
		--	   ║MUX╟───╮
		-- i1──╚═╤═╝   ╰─╔═══╗
		--       ╰───╮   ║MUX╟───out
		-- i2──╔═══╗ │ ╭─╚═╤═╝
		--	   ║MUX╟─┼─╯   │
		-- i3──╚═╤═╝ │     │
		--       │   │     │
		-- sel0──┴───╯     │ 
		-- sel1────────────╯
			
end structural;