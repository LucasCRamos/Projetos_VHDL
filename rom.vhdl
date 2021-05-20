library ieee;
use ieee.numeric_bit.all;
use std.textio.all;

entity rom is
  port (
    addr : in bit_vector (7 downto 0);
    data : out bit_vector (31 downto 0)
  );
end rom;

architecture rom_a of rom is

  type mem_t is array (0 to 255) of bit_vector(31 downto 0);
  
  impure function inicializa(nome_do_arquivo : in string) return mem_t is

    file arquivo : text open read_mode is nome_do_arquivo;
    variable linha : line;
    variable temp_bv : bit_vector(31 downto 0);
    variable temp_mem : mem_t;

    begin

      for i in mem_t'range loop 
      readline(arquivo,linha);
      read(linha, temp_bv);
      temp_mem(i) := temp_bv;
      end loop;

    return temp_mem;
  
  end;

  constant mem : mem_t := inicializa("rom.dat");

begin

  data <= mem (to_integer(unsigned(addr)));

end architecture;

  