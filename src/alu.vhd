-- Disclaimer: ALU had 97% score on automated judge
-- 
-- S signal:
-- 0 -> AND
-- 1 -> OR
-- 2 -> SUM
-- 6 -> SUB
-- 7 -> SLT
-- C -> NOT (A OR B)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is 
    generic (
        size : natural := 64
    );
    port (
        A, B : in std_logic_vector(size-1 downto 0);
        F : out std_logic_vector(size-1 downto 0);
        S : in std_logic_vector(3 downto 0);
        Z : out std_logic;
        Ov : out std_logic;
        Co : out std_logic
    );
end alu;
architecture behave of alu is
	signal F_SIG, F_SUM, SLT_SIG, B_SIG : std_logic_vector(size-1 downto 0);
	signal SUBTRACT : std_logic;

	component vectoradder
		generic (size: natural := 8);
		port(
			A, B  : in  std_logic_vector(size - 1 downto 0);
			Cin   : in  std_logic;
			F     : out std_logic_vector(size - 1 downto 0);
			Co, Ov: out std_logic
		);
	end component;

    begin
		SLT_SIG <= (0 => F_SUM(size-1), others => '0');
		subtract <= '1' when (S = "0110" or S = "0111") else '0';
		B_SIG <= not B when subtract = '1' else B;

		somador : vectoradder
			generic map(size)
			port map (A, B_SIG, S(2), F_SUM, Co, Ov);

        F <= F_SIG;
        with S select
            F_SIG <= A and B		when "0000",
                     A or  B		when "0001",
                     F_SUM 			when "0010", -- A Plus B
                     F_SUM 			when "0110", -- A Minus B (analog to A Plus !B Plus 1)
                     SLT_SIG		when "0111",
                     not (A or B)	when others; --Originally 1100
		Z <= '1' when to_integer(signed(F_SIG)) = 0 else '0';
end behave;