library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD.all;

entity dmem is
    port (
        clk, we : in std_logic;
        a, wd : in std_logic_vector(31 downto 0);
        rd : out std_logic_vector(31 downto 0));
end;
architecture behave of dmem is
    type ramtype is array (63 downto 0) of
    std_logic_vector(31 downto 0);
    signal mem : ramtype := (others => (others => '0'));

    begin
	 
        -- read or write memory
        operate: process(clk, mem, a)
            begin
            rd <= mem(to_integer(unsigned(a(7 downto 2))));
            if rising_edge(clk) then
                if (we='1') then
                    mem(to_integer(unsigned(a(7 downto 2)))) <= wd;
                end if;
            end if;
        end process;
end;