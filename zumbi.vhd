library ieee;
use ieee.numeric_bit;

entity zumbi is
port(
clock, reset: in bit;
x: in bit_vector(1 downto 0);
z: out bit
);
end entity;

architecture estrutural of zumbi is
component ffd is
port (
clock, clear, set: in bit;
d: in bit;
q, q_n: out bit
);
end component;

signal d1,d0,q1,q0,q1_n,q0_n: bit;

begin

ffd1: ffd port map (clock, reset, '0', d1, q1, q1_n);
ffd0: ffd port map (clock, reset, '0', d0, q0, q0_n);

d0 <= (not(x(1)) and x(0)) or (x(0) and q0);

d1 <= (x(1) and not(x(0))) or (not(q1) and q0 and x(1)) or (x(1) and q1 and not(q0));

z <= q1;

end architecture;
