library IEEE;
use IEEE.std_logic_1164.all;

entity idex is 
port(
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

end idex;

architecture reg of idex is
    signal  input_concatenado : std_logic_vector (184 downto 0); --RegWriteD & ResultSrcD & MemWriteD & JumpD & BranchD & ALUControlD & ALUSrcD & RD1 & RD2 & PCD & Rs1D & Rs2D & RdD & ImmExtD & PCPlus4D; -- controle | dados
    signal  output_concatenado : std_logic_vector (184 downto 0); --RegWriteE & ResultSrcE & MemWriteE & JumpE & BranchE & ALUControlE & ALUSrcE & RD1E & RD2E & PCE & Rs1E & Rs2E & RdE & ImmExtE & PCPlus4E; -- controle | dados

    component registrador_d is
        generic(
            constant N : integer := 32
            );
        port(
            clock : in std_logic;
            reset : in std_logic;
            load : in std_logic;
            d : in std_logic_vector(N-1 downto 0);
            q : out std_logic_vector(N-1 downto 0)
            );
    end component;

begin
    input_concatenado <= RegWriteD & ResultSrcD & MemWriteD & JumpD & BranchD & ALUControlD & ALUSrcD &
    RD1 & RD2 & PCD & Rs1D & Rs2D & RdD & ImmExtD & PCPlus4D;

    reg1 : registrador_d
    generic map (
        N => 185
    )
    port map (
        clock => CLK,
        reset => CLR,
        load => EN,
        d => input_concatenado,
        q => output_concatenado
    );

    PCPlus4E <= output_concatenado(31 downto 0);
    ImmExtE <= output_concatenado(63 downto 32);
    RdE <= output_concatenado(68 downto 64);
    Rs2E <= output_concatenado(73 downto 69);
    Rs1E <= output_concatenado(78 downto 74);
    PCE <= output_concatenado(110 downto 79);
    RD2E <= output_concatenado(142 downto 111);
    RD1E <= output_concatenado(174 downto 143);
    ALUSrcE <= output_concatenado(175);
    ALUControlE <= output_concatenado(178 downto 176);
    BranchE <= output_concatenado(179);
    JumpE <= output_concatenado(180);
    MemWriteE <= output_concatenado(181);
    ResultSrcE <= output_concatenado(183 downto 182);
    RegWriteE <= output_concatenado(184);



end reg ;