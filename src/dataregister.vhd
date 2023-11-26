library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dataregister is
	generic(
            word_s : natural := 64;
            reset_value : natural := 0
		);
	port(
		    clock, reset, load : in std_logic;
            d : in std_logic_vector(word_s-1 downto 0);
            q : out std_logic_vector(word_s-1 downto 0)
		);
end dataregister;
architecture behave of dataregister is
	constant reset_sig : std_logic_vector(word_s-1 downto 0) := std_logic_vector(to_unsigned(reset_value, word_s));
	signal s_q : std_logic_vector(word_s-1 downto 0) := reset_sig;
begin
	process(reset, clock, load)
	begin
		if (reset = '1') then
			s_q <= reset_sig;
		elsif (load = '1' and rising_edge(clock)) then
			s_q <= d;
		end if;
	end process;
	q <= s_q;
end behave;