library ieee;
use ieee.numeric_bit.all;

entity ram is
  generic(
    addressSize : natural := 64;
    wordSize    : natural := 32
  );
  port(
    ck, wr : in  bit;
    addr   : in  bit_vector(addressSize-1 downto 0);
    data_i : in  bit_vector(wordSize-1 downto 0);
    data_o : out bit_vector(wordSize-1 downto 0)
  );
end ram;

architecture arqui of ram is
  constant depth : natural := 2**addressSize;
  type mem_type is array (0 to depth-1) of bit_vector(wordSize-1 downto 0);
  signal mem : mem_type;
begin
  wrt: process(ck)
  begin
    if (ck='1' and ck'event) then
      if (wr='1') then
        mem(to_integer(unsigned(addr))) <= data_i;
      end if;
    end if;
  end process;
  data_o <= mem(to_integer(unsigned(addr)));
end arqui;
