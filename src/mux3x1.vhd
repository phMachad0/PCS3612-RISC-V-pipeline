library IEEE;
use IEEE.std_logic_1164.all;

entity mux3x1 is
port(
  RD         : in  bit_vector(31 downto 0);
  ALUResultM : in  bit_vector(31 downto 0);
  ResultW    : in  bit_vector(31 downto 0);
  Forward    : in  bit_vector(1 downto 0);
  Src        : out bit_vector(31 downto 0));
end mux3x1;

architecture comb of mux3x1 is
begin
 Src <= RD when Forward = "00" else
        ALUResultM when Forward = "01" else
        ResultW else
        (others => '0');
end comb;