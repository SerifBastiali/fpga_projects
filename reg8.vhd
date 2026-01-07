library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity reg8 is

port(

clk, rst, ld, inc, clr : in std_logic; -- Added clr for ACZERO
d : in std_logic_vector(7 downto 0);
q : out std_logic_vector(7 downto 0)

);

end reg8;

architecture rtl of reg8 is

signal temp : std_logic_vector(7 downto 0);
	 
begin

process(clk, rst)

begin

IF rst = '1' THEN
temp <= (others => '0');
ELSIF rising_edge(clk) THEN
IF clr = '1' THEN        -- Synchronous Clear
temp <= (others => '0');
ELSIF ld = '1' THEN
temp <= d;
ELSIF inc = '1' THEN
temp <= temp + 1;
end IF;

end IF;

end process;

q <= temp;
	 
end rtl;