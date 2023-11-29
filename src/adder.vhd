library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity adder is
    port (
        a, b : in std_logic_vector(31 downto 0);
        y : out std_logic_vector(31 downto 0));
end;
architecture behave of adder is
begin
    y <= std_logic_vector(signed(a) + signed(b)); -- TODO signed or unsigned?
end;