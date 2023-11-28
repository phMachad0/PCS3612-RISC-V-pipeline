LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
ENTITY flopenr IS
    GENERIC (width : INTEGER);
    PORT (
        clk, reset, en : IN STD_LOGIC;
        d : IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
        q : OUT STD_LOGIC_VECTOR(width-1 DOWNTO 0));
END;
ARCHITECTURE asynchronous OF flopenr IS
BEGIN
    PROCESS (clk, reset, en) BEGIN
        IF reset = '1' THEN
            q <= (OTHERS => '0');
        ELSIF rising_edge(clk) AND en = '1' THEN
            q <= d;
        END IF;
    END PROCESS;
END;