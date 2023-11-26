-- O extensor de sinal é sensível à
-- instrução. Sua entrada é sempre de 32b (uma instrução) e a saída
-- 64b, que corresponde ao imediato contido na instrução já com sinal estendido.
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity signextend is
    port (
        i : in  std_logic_vector(31 downto 0);
        o : out std_logic_vector(63 downto 0)
    );
end signextend;
architecture behave of signextend is
    signal D_sig, R_sig, B_sig, CB_sig : std_logic_vector(63 downto 0);
    signal signed_sig : signed(31 downto 0);
    begin
        signed_sig <= signed(i);
        --Handle D type -> 11 Opcode, 9 Address, 2 Op2, 5 Rn, 5 Rt -> Extend Address -> Extend 20 downto 12
        D_sig <= std_logic_vector(resize(signed(i(20 downto 12)), o'length));
        --Handle R type -> 11 Opcode, 5 Rm, 6 Shamt, 5 Rn, 5 Rd -> Extend.. ? -> Currently extending SHAMT
        R_sig <= std_logic_vector(resize(signed(i(15 downto 10)), o'length));
        --Handle B type -> 6 Opcode, 26 BR_Address -> Extend BR_Address -> Extend 25 downto 0
        B_sig <= std_logic_vector(resize(signed(i(25 downto 0)), o'length));
        --Handle CB type -> 8 Opcode, 19 Cond_BR_Address, 5 Rt -> Extend Cond_BR_Address -> Extend 23 downto 5
        CB_sig <= std_logic_vector(resize(signed(i(23 downto 5)), o'length));

        o <= D_sig when i(31 downto 27) = "11111" else
             CB_sig when i(31 downto 24) = "10110100" else
             B_sig when i(31 downto 26) = "000101" else
             R_sig;
end behave;