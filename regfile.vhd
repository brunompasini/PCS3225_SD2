library IEEE;
use ieee.math_real.ceil;
use ieee.math_real.log2;
use IEEE.numeric_bit.all;


entity regfile is
    generic(
        regn: natural:= 32;
        wordSize : natural := 64
    );
    port(
        clock: in bit;
        reset: in bit;
        regWrite: in bit;
        rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
        d : in bit_vector(wordSize-1 downto 0);
        q1, q2: out bit_vector(wordSize-1 downto 0)
    );
end regfile;

architecture rtl of regfile is
    type breg is array(0 to regn-1) of bit_vector(wordSize-1 downto 0);
    signal brg : breg;
begin
    process(reset,clock)
    begin
        if reset = '1' then
            brg <= (others=>(others=>'0'));
        end if;
        if (clock='1' and clock'event and regWrite ='1' ) then
            if (regWrite='1'and to_integer(unsigned(wr)) < regn-1) then
                brg(to_integer(unsigned(wr))) <= d;
            end if;
        end if;
    end process;
    q1 <= brg(to_integer(unsigned(rr1)));
    q2 <= brg(to_integer(unsigned(rr2)));

end architecture rtl;
