LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY aludec IS
    PORT (
        opb5 : IN STD_LOGIC;
        funct3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        funct7b5 : IN STD_LOGIC;
        ALUOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        ALUControl : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END;
ARCHITECTURE behave OF aludec IS
    SIGNAL RtypeSub : STD_LOGIC;
BEGIN
    RtypeSub <= funct7b5 AND opb5; -- TRUE FOR R-TYPE subtract
    PROCESS (opb5, funct3, funct7b5, ALUOp, RtypeSub) BEGIN
        CASE ALUOp IS
            WHEN "00" => ALUControl <= "000"; -- addition
            WHEN "01" => ALUControl <= "001"; -- subtraction
            WHEN OTHERS => CASE funct3 IS -- R-TYPE OR I-TYPE ALU
            WHEN "000" = IF RtypeSub = '1' THEN
                ALUControl <= "001"; -- sub
            ELSE
                ALUControl <= "000"; -- add, addi
        END IF;
        WHEN "010" => ALUControl <= "101"; -- slt, slti
        WHEN "110" => ALUControl <= "011"; -- OR, ori
        WHEN "111" => ALUControl <= "010"; -- AND, andi
        WHEN OTHERS => ALUControl <= "---"; -- unknown
    END CASE;
END CASE;
END PROCESS;