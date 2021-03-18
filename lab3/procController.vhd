library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity procController is
    Port ( 	master_load_enable: in STD_LOGIC;
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

signal tmp1_out, tmp2_out, tmp_out_in, tmp_out : std_logic;

begin

tmp1_out <= opcode(3) or opcode(2) or opcode(1) or opcode(0);
tmp2_out <= neq xor eq;
tmp_out_in <= tmp1_out xnor tmp2_out;

process(CLK, ARESETN)
begin
if ARESETN='0' then
	tmp_out <= '0';
else
  if rising_edge(clk) then
   	 if master_load_enable = '1' then
		    tmp_out <= tmp_out_in;
	   end if;
  end if;
end if;
end process;

pcSel <= tmp_out;
pcLd <= tmp_out;
instrLd <= tmp_out; 
addrMd <= tmp_out;
dmWr <= tmp_out;
dataLd <= tmp_out;
flagLd <= tmp_out;
accSel  <= tmp_out;
accLd <= tmp_out;
im2bus <= tmp_out;
dmRd <= tmp_out;
acc2bus <= tmp_out;
ext2bus <= tmp_out;
dispLd <= tmp_out;
aluMd(1) <= tmp_out;
aluMd(0) <= not tmp_out;

end Behavioral;


