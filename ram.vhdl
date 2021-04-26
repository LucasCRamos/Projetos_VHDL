library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

entity ram is
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
end ram;

architecture myram of ram is

    type mem_type is array (0 to (2**addr'length)-1) of std_logic_vector(data'range);

    signal mem: mem_type;

    begin

        process(enable,ck)

            variable count : integer range 0 to delay_in_clocks+1;

            variable aux: bit;

            begin

            if enable = '1' then

                if rising_edge(ck) then -- proxima borda de subida

                    aux := '1'; --ocupado

                    bsy <= aux;

                    if aux = '1' then

                        count := count + 1;

                        if count = (delay_in_clocks+1) then

                            bsy <= '0';
                            count := 0;

                        end if;

                    end if;

                    if write_enable = '1' then --escrita

                        mem(to_integer(unsigned(addr))) <= data;

                    else --leitura
                        
                        data <= (others => 'Z'); --antes da leitura, deve estar em tri-state
                        data <= mem(to_integer(unsigned(addr)));

                    end if;

                end if;

            else -- enable = '0'

                bsy <= '0';
                data <= (others => 'Z');
                    
            end if;

        end process;

end myram;

