library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

entity ram is
    generic (
        addr_s : natural := 64; -- Address size (Address will range from 2^(addr_s)-1 downto 0)
        word_s : natural := 32; -- Word size (Memory width in std_logics)
        init_f : string  := "ram.dat" -- File that defines initial memory
    );
    port (
        clock  : in  std_logic;
        rd, wr : in  std_logic; -- Read/Write enables
        addr   : in  std_logic_vector (addr_s-1 downto 0);
        data_i : in  std_logic_vector (word_s-1 downto 0);
        data_o : out std_logic_vector (word_s-1 downto 0)
    );
end ram;

architecture behave of ram is
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

	signal memory : memoryType := init_mem(init_f);

    begin
        operate: process(clock)
            begin
            if (rd = '1') then
                data_o <= memory(to_integer(unsigned(addr)));
            end if;
            if (clock='1' and clock'event) then
                if (wr='1') then
                    memory(to_integer(unsigned(addr))) <= data_i;
                end if;
            end if;
        end process;
end behave;