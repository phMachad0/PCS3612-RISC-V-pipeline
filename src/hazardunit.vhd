library IEEE;
use IEEE.std_logic_1164.all;

entity hazardunit is
port(
        Rs1D        : in bit_vector(4 downto 0);
        Rs2D        : in bit_vector(4 downto 0);
        Rs1E        : in bit_vector(4 downto 0);
        Rs2E        : in bit_vector(4 downto 0);
        RdE         : in bit_vector(4 downto 0);
        PCSrcE      : in bit;
        ResultSrcE0 : in bit;
        RdM         : in bit_vector(4 downto 0);
        RdW         : in bit_vector(4 downto 0);
        RegWriteM   : in bit;
        RegWriteW   : in bit;

        StallF      : out bit;
        StallD      : out bit;
        FlushD      : out bit;
        FlushE      : out bit;
        ForwardAE   : out bit_vector(1 downto 0);
        ForwardBE   : out bit_vector(1 downto 0)
);
end hazardunit;

architecture arch of hazardunit is

    signal lwStall : bit;
begin
    ForwardAE <= "10" when ((Rs1E = RdM) and RegWriteM = '1' and Rs1E /= "00000") else -- Forward from MEM
                 "01" when ((Rs1E = RdW) and RegWriteW = '1' and Rs1E /= "00000") else -- Forward from WB
                 "00" ; -- No forwarding, uses RD1E

    ForwardBE <= "10" when ((Rs2E = RdM) and RegWriteM = '1' and Rs2E /= "00000") else -- Forward from MEM
                 "01" when ((Rs2E = RdW) and RegWriteW = '1' and Rs2E /= "00000") else -- Forward from WB
                 "00" ; -- No forwarding, uses RD2E
    
    lwStall <= ResultSrcE0 and ((Rs1D = RdE) or (Rs2D = RdE));
    StallF  <= lwStall;
    StallD  <= lwStall;
    FlushD <= PCSrcE;
    FlushE  <= lwStall or PCSrcE;

end arch ; 