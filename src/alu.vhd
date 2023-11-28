library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity alu is
    port (
        a, b : in std_logic_vector(31 downto 0);
        ALUControl : in std_logic_vector(2 downto 0);
        ALUResult : buffer std_logic_vector(31 downto 0);
        Zero : out std_logic
        );
end;
architecture behave of alu is
begin
    with ALUControl select
    ALUResult <= std_logic_vector(signed(a) + signed(b)) when "000",
                  std_logic_vector(signed(a) - signed(b)) when "001",
                  a and b when "010",
                  a or b when "011",
                  a xor b when "100",
                  std_logic_vector(signed(a) sll to_integer(unsigned(b))) when "101",
                  "--------------------------------" when others;
    Zero <= '1' when ALUResult = "00000000000000000000000000000000";
end;