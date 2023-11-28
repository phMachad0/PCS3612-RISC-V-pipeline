library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity riscvsingle is
    port (
        clk, reset : in std_logic;
        PC : out std_logic_vector(31 downto 0);
        Instr : in std_logic_vector(31 downto 0);
        MemWrite : out std_logic;
        ALUResult, WriteData : out std_logic_vector(31 downto 0);
        ReadData : in std_logic_vector(31 downto 0)
    );
end;

architecture struct of riscvsingle is
    component controller
        port (
            op : in std_logic_vector(6 downto 0);
            funct3 : in std_logic_vector(2 downto 0);
            funct7b5, Zero : in std_logic;
            ResultSrc : out std_logic_vector(1 downto 0);
            MemWrite : out std_logic;
            PCSrc, ALUSrc : out std_logic;
            RegWrite, Jump : out std_logic;
            ImmSrc : out std_logic_vector(1 downto 0);
            ALUControl : out std_logic_vector(2 downto 0)
        );
    end component;

    component datapath
        port (
            clk, reset : inSTD_LOGIC;
            ResultSrc : in std_logic_vector(1 downto 0);
            PCSrc, ALUSrc : in std_logic;
            RegWrite : in std_logic;
            ImmSrc : in std_logic_vector(1 downto 0);
            ALUControl : in std_logic_vector(2 downto 0);
            Zero : out std_logic;
            PC : out std_logic_vector(31 downto 0);
            Instr : in std_logic_vector(31 downto 0);
            ALUResult, WriteData : out std_logic_vector(31 downto 0);
            ReadData : in std_logic_vector(31 downto 0)
        );
    end component;

    signal ALUSrc, RegWrite, Jump, Zero, PCSrc : std_logic;
    signal ResultSrc, ImmSrc : std_logic_vector(1 downto 0);
    signal ALUControl : std_logic_vector(2 downto 0);
begin
    c : controller
    port map (
        Instr(6 downto 0), Instr(14 downto 12),
        Instr(30), Zero, ResultSrc, MemWrite,
        PCSrc, ALUSrc, RegWrite, Jump,
        ImmSrc, ALUControl
    );
    dp : datapath 
    port map (
        clk, reset, ResultSrc, PCSrc, ALUSrc,
        RegWrite, ImmSrc, ALUControl, Zero,
        PC, Instr, ALUResult, WriteData,
        ReadData
    );
end;
