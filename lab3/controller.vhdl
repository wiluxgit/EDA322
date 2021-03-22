library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity procController is
	Port (  master_load_enable: in STD_LOGIC;
				opcode : in  STD_LOGIC_VECTOR (3 downto 0);
				neq : in STD_LOGIC;
				eq : in STD_LOGIC; 
				CLK : in STD_LOGIC;
				ARESETN : in STD_LOGIC;
				pcSel : out  STD_LOGIC;
				pcLd : out  STD_LOGIC;
				instrLd : out  STD_LOGIC;
				addrMd : out  STD_LOGIC;
				dmWr : out  STD_LOGIC;
				dataLd : out  STD_LOGIC;
				flagLd : out  STD_LOGIC;
				accSel : out  STD_LOGIC;
				accLd : out  STD_LOGIC;
				im2bus : out  STD_LOGIC;
				dmRd : out  STD_LOGIC;
				acc2bus : out  STD_LOGIC;
				ext2bus : out  STD_LOGIC;
				dispLd: out STD_LOGIC;
				aluMd : out STD_LOGIC_VECTOR(1 downto 0));
end procController;

architecture Behavioral of procController is
	type type_controllerState is (Q_FETCH, Q_DECODE, Q_DECODE2, Q_EXECUTE, Q_MEMORY);
	
	signal l_state: type_controllerState;
	signal l_nextState: type_controllerState;
	signal l_op: STD_LOGIC_VECTOR (3 downto 0);
	
	constant oNOOP:           STD_LOGIC_VECTOR(3 downto 0) := "0000";
	constant oLOADBYTE:       STD_LOGIC_VECTOR(3 downto 0) := "0001";
	constant oSTOREBYTE:      STD_LOGIC_VECTOR(3 downto 0) := "0010";
	constant oLOADBYTEINDEX:  STD_LOGIC_VECTOR(3 downto 0) := "0011";
	constant oSTOREBYTEINDEX: STD_LOGIC_VECTOR(3 downto 0) := "0010";
	constant oINPUT:          STD_LOGIC_VECTOR(3 downto 0) := "0101";
	constant oADD:            STD_LOGIC_VECTOR(3 downto 0) := "0110";
	constant oADDINDEX:       STD_LOGIC_VECTOR(3 downto 0) := "0111";
	constant oSUB:            STD_LOGIC_VECTOR(3 downto 0) := "1000";
	constant oNOT:            STD_LOGIC_VECTOR(3 downto 0) := "1001"; -- arg should be 0, or else what? 
	constant oAND:            STD_LOGIC_VECTOR(3 downto 0) := "1010";
	constant oCMP:            STD_LOGIC_VECTOR(3 downto 0) := "1011";
	constant oJUMP:           STD_LOGIC_VECTOR(3 downto 0) := "1100";
	constant oJEQ:            STD_LOGIC_VECTOR(3 downto 0) := "1101";
	constant oJNE:            STD_LOGIC_VECTOR(3 downto 0) := "1110";
	constant oDISP:           STD_LOGIC_VECTOR(3 downto 0) := "1111"; -- arg should be 0, or else what? 
		
	begin
		process(CLK, ARESETN) begin
			if ARESETN = '0' then
				l_state <= Q_FETCH;
				
			elsif rising_edge(clk) then
				l_state <= l_nextState;
			end if;
		end process;
			
		process(l_state, ARESETN) begin	
			pcSel <= '0';
			pcLd <= '0';
			addrMd <= '0';
			dmWr <= '0';
			dataLd <= '0';
			flagLd <= '0';
			accSel <= '0';
			accLd <= '0';
			dmRd <= '0';
			dispLd <= '0';
			
			if ARESETN = '0' then			
				l_nextState <= Q_FETCH;
				
			else
				
				--l_nextState <= l_state;
				
				case l_state is 
				-- ================= Fetch ================= --
				when Q_FETCH => 					
					case l_op is
						when "0010" => l_nextState <= Q_MEMORY;
						when "1111" => l_nextState <= Q_EXECUTE;
						when others => l_nextState <= Q_DECODE;
					end case;
					
				-- ================= DECODE ================ --
				when Q_DECODE => 
					if (
							l_op =    "0000" OR l_op = "0001" OR l_op = "0011" OR l_op = "0100" OR l_op = "0110" 
							OR l_op = "0111" OR l_op = "1000" OR l_op = "1001" OR l_op = "1010"	OR l_op = "1010"
						) then
						dataLd <= '1';
					elsif l_op = "0101" then
						dmWr <= '1';						
					elsif l_op = "1100" then
						pcLd <= '1';
						pcSel <= '1';
					
					--Jeq/Jne
					elsif l_op = "1101" then -- jeq
						pcLd <= '1';
						if eq = '1' then 
							pcSel <= '1';
						else 
							pcSel <= '0';
						end if;							
					elsif l_op = "1110" then -- neq
						pcLd <= '1';
						if eq = '1' then 
							pcSel <= '1';
						else 
							pcSel <= '0';
						end if;
					end if;
					
					case l_op is
						when "0011" => l_nextState <= Q_DECODE2;
						when "0111" => l_nextState <= Q_DECODE2;
						when "0101" => l_nextState <= Q_FETCH;
						when "1101" => l_nextState <= Q_FETCH;
						when "1110" => l_nextState <= Q_FETCH;
						when others => l_nextState <= Q_EXECUTE;
					end case;
				
				-- ================= DECODE* ================ --
				when Q_DECODE2 => 
					if (l_op = "0011" or l_op = "0111") then
						addrMd <= '1';
						dataLd <= '1';
					end if;
					
					l_nextState <= Q_EXECUTE;
						
				-- ================= EXECUTE ================ --
				when Q_EXECUTE => 
					if l_op = "1111" then
						pcLd <= '1';
						dispLd <= '1';
					elsif l_op = "0011" then
						pcLd <= '1';
						accSel <= '1';
						accLd <= '1';
						dmRd <= '1';
					elsif l_op = "0111" then
						pcLd <= '1';
						flagLd <= '1';
						accLd <= '1';
						dmRd <= '1';
					elsif (l_op="0000" or l_op="0100" or l_op="0110" or l_op="0111" or l_op="1000" or l_op="1010") then
						pcLd <= '1';
						flagLd <= '1';
						accLd <= '1';
						dmRd <= '1';
					elsif l_op = "0001" then
						pcLd <= '1';
						accSel <= '1';
						accLd <= '1';
						dmRd <= '1';
					elsif l_op = "1011" then
						pcLd <= '1';
						flagLd <= '1';
						dmRd <= '1';
					elsif l_op = "1001" then
						pcLd <= '1';
						flagLd <= '1';
						accLd <= '1';
						dmRd <= '1'; -- would be in state "X" if litteral from pdf. but we assume that is mistyped
						             -- also makes sense on what NOT is supposed to do
					end if;
					
					case l_op is
						when "0100" => l_nextState <= Q_MEMORY;
						when others => l_nextState <= Q_FETCH;
					end case;
					
				-- ================= MEMEORY ================ --
				when Q_MEMORY => 
					if l_op = "0010" then
						pcLd <= '1';
						dmWr <= '1';
					elsif l_op = "0100" then
						pcLd <= '1';
						addrMd <= '1';
						dmWr <= '1';
					end if;
					l_nextState <= Q_FETCH;	
				end case;
			end if;
		end process;
		
		-- ================= STATELESS EXPRESSIONS ================ --
		instrLd <= '1';
		l_op <= opcode;
		
		with l_op select acc2bus <=
				'1' when "0010",
				'1' when "0100",
				'0' when others;
		with l_op select ext2bus <=
				'1' when "0101",
				'0' when others;
		with l_op select im2bus <=
				'1' when "1100",
				'1' when "1101",
				'1' when "1110",
				'0' when others;
		with l_op select aluMd <=
				"00" when "0000",
				"00" when "0110",
				"00" when "0111",
				"01" when "1000",
				"11" when "1001",
				"10" when "1010",
				"00" when "1111",
				"00" when others;
			
			
			

-- signal tmp1_out, tmp2_out, tmp_out_in, tmp_out : std_logic;

-- begin

-- tmp1_out <= opcode(3) or opcode(2) or opcode(1) or opcode(0);
-- tmp2_out <= neq xor eq;
-- tmp_out_in <= tmp1_out xnor tmp2_out;


-- begin
-- if ARESETN='0' then
	-- tmp_out <= '0';
-- else
  -- if rising_edge(clk) then
	 -- if master_load_enable = '1' then
			-- tmp_out <= tmp_out_in;
	   -- end if;
  -- end if;
-- end if;
-- end process;

-- pcSel <= tmp_out;
-- pcLd <= tmp_out;
-- instrLd <= tmp_out; 
-- addrMd <= tmp_out;
-- dmWr <= tmp_out;
-- dataLd <= tmp_out;
-- flagLd <= tmp_out;
-- accSel  <= tmp_out;
-- accLd <= tmp_out;
-- im2bus <= tmp_out;
-- dmRd <= tmp_out;
-- acc2bus <= tmp_out;
-- ext2bus <= tmp_out;
-- dispLd <= tmp_out;
-- aluMd(1) <= tmp_out;
-- aluMd(0) <= not tmp_out;

end Behavioral;


-- 1) Fetch (FE)
-- 2) Decode (DE)
-- 3) Decode* (DE*)
-- 4) Execute (EX) 
-- 5) Memory (ME)