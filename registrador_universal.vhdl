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

signal aux: bit_vector(word_size-1 downto 0);

  begin

    process(clock,clear,set)

    begin

      if(clear = '1') then --> força saida para 0

        aux <= (others => '0');

        parallel_output <= aux;

      elsif (set = '1') then --> caso clear nao esteja ativado, força saida para 1

        aux <= (others => '1');
        
        parallel_output <= aux;

      else

        if rising_edge(clock) then --> na borda de subida do clock...

          if (enable = '1') then --> se enable eh 1, vai depender do control

            if (control = "01") then --> deslocamento pra direita

              aux(word_size-2 downto 0) <= parallel_input(word_size-1 downto 1);

              aux(word_size-1) <= serial_input;

              parallel_output <= aux;

            elsif (control = "10") then --> deslocamento pra esquerda

              aux(word_size-1 downto 1) <= parallel_input(word_size-2 downto 0);

              aux(0) <=  serial_input;

              parallel_output <= aux;

            elsif (control = "11") then --> carga paralela

            parallel_output <= aux;

            end if; --> fecha os if's do control

          end if; --> fecha if do enable

      end if; --> fecha if do rising_edge

    end if; --> fecha os if's das entradas assincronas

  end process; --> fecha process

end architecture;
