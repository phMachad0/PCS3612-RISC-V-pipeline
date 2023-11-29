library IEEE;
use IEEE.std_logic_1164.all;

entity hazardunit is
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
end hazardunit;

architecture arch of hazardunit is

    signal lwStall : std_logic;
begin
    ForwardAE <= "10" when ((Rs1E = RdM) and RegWriteM = '1' and Rs1E /= "00000") else -- Forward from MEM
                 "01" when ((Rs1E = RdW) and RegWriteW = '1' and Rs1E /= "00000") else -- Forward from WB
                 "00" ; -- No forwarding, uses RD1E

    ForwardBE <= "10" when ((Rs2E = RdM) and RegWriteM = '1' and Rs2E /= "00000") else -- Forward from MEM
                 "01" when ((Rs2E = RdW) and RegWriteW = '1' and Rs2E /= "00000") else -- Forward from WB
                 "00" ; -- No forwarding, uses RD2E
    
    lwStall <= '1' when (ResultSrcE0='1') and ((Rs1D = RdE) or (Rs2D = RdE)) else '0';
    StallF  <= lwStall;
    StallD  <= lwStall;
    FlushD <= PCSrcE;
    FlushE  <= lwStall or PCSrcE;

end arch ; 