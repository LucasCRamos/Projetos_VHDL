library ieee;
use ieee.numeric_bit.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

entity regfile is
    generic(
        regn:natural:=32;
        wordSize:natural:=64
    );
    port(
        clock: in bit;
        reset: in bit;
        regWrite: in bit;
        rr1,rr2,wr: in bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
        d: in bit_vector(wordSize-1 downto 0);
        q1,q2: out bit_vector(wordSize-1 downto 0)
    );
end regfile;

architecture arch_reg of regfile is

    type bank is array (0 to regn-1) of bit_vector(wordSize-1 downto 0);

    begin

        process(clock,reset)

        variable banco : bank;

            begin

                if reset = '1' then --reset assincrono

                    for i in 0 to regn-2 loop -- o ultimo já está zerado, por isso vai até regn-2

                        banco(i) := (others => '0');

                    end loop;

                elsif rising_edge(clock) and regWrite = '1' then -- na borda de subida faz a escrita

                        if (to_integer(unsigned(wr)) /= regn-1) then -- registrador diferente do ultimo

                            banco(to_integer(unsigned(wr))) := d;

                        end if;

                end if;

                q1 <= banco(to_integer(unsigned(rr1)));
                q2 <= banco(to_integer(unsigned(rr2)));

        end process;

end arch_reg;
