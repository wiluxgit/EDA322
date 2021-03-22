library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EDA322_processor is
	port( 
		externalIn: in STD_LOGIC_VECTOR (7 downto 0); -- “extIn” in Figure 1
		CLK: in STD_LOGIC;
		master_load_enable: in STD_LOGIC;
		ARESETN: in STD_LOGIC;
		pc2seg: out STD_LOGIC_VECTOR (7 downto 0); -- PC 
		instr2seg: out STD_LOGIC_VECTOR (11 downto 0); -- Instruction register
		Addr2seg: out STD_LOGIC_VECTOR (7 downto 0); -- Address register
		dMemOut2seg: out STD_LOGIC_VECTOR (7 downto 0); -- Data memory output
		aluOut2seg: out STD_LOGIC_VECTOR (7 downto 0); -- ALU output
		acc2seg: out STD_LOGIC_VECTOR (7 downto 0); -- Accumulator
		flag2seg: out STD_LOGIC_VECTOR (3 downto 0); -- Flags
		busOut2seg: out STD_LOGIC_VECTOR (7 downto 0); -- Value on the bus
		disp2seg: out STD_LOGIC_VECTOR(7 downto 0); --Display register
		errSig2seg: out STD_LOGIC; -- Bus Error signal
		ovf: out STD_LOGIC; -- Overflow 
		zero: out STD_LOGIC -- Zero
	); 
end EDA322_processor;

architecture structural of EDA322_processor is
	component procController is
		port(
			master_load_enable: in STD_LOGIC;
			opcode: in  STD_LOGIC_VECTOR (3 downto 0);
			neq: in STD_LOGIC;
			eq: in STD_LOGIC; 
			CLK: in STD_LOGIC;
			ARESETN: in STD_LOGIC;
			pcSel: out  STD_LOGIC;
			pcLd: out  STD_LOGIC;
			instrLd: out  STD_LOGIC;
			addrMd: out  STD_LOGIC;
			dmWr: out  STD_LOGIC;
			dataLd: out  STD_LOGIC;
			flagLd: out  STD_LOGIC;
			accSel: out  STD_LOGIC;
			accLd: out  STD_LOGIC;
			im2bus: out  STD_LOGIC;
			dmRd: out  STD_LOGIC;
			acc2bus: out  STD_LOGIC;
			ext2bus: out  STD_LOGIC;
			dispLd: out STD_LOGIC;
			aluMd: out STD_LOGIC_VECTOR(1 downto 0)
		);
	end component;
	
	component alu_wRCA is
		port(
			ALU_inA: in STD_LOGIC_VECTOR(7 downto 0);
			ALU_inB: in STD_LOGIC_VECTOR(7 downto 0);
			ALU_out: out STD_LOGIC_VECTOR(7 downto 0);
			Carry: out STD_LOGIC;
			NotEq: out STD_LOGIC;
			Eq: out STD_LOGIC;
			isOutZero: out STD_LOGIC;
			operation: in STD_LOGIC_VECTOR(1 downto 0)
		);
	end component;
	
	component E_rca is
		port (
			RCA_a:   in  STD_LOGIC_VECTOR(7 downto 0);
			RCA_b:   in  STD_LOGIC_VECTOR(7 downto 0);
			RCA_cin: in  STD_LOGIC;
			RCA_sum: out STD_LOGIC_VECTOR(7 downto 0);
			RCA_cout:out STD_LOGIC
		);
	end component;

	component E_register is
		generic (n:integer:=8);
		port (
			dIn: in STD_LOGIC_VECTOR(n-1 downto 0);
			clk: in STD_LOGIC;
			aresetn: in STD_LOGIC;
			loadE: in STD_LOGIC;
			output: out STD_LOGIC_VECTOR(n-1 downto 0)
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
	
	component mem_array is
		generic(
			data_width: integer := 12;
			addr_width: integer := 8;
			init_file:  string  := "inst_mem.mif"
		);
		port(
			addr: in  STD_LOGIC_VECTOR(addr_width-1 downto 0);
			dIn: in  STD_LOGIC_VECTOR(data_width-1 downto 0);
			clk: in  STD_LOGIC;
			we: in  STD_LOGIC;
			output: out STD_LOGIC_VECTOR(data_width-1 downto 0)
		);
	end component;
	
	component E_PBus is
		port( 
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
	end component;
	
	
	signal l_nxtpc: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	signal l_pc: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	signal l_PCIncrOut: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	
	signal l_InstrMemOut: STD_LOGIC_VECTOR(11 downto 0) := "000000000000";	
	signal l_Instruction: STD_LOGIC_VECTOR(11 downto 0) := "000000000000";
	
	alias l_opFromInstruction: STD_LOGIC_VECTOR(3 downto 0) is l_Instruction(11 downto 8);
	alias l_addrFromInstruction: STD_LOGIC_VECTOR(7 downto 0) is l_Instruction(7 downto 0);
	
	signal l_MemData_Addr: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	signal l_MemDataOut: STD_LOGIC_VECTOR(7 downto 0) := "00000000";	
	signal l_MemDataOutReged: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	signal l_dataIn: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	
	signal l_OutFromAlu: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	signal l_OutFromAcc: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	signal l_InToAcc: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	
	signal l_FlagInp: STD_LOGIC_VECTOR(3 downto 0);
	alias l_AluFlag_Carry:  STD_LOGIC is l_FlagInp(0);
	alias l_AluFlag_EQ:     STD_LOGIC is l_FlagInp(1);
	alias l_AluFlag_NEQ:    STD_LOGIC is l_FlagInp(2);
	alias l_AluFlag_isZero: STD_LOGIC is l_FlagInp(3);
	
	signal l_Regged_Flag: STD_LOGIC_VECTOR(3 downto 0);
	alias l_Regged_AluFlag_Carry:  STD_LOGIC is l_Regged_Flag(0);
	alias l_Regged_AluFlag_EQ:     STD_LOGIC is l_Regged_Flag(1);
	alias l_Regged_AluFlag_NEQ:    STD_LOGIC is l_Regged_Flag(2);
	alias l_Regged_AluFlag_isZero: STD_LOGIC is l_Regged_Flag(3);
	
	signal l_Bus: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	signal l_BusOut: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	signal l_Bus_errSig: STD_LOGIC := '0';
	
	-- signal l_D_pc2seg: STD_LOGIC_VECTOR(7 downto 0);
	-- signal l_D_instr2seg: STD_LOGIC_VECTOR(12 downto 0);
	-- signal l_D_addr2seg: STD_LOGIC_VECTOR(7 downto 0);
	-- signal l_D_memOut2seg: STD_LOGIC_VECTOR(7 downto 0);
	-- signal l_D_aluOut2seg: STD_LOGIC_VECTOR(7 downto 0);
	-- signal l_D_accOut2seg: STD_LOGIC_VECTOR(7 downto 0);
	-- signal l_D_busOut2seg: STD_LOGIC_VECTOR(7 downto 0);
	-- signal l_D_errSig2seg: STD_LOGIC_VECTOR(7 downto 0);
	-- signal l_D_flag2seg: STD_LOGIC_VECTOR(7 downto 0);
	-- signal l_D_disp2seg: STD_LOGIC_VECTOR(7 downto 0);
	
	signal l_proc_pcSel: STD_LOGIC := '0';
	signal l_proc_pcLd: STD_LOGIC := '0';
	signal l_proc_instrLd: STD_LOGIC := '0';
	signal l_proc_addrMd: STD_LOGIC := '0';
	signal l_proc_dmWr: STD_LOGIC := '0';
	signal l_proc_dataLd: STD_LOGIC := '0';
	signal l_proc_flagLd: STD_LOGIC := '0';
	signal l_proc_accSel: STD_LOGIC := '0';
	signal l_proc_accLd: STD_LOGIC := '0';
	signal l_proc_im2bus: STD_LOGIC := '0';
	signal l_proc_dmRd: STD_LOGIC := '0';
	signal l_proc_acc2bus: STD_LOGIC := '0';
	signal l_proc_ext2bus: STD_LOGIC := '0';
	signal l_proc_dispLd: STD_LOGIC := '0';
	signal l_proc_aluMd: STD_LOGIC_VECTOR(1 downto 0) := "00";
	
	begin 
		
		-- Internal Bus --
		INTERNAL_BUS:
		entity work.E_PBus(implem)
		port map( 
			PBUS_INSTRUCTION => l_addrFromInstruction,
			PBUS_DATA => l_MemDataOutReged,
			PBUS_ACC => l_OutFromAcc,
			PBUS_EXTDATA => externalIn,
			PBUS_OUTPUT => l_Bus,
			PBUS_ERR => l_Bus_errSig,
			PBUS_instrSEL => l_proc_im2bus,
			PBUS_dataSEL => l_proc_dmRd,
			PBUS_accSEL => l_proc_acc2bus,
			PBUS_extdataSEL => l_proc_ext2bus
		);
		l_BusOut <= l_Bus;		
		
		-- Pre Instruction Memory Block --
		FE:
		entity work.E_register(behavioral)
		generic map (n => 8)
		port map (
			dIn => l_nxtpc,
			clk => CLK,
			aresetn => ARESETN,
			loadE => l_proc_pcSel,
			output => l_pc
		);
		
		PCIncr:
		entity work.E_rca(implem)
		port map(
			RCA_a => "00000001",
			RCA_b => l_pc, 
			RCA_cin => '0',
			RCA_sum => l_PCIncrOut
			--RCA_cout => Carry
		);
		
		PCIncr_Mux:
		entity work.E_bytemux2(implem)
		port map(
			bytemux2_i0 => l_PCIncrOut,
			bytemux2_i1 => l_Bus,
			bytemux2_sel => l_proc_pcSel,
			bytemux2_out => l_nxtpc
		);
		
		-- Instruction Memory
		INSTR_MEM:
		entity work.mem_array(behavioral)
		generic map(
			data_width => 12,
			addr_width => 8,
			init_file => "inst_mem.mif"
		)
		port map (
			addr => l_pc,
			dIn	=> "000000000000",
			clk => CLK,
			we => '0',
			output => l_InstrMemOut
		);
		
		-- Post Instruction Memory Block --
		FEDE:
		entity work.E_register(behavioral)
		generic map (n => 12)
		port map (
			dIn => l_InstrMemOut,
			clk => CLK,
			aresetn => ARESETN,
			loadE => l_proc_instrLd,
			output => l_Instruction
		);
		
		DATAMEM_IN_Mux:
		entity work.E_bytemux2(implem)
		port map(
			bytemux2_i0 => l_addrFromInstruction,
			bytemux2_i1 => l_MemDataOutReged,
			bytemux2_sel => l_proc_addrMd,
			bytemux2_out => l_MemData_Addr
		);
		
		-- Data Memory With Logic--
		DATA_MEM:
		entity work.mem_array(behavioral)
		generic map(
			data_width => 8,
			addr_width => 8,
			init_file => "data_mem.mif"
		)
		port map (
			addr => l_MemData_Addr,
			dIn	=> l_dataIn,
			clk => CLK,
			we => l_proc_dmWr,
			output => l_MemDataOut
		);
		
		DEEX:
		entity work.E_register(behavioral)
		generic map (n => 8)
		port map (
			dIn => l_MemDataOut,
			clk => CLK,
			aresetn => ARESETN,
			loadE => l_proc_dataLd,
			output => l_MemDataOutReged
		);
		
		-- ALU		
		ALU:
		entity work.alu_wRCA(implem)
		port map(
			ALU_inA => l_OutFromAcc,
			ALU_inB => l_BusOut,
			ALU_out => l_OutFromAlu,
			Carry => l_AluFlag_Carry,
			NotEq => l_AluFlag_NEQ,
			Eq => l_AluFlag_EQ,
			isOutZero => l_AluFlag_isZero,
			operation => l_proc_aluMd
		);
		
		ALU_OUT_Mux:
		entity work.E_bytemux2(implem)
		port map(
			bytemux2_i0 => l_OutFromAlu,
			bytemux2_i1 => l_BusOut,
			bytemux2_sel => l_proc_accSel,
			bytemux2_out => l_InToAcc
		);
		
		REG_ACC:
		entity work.E_register(behavioral)
		generic map (n => 8)
		port map (
			dIn => l_InToAcc,
			clk => CLK,
			aresetn => ARESETN,
			loadE => l_proc_accLd,
			output => l_OutFromAcc
		);
		
		REG_FLAG:
		entity work.E_register(behavioral)
		generic map (n => 4)
		port map (
			dIn => l_FlagInp,
			clk => CLK,
			aresetn => ARESETN,
			loadE => l_proc_flagLd,
			output => l_Regged_Flag
		);
		
		REG_DISPLAY:
		entity work.E_register(behavioral)
		generic map (n => 8)
		port map (
			dIn => l_OutFromAcc,
			clk => CLK,
			aresetn => ARESETN,
			loadE => l_proc_dispLd,
			output => disp2seg
		);
		
		-- Displays
		flag2seg <= l_Regged_Flag;
		acc2seg <= l_OutFromAcc;
		aluOut2seg <= l_OutFromAlu;
		errSig2seg <= l_Bus_errSig;
		dMemOut2seg <= l_MemDataOut;
		Addr2seg <= l_MemData_Addr;
		instr2seg <= l_Instruction;
		pc2seg <= l_pc;
		
		-- disp2seg already done @ REG_DISPLAY
		
		-- CONTROLLER
		
		PROC_CONTROLLER:		
		entity work.procController(behavioral)
		port map(
			master_load_enable => master_load_enable,
			opcode => l_opFromInstruction,
			neq => l_Regged_AluFlag_NEQ,
			eq => l_Regged_AluFlag_EQ,
			CLK => CLK,
			ARESETN => ARESETN,
			pcSel => l_proc_pcSel,
			pcLd => l_proc_pcLd,
			instrLd => l_proc_instrLd,
			addrMd => l_proc_addrMd,
			dmWr => l_proc_dmWr,
			dataLd => l_proc_dataLd,
			flagLd => l_proc_flagLd,
			accSel => l_proc_accSel,
			accLd => l_proc_accLd,
			im2bus => l_proc_im2bus,
			dmRd => l_proc_dmRd,
			acc2bus => l_proc_acc2bus,
			ext2bus => l_proc_ext2bus,
			dispLd => l_proc_dispLd,
			aluMd => l_proc_aluMd
		);
		
end structural;