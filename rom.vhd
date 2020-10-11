library ieee;
use ieee.numeric_bit.ALL;
use std.textio.all;

entity rom is
  generic(
    addressSize   : natural := 64;
    wordSize      : natural := 32;
    mifFileName : string  := "rom.dat"
  );
  port(
    addr : in  bit_vector(addressSize-1 downto 0);
    data : out bit_vector(wordSize-1 downto 0)
  );
end rom;

architecture rtl of rom is
  constant depth : natural := 2**addressSize;
  type mem_type is array (0 to depth-1) of bit_vector(wordSize-1 downto 0);
  impure function init_mem(file_name : in string) return mem_type is
    file     fil       : text open read_mode is file_name;
    variable lin       : line;
    variable temp_bv  : bit_vector(wordSize-1 downto 0);
    variable temp_mem : mem_type;
  begin
    for i in mem_type'range loop
      readline(fil, lin);
      read(lin, temp_bv);
      temp_mem(i) := temp_bv;
    end loop;
    return temp_mem;
  end;
  constant mem : mem_type := init_mem(mifFileName);
begin
  data <= mem(to_integer(unsigned(addr)));
end rtl;
