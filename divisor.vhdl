library ieee;
use ieee.numeric_bit.all;

entity registrador_universal is
generic (
word_size: positive := 4
);
port (
clock, clear, set, enable: in bit;
control: in bit_vector(1 downto 0);
serial_input: in bit;
parallel_input: in bit_vector(word_size-1 downto 0);
parallel_output: out bit_vector(word_size-1 downto 0)
);
end entity;

architecture registrador of registrador_universal is

  begin

    process(clock,clear,set)

    variable aux: bit_vector(word_size-1 downto 0);

    begin

      if (clear = '1') then --> força saida para 0

        aux := (others => '0');

      elsif (set = '1') then --> caso clear nao esteja ativado, força saida para 1

        aux := (others => '1');

      else

        if rising_edge(clock) then --> na borda de subida do clock...

          if (enable = '1') then --> se enable eh 1, vai depender do control

            if (control = "01") then --> deslocamento pra direita

            aux := serial_input&aux(word_size-1 downto 1);

            elsif (control = "10") then --> deslocamento pra esquerda

            aux := aux(word_size-2 downto 0)&serial_input;

            elsif (control = "11") then --> carga paralela

            aux := parallel_input;

            end if; --> fecha os if's do control

          end if; --> fecha if do enable

      end if; --> fecha if do rising_edge

    end if; --> fecha os if's das entradas assincronas

  parallel_output <= aux;

  end process; --> fecha process

end architecture;

library ieee;
use ieee.numeric_bit.all;

entity fdm is
  generic (
    word_size: positive
  );
  port (
    clock, reset, sel: in bit;
    loadA, loadB: in bit_vector(1 downto 0);
    A, B: in bit_vector(word_size-1 downto 0);
    resultado, resto: out bit_vector(word_size-1 downto 0);
    comp: out bit
  );
end entity;

architecture arch_fdm of fdm is

  component registrador_universal is
    generic (
    word_size: positive
    );
    port (
      clock, clear, set, enable: in bit;
      control: in bit_vector(1 downto 0);
      serial_input: in bit;
      parallel_input: in bit_vector(word_size-1 downto 0);
      parallel_output: out bit_vector(word_size-1 downto 0)
    );
  end component;

  signal sub, mux, saidaA, saidaB, temp: bit_vector(word_size-1 downto 0);    

begin

  regA: registrador_universal

    generic map(word_size)
    port map(clock, reset, '0', '1', loadA, '0', mux, saidaA);

  regB: registrador_universal

    generic map(word_size)
    port map(clock, reset, '0', '1', loadB, '0', B, saidaB);

    sub <= bit_vector(unsigned(saidaA) - unsigned(saidaB));

    comp <= '1' when (sub < B) else '0';

    mux <= A when sel = '0' else sub;

    resto <= sub;

  process(clock, reset, loadA)

    begin

    if reset='1' then

      temp <= (others => '0');

    elsif rising_edge(clock) then

      if loadA="11" then

        temp <= bit_vector(unsigned(temp)+1);

      end if;

    end if;

  end process;

  resultado <= temp;

end architecture;

library ieee;
use ieee.numeric_bit.all;

entity ucm is
  port(
      clock, reset, vai, comp: in bit;
      loadA, loadB: out bit_vector(1 downto 0);
      pronto, sel: out bit
  );
end entity;

architecture arch_ucm of ucm is

  type estados is (S0, S1, S2, S3, S4);

  signal atual, prox: estados;

begin

  process(clock, reset)

  begin

      if reset = '1' then

          atual <= S0;

      elsif rising_edge(clock) then

          atual <= prox;

      end if;

  end process;

  prox <=

      S0 when atual = S0 and vai = '0' else

      S1 when atual = S0 and vai = '1' else

      S2 when atual = S1 else

      S3 when atual = S2 and comp = '0' else

      S4 when atual = S2 and comp = '1' else

      S2 when atual = S3 else

      S0;

  loadA <= "11"  when atual = S1 or atual = S3 else "00";

  loadB <= "11"  when atual = S1 else "00";

  pronto <= '1'  when atual = S4 else '0';

  sel <= '1'  when atual = S3 else '0';

end architecture;

library ieee;
use ieee.numeric_bit.all;

entity divisor is
    generic(
    word_size: positive
    );
    port (
    clock, reset, vai: in bit;
    pronto: out bit;
    A, B: in bit_vector(word_size-1 downto 0);
    resultado, resto: out bit_vector(word_size-1 downto 0)
    );
end entity;

architecture archtop of divisor is

    component fdm is
        generic (
          word_size: positive
        );
        port (
          clock, reset, sel: in bit;
          loadA, loadB: in bit_vector(1 downto 0);
          A, B: in bit_vector(word_size-1 downto 0);
          resultado, resto: out bit_vector(word_size-1 downto 0);
          comp: out bit
        );
      end component;

    component ucm is
        port(
            clock, reset, vai, comp: in bit;
            loadA, loadB: out bit_vector(1 downto 0);
            pronto, sel: out bit
        );
      end component;

  signal sl, cmp: bit;
  signal load_A, load_B: bit_vector(1 downto 0);

begin

  fluxo: fdm

    generic map (word_size)
    port map(clock, reset, sl, load_A, load_B, A, B, resultado, resto, cmp);

  controle: ucm
  
    port map(clock, reset, vai, cmp, load_A, load_B, pronto, sl);

end architecture;
