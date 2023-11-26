library ieee;
use ieee.std_logic_1164.all;

entity fulladder is
	port (
		A, B, Cin : in  std_logic;
		F, Co     : out std_logic
	);
end fulladder;
architecture behavior of fulladder is
begin
	F <= A xor B xor Cin;
	Co <= (A and B) or (Cin and A) or (Cin and B);
end architecture;
