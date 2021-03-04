library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;


entity ALU_TB is
end ALU_TB;

architecture BEHAVIORAL of ALU_TB is

-----------------------------------------------------------------------------
  -- Declarations
  -----------------------------------------------------------------------------

  constant Size    : integer := 199;
  type Operand_array is array (Size downto 0) of std_logic_vector(7 downto 0);
  type OpCode_array is array (Size downto 0) of std_logic_vector(1 downto 0);

  -----------------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------------
  function bin (
    myChar : character)
    return std_logic is
    variable bin : std_logic;
  begin
    case myChar is
      when '0' => bin := '0';
      when '1' => bin := '1';
      when 'x' => bin := '0';
      when others => assert (false) report "no binary character read" severity failure;
    end case;
    return bin;
  end bin;

  impure function loadOperand (
    fileName : string)
    return Operand_array is
    file objectFile : text open read_mode is fileName;
    variable memory : Operand_array;
    variable L      : line;
    variable index  : natural := 0;
    variable myChar : character;
  begin
    while not endfile(objectFile) loop
      readline(objectFile, L);
      for i in 7 downto 0 loop
        read(L, myChar);
        memory(index)(i) := bin(myChar);
      end loop;
      index := index + 1;
    end loop;
    return memory;
  end loadOperand;


  impure function loadOpCode (
    fileName : string)
    return OpCode_array is
    file objectFile : text open read_mode is fileName;
    variable memory : OpCode_array;
    variable L      : line;
    variable index  : natural := 0;
    variable myChar : character;
  begin
    while not endfile(objectFile) loop
      readline(objectFile, L);
      for i in 1 downto 0 loop
        read(L, myChar);
        memory(index)(i) := bin(myChar);
      end loop;
      index := index + 1;
    end loop;
    return memory;
  end loadOpCode;


component alu_wRCA is
    Port ( ALU_inA : in  STD_LOGIC_VECTOR (7 downto 0);
           ALU_inB : in  STD_LOGIC_VECTOR (7 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (7 downto 0);
			     Carry : out STD_LOGIC;
			     NotEq : out STD_LOGIC;
			     Eq : out STD_LOGIC;
			     isOutZero : out STD_LOGIC;
           operation : in  STD_LOGIC_VECTOR (1 downto 0));
end component;

signal AMem        : Operand_array := (others => (others => '0'));
signal BMem        : Operand_array := (others => (others => '0'));
signal OpMem       : OpCode_array := (others => (others => '0'));

signal op_a, op_b, op_out, exp_op_out : std_logic_vector(7 downto 0);
signal opcode : std_logic_vector(1 downto 0); 

signal Carry, NotEq, Eq, isOutZero : std_logic;

signal vec_count: std_logic_vector(7 downto 0) := "00000000";

begin

AMem         <= loadOperand(string'("A_mod_FINAL.tv"));
BMem         <= loadOperand(string'("B_mod_FINAL.tv"));
OpMem        <= loadOpCode(string'("Op_mod_FINAL.tv"));

test_inst: alu_wRCA port map (op_a, op_b, op_out, Carry, NotEq, Eq, isOutZero, opcode);

with opcode select 
  exp_op_out <= op_a + op_b when "00",
  op_a - op_b when "01",
  op_a and op_b when "10",
  not op_a  when "11",
  "01000100" when others;


process 
variable i, final : integer :=0; 
begin
wait for 10 ns;
while_loop: while i < Size loop
  -- set operands and opcode
  op_a <= AMem(i);
  op_b <= BMem(i);
  opcode <= OpMem(i);
  
  --generate expected output
  --case opcode is
    --when "00" => exp_op_out <= op_a + op_b;
    --when "01" => exp_op_out <= op_a + op_b;
    --when "10" => exp_op_out <= op_a nand op_b;
    --when "11" => exp_op_out <= not op_b; 
    --when others => assert false;
  --end case ;
  
  wait for 5 ns;
  assert(exp_op_out = op_out) report "Test failed" severity failure; --assert if unexpected output
  wait for 5 ns; 
  i := i + 1; -- Goto next test vector
end loop while_loop;   

report "Test passed" ;
  
end process;
  
end BEHAVIORAL;


