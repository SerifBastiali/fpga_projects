library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity reg16 is
    port(
        clk, rst, ld, inc, dec : in std_logic;
        d : in std_logic_vector(15 downto 0);
        q : out std_logic_vector(15 downto 0)
    );
end reg16;

architecture rtl of reg16 is
    signal temp : std_logic_vector(15 downto 0);
begin
    process(clk, rst)
    begin
        IF rst = '1' THEN
            temp <= (others => '0'); -- Asynchronous Reset
        ELSIF rising_edge(clk) THEN
           IF ld = '1' THEN
    temp <= d;
ELSIF inc = '1' THEN
    temp <= temp + 1;
ELSIF dec = '1' THEN
    temp <= temp - 1;
end IF;

        end IF;
    end process;
    q <= temp;
end rtl;