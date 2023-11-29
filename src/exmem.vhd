library IEEE;
use IEEE.std_logic_1164.all;

entity exmem is 
port(
    CLK : in std_logic;
    EN  : in std_logic; -- aqui sempre em 1
    CLR : in std_logic; -- aqui sempre em 0

    --entradas de dados
    ALUResultE : in std_logic_vector (31 downto 0);
    WriteDataE : in std_logic_vector (31 downto 0);
    RdE        : in std_logic_vector(4 downto 0);
    PCPlus4E   : in std_logic_vector (31 downto 0);

    --entradas de controle
    RegWriteE   : in std_logic;
    ResultSrcE  : in std_logic_vector(1 downto 0);
    MemWriteE   : in std_logic;
 
    --saidas de dados
    ALUResultM : out std_logic_vector (31 downto 0);
    WriteDataM : out std_logic_vector (31 downto 0);
    RdM        : out std_logic_vector(4 downto 0);
    PCPlus4M   : out std_logic_vector (31 downto 0);
    

    --saidas de controle
    RegWriteM   : out std_logic;
    ResultSrcM  : out std_logic_vector(1 downto 0);
    MemWriteM   : out std_logic


);

end exmem;


architecture reg of exmem is
    signal  input_concatenado : std_logic_vector (104 downto 0); --RegWriteE & ResultSrcE & MemWriteE & ALUResultE & WriteDataE & RdE & PCPlus4E;
    signal  output_concatenado : std_logic_vector (104 downto 0); --RegWriteM & ResultSrcM & MemWriteM & ALUResultM & WriteDataM & RdM & PCPlus4M;

    component registrador_d is
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
    end component;

begin
    input_concatenado <= RegWriteE & ResultSrcE & MemWriteE & ALUResultE & WriteDataE & RdE & PCPlus4E;

    reg1 : registrador_d
    generic map (
        N => 105
    )
    port map (
        clock => CLK,
        reset => CLR,
        load => EN,
        d => input_concatenado,
        q => output_concatenado
    );

    PCPlus4M <= output_concatenado(31 downto 0);
    RdM <= output_concatenado(36 downto 32);
    WriteDataM <= output_concatenado(68 downto 37);
    ALUResultM <= output_concatenado(100 downto 69);
    MemWriteM <= output_concatenado(101);
    ResultSrcM <= output_concatenado(103 downto 102);
    RegWriteM <= output_concatenado(104);

end reg;