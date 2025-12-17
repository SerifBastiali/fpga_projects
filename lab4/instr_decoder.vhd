library ieee;
use ieee.std_logic_1164.all;


entity instr_decoder is
port(
Din : in std_logic_vector(3 downto 0);
Dout : out std_logic_vector(15 downto 0)
);
end instr_decoder;


architecture rtl of instr_decoder is
begin
process(Din)
begin
Dout <= (others => '0');
case Din is
when "0000" => Dout(0) <= '1'; -- NOP
when "0001" => Dout(1) <= '1'; -- LDAC
when "0010" => Dout(2) <= '1'; -- STAC
when "0011" => Dout(3) <= '1'; -- ADD
when "0100" => Dout(4) <= '1'; -- SUB
when "0101" => Dout(5) <= '1'; -- INAC
when "0110" => Dout(6) <= '1'; -- CLAC
when "0111" => Dout(7) <= '1'; -- MVAC
when "1000" => Dout(8) <= '1'; -- MOVR
when "1001" => Dout(9) <= '1'; -- AND
when "1010" => Dout(10) <= '1'; -- OR
when "1011" => Dout(11) <= '1'; -- XOR
when "1100" => Dout(12) <= '1'; -- NOT
when "1101" => Dout(13) <= '1'; -- JUMP
when "1110" => Dout(14) <= '1'; -- JMPZ
when "1111" => Dout(15) <= '1'; -- JPNZ
when others => null;
end case;
end process;
end rtl;