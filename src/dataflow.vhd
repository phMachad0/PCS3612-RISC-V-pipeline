library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity dataflow is
    port(
        --Common
        clock    : in std_logic;
        reset    : in std_logic;
        
        --From Control Unit
        reg2loc  : in std_logic;
        pcsrc    : in std_logic;
        memToReg : in std_logic;
        aluCtrl  : in std_logic_vector(3 downto 0);
        aluSrc   : in std_logic;
        regWrite : in std_logic;
        
        --To Control Unit
        opcode   : out std_logic_vector(10 downto 0);
        zero     : out std_logic;

        --IM interface
        imAddr   : out std_logic_vector(63 downto 0);
        imOut    : in  std_logic_vector(31 downto 0);

        --DM interface
        dmAddr   : out std_logic_vector(63 downto 0);
        dmIn     : out std_logic_vector(63 downto 0);
        dmOut    : in  std_logic_vector(63 downto 0)
    );
end dataflow;
architecture behave of dataflow is
    component dataregister is
        generic(
            word_s: natural := 64
        );
        port(
            clock: in std_logic;
            reset: in std_logic;
            load: in std_logic;
            d: in std_logic_vector(word_s-1 downto 0);
            q: out std_logic_vector(word_s-1 downto 0)
        );
    end component;

    component shiftleft2 is
        generic(
            word_s : natural := 64
        ); 
        port (
            i : in  std_logic_vector(word_s-1 downto 0);
            o : out std_logic_vector(word_s-1 downto 0)
        );
    end component shiftleft2;
    
    component alu is
        generic(
            size: natural := 64
        );
        port(
            A, B: in std_logic_vector(size-1 downto 0);
            F: out std_logic_vector(size-1 downto 0);
            S: in std_logic_vector(3 downto 0);
            Z: out std_logic;
            Ov: out std_logic;
            Co: out std_logic
        );
    end component alu;

    component signExtend is 
    port(
        i: in std_logic_vector(31 downto 0);
        o: out std_logic_vector(63 downto 0)
    );
    end component signExtend;

    component regfile is 
    generic(
        reg_n: natural := 32;
        word_s: natural := 64
    );
    port(
        clock: in std_logic;
        reset: in std_logic;
        regWrite: in std_logic;
        rr1, rr2, wr: in std_logic_vector(natural(ceil(log2(real(reg_n))))-1 downto 0);
        d: in std_logic_vector(word_s-1 downto 0);
        q1, q2: out std_logic_vector(word_s-1 downto 0) 
    );
    end component regfile;

    --PC
    signal instructionAddress: std_logic_vector(63 downto 0);
    signal nextAddress: std_logic_vector(63 downto 0);
    signal addressPlus4: std_logic_vector(63 downto 0);
    signal Branch_address: std_logic_vector(63 downto 0);
    --REGFILE 
    signal regMux: std_logic_vector(4 downto 0);
    signal readData1: std_logic_vector(63 downto 0);
    signal readData2: std_logic_vector(63 downto 0);
    signal memToRegMux: std_logic_vector(63 downto 0);
    --ALU
    signal ALUSrcMux: std_logic_vector(63 downto 0);
    signal ALUResult: std_logic_vector(63 downto 0);
    --SIGNEXTEND
    signal signExtToALU: std_logic_vector(63 downto 0);
    --SHIFTLEFT2
    signal shiftToPC: std_logic_vector(63 downto 0);
    begin
        -- Components
        PC: dataregister
            generic map(
                word_s => 64
                )
            port map(
                clock => clock, 
                reset => reset, 
                load => '1', 
                d => nextAddress, 
                q => instructionAddress
            );

        ALUMAIN: alu
            generic map(64)
            port map(readData1, ALUSrcMux, ALUResult, aluCtrl, zero, open, open);
        Pc_incrementer: alu
            generic map(64)
            port map(instructionAddress, (2 => '1', others => '0'), addressPlus4, "0010", open, open, open);
        Branch_alu: alu
            generic map(64)
            port map(instructionAddress, shiftToPC, Branch_address, "0010", open, open, open);
        
        REGBANK: regfile
            generic map(32, 64)
            port map(clock, reset, regWrite, imOut(9 downto 5),
             regMux, imOut(4 downto 0), memToRegMux, readData1, readData2);  
        
        SIGNEXT: signExtend
            port map(imOut, signExtToALU);

        SHIFTLEFT: shiftleft2
            port map(signExtToALU, shiftToPC);
        
        -- Muxes
        regMux <= imOut(20 downto 16) when (reg2loc = '0') else imOut(4 downto 0);
        memToRegMux <= ALUResult when (memToReg = '0') else dmOut;
        ALUSrcMux <= readData2 when (aluSrc = '0') else signExtToALU;
        nextAddress <= addressPlus4 when (pcsrc = '0') else Branch_address;

        -- Outputs
        dmIn <= readData2;
        dmAddr <= ALUResult;
        opcode <= imOut(31 downto 21);
        imAddr <= instructionAddress;

end behave;
