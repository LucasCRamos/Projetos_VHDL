entity onebit is
  port(
    a0, b0, cin, less, Ainvert, Binvert : in bit;
    operacao : in bit_vector(1 downto 0);
    resultado, cout, overflow, set: out bit
  );

end entity onebit;

architecture arch_onebit of onebit is

  signal na0, nb0, opsum, opand, opor, a, b, o1, o2, o3, o4: bit;

  signal overflow_temp: bit;

  begin

  resultado <= opand when operacao = "00" else
    opor when operacao = "01" else
    opsum when operacao = "10" else
    less;

  na0 <= not (a0);
  a <= a0 when Ainvert = '0' else na0;

  nb0 <= not (b0);
  b <= b0 when Binvert = '0' else nb0;

  opand <= a and b;
  opor <= a or b;

  opsum <= (a and (not b) and (not cin)) or ((not a) and b and (not cin)) or ((not a) and (not b) and cin) or (a and b and cin);
  cout <= (b and cin) or (a and cin) or (a and b);


  o1 <= (not Binvert) and (not a) and (not b) and opsum;
  o2 <= (not Binvert) and a and b and (not opsum);
  o3 <= Binvert and (not a) and (not b) and opsum;
  o4 <= Binvert and a and b and (not opsum);

  overflow_temp <= (o1 or o2 or o3 or o4);

  overflow <= overflow_temp;

  set <= opsum when overflow_temp = '0' else not(opsum);

end arch_onebit;

entity alu is
  generic(
    size : natural := 10 -- bit size
  );
  port(
    A, B : in bit_vector (size-1 downto 0); -- inputs
    F : out bit_vector(size-1 downto 0); -- output
    S : in bit_vector(3 downto 0); -- opselection
    Z : out bit; -- zeroflag
    Ov : out bit ; -- overflowflag
    Co : out bit -- carryout
  );
end entity alu;

architecture arch_alu of alu is

    component onebit is
      port(
        a0, b0, cin, less, Ainvert, Binvert : in bit;
        operacao : in bit_vector(1 downto 0);
        resultado, cout, overflow, set: out bit
      );

    end component;

    signal resAux, coutAux, overflowAux, setAux, zeroAux: bit_vector (size-1 downto 0);

    begin

      map1: onebit port map(

        a0 => A(0),
        b0 => B(0),
        cin => S(2),
        less => setAux(size-1),
        Ainvert => S(3),
        Binvert => S(2),
        operacao => S(1 downto 0),
        resultado => resAux(0),
        cout => coutAux(0),
        overflow => overflowAux(0),
        set => setAux(0)
      );

      label1: for i in 1 to size-1 generate

      map2: onebit port map(

        a0 => A(i),
        b0 => B(i),
        cin => coutAux(i-1),
        less => '0',
        Ainvert => S(3),
        Binvert => S(2),
        operacao => S(1 downto 0),
        resultado => resAux(i),
        cout => coutAux(i),
        overflow => overflowAux(i),
        set => setAux(i)

        );

      end generate label1;

      Co <= coutAux(size-1);
      Ov <= overflowAux(size-1);
      F <= resAux;

      zeroAux(0) <= resAux(0) or resAux(1);

      label2: for j in 2 to size-1 generate

        zeroAux(j-1) <= zeroAux(j-2) or resAux(j);

      end generate label2;

      Z <= not zeroAux(size-2);

end arch_alu;
