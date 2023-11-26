library ieee;
use ieee.std_logic_1164.all;

entity toplevel is
    port (
        clock : in std_logic;
        reset : in std_logic;

        --Data Memory
        dmem_addr : out std_logic_vector(63 downto 0);
        dmem_dati : out std_logic_vector(63 downto 0);
        dmem_dato : in std_logic_vector(63 downto 0);
        dmem_we : out std_logic;

        --Instruction Memory
        imem_addr : out std_logic_vector(63 downto 0);
        imem_data : in std_logic_vector(31 downto 0)
    );
end toplevel;

architecture behave of toplevel is
    component dataflow is
        port (
            --Common
            clock : in std_logic;
            reset : in std_logic;

            --From Control Unit
            reg2loc : in std_logic;
            pcsrc : in std_logic;
            memToReg : in std_logic;
            aluCtrl : in std_logic_vector(3 downto 0);
            aluSrc : in std_logic;
            regWrite : in std_logic;

            --To Control Unit
            opcode : out std_logic_vector(10 downto 0);
            zero : out std_logic;

            --IM interface
            imAddr : out std_logic_vector(63 downto 0);
            imOut : in std_logic_vector(31 downto 0);

            --DM interface
            dmAddr : out std_logic_vector(63 downto 0);
            dmIn : out std_logic_vector(63 downto 0);
            dmOut : in std_logic_vector(63 downto 0)
        );
    end component;

    component controlunit is
        port (
			  --To dataflow
			  reg2loc : out std_logic;
			  memRead : out std_logic;
			  memToReg : out std_logic;
			  aluOp : out std_logic_vector(1 downto 0);
			  memWrite : out std_logic;
			  aluSrc : out std_logic;
			  regWrite : out std_logic;
			  aluCtrl : out std_logic_vector(3 downto 0);
			  pcsrc : out std_logic;
			  --From dataflow
			  opcode : in std_logic_vector(10 downto 0);
			  zero : in std_logic
		 );
    end component;

    signal reg2loc_sig, pcsrc_sig, memtoreg_sig, alusrc_sig, regWrite_sig, 
    zero_sig, memwrite_sig, branch_sig, uncondbranch_sig : std_logic;
    signal aluCtrl_sig : std_logic_vector(3 downto 0);
    signal opcode_sig : std_logic_vector(10 downto 0);
    signal imOut_sig : std_logic_vector(31 downto 0);
    signal imAddr_sig, dmAddr_sig, dmIn_sig, dmOut_sig : std_logic_vector(63 downto 0);

begin

    dmOut_sig <= dmem_dato;
    imOut_sig <= imem_data;

    imem_addr <= imAddr_sig;
    dmem_addr <= dmAddr_sig;
    dmem_dati <= dmIn_sig;
    dmem_we <= memwrite_sig;

    DF : dataflow port map(
        clock => clock,
        reset => reset,
        reg2loc => reg2loc_sig,
        pcsrc => pcsrc_sig,
        memtoreg => memtoreg_sig,
        alusrc => alusrc_sig,
        regwrite => regwrite_sig,
        aluctrl => aluCtrl_sig,
        opcode => opcode_sig,
        zero => zero_sig,
        imaddr => imAddr_sig,
        imOut => imout_sig,
        dmAddr => dmAddr_sig,
        dmIn => dmIn_sig,
        dmOut => dmOut_sig
    );

    UC : controlunit port map(
        reg2loc => reg2loc_sig, 
        memRead => open, 
        memToReg => memToReg_sig, 
        aluOp => open, 
        memWrite => memWrite_sig,
        aluSrc => alusrc_sig, 
        regWrite => regWrite_sig, 
        opcode => opcode_sig,
        aluCtrl => aluCtrl_sig,
		  zero => zero_sig,
		  pcsrc => pcsrc_sig
    );

end behave;