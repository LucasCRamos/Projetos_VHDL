entity gray2bin is
generic (
size: natural := 3
);
port (
gray: in bit_vector(size-1 downto 0);
bin: out bit_vector(size-1 downto 0)
);
end entity;

architecture arch of gray2bin is

  signal aux: bit_vector(size-1 downto 0);

  begin

    aux(size-1)<=gray(size-1);

    aux(size-2 downto 0) <= aux(size-1 downto 1) xor gray(size-2 downto 0);

    bin<=aux;

end architecture;
