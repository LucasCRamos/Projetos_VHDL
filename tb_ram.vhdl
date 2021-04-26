library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

entity tb_ram is
end tb_ram;

architecture testbench of tb_ram is
  component ram is
    generic (
        address_size_in_bits : natural := 64;
        word_size_in_bits : natural:= 32;
        delay_in_clocks : positive := 1
    );
    port(
        ck,enable,write_enable : in bit;
        addr : in bit_vector(address_size_in_bits-1 downto 0);
        data : inout std_logic_vector(word_size_in_bits-1 downto 0);
        bsy : out bit
    );
  end component;
  
  -- sinais de suporte
  signal addr: bit_vector(7 downto 0);
  signal data: std_logic_vector(3 downto 0);
  signal stopc, clk, we, e, bsy: bit := '0';
  -- Periodo do clock
  constant periodo : time := 10 ns;

begin
  -- Geração de clock
  clk <= stopc and (not clk) after periodo/2;
  -- Instâncias a serem testada
  dutA: ram 
    generic map(8,4,5)
    port map(clk, e, we, addr, data, bsy);
  
  -- Estímulos
  stim: process
    variable addr_tmp: bit_vector(3 downto 0);
  begin
    stopc <= '1';
    --escrevendo na memória
    for i in 0 to 255 loop
      addr <= bit_vector(to_unsigned(i,8));
      data <= (others => '1');
    end loop; 

    e <= '1';
    we <= '1';
    
    -- if bsy = '0' then
    --   e <= '0';
    --   we <= '0';
    -- end if;

    --! Lendo todas as memórias
    for i in 0 to 255 loop
      addr <= bit_vector(to_unsigned(i,8));
      wait for 1 ns;
      -- assert d4a = a5(7 downto 0)
      --   report "ROM1 mem("&to_bstring(a5)&")="&to_bstring(d4a);
    end loop;
    stopc <= '0';
    wait;
  end process;
end architecture;