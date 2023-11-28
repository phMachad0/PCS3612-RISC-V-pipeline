library IEEE;
use IEEE.std_logic_1164.all;

entity ifid is 
port(
    CLK : in std_logic;
    EN  : in std_logic; -- not(StallD)
    CLR : in std_logic; -- FlushD

    RDF : in std_logic_vector(31 downto 0);
    PCF : in std_logic_vector(31 downto 0);
    PCPlus4F : in  std_logic_vector(31 downto 0);

    InstrD : out std_logic_vector(31 downto 0);
    PCD    : out std_logic_vector(31 downto 0);
    PCPlus4D : out std_logic_vector(31 downto 0)
);
end ifid;


architecture reg of ifid is
    signal  input_concatenado : std_logic_vector (95 downto 0); --RDF, PCF, PCPlus4F
    signal  output_concatenado : std_logic_vector (95 downto 0); --InstrD, PCD, PCPlus4D

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
    input_concatenado <= RDF & PCF & PCPlus4F;

    reg1 : registrador_d
    generic map (
        N => 96
    )
    port map (
        clock => CLK,
        reset => CLR,
        load => EN,
        d => input_concatenado,
        q => output_concatenado
    );

    InstrD <= output_concatenado(95 downto 64);
    PCD <= output_concatenado(63 downto 32); 
    PCPlus4D <= output_concatenado(31 downto 
0);

end reg ;