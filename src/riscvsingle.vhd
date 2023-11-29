library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity riscvsingle is
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        Instr     : in  std_logic_vector(31 downto 0);
        ReadData  : in  std_logic_vector(31 downto 0);
        PC        : out std_logic_vector(31 downto 0);
        ALUResult : out std_logic_vector(31 downto 0);
        WriteData : out std_logic_vector(31 downto 0);
        MemWrite  : out std_logic
    );
end;

architecture struct of riscvsingle is
    component controller
        port (
            op          : in  std_logic_vector(6 downto 0);
            funct3      : in  std_logic_vector(2 downto 0);
            funct7b5    : in  std_logic;
            ResultSrcD  : out std_logic_vector(1 downto 0);
            RegWriteD   : out std_logic; 
            MemWriteD   : out std_logic;
            JumpD       : buffer std_logic;
            BranchD     : out std_logic;
            ALUControlD : out std_logic_vector(2 downto 0);
            ALUSrcD     : out std_logic;
            ImmSrcD     : out std_logic_vector(1 downto 0)
        );
    end component;

    component datapath
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
            PCF         : out std_logic_vector(31 downto 0); -- IMem ADRR
            ALUResultM  : out std_logic_vector(31 downto 0); -- DMEM ADDR
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
    end component;

    component hazardunit
        port(
            Rs1D        : in std_logic_vector(4 downto 0);
            Rs2D        : in std_logic_vector(4 downto 0);
            Rs1E        : in std_logic_vector(4 downto 0);
            Rs2E        : in std_logic_vector(4 downto 0);
            RdE         : in std_logic_vector(4 downto 0);
            PCSrcE      : in std_logic;
            ResultSrcE0 : in std_logic;
            RdM         : in std_logic_vector(4 downto 0);
            RdW         : in std_logic_vector(4 downto 0);
            RegWriteM   : in std_logic;
            RegWriteW   : in std_logic;
            StallF      : out std_logic;
            StallD      : out std_logic;
            FlushD      : out std_logic;
            FlushE      : out std_logic;
            ForwardAE   : out std_logic_vector(1 downto 0);
            ForwardBE   : out std_logic_vector(1 downto 0)
        );
    end component;

    signal RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD, 
    StallF, StallD, FlushD, FlushE, PCSrcE, ResultSrcE0,
    RegWriteM, RegWriteW : std_logic;
    signal ResultSrcD, ImmSrcD, ForwardAE, ForwardBE : std_logic_vector(1 downto 0);
    signal ALUControlD : std_logic_vector(2 downto 0);
    signal Rs1D, Rs2D, Rs1E, Rs2E, RdM, RdW, RdE : std_logic_vector(4 downto 0);
    signal InstrD : std_logic_vector(31 downto 0);

begin
    co : controller
    port map (
        op => InstrD(6 downto 0),
        funct3 => InstrD(14 downto 12),
        funct7b5 => InstrD(30),
        ResultSrcD => ResultSrcD,
        RegWriteD => RegWriteD,
        MemWriteD => MemWriteD,
        JumpD => JumpD,
        BranchD => BranchD,
        ALUControlD => ALUControlD,
        ALUSrcD => ALUSrcD,
        ImmSrcD => ImmSrcD
    );

    dp : datapath 
    port map (
        clk => clk,
        reset => reset,
        ResultSrcD => ResultSrcD,
        RegWriteD => RegWriteD,
        MemWriteD => MemWriteD,
        JumpD => JumpD,
        BranchD => BranchD,
        ALUControlD => ALUControlD,
        ALUSrcD => ALUSrcD,
        ImmSrcD => ImmSrcD,
        StallF => StallF,
        StallD => StallD,
        FlushD => FlushD,
        FlushE => FlushE,
        ForwardAE => ForwardAE,
        ForwardBE => ForwardBE,
        Instr => Instr,
        ReadData => ReadData,
        InstrD => InstrD,
        PCF => PC,
        ALUResultM => ALUResult,
        WriteDataM => WriteData,
        MemWriteM => MemWrite,
        Rs1D => Rs1D,
        Rs2D => Rs2D,
        Rs1E => Rs1E,
        Rs2E => Rs2E,
        RdE => RdE,
        PCSrcE => PCSrcE,
        ResultSrcE0 => ResultSrcE0,
        RdM => RdM,
        RegWriteM => RegWriteM,
        RdW => RdW,
        RegWriteW => RegWriteW
    );

    hu : hazardunit
    port map (
        Rs1D => Rs1D,
        Rs2D => Rs2D,
        Rs1E => Rs1E,
        Rs2E => Rs2E,
        RdE => RdE,
        PCSrcE => PCSrcE,
        ResultSrcE0 => ResultSrcE0,
        RdM => RdM,
        RdW => RdW,
        RegWriteM => RegWriteM,
        RegWriteW => RegWriteW,
        StallF => StallF,
        StallD => StallD,
        FlushD => FlushD,
        FlushE => FlushE,
        ForwardAE => ForwardAE,
        ForwardBE => ForwardBE
    );
end;
