library IEEE;
use IEEE.std_logic_1164.all;

entity memwb is 
port(
    CLK : in std_logic;
    EN  : in std_logic; -- aqui sempre em 1
    CLR : in std_logic; -- aqui sempre em 0

    --entradas de dados
    ALUResultM  : in std_logic_vector (31 downto 0);
    ReadDataM   : in std_logic_vector (31 downto 0);
    RdM         : in std_logic_vector(4 downto 0);
    PCPlus4M    : in std_logic_vector (31 downto 0);

    --entradas de controle
    RegWriteM   : in std_logic;
    ResultSrcM  : in std_logic_vector(1 downto 0);
 
    --saidas de dados
    ALUResultW  : out std_logic_vector (31 downto 0);
    ReadDataW   : out std_logic_vector (31 downto 0);
    RdW         : out std_logic_vector(4 downto 0);
    PCPlus4W    : out std_logic_vector (31 downto 0);

    --saidas de controle
    RegWriteW   : out std_logic;
    ResultSrcW  : out std_logic_vector(1 downto 0)

);

end memwb;


architecture reg of memwb is
    signal  input_concatenado : std_logic_vector (103 downto 0); 
    signal  output_concatenado : std_logic_vector (103 downto 0); 

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
    input_concatenado <= RegWriteM & ResultSrcM & ALUREsultM & ReadDataM & RdM & PCPlus4M;

    reg1 : registrador_d
    generic map (
        N => 104
    )
    port map (
        clock => CLK,
        reset => CLR,
        load => EN,
        d => input_concatenado,
        q => output_concatenado
    );

    PCPlus4W <= output_concatenado(31 downto 0);
    RdW <= output_concatenado(36 downto 32);
    ReadDataW <= output_concatenado(68 downto 37);
    ALUResultW <= output_concatenado(100 downto 69);
    ResultSrcW <= output_concatenado(102 downto 101);
    RegWriteW <= output_concatenado(103);

end reg;