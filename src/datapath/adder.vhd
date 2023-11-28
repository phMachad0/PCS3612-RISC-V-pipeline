LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD_UNSIGNED.ALL;
ENTITY adder IS
    PORT (
        a, b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        y : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END;
ARCHITECTURE behave OF adder IS
BEGIN
    y <= a + b;
END;