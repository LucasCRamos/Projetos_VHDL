entity registrador_universal_tb is
end entity;

architecture teste of registrador_universal_tb is

component registrador_universal is
generic (
word_size: positive := 4
);
port (
clock, clear, set, enable: in bit;
control: in bit_vector(1 downto 0);
serial_input: in bit;
parallel_input: in bit_vector(3 downto 0);
parallel_output: out bit_vector(3 downto 0)
);
end component;

signal clock, clear, set, enable, simula: bit;
signal control: bit_vector(1 downto 0);
signal serial_input: bit;
signal parallel_input, parallel_output: bit_vector(3 downto 0);

begin

dut:registrador_universal port map(clock,clear,set,enable,control,serial_input,parallel_input,parallel_output);

clock <= (simula and not clock) after 1 ns;

teste: process

begin

  simula <= '1';

  report "BOT";

  clear<='1'; set<='1';
  wait for 1 ns;
  assert parallel_output="0000" report "Caso 1 falhou!" severity warning;
  
  clear<='0'; set<='1';
  wait for 1 ns;
  assert parallel_output="1111" report "Caso 2 falhou!" severity warning;

  clear<='0'; set<='0'; enable<='1'; control<="11"; parallel_input<="1011";
  wait for 2 ns;
  control<="01"; serial_input<='1';
  wait for 4 ns;
  assert parallel_output="1101" report "Caso 3 falhou!" severity warning;

  clear<='0'; set<='0'; enable<='1'; control<="11"; parallel_input<="1011";
  wait for 2 ns;
  control<="01"; serial_input<='0';
  wait for 4 ns;
  assert parallel_output="0101" report "Caso 4 falhou!" severity warning;
  
  clear<='0'; set<='0'; enable<='1'; control<="11"; parallel_input<="1011"; serial_input<='0';
  wait for 2 ns;
  assert parallel_output="1011" report "Caso 5 falhou!" severity warning;

  report "EOT";

  simula <= '0';

  wait;

end process;

end architecture;
