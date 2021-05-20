library IEEE;
use ieee.numeric_bit.all;
use ieee.math_real.all;

entity secded_dec16 is
port (
mem_data: in bit_vector(21 downto 0);
u_data: out bit_vector(15 downto 0);
syndrome: out natural;
two_errors: out bit;
one_error: out bit
);
end entity;

architecture arch of secded_dec16 is

  signal e0, e1, e2, e3, e4, e5: bit;

  signal syn: natural;

  signal aux: bit_vector(4 downto 0);

begin

e0 <= mem_data(0) xor mem_data(20) xor mem_data(18) xor mem_data(16) xor mem_data(14) xor mem_data(12) xor mem_data(10) xor mem_data(8) xor mem_data(6) xor mem_data(4) xor mem_data(2);


e1 <= mem_data(1) xor mem_data(18) xor mem_data(17) xor mem_data(14) xor mem_data(13) xor mem_data(10) xor mem_data(9) xor mem_data(6) xor mem_data(5) xor mem_data(2);


e2  <= mem_data(3) xor mem_data(20) xor mem_data(19) xor mem_data(14) xor mem_data(13) xor mem_data(12) xor mem_data(11) xor mem_data(6) xor mem_data(5) xor mem_data(4);


e3 <= mem_data(7) xor mem_data(14) xor mem_data(13) xor mem_data(12) xor mem_data(11) xor mem_data(10) xor mem_data(9) xor mem_data(8);


e4 <= mem_data(15) xor mem_data(20) xor mem_data(19) xor mem_data(18) xor mem_data(17) xor mem_data(16);


e5 <= mem_data(0) xor mem_data(1) xor mem_data(2) xor mem_data(3) xor mem_data(4) xor mem_data(5) xor mem_data(6) xor mem_data(7) xor mem_data(8) xor mem_data(9) xor mem_data(10) xor mem_data(11) xor mem_data(12) xor mem_data(13) xor

mem_data(14) xor mem_data(15) xor mem_data(16) xor mem_data(17) xor mem_data(18) xor mem_data(19) xor mem_data(20) xor mem_data(21);


aux(0) <= e0;
aux(1) <= e1;
aux(2) <= e2;
aux(3) <= e3;
aux(4) <= e4;


syn <= 0 when aux = "00000" else
1 when aux = "00001" else
2 when aux = "00010" else
3 when aux = "00011" else
4 when aux = "00100" else
5 when aux = "00101" else
6 when aux = "00110" else
7 when aux = "00111" else
8 when aux = "01000" else
9 when aux = "01001" else
10 when aux = "01010" else
11 when aux = "01011" else
12 when aux = "01100" else
13 when aux = "01101" else
14 when aux = "01110" else
15 when aux = "01111" else
16 when aux = "10000" else
17 when aux = "10001" else
18 when aux = "10010" else
19 when aux = "10011" else
20 when aux = "10100" else
21 when aux = "10101" else
22;

syndrome <= syn;

one_error <= '1' when e5 ='1' else '0';

two_errors <= '1' when e5 ='0' and syn /= 0 else '0';

u_data(0) <= mem_data(2) when syn /= 3 else not (mem_data(2));
u_data(1) <= mem_data(4) when syn /= 5 else not (mem_data(4));
u_data(2) <= mem_data(5) when syn /= 6 else not (mem_data(5));
u_data(3) <= mem_data(6) when syn /= 7 else not (mem_data(6));
u_data(4) <= mem_data(8) when syn /= 9 else not (mem_data(8));
u_data(5) <= mem_data(9) when syn /= 10 else not (mem_data(9));
u_data(6) <= mem_data(10) when syn /= 11 else not (mem_data(10));
u_data(7) <= mem_data(11) when syn /= 12 else not (mem_data(11));
u_data(8) <= mem_data(12) when syn /= 13 else not (mem_data(12));
u_data(9) <= mem_data(13) when syn /= 14 else not (mem_data(13));
u_data(10) <= mem_data(14) when syn /= 15 else not (mem_data(14));
u_data(11) <= mem_data(16) when syn /= 17 else not (mem_data(16));
u_data(12) <= mem_data(17) when syn /= 18 else not (mem_data(17));
u_data(13) <= mem_data(18) when syn /= 19 else not (mem_data(18));
u_data(14) <= mem_data(19) when syn /= 20 else not (mem_data(19));
u_data(15) <= mem_data(20) when syn /= 21 else not (mem_data(20));


end architecture;
