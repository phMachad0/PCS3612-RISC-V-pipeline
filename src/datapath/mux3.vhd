LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY mux3 IS
    GENERIC (width : INTEGER := 8);
    PORT (
        d0, d1, d2 : IN STD_LOGIC_VECTOR(width−1 DOWNTO 0);
        s : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        y : OUT STD_LOGIC_VECTOR(width−1 DOWNTO 0));
END;
ARCHITECTURE behave OF mux3 IS
BEGIN
    PROCESS (d0, d1, d2, s) BEGIN
        IF (s = "00") THEN
            y <= d0;
        ELSIF (s = "01") THEN
            y <= d1;
        ELSIF (s = "10") THEN
            y <= d2;
        END IF;
    END PROCESS;
END;