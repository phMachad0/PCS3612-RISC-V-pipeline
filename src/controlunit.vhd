library ieee;
use ieee.std_logic_1164.all;

entity controlunit is
    port (
        --To dataflow
        reg2loc : out std_logic;
        memRead : out std_logic;
        memToReg : out std_logic;
        aluOp : out std_logic_vector(1 downto 0);
        memWrite : out std_logic;
        aluSrc : out std_logic;
        regWrite : out std_logic;
        aluCtrl : out std_logic_vector(3 downto 0);
		  pcsrc : out std_logic;
        --From dataflow
        opcode : in std_logic_vector(10 downto 0);
		  zero : in std_logic
    );
end controlunit;

architecture behave of controlunit is
	signal aluop_sig : std_logic_vector(1 downto 0);
	signal branch_sig, uncondbranch_sig : std_logic;

    begin 
        reg2loc <= '1' when (opcode = "11111000000") or (opcode(10 downto 3) = "10110100") or (opcode(10 downto 5) = "000101") else '0';

		  uncondbranch_sig <= '1' when opcode(10 downto 5) = "000101" else '0';
		  
        branch_sig <= '1' when opcode(10 downto 3) = "10110100" else '0';

        memRead <= '1' when opcode = "11111000010" else '0';

        memToReg <= '1' when opcode(10 downto 3) = "101101100" or opcode = "11111000010" else '0';
        
        aluOp <= aluop_sig;
        aluop_sig <= "01" when opcode(10 downto 3) = "10110100" else
                 "00" when opcode = "11111000010" or opcode = "11111000000" else "10";
        
        memWrite <= '1' when opcode = "11111000000" else '0';
        
        aluSrc <= '1' when opcode = "11111000010" or opcode = "11111000000" else '0';

        regWrite <= '0' when opcode = "11111000000" or
                             opcode(10 downto 3) = "10110100" or
                             opcode(10 downto 5) = "000101" else '1';
                    --'1' when (opcode = "11111000010") or
                    --         (opcode = "11001011000") or 
                    --         (opcode = "10001011000") or
                    --         (opcode = "10001010000") or 
                    --         (opcode = "10101010000") else '0';

                aluCtrl <= 
                    "0010" when (aluop_sig = "00") else
                    "0111" when (aluop_sig = "01") else
                    "0010" when (aluop_sig = "10" and opcode = "10001011000") else
                    "0110" when (aluop_sig = "10" and opcode = "11001011000") else
                    "0000" when (aluop_sig = "10" and opcode = "10001010000") else
                    "0001" when (aluop_sig = "10" and opcode = "10101010000") else
                    "0000";
						  
			pcsrc <= uncondbranch_sig or (branch_sig and zero);
end behave;