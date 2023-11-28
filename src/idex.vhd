library IEEE;
use ieee.std_logic_1164.all;

entity IDEX is 
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
    ImmSrcD     : in std_logic_vector(1 downto 0);

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

end IDEX;