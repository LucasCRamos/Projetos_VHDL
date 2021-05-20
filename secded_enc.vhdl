entity secded_enc16 is
port (
u_data: in bit_vector(15 downto 0);
mem_data: out bit_vector(21 downto 0)
);
end entity;

architecture arch of secded_enc16 is

  signal aux0,aux1,aux3,aux7,aux15: bit;

begin

  aux0 <= u_data(15) xor u_data(13) xor u_data(11) xor u_data(10) xor u_data(8) xor u_data(6) xor u_data(4) xor u_data(3) xor u_data(1) xor u_data(0);

  mem_data(0) <= aux0;

  aux1 <= u_data(13) xor u_data(12) xor u_data(10) xor u_data(9) xor u_data(6) xor u_data(5) xor u_data(3) xor u_data(2) xor u_data(0);

  mem_data(1) <= aux1;

  mem_data(2) <= u_data(0);

  aux3 <= u_data(15) xor u_data(14) xor u_data(10) xor u_data(9) xor u_data(8) xor u_data(7) xor u_data(3) xor u_data(2) xor u_data(1);

  mem_data(3) <= aux3;

  mem_data(4) <= u_data(1);

  mem_data(5) <= u_data(2);

  mem_data(6) <= u_data(3);

  aux7 <= u_data(10) xor u_data(9) xor u_data(8) xor u_data(7) xor u_data(6) xor u_data(5) xor u_data(4);

  mem_data(7) <= aux7;

  mem_data(8) <= u_data(4);

  mem_data(9) <= u_data(5);

  mem_data(10) <= u_data(6);

  mem_data(11) <= u_data(7);

  mem_data(12) <= u_data(8);

  mem_data(13) <= u_data(9);

  mem_data(14) <= u_data(10);

  aux15 <= u_data(15) xor u_data(14) xor u_data(13) xor u_data(12) xor u_data(11);

  mem_data(15) <= aux15;

  mem_data(16) <= u_data(11);

  mem_data(17) <= u_data(12);

  mem_data(18) <= u_data(13);

  mem_data(19) <= u_data(14);

  mem_data(20) <= u_data(15);

  mem_data(21) <= aux0 xor aux1 xor u_data(0) xor aux3 xor u_data(1) xor u_data(2) xor u_data(3) xor aux7 xor u_data(4) xor u_data(5) xor u_data(6) xor u_data(7) xor u_data(8) xor u_data(9) xor u_data(10) xor aux15 xor u_data(11) xor u_data(12) xor u_data(13) xor

  u_data(14) xor u_data(15);

end architecture;
