LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY regfile IS
    PORT (
        clk : IN STD_LOGIC;
        we3 : IN STD_LOGIC;
        a1, a2, a3 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        wd3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        rd1, rd2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END;
ARCHITECTURE behave OF regfile IS
    TYPE ramtype IS ARRAY (31 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mem : ramtype;
BEGIN
    -- three ported REGISTER FILE
    -- read two ports combinationally (A1/RD1, A2/RD2)
    -- write third PORT ON rising edge OF clock (A3/WD3/WE3)
    -- REGISTER 0 hardwired TO 0
    PROCESS (clk) 
    BEGIN
        IF rising_edge(clk) THEN
            IF we3 = '1' THEN
                mem(to_integer(unsigned(a3))) <= wd3;
            END IF;
        END IF;
    END PROCESS;
    PROCESS (a1, a2) BEGIN
        IF (to_integer(unsigned(a1)) = 0) THEN
            rd1 <= X"00000000";
        ELSE
            rd1 <= mem(to_integer(unsigned(a1)));
        END IF;
        IF (to_integer(unsigned(a2)) = 0) THEN
            rd2 <= X"00000000";
        ELSE
            rd2 <= mem(to_integer(unsigned(a2)));
        END IF;
    END PROCESS;
END;
