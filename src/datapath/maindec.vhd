LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY maindec IS
    PORT (
        op : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        ResultSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        MemWrite : OUT STD_LOGIC;
        Branch, ALUSrc : OUT STD_LOGIC;
        RegWrite, Jump : OUT STD_LOGIC;
        ImmSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        ALUOp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END;
ARCHITECTURE behave OF maindec IS
    SIGNAL controls : STD_LOGIC_VECTOR(10 DOWNTO 0);
BEGIN
    PROCESS (op) BEGIN
        CASE op IS
            WHEN "0000011" => controls <= "10010010000"; -- lw
            WHEN "0100011" => controls <= "00111000000"; -- sw
            WHEN "0110011" => controls <= "1--00000100"; -- R-TYPE
            WHEN "1100011" => controls <= "01000001010"; -- beq
            WHEN "0010011" => controls <= "10010000100"; -- I-TYPE ALU
            WHEN "1101111" => controls <= "11100100001"; -- jal
            WHEN OTHERS => controls <= "-----------"; -- NOT valid
        END CASE;
    END PROCESS;
    (RegWrite, ImmSrc(1), ImmSrc(0), ALUSrc, MemWrite,
    ResultSrc(1), ResultSrc(0), Branch, ALUOp(1), ALUOp(0),
    Jump) <= controls;
END;