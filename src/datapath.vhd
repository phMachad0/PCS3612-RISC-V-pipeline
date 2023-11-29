library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
entity datapath is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        ResultSrcD  : in std_logic_vector(1 downto 0);
        RegWriteD   : in std_logic; 
        MemWriteD   : in std_logic;
        JumpD       : in std_logic;
        BranchD     : in std_logic;
        ALUControlD : in std_logic_vector(2 downto 0);
        ALUSrcD     : in std_logic;
        ImmSrcD     : in std_logic_vector(1 downto 0);
        StallF      : in std_logic;
        StallD      : in std_logic;
        FlushD      : in std_logic;
        FlushE      : in std_logic;
        ForwardAE   : in std_logic_vector(1 downto 0);
        ForwardBE   : in std_logic_vector(1 downto 0);
        Instr       : in std_logic_vector(31 downto 0); -- IMem RD
        ReadData    : in std_logic_vector(31 downto 0); -- DMEM RD
        InstrD      : buffer std_logic_vector(31 downto 0);
        PCF         : buffer std_logic_vector(31 downto 0); -- IMem ADRR
        ALUResultM  : buffer std_logic_vector(31 downto 0); -- DMEM ADDR
        WriteDataM  : out std_logic_vector(31 downto 0); -- DMEM WD
        MemWriteM   : out std_logic; -- DMEM WE
        Rs1D        : buffer std_logic_vector(4 downto 0);
        Rs2D        : buffer std_logic_vector(4 downto 0);
        Rs1E        : out std_logic_vector(4 downto 0);
        Rs2E        : out std_logic_vector(4 downto 0);
        RdE         : buffer std_logic_vector(4 downto 0);
        PCSrcE      : buffer std_logic;
        ResultSrcE0 : out std_logic;
        RdM         : buffer std_logic_vector(4 downto 0);
        RegWriteM   : buffer std_logic;
        RdW         : buffer std_logic_vector(4 downto 0);
        RegWriteW   : buffer std_logic
    );
end;
architecture struct of datapath is
    component flopenr is
        generic (
            width : integer
        );
        port (
            clk   : in  std_logic;
            reset : in  std_logic; 
            en    : in  std_logic;
            d     : in  std_logic_vector(width - 1 downto 0);
            q     : out std_logic_vector(width - 1 downto 0)
        );
    end component;

    component adder
        port (
            a : in  std_logic_vector(31 downto 0);
            b : in  std_logic_vector(31 downto 0);
            y : out std_logic_vector(31 downto 0)
        );
    end component;

    component mux2x1
    generic (
        width : integer
    );
    port (
        d0 : in  std_logic_vector(width-1 downto 0); 
        d1 : in  std_logic_vector(width-1 downto 0);
        s  : in  std_logic;
        y  : out std_logic_vector(width-1 downto 0)
    );
    end component;
    component mux3x1
    generic (
        width : integer
    );
    port (
        d0 : in  std_logic_vector(width-1 downto 0);
        d1 : in  std_logic_vector(width-1 downto 0);
        d2 : in  std_logic_vector(width-1 downto 0);
        s  : in  std_logic_vector(1 downto 0);
        y  : out std_logic_vector(width-1 downto 0)
    );
    end component;

    component regfile
        port (
            clk : in  std_logic;
            we3 : in  std_logic;
            a1  : in  std_logic_vector(4 downto 0); 
            a2  : in  std_logic_vector(4 downto 0); 
            a3  : in  std_logic_vector(4 downto 0);
            wd3 : in  std_logic_vector(31 downto 0);
            rd1 : out std_logic_vector(31 downto 0);
            rd2 : out std_logic_vector(31 downto 0)
        );
    end component;

    component extend
        port (
            instr  : in  std_logic_vector(31 downto 7);
            immsrc : in  std_logic_vector(1 downto 0);
            immext : out std_logic_vector(31 downto 0));
    end component;

    component alu
        port (
            a          : in     std_logic_vector(31 downto 0);
            b          : in     std_logic_vector(31 downto 0);
            ALUControl : in     std_logic_vector(2 downto 0);
            ALUResult  : buffer std_logic_vector(31 downto 0);
            Zero       : out    std_logic
        );
    end component;

    component ifid is 
        port(
            CLK : in std_logic;
            EN  : in std_logic; -- not(StallD)
            CLR : in std_logic; -- FlushD

            RDF : in std_logic_vector(31 downto 0);
            PCF : in std_logic_vector(31 downto 0);
            PCPlus4F : in  std_logic_vector(31 downto 0);

            InstrD : out std_logic_vector(31 downto 0);
            PCD    : out std_logic_vector(31 downto 0);
            PCPlus4D : out std_logic_vector(31 downto 0)
        );
    end component;

    component idex is 
        port (
            CLK : in std_logic;
            EN  : in std_logic; -- aqui sempre em 1
            CLR : in std_logic; --FlushE

            --entradas de dados
            RD1     : in std_logic_vector(31 downto 0);
            RD2     : in std_logic_vector(31 downto 0);
            PCD     : in std_logic_vector(31 downto 0);
            Rs1D    : in std_logic_vector(4 downto 0);
            Rs2D    : in  std_logic_vector(4 downto 0);
            RdD     : in  std_logic_vector(4 downto 0);
            ImmExtD : in  std_logic_vector(31 downto 0); 
            PCPlus4D : in std_logic_vector(31 downto 0);

            --entradas de controle
            RegWriteD   : in std_logic;
            ResultSrcD  : in std_logic_vector(1 downto 0);
            MemWriteD   : in std_logic;
            JumpD       : in std_logic;   
            BranchD     : in std_logic;
            ALUControlD : in std_logic_vector(2 downto 0); 
            ALUSrcD     : in std_logic;

            --saidas de dados
            RD1E    : out std_logic_vector(31 downto 0);
            RD2E    : out std_logic_vector(31 downto 0);
            PCE     : out std_logic_vector(31 downto 0);
            Rs1E    : out std_logic_vector(4 downto 0);
            Rs2E    : out  std_logic_vector(4 downto 0);
            RdE     : out  std_logic_vector(4 downto 0);
            ImmExtE : out  std_logic_vector(31 downto 0); 
            PCPlus4E: out std_logic_vector(31 downto 0);

            --saidas de controle
            RegWriteE   : out std_logic;
            ResultSrcE  : out std_logic_vector(1 downto 0);
            MemWriteE   : out std_logic;
            JumpE       : out std_logic;   
            BranchE     : out std_logic;
            ALUControlE : out std_logic_vector(2 downto 0); 
            ALUSrcE     : out std_logic
        );
    end component;

    component exmem is 
        port (
            CLK : in std_logic;
            EN  : in std_logic; -- aqui sempre em 1
            CLR : in std_logic; -- aqui sempre em 0

            --entradas de dados
            ALUResultE : in std_logic_vector (31 downto 0);
            WriteDataE : in std_logic_vector (31 downto 0);
            RdE        : in std_logic_vector(4 downto 0);
            PCPlus4E   : in std_logic_vector (31 downto 0);

            --entradas de controle
            RegWriteE   : in std_logic;
            ResultSrcE  : in std_logic_vector(1 downto 0);
            MemWriteE   : in std_logic;
        
            --saidas de dados
            ALUResultM : out std_logic_vector (31 downto 0);
            WriteDataM : out std_logic_vector (31 downto 0);
            RdM        : out std_logic_vector(4 downto 0);
            PCPlus4M   : out std_logic_vector (31 downto 0);
            
            --saidas de controle
            RegWriteM   : out std_logic;
            ResultSrcM  : out std_logic_vector(1 downto 0);
            MemWriteM   : out std_logic
        );
        end component;

        component memwb is 
            port (
                CLK : in std_logic;
                EN  : in std_logic; -- aqui sempre em 1
                CLR : in std_logic; -- aqui sempre em 0

                --entradas de dados
                ALUResultM  : in std_logic_vector (31 downto 0);
                ReadDataM   : in std_logic_vector (31 downto 0);
                RdM         : in std_logic_vector(4 downto 0);
                PCPlus4M    : in std_logic_vector (31 downto 0);

                --entradas de controle
                RegWriteM   : in std_logic;
                ResultSrcM  : in std_logic_vector(1 downto 0);
            
                --saidas de dados
                ALUResultW  : out std_logic_vector (31 downto 0);
                ReadDataW   : out std_logic_vector (31 downto 0);
                RdW         : out std_logic_vector(4 downto 0);
                PCPlus4W    : out std_logic_vector (31 downto 0);

                --saidas de controle
                RegWriteW   : out std_logic;
                ResultSrcW  : out std_logic_vector(1 downto 0)
            );
            end component;

    signal PCPlus4F, PCPlus4D, PCTargetE, PCFTemp, PCPlus4W, PCPlus4M, PCPlus4E, PCE, PCD : std_logic_vector(31 downto 0);
    signal RD1, RD1E, RD2, RD2E, ResultW : std_logic_vector(31 downto 0);
    signal ImmExtD, ImmExtE : std_logic_vector(31 downto 0);
    signal RdD : std_logic_vector(4 downto 0); 
    signal RegWriteE, MemWriteE : std_logic;
    signal JumpE, BranchE, ZeroE : std_logic; 
    signal ALUControlE : std_logic_vector(2 downto 0);
    signal ALUSrcE : std_logic; 
    signal SrcAE, SrcBE : std_logic_vector(31 downto 0);
    signal ALUResultE, ALUResultW, WriteDataE, ReadDataW : std_logic_vector(31 downto 0);
    signal ResultSrcE, ResultSrcM, ResultSrcW : std_logic_vector(1 downto 0); 
    signal not_StallF, not_StallD : std_logic;

begin
    not_StallF <= not StallF;
    not_StallD <= not StallD;

    PCSrcE <= JumpE or (BranchE and ZeroE);

    ResultSrcE0 <= ResultSrcE(0);

    Rs1D <= InstrD(19 downto 15); 
    Rs2D <= InstrD(24 downto 20);
    RdD <= InstrD(11 downto 7);

    -- Mux for PCF'
    pcmux : mux2x1 
    generic map (
        width => 32
    ) 
    port map (
        d0 => PCPlus4F, 
        d1 => PCTargetE, 
        s => PCSrcE,
        y => PCFTemp
    );

    pcreg : flopenr 
    generic map (
        width => 32
    ) 
    port map (
        clk => clk, 
        reset => reset, 
        en => not_StallF,
        d => PCFTemp, 
        q => PCF
    );

    pcadd4 : adder 
    port map (
        a => PCF, 
        b => X"00000004", 
        y => PCPlus4F
    );

    regifid : ifid
    port map (
        CLK => clk,
        EN => not_StallD,
        CLR => FlushD,
        RDF => Instr,
        PCF => PCF,
        PCPlus4F => PCPlus4F,
        InstrD => InstrD,
        PCD => PCD,
        PCPlus4D => PCPlus4D
    );

    rf : regfile 
    port map (
        clk => clk,
        we3 => RegWriteW,
        a1 => InstrD(19 downto 15),
        a2 => InstrD(24 downto 20),
        a3 => RdW,
        wd3 => ResultW,
        rd1 => RD1,
        rd2 => RD2
    );

    ext : extend 
    port map (
        instr => InstrD(31 downto 7), 
        immsrc => ImmSrcD, 
        immext => ImmExtD
    );

    regidex : idex
    port map (
        CLK => clk,
        EN => '1',
        CLR => FlushE,

        --entradas de dados
        RD1 => RD1,
        RD2 => RD2,
        PCD => PCD,
        Rs1D => Rs1D,
        Rs2D => Rs2D,
        RdD => RdD,
        ImmExtD => ImmExtD,
        PCPlus4D => PCPlus4D,

        --entradas de controle
        RegWriteD => RegWriteD,
        ResultSrcD => ResultSrcD,
        MemWriteD => MemWriteD,
        JumpD => JumpD,
        BranchD => BranchD,
        ALUControlD => ALUControlD,
        ALUSrcD => ALUSrcD,

        --saidas de dados
        RD1E => RD1E,
        RD2E => RD2E,
        PCE => PCE,
        Rs1E => Rs1E,
        Rs2E => Rs2E,
        RdE => RdE,
        ImmExtE => ImmExtE,
        PCPlus4E => PCPlus4E,

        --saidas de controle
        RegWriteE => RegWriteE,
        ResultSrcE => ResultSrcE,
        MemWriteE => MemWriteE,
        JumpE => JumpE,
        BranchE => BranchE,
        ALUControlE => ALUControlE,
        ALUSrcE => ALUSrcE
    );

    AluASelect : mux3x1 
    generic map (
        width => 32
    ) 
    port map (
        d0 => RD1E, 
        d1 => ResultW,
        d2 => AluResultM, 
        s => ForwardAE,
        y => SrcAE
    );

    AluBSelect : mux2x1 
    generic map (
        width => 32
    ) 
    port map (
        d0 => WriteDataE, 
        d1 => ImmExtE,
        s => AluSrcE,
        y => SrcBE
    );

    WDESelect : mux3x1 
    generic map (
        width => 32
    ) 
    port map (
        d0 => RD2E, 
        d1 => ResultW,
        d2 => ALUResultM,
        s => ForwardBE,
        y => WriteDataE
    );

    mainalu : alu 
    port map (
        a => SrcAE, 
        b => SrcBE, 
        ALUControl => ALUControlE, 
        ALUResult => ALUResultE, 
        Zero => ZeroE
    );

    regexmem : exmem
    port map (
        CLK => clk,
        EN => '1', 
        CLR => '0',

        --entradas de dados
        ALUResultE => ALUResultE,
        WriteDataE => WriteDataE,
        RdE => RdE,
        PCPlus4E => PCPlus4E,

        --entradas de controle
        RegWriteE => RegWriteE,
        ResultSrcE => ResultSrcE,
        MemWriteE => MemWriteE,
    
        --saidas de dados
        ALUResultM => ALUResultM,
        WriteDataM => WriteDataM,
        RdM => RdM,
        PCPlus4M => PCPlus4M,
        
        --saidas de controle
        RegWriteM => RegWriteM,
        ResultSrcM => ResultSrcM,
        MemWriteM => MemWriteM
    );

    pcaddbranch : adder 
    port map (
        a => PCE, 
        b => ImmExtE, 
        y => PCTargetE
    );

    regmemwb : memwb
    port map (
        CLK => clk,
        EN => '1',
        CLR => '0',

        --entradas de dados
        ALUResultM => ALUResultM,
        ReadDataM => ReadData,
        RdM => RdM,
        PCPlus4M => PCPlus4M,
        --entradas de controle
        RegWriteM => RegWriteM,
        ResultSrcM => ResultSrcM,
        --saidas de dados
        ALUResultW => ALUResultW,
        ReadDataW => ReadDataW,
        RdW => RdW,
        PCPlus4W => PCPlus4W,
        --saidas de controle
        RegWriteW => RegWriteW,
        ResultSrcW => ResultSrcW
    );

    ResultWSelect : mux3x1
    generic map (
        width => 32
    ) 
    port map (
        d0 => ALUResultW, 
        d1 => ReadDataW,
        d2 => PCPlus4W, 
        s => ResultSrcW,
        y => ResultW
    );

end;