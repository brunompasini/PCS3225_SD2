entity controlunit is
    port (
        --- to datapath
        reg2loc : out bit;
        uncondBranch : out bit;
        branch : out bit;
        memRead: out bit;
        memToReg : out bit;
        aluOp: out bit_vector(1 downto 0);
        memWrite : out bit;
        aluSrc : out bit;
        regWrite : out bit;
        --- from datapath
        opcode : in bit_vector(10 downto 0)        
    );
end entity;

architecture arq of controlunit is
    signal ldur : bit_vector(9 downto 0) := "0001100011";
    signal stur : bit_vector(9 downto 0) := "1000000110";
    signal cbz : bit_vector(9 downto 0) :=  "1010001000";
    signal b : bit_vector(9 downto 0) :=    "0100001000";
    signal r : bit_vector(9 downto 0) :=    "0000010001";
    signal temp : bit_vector(9 downto 0);
begin
    temp <= ldur when opcode = "11111000010" else
            stur when opcode = "11111000000" else
            cbz when opcode = "10110100000" else
            b when opcode = "00010100000" else
            r;

    reg2loc <= temp(9);
    uncondBranch <= temp(8);
    branch <= temp(7);
    memRead<= temp(6);
    memToReg <= temp(5);
    aluOp<= temp(4 downto 3);
    memWrite <= temp(2);
    aluSrc <= temp(1);
    regWrite <= temp(0);

end architecture arq;
