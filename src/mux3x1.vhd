library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity mux3x1 is
    generic (width : integer := 8);
    port (
        d0, d1, d2 : in std_logic_vector(width-1 downto 0);
        s : in std_logic_vector(1 downto 0);
        y : out std_logic_vector(width-1 downto 0));
end;
architecture behave of mux3x1 is
begin
    with s select 
        y <= d0 when "00",
             d1 when "01",
             d2 when "10",
             (others => '-') when others;
end;