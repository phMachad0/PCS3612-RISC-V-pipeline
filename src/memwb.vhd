library IEEE;
use ieee.std_logic_1164.all;

entity MEMWB is 
port(
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

end MEMWB;