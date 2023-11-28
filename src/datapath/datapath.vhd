LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
ENTITY datapath IS
    PORT (
        clk, reset : IN STD_LOGIC;
        ResultSrc : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        PCSrc, ALUSrc : IN STD_LOGIC;
        RegWrite : IN STD_LOGIC;
        ImmSrc : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        ALUControl : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Zero : OUT STD_LOGIC;
        PC : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0);
        Instr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALUResult, WriteData : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0);
        ReadData : IN STD_LOGIC_VECTOR(31 DOWNTO 0));
END;
ARCHITECTURE struct OF datapath IS
    COMPONENT flopr GENERIC (width : INTEGER);
        PORT (
            clk, reset : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0));
    END COMPONENT;
    COMPONENT adder
        PORT (
            a, b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            y : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    COMPONENT mux2 GENERIC (width : INTEGER);
        PORT (
            d0, d1 : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
            s : IN STD_LOGIC;
            y : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0));
    END COMPONENT;
    COMPONENT mux3 GENERIC (width : INTEGER);
        PORT (
            d0, d1, d2 : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
            s : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            y : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0));
    END COMPONENT;
    COMPONENT regfile
        PORT (
            clk : IN STD_LOGIC;
            we3 : IN STD_LOGIC;
            a1, a2, a3 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            wd3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            rd1, rd2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    COMPONENT extend
        PORT (
            instr : IN STD_LOGIC_VECTOR(31 DOWNTO 7);
            immsrc : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            immext : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    COMPONENT alu
        PORT (
            a, b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ALUControl : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            ALUResult : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0);
            Zero : OUT STD_LOGIC);
    END COMPONENT;
    COMPONENT dataregister
        GENERIC (
            word_s : NATURAL := 64;
            reset_value : NATURAL := 0
        );
        PORT (
            clock, reset, load : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(word_s - 1 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(word_s - 1 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL PCNext, PCPlus4F, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W, PCTarget : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ImmExtD, ImmExtE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SrcA, SrcAE, SrcBE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL WriteDataE, WriteDataM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ReadDataW : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ALUResultM, ALUResultW : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ResultW : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    -- NEXT PC logic
    pcreg : flopr GENERIC MAP(32) PORT MAP(clk, reset, PCNext, PC);
    pcadd4 : adder PORT MAP(PC, X"00000004", PCPlus4F);
    pcaddbranch : adder PORT MAP(PCE, ImmExtE, PCTargetE);
    pcmux : mux2 GENERIC MAP(
        32) PORT MAP(PCPlus4F, PCTargetE, PCSrc,
        PCNext);
    -- REGISTER FILE logic
    rf : regfile PORT MAP(
        clk, RegWrite, InstrD(19 DOWNTO 15),
        InstrD(24 DOWNTO 20), RdW,
        ResultW, SrcA, WriteData);
    ext : extend PORT MAP(InstrD(31 DOWNTO 7), ImmSrc, ImmExtD);
    -- ALU logic
    srcbmux : mux2 GENERIC MAP(
        32) PORT MAP(WriteDataE, ImmExtE,
        ALUSrc, SrcBE);
    mainalu : alu PORT MAP(SrcAE, SrcBE, ALUControl, ALUResult, Zero);
    resultmux : mux3 GENERIC MAP(
        32) PORT MAP(ALUResultM, ReadDataW,
        PCPlus4W, ResultSrc,
        ResultW);
    -- PIPELINE REGISTERS
    fetchreg1: dataregister PORT MAP(clk, '1', Instr, InstrD);
    fetchreg2: dataregister PORT MAP(clk, '1', PC, PCD);
    fetchreg3: dataregister PORT MAP(clk, '1', PCPlus4F, PCPlus4D);
    decodereg1: dataregister PORT MAP(clk, '1', SrcA, SrcAE);
    decodereg2: dataregister PORT MAP(clk, '1', WriteData, WriteDataE);
    decodereg3: dataregister PORT MAP(clk, '1', PCD, PCDE);
    decodereg4: dataregister PORT MAP(clk, '1', RdD, RdE);
    decodereg5: dataregister PORT MAP(clk, '1', ImmExtD, ImmExtE);
    decodereg6: dataregister PORT MAP(clk, '1', PCPlus4D, PCPlus4E);
    executereg1: dataregister PORT MAP(clk, '1', ALUResult, ALUResultM);
    executereg2: dataregister PORT MAP(clk, '1', WriteDataE, WriteDataM);
    executereg3: dataregister PORT MAP(clk, '1', RdE, RdM);
    executereg4: dataregister PORT MAP(clk, '1', PCPlus4E, PCPlus4M);
    memoryreg1: dataregister PORT MAP(clk, '1', ALUResultM, ALUResultW);
    memoryreg2: dataregister PORT MAP(clk, '1', ReadData, ReadDataW);
    memoryreg3: dataregister PORT MAP(clk, '1', RdM, RdW);
    memoryreg4: dataregister PORT MAP(clk, '1', PCPlus4M, PCPlus4W);

    RdD <= InstrD(11 DOWNTO 7);
    ALUResult <= ALUResultM;
    WriteData <= WriteDataM;
END;