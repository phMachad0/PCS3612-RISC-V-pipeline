LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY extend IS
    PORT (
        instr : IN STD_LOGIC_VECTOR(31 DOWNTO 7);
        immsrc : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        immext : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END;
ARCHITECTURE behave OF extend IS
BEGIN
    PROCESS (instr, immsrc) BEGIN
        CASE immsrc IS
                -- I-TYPE
            WHEN "00" =>
                immext <= (31 DOWNTO 12 => instr(31)) & instr(31 DOWNTO 20);
                -- S-types (stores)
            WHEN "01" =>
                immext <= (31 DOWNTO 12 => instr(31)) &
                    instr(31 DOWNTO 25) & instr(11 DOWNTO 7);
                -- B-TYPE (branches)
            WHEN "10" =>
                immext <= (31 DOWNTO 12 => instr(31)) & instr(7) & instr(30
                    DOWNTO 25) & instr(11 DOWNTO 8) & '0';
                -- J-TYPE (jal)
            WHEN "11" =>
                immext <= (31 DOWNTO 20 => instr(31)) &
                    instr(19 DOWNTO 12) & instr(20) &
                    instr(30 DOWNTO 21) & '0';
            WHEN OTHERS =>
                immext <= (31 DOWNTO 0 => '-');
        END CASE;
    END PROCESS;
END;