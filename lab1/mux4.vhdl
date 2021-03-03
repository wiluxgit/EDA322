library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_mux4 is
	port(
		mux4_i0, mux4_i1, mux4_i2, mux4_i3: in STD_LOGIC;
		mux4_sel: in STD_LOGIC_VECTOR(1 downto 0);
		mux4_out: out STD_LOGIC
	);
end E_mux4;

architecture structural of E_mux4 is
	component E_mux2
		port(
			mux2_i0,mux2_i1: in STD_LOGIC;
			mux2_sel: in STD_LOGIC;
			mux2_out: out STD_LOGIC
		);
	end component;
	signal l_topMuxOut, l_botMuxOut: STD_LOGIC;
	begin
		TOPMUX: entity work.E_mux2(structural)
			port map (mux4_i0, mux4_i1, mux4_sel(0), l_topMuxOut);
			
		BOTMUX: entity work.E_mux2(structural)
			port map (mux4_i1, mux4_i3, mux4_sel(0), l_botMuxOut);
			
		FINALMUX: entity work.E_mux2(structural)
			port map (l_topMuxOut, l_botMuxOut, mux4_sel(1), mux4_out);
			
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