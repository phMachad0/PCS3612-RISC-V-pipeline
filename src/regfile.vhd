library ieee;
use     ieee.std_logic_1164.all;
use     ieee.math_real.all;
use     ieee.numeric_std.all;

entity regfile is
    generic(
        reg_n  : natural := 10;
        word_s : natural := 64
    );
    port(
        clock        : in  std_logic;
        reset        : in  std_logic;
        regWrite     : in  std_logic;
        rr1, rr2, wr : in  std_logic_vector(natural(ceil(log2(real(reg_n))))-1 downto 0);
        d            : in  std_logic_vector(word_s-1 downto 0);
        q1, q2       : out std_logic_vector(word_s-1 downto 0)
    );
end regfile;
architecture behave of regfile is
    type registerControl is array (reg_n-1 downto 0) of std_logic_vector(word_s-1 downto 0);
    signal registerQs : registerControl;
    signal wrArray : std_logic_vector(reg_n-1 downto 0);
    component dataRegister
        generic(
            word_s : natural := 64;
            reset_value : natural := 0
        );
        port(
            clock, reset, load : in std_logic;
            d : in std_logic_vector(word_s-1 downto 0);
            q : out std_logic_vector(word_s-1 downto 0)
        );
	end component;
    begin
        lastReg : dataRegister generic map(word_s)
                          port map (clock, reset, '0', d, registerQs(reg_n-1));
        regGen : for i in reg_n-2 downto 0 generate
			Reg_i : dataRegister generic map(word_s)
            port map (clock, reset, regWrite, d, registerQs(i));
        end generate;

        
    
end behave;