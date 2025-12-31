library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity extRAM is
port(
clk : in std_logic;
we : in std_logic;
addr: in std_logic_vector(7 downto 0);
din : in std_logic_vector(7 downto 0);
dout: out std_logic_vector(7 downto 0)
);
end extRAM;


architecture arc of extRAM is
type ram_type is array (0 to 255) of std_logic_vector(7 downto 0);
signal RAM : ram_type := (
0 => "00000001", 1 => "00101000", 2 => "00000000",
3 => "00000010", 4 => "00101011", 5 => "00000000",
6 => "00000011", 7 => "00001010", 8 => "00001111",
9 => "00001110", 10 => "00001000", 11 => "00001001",
12 => "00000100", 13 => "00000101", 14 => "00011000",
24 => "00000111", 25 => "00100000",
27 => "00001111", 28 => "00000111",
32 => "00001011", 33 => "00000110", 34 => "00011000",
40 => "01111010",
others => (others=>'0'));
begin
process(clk)
begin
if rising_edge(clk) then
if we='1' then
RAM(conv_integer(addr)) <= din;
end if;
dout <= RAM(conv_integer(addr));
end if;
end process;
end arc;