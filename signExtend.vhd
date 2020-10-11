library IEEE;
use IEEE.numeric_bit.all;
use IEEE.std_logic_1164.all;

entity signExtend is
    port (
        i : in bit_vector(31 downto 0);
        o : out bit_vector(63 downto 0)
    );
end entity signExtend;

architecture arch of signExtend is
    signal opcd : bit_vector(10 downto 0);
    signal ehB : bit;
    signal ehCB : bit;
    signal ehD : bit;
    signal ehR : bit;
    signal conc : bit_vector(3 downto 0);
    signal zero : bit_vector(63 downto 0) := "1111111111111111111111111111111111111111111111111111111111111111";
begin
    ehB <= '1' when i(31 downto 26) = "000101" else
    '0';
    ehCB <= '1' when i(31 downto 24) = "10110100" else
    '0';
    ehD <= '1' when i(31 downto 27) = "11111" else
    '0';
    ehR <= '1' when (ehCB  = '0') and (ehB = '0') and (ehD = '0') else
    '0';

    conc <= (ehB&ehCB&ehD&ehR);

    with conc select o <=
    bit_vector(resize(signed(i(25 downto 0)),64)) when "1000",
    bit_vector(resize(signed(i(23 downto 5)),64)) when "0100",
    bit_vector(resize(signed(i(20 downto 12)),64)) when "0010",
    bit_vector(resize(signed(i(20 downto 0)),64)) when "0001",
    zero when others;

end arch;
