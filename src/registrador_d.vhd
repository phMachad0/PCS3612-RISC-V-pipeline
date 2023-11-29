library ieee;
use ieee.std_logic_1164.all;

entity registrador_d is
	generic(
		constant N : integer := 32
		);
	port(
        clock : in std_logic;
        reset : in std_logic;
        load : in std_logic;
		d : in std_logic_vector(N-1 downto 0);
		q : out std_logic_vector(N-1 downto 0)
		);
end registrador_d;

architecture behave of registrador_d is
begin
	process(reset, clock, load)
	begin
		if (rising_edge(clock) and (reset = '1')) then
			q <= (others => '0');
		elsif ((load = '1') and (rising_edge(clock))) then
			q <= d;
		end if;
	end process;
end behave;