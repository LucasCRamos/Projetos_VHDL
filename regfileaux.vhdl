library ieee;
use ieee.numeric_bit.all;

entity reg is

    generic (N: natural:=64);

    port(
        
        ck, rst, rw: in bit;
        D: in bit_vector(N-1 downto 0);
        Q: out bit_vector(N-1 downto 0)
    
    );

end reg;

architecture arch_reg of reg is

    begin

    process(rst,ck)

        begin

            if (rst = '1') then

                Q <= (others => '0');

            elsif rising_edge(ck) then 

                if rw = '1' then

                    Q <= D;

                end if;

            end if;

        end process;

end arch_reg;


component reg is

    generic (N: natural:=64);

    port(
        
        ck, rst, rw: in bit;
        D: in bit_vector(N-1 downto 0);
        Q: out bit_vector(N-1 downto 0)
    
    );

end component;

begin

    map1: reg generic map(wordSize) port map(

        ck => clock,
        rst => reset,
        rw => regWrite,
        D => d

    );