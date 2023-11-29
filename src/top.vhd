library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity top is
    port (
        clk       : in std_logic;
        reset     : in std_logic;
        WriteData : buffer std_logic_vector(31 downto 0);
        DataAdr   : buffer std_logic_vector(31 downto 0);
        MemWrite  : buffer std_logic
    );
end;

architecture test of top is
    component riscvsingle
        port (
            clk       : in  std_logic;
            reset     : in  std_logic;
            Instr     : in  std_logic_vector(31 downto 0);
            ReadData  : in  std_logic_vector(31 downto 0);
            PC        : out std_logic_vector(31 downto 0);
            ALUResult : out std_logic_vector(31 downto 0);
            WriteData : out std_logic_vector(31 downto 0);
            MemWrite  : out std_logic
        );
    end component;

    component imem
        port (
            a  : in  std_logic_vector(31 downto 0);
            rd : out std_logic_vector(31 downto 0)
        );
    end component;

    component dmem
        port (
            clk : in  std_logic; 
            we  : in  std_logic;
            a   : in  std_logic_vector(31 downto 0); 
            wd  : in  std_logic_vector(31 downto 0);
            rd  : out std_logic_vector(31 downto 0)
        );
    end component;
    
    signal PC, Instr, ReadData : std_logic_vector(31 downto 0);
begin
    -- instantiate processor and memories
    rvsingle : riscvsingle 
    port map (
        clk => clk, 
        reset => reset, 
        PC => PC, 
        Instr => Instr,
        MemWrite => MemWrite, 
        ALUResult => DataAdr,
        WriteData => WriteData, 
        ReadData => ReadData
    );

    imem1 : imem 
    port map (
        a => PC, 
        rd => Instr
    );

    dmem1 : dmem
    port map (
        clk => clk, 
        we => MemWrite, 
        a => DataAdr, 
        wd => WriteData,
        rd => ReadData
    );
end;