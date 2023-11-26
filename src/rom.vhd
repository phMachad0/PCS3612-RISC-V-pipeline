library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

entity rom is
    generic (
        addr_s : natural := 64;
        word_s : natural := 32; 
        init_f : string  := "rom.dat"
    );
    port (
        addr : in  std_logic_vector (addr_s-1 downto 0);
        data : out std_logic_vector (word_s-1 downto 0)
    );
end rom;

architecture behave of rom is
    constant depth : natural := 2**addr_s;
    type memorytype is array(0 to depth-1) of std_logic_vector(word_s-1 downto 0);

    impure function init_mem(file_name : in string) return memorytype is
        file     f       : text open read_mode is file_name;
        variable l       : line;
        variable tmp_bv  : std_logic_vector(word_s-1 downto 0);
        variable tmp_mem : memorytype;
      begin
        for i in memorytype'range loop
          readline(f, l);
          read(l, tmp_bv);
          tmp_mem(i) := tmp_bv;
        end loop;
        return tmp_mem;
      end;
    
	constant memory : memoryType := init_mem(init_f);

    begin
        data <= memory(to_integer(unsigned(addr)));
end behave;