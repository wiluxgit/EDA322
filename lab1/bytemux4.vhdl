library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity E_bytemux4 is
	port(
		bytemux4_i0, bytemux4_i1, bytemux4_i2, bytemux4_i3: in STD_LOGIC_VECTOR(7 downto 0);
		bytemux4_sel: in STD_LOGIC_VECTOR(1 downto 0);
		bytemux4_out: out STD_LOGIC_VECTOR(7 downto 0)
	);
end E_bytemux4;

architecture structural of E_bytemux4 is
	component E_bytemux2
		port(
			bytemux2_i0,bytemux2_i1: in STD_LOGIC_VECTOR(7 downto 0);
			bytemux2_sel: in STD_LOGIC_VECTOR(7 downto 0);
			bytemux2_out: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	signal l_topMuxOut, l_botMuxOut: STD_LOGIC_VECTOR(7 downto 0);
	begin
		TOPMUX: 
		entity work.E_bytemux2(structural)
		port map (bytemux4_i0, bytemux4_i1, bytemux4_sel(0), l_topMuxOut);
			
		BOTMUX:
		entity work.E_bytemux2(structural)
		port map (bytemux4_i1, bytemux4_i3, bytemux4_sel(0), l_botMuxOut);
			
		FINALMUX:
		entity work.E_bytemux2(structural)
		port map (l_topMuxOut, l_botMuxOut, bytemux4_sel(1), bytemux4_out);
			
		-- i0──╔═══╗
		--     ║MUX╟───╮
		-- i1──╚═╤═╝   ╰─╔═══╗
		--       ╰───╮   ║MUX╟───out
		-- i2──╔═══╗ │ ╭─╚═╤═╝
		--     ║MUX╟─┼─╯   │
		-- i3──╚═╤═╝ │     │
		--       │   │     │
		-- sel0──┴───╯     │
		-- sel1────────────╯
			
end structural;