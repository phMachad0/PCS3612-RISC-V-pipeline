library IEEE;
use ieee.std_logic_1164.all;

entity EXMEM is 
port(
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

end EXMEM;