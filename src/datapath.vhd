library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
entity datapath is
    port (
        clk, reset : in std_logic;
        ResultSrc : in std_logic_vector(1 downto 0);
        PCSrc, ALUSrc : in std_logic;
        RegWrite : in std_logic;
        ImmSrc : in std_logic_vector(1 downto 0);
        ALUControl : in std_logic_vector(2 downto 0);
        Zero : out std_logic;
        PC : buffer std_logic_vector(31 downto 0);
        Instr : in std_logic_vector(31 downto 0);
        ALUResult, WriteData : buffer std_logic_vector(31 downto 0);
        ReadData : in std_logic_vector(31 downto 0));
end;
architecture struct of datapath is
    component flopr
        generic (
            width : integer
        );
        port (
            clk, reset : in std_logic;
            d : in std_logic_vector(width-1 downto 0);
            q : out std_logic_vector(width-1 downto 0));
    end component;
    component adder
        port (
            a, b : in std_logic_vector(31 downto 0);
            y : out std_logic_vector(31 downto 0));
    end component;
    component mux2x1
    generic (
        width : integer
        );
        port (
            d0, d1 : in std_logic_vector(width-1 downto 0);
            s : in std_logic;
            y : out std_logic_vector(width-1 downto 0)
        );
    end component;
    component mux3x1
    generic (
        width : integer
        );
        port (
            d0, d1, d2 : in std_logic_vector(width-1 downto 0);
            s : in std_logic_vector(1 downto 0);
            y : out std_logic_vector(width-1 downto 0)
        );
    end component;
    component regfile
        port (
            clk : in std_logic;
            we3 : in std_logic;
            a1, a2, a3 : in std_logic_vector(4 downto 0);
            wd3 : in std_logic_vector(31 downto 0);
            rd1, rd2 : out std_logic_vector(31 downto 0));
    end component;
    component extend
        port (
            instr : in std_logic_vector(31 downto 7);
            immsrc : in std_logic_vector(1 downto 0);
            immext : out std_logic_vector(31 downto 0));
    end component;
    component alu
        port (
            a, b : in std_logic_vector(31 downto 0);
            ALUControl : in std_logic_vector(2 downto 0);
            ALUResult : buffer std_logic_vector(31 downto 0);
            Zero : out std_logic);
    end component;
    signal PCNext, PCPlus4, PCTarget : std_logic_vector(31 downto 0);
    signal ImmExt : std_logic_vector(31 downto 0);
    signal SrcA, SrcB : std_logic_vector(31 downto 0);
    signal Result : std_logic_vector(31 downto 0);
begin
    -- next PC logic
    pcreg : flopr 
    generic map (
        width => 32
    ) 
    port map (
        clk => clk, 
        reset => reset, 
        d => PCNext, 
        q => PC
    );
    pcadd4 : adder 
    port map (
        a => PC, 
        b => X"00000004", 
        y => PCPlus4
    );
    
    pcaddbranch : adder 
    port map (
        a => PC, 
        b => ImmExt, 
        y => PCTarget
    );
    
    pcmux : mux2x1 
    generic map (
        width => 32
    ) 
    port map (
        d0 => PCPlus4, 
        d1 => PCTarget, 
        s => PCSrc,
        y => PCNext
    );

    -- register file logic
    rf : regfile 
    port map (
        clk => clk, 
        we3 => RegWrite, 
        a1 => Instr(19 downto 15),
        a2 => Instr(24 downto 20), 
        a3 => Instr(11 downto 7),
        wd3 => Result, 
        rd1 => SrcA, 
        rd2 => WriteData
    );
    
    ext : extend 
    port map (
        instr => Instr(31 downto 7), 
        immsrc => ImmSrc, 
        immext => ImmExt
    );
    
    -- ALU logic
    srcbmux : mux2x1 
    generic map (
        width => 32
    ) 
    port map (
        d0 => WriteData, 
        d1 => ImmExt,
        s => ALUSrc, 
        y => SrcB
    );
    
    mainalu : alu 
    port map (
        a => SrcA, 
        b => SrcB, 
        ALUControl => ALUControl, 
        ALUResult => ALUResult, 
        Zero => Zero
    );

    resultmux : mux3x1 
    generic map (
        width => 32
    ) 
    port map (
        d0 => ALUResult, 
        d1 => ReadData,
        d2 => PCPlus4, 
        s => ResultSrc,
        y => Result
    );
end;