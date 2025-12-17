library ieee;
use ieee.std_logic_1164.all;


entity state_decoder is
port(
Din : in std_logic_vector(2 downto 0);
Dout : out std_logic_vector(7 downto 0)
);
end state_decoder;


architecture rtl of state_decoder is
begin
process(Din)
begin
Dout <= (others => '0');
case Din is
when "000" => Dout(0) <= '1'; -- T0
when "001" => Dout(1) <= '1'; -- T1
when "010" => Dout(2) <= '1'; -- T2
when "011" => Dout(3) <= '1'; -- T3
when "100" => Dout(4) <= '1'; -- T4
when "101" => Dout(5) <= '1'; -- T5
when "110" => Dout(6) <= '1'; -- T6
when "111" => Dout(7) <= '1'; -- T7
when others => null;
end case;
end process;
end rtl;