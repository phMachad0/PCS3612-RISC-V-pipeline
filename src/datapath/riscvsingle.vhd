LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY riscvsingle IS
    PORT (
        clk, reset : IN STD_LOGIC;
        PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Instr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MemWrite : OUT STD_LOGIC;
        ALUResult, WriteData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        ReadData : IN STD_LOGIC_VECTOR(31 DOWNTO 0));
END;
ARCHITECTURE struct OF riscvsingle IS
    COMPONENT controller
        PORT (
            op : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            funct3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            funct7b5, Zero : IN STD_LOGIC;
            ResultSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            MemWrite : OUT STD_LOGIC;
            PCSrc, ALUSrc : OUT STD_LOGIC;
            RegWrite, Jump : OUT STD_LOGIC;
            ImmSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            ALUControl : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
    END COMPONENT;
    COMPONENT datapath
        PORT (
            clk, reset : IN STD_LOGIC;
            ResultSrc : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            PCSrc, ALUSrc : IN STD_LOGIC;
            RegWrite : IN STD_LOGIC;
            ImmSrc : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            ALUControl : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Zero : OUT STD_LOGIC;
            PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ALUResult, WriteData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            ReadData : IN STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    SIGNAL ALUSrc, RegWrite, Jump, Zero, PCSrc : STD_LOGIC;
    SIGNAL ResultSrc, ImmSrc : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL ALUControl : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
    c : controller PORT MAP(
        Instr(6 DOWNTO 0), Instr(14 DOWNTO 12),
        Instr(30), Zero, ResultSrc, MemWrite,
        PCSrc, ALUSrc, RegWrite, Jump,
        ImmSrc, ALUControl);
    dp : datapath PORT MAP(
        clk, reset, ResultSrc, PCSrc, ALUSrc,
        RegWrite, ImmSrc, ALUControl, Zero,
        PC, Instr, ALUResult, WriteData,
        ReadData);
END;