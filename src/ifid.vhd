library IEEE;
use ieee.std_logic_1164.all;

entity IFID is 
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
end IFID;