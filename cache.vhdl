library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all; 

entity cache is
    generic(
        address_size_in_bits : natural := 16;
        cache_size_in_bits : natural := 8;
        word_size_in_bits : natural := 8
    );
    port(
        ck, enable, write_enable : in bit;
        addr_i : in bit_vector(address_size_in_bits-1 downto 0);
        data_i : in bit_vector(word_size_in_bits-1 downto 0);
        data_o : out bit_vector(word_size_in_bits-1 downto 0);
        bsy : out bit; -- indica se a cache estah busy
        nl_data_i : in std_logic_vector(word_size_in_bits-1 downto 0); -- recebe dados da memoria
        nl_enable, nl_write_enable : out bit; -- habilita a memoria e habilita escrita na memoria
        nl_bsy : in bit -- indica se a memoria estah busy
    );
end cache;

architecture arch_cache of cache is

    type memory is array (0 to (2**cache_size_in_bits)-1) of bit_vector(address_size_in_bits downto 0);
    signal cac: memory;

    type st is (s00, s01, s02, s03, s04);
    signal ea, pe: st;

begin

  sincrono: process(enable, ck, pe)
  begin

    if enable = '0' then
      ea <= s00;
    elsif rising_edge(ck) then
      ea <= pe;
    end if;

	end process sincrono;


	-- funcoes de transicao e saida
	combinatorio: process(ea, nl_bsy, write_enable)
	begin

		case(ea) is
		when s00 =>
			bsy<='0'; 
      nl_enable<='0'; 
      nl_write_enable<='0'; 

      --nl_bsy ='0';
      if write_enable = '1' then
        pe<=s01; 
      else
        pe<=s02;
      end if;
    
    --escrita
		when s01 =>
			bsy<='1'; nl_enable<='1'; nl_write_enable<='1';
      cac(to_integer(unsigned(addr_i(cache_size_in_bits-1 downto 0)))) <= '1' & addr_i(address_size_in_bits-1 downto cache_size_in_bits) & data_i; 
      
      if write_enable = '1' then
        if nl_bsy = '1' then
          pe <= s03; 
        else
          pe <= s01;
        end if;
      else
        pe<=s00;
      end if;
    
    --leitura
    when s02 =>

      bsy<='1'; nl_write_enable<='0';

      if write_enable = '0' then
        --checa se o dado estah na cache
        if cac(to_integer(unsigned(addr_i(cache_size_in_bits-1 downto 0))))(address_size_in_bits downto cache_size_in_bits) = '1' & addr_i(address_size_in_bits-1 downto cache_size_in_bits) then
          nl_enable<='0'; 
          data_o <= cac(to_integer(unsigned(addr_i(cache_size_in_bits-1 downto 0))))(word_size_in_bits-1 downto 0);
          pe <= s00;
        else
          nl_enable<='1';
          if nl_bsy = '1' then
            pe <= s03; 
          else
            pe <= s02;
          end if; 
        end if;

      else
        pe <= s00;
      end if;

		when s03 => 
      bsy<='1'; nl_enable<='1'; 
      
      if write_enable = '1' then
        nl_write_enable<='1';
      else
        nl_write_enable <= '0';
      end if;

			if nl_bsy ='0' then 

				pe<=s04;

        if write_enable = '0' then
          cac(to_integer(unsigned(addr_i(cache_size_in_bits-1 downto 0))))(address_size_in_bits) <= '1';
          cac(to_integer(unsigned(addr_i(cache_size_in_bits-1 downto 0))))(address_size_in_bits-1 downto cache_size_in_bits) <= addr_i(address_size_in_bits-1 downto cache_size_in_bits);
  
          --salva o dado
          for j in 0 to (word_size_in_bits-1) loop
  
            if nl_data_i(j) = '0' then
  
              cac(to_integer(unsigned(addr_i(cache_size_in_bits-1 downto 0))))(j) <= '0';
            
            else 
              
              cac(to_integer(unsigned(addr_i(cache_size_in_bits-1 downto 0))))(j) <= '1';
              
            end if;
        
          end loop;
        end if;
  
      else
        pe<=s03;
			end if;

		when s04 => 
      bsy<='1'; nl_enable<='0'; nl_write_enable <= '0';  
      data_o <= cac(to_integer(unsigned(addr_i(cache_size_in_bits-1 downto 0))))(word_size_in_bits-1 downto 0);
      pe <= s00;

		when others =>
			pe<=s00;
		end case;
            
  end process combinatorio;

end architecture;