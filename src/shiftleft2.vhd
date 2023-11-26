library ieee;
use ieee.std_logic_1164.all;

entity shiftleft2 is
    generic(
        word_s : natural := 64
    ); 
    port (
        i : in  std_logic_vector(word_s-1 downto 0);
        o : out std_logic_vector(word_s-1 downto 0)
    );
end shiftleft2;
architecture behave of shiftleft2 is
    begin
        o <= i(word_s-3 downto 0) & "00"; --SLL
end behave;
