library ieee;
use ieee.std_logic_1164.all;

entity vectoradder is
	generic (size: natural := 8);
	port (
		A, B  : in  std_logic_vector(size - 1 downto 0);
		Cin   : in  std_logic;
		F     : out std_logic_vector(size - 1 downto 0);
		Co, Ov: out std_logic
	);
end vectoradder;
architecture behavior of vectoradder is
	signal F_SIG : std_logic_vector(size - 1 downto 0);
	component fulladder
		port (A, B, Cin: in std_logic; F, Co: out std_logic);
	end component;
	signal carries : std_logic_vector(size downto 0);
	begin
		F <= F_SIG;
		carries(0) <= Cin;
		Co <= carries(size);
		Ov <= (A(size - 1) xnor B(size - 1)) and (A(size - 1) xor F_SIG(size - 1));
		FA : for i in 0 to size - 1 generate
			FA_i : fulladder 
            port map(
                A => A(i), 
                B => B(i), 
                Cin => carries(i), 
                F => F_SIG(i), 
                Co => carries(i + 1)
            );
		end generate;
end architecture;
