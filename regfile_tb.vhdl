library ieee;
use ieee.numeric_bit.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

entity regfile_tb is 
end regfile_tb;

architecture arch_reg_tb of regfile_tb is
    component regfile is
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
    end component;

    constant regnAux : natural := 8; -- bit size
    constant wordSizeAux : natural := 9; -- bit size
    constant periodoClock: time := 1 ns;

    signal stopc,clock: bit := '0';
    signal reset, regWrite: bit;
    signal rr1, rr2, wr: bit_vector(natural(ceil(log2(real(regnAux))))-1 downto 0);
    signal d, q1, q2: bit_vector(wordSizeAux-1 downto 0);

begin

clock <= stopc and (not clock) after periodoClock/2;
     
  test: regfile
  generic map(
    regn => regnAux,
    wordSize => wordSizeAux
  )
  port map(clock,reset,regWrite,rr1,rr2,wr,d,q1,q2);

  st: process is

  begin

    stopc <= '1';

    assert false report "BOT" severity note;

    reset <= '0';
    regWrite <= '1';
    d <= "000101011";
    wr <= "111";
    rr1 <= "111";

    wait until rising_edge(clock);

    d <= "000101011";
    wr <= "001";
    rr2 <= "001";

    wait for 5 ns;

    reset <= '1';

    d <= "000101011";
    wr <= "110";
    rr1 <= "110";

    report "EOT";

    stopc <= '0';
    wait;

  end process;

end architecture;