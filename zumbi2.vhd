library ieee;
use ieee.numeric_bit.rising_edge;

entity zumbi is
  port(
    clock, reset: in bit;
    x: in bit_vector(1 downto 0);
    z: out bit
  );
  end entity;

architecture fsm of zumbi is

  type estados_t is (S0, S1, S2, S3);

  signal estado_atual, proximo_estado: estados_t;

  begin

    sincrono: process(clock, reset)

    begin

      if reset='1' then
        estado_atual <= S0;

      elsif rising_edge(clock) then
        estado_atual <= proximo_estado;
      end if;

    end process;

    proximo_estado <=

      S0  when estado_atual=S0 and x(1)='0' and x(0)='0' else
      S1 when estado_atual=S0 and x(1)='0' and x(0)='1' else
      S0  when estado_atual=S0 and x(1)='1' and x(0)='1' else
      S3  when estado_atual=S0 and x(1)='1' and x(0)='0' else

      S0  when estado_atual=S1  and x(1)='0' and x(0)='0' else
      S1 when estado_atual=S1  and x(1)='0' and x(0)='1' else
      S2  when estado_atual=S1  and x(1)='1' and x(0)='1' else
      S3  when estado_atual=S1  and x(1)='1' and x(0)='0' else

      S0  when estado_atual=S2  and x(1)='0' and x(0)='0' else
      S1 when estado_atual=S2  and x(1)='0' and x(0)='1' else
      S1 when estado_atual=S2  and x(1)='1' and x(0)='1' else
      S3  when estado_atual=S2  and x(1)='1' and x(0)='0' else

      S0  when estado_atual=S3  and x(1)='0' and x(0)='0' else
      S1 when estado_atual=S3  and x(1)='0' and x(0)='1' else
      S3  when estado_atual=S3  and x(1)='1' and x(0)='1' else
      S3  when estado_atual=S3  and x(1)='1' and x(0)='0' else
      S0;

    z <= '1' when (estado_atual=S2 or estado_atual=S3)  else '0';

end architecture;
