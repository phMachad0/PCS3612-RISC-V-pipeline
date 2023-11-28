library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register is
	port(
		    clock, load : in std_logic;
            d : in std_logic_vector(31 downto 0);
            q : out std_logic_vector(31 downto 0)
		);
end register;
architecture behave of register is
begin
	process(clock, load)
	begin
		if (load = '1' and rising_edge(clock)) then
			s_q <= d;
		end if;
	end process;
	q <= s_q;
end behave;