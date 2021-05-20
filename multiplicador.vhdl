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

entity contador is
  generic (
    word_size: positive
  );
  port (
    clock, reset, load, enable: in bit;
    carga: in bit_vector(word_size-1 downto 0);
    saida: out bit_vector(word_size-1 downto 0);
    rco: out bit
  );
end entity;

architecture arch_c of contador is

  signal temp, help: bit_vector(word_size-1 downto 0);

begin

  process(clock, reset, load, enable)

  begin

    if reset='1' then

      temp <= (others => '0');

    elsif rising_edge(clock) then

      if enable='1' then

        if load='1' then

          temp <= carga;

        else

          temp <= bit_vector(unsigned(temp)-1);

        end if;

      end if;

    end if;

  end process;

  help <= (others => '0');

  rco <= '1' when temp=help else '0';

  saida <= temp;

end architecture;

library ieee;
use ieee.numeric_bit.all;

entity fdm is
  generic (
    word_size: positive
  );
  port (
    clock, clearAB, clearR: in bit;
    loadA, loadR: in bit_vector(1 downto 0);
    loadB, enableB: in bit;
    A, B: in bit_vector(word_size-1 downto 0);
    resultado: out bit_vector(2*word_size-1 downto 0);
    zero: out bit
  );
end entity;

architecture arch_fdm of fdm is

  component contador is
    generic (
      word_size: positive := 4
    );
    port (
      clock, reset, load, enable: in bit;
      carga: in bit_vector(word_size-1 downto 0);
      saida: out bit_vector(word_size-1 downto 0);
      rco: out bit
    );
  end component;

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

  signal saidaA, saidaB, help: bit_vector(word_size-1 downto 0);
  signal soma, saidaR: bit_vector(2*word_size-1 downto 0);

begin

  regA: registrador_universal

    generic map(word_size)
    port map(clock, clearAB, '0', '1', loadA, '0', A, saidaA);

  regR: registrador_universal

    generic map(2*word_size)
    port map(clock, clearR, '0', '1', loadR, '0', soma, saidaR);

  contB: contador

    generic map(word_size)
    port map(clock, clearAB, loadB, enableB, B, saidaB, zero);

    help <= (others => '0');

    soma <= bit_vector(unsigned(help&saidaA) + unsigned(saidaR));

    resultado <= saidaR;

end architecture;

library ieee;
use ieee.numeric_bit.all;

entity ucm is
  port(
      clock, reset, vai, zero: in bit;
      loadA, loadR: out bit_vector(1 downto 0);
      loadB, clearR, enableB, pronto: out bit
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

      S3 when atual = S2 and zero = '0' else

      S4 when atual = S2 and zero = '1' else

      S2 when atual = S3 else

      S0;

  loadA <= "11"  when atual = S1 else "00";

  loadB <= '1'   when atual = S1 else '0';

  clearR <= '1'  when atual = S1 else '0';

  loadR <= "11"  when atual = S3 else "00";

  enableB <= '1' when atual = S3 or atual = S1 else '0';

  pronto <= '1'  when atual = S4 else '0';

end architecture;

library ieee;
use ieee.numeric_bit.all;

entity multiplicador is
  generic(
    word_size: positive
  );
  port (
    clock, reset, vai: in bit;
    pronto: out bit;
    A, B: in bit_vector(word_size-1 downto 0);
    resultado: out bit_vector(2*word_size-1 downto 0)
  );
end entity;

architecture archtop of multiplicador is

  component fdm is
    generic (
      word_size: positive
    );
    port (
      clock, clearAB, clearR: in bit;
      loadA, loadR: in bit_vector(1 downto 0);
      loadB, enableB: in bit;
      A, B: in bit_vector(word_size-1 downto 0);
      resultado: out bit_vector(2*word_size-1 downto 0);
      zero: out bit
    );
  end component;

  component ucm is
    port(
        clock, reset, vai, zero: in bit;
        loadA, loadR: out bit_vector(1 downto 0);
        loadB, clearR, enableB, pronto: out bit
    );
  end component;

  signal clear_R, load_B, enable_B, nought: bit;
  signal load_A, load_R: bit_vector(1 downto 0);

begin

  fluxo: fdm
    generic map (word_size)
    port map(clock, reset, clear_R, load_A, load_R, load_B, enable_B, A, B, resultado, nought);
  controle: ucm
    port map(clock, reset, vai, nought, load_A, load_R, load_B, clear_R, enable_B, pronto);

end architecture;
