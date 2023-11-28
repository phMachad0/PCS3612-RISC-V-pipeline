LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY controller IS
    PORT (
        op : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        funct3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        funct7b5, Zero : IN STD_LOGIC;
        ResultSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        MemWrite : OUT STD_LOGIC;
        PCSrc, ALUSrc : OUT STD_LOGIC;
        RegWrite : OUT STD_LOGIC;
        Jump : BUFFER STD_LOGIC;
        ImmSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        ALUControl : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END;
ARCHITECTURE struct OF controller IS
    COMPONENT maindec
        PORT (
            op : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            ResultSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            MemWrite : OUT STD_LOGIC;
            Branch, ALUSrc : OUT STD_LOGIC;
            RegWrite, Jump : OUT STD_LOGIC;
            ImmSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            ALUOp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
    END COMPONENT;
    COMPONENT aludec
        PORT (
            opb5 : IN STD_LOGIC;
            funct3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            funct7b5 : IN STD_LOGIC;
            ALUOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            ALUControl : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
    END COMPONENT;
    SIGNAL ALUOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Branch : STD_LOGIC;
BEGIN
    md : maindec PORT MAP(
        op, ResultSrc, MemWrite, Branch,
        ALUSrc, RegWrite, Jump, ImmSrc, ALUOp);
    ad : aludec PORT MAP(op(5), funct3, funct7b5, ALUOp, ALUControl);
    PCSrc <= (Branch AND Zero) OR Jump;
END;