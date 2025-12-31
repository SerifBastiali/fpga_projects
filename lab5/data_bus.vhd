library ieee;
use ieee.std_logic_1164.all;

entity data_bus is
port(
    ARout, PCout, DRout, ACout, RRout, TRout : in std_logic_vector(7 downto 0);
    memout : in std_logic_vector(7 downto 0);
    sel    : in std_logic_vector(2 downto 0);
    dataBus : out std_logic_vector(7 downto 0)
);
end data_bus;

architecture arc of data_bus is
begin
process(sel, ARout, PCout, DRout, ACout, TRout, RRout, memout)
begin
    case sel is
        when "000" => dataBus <= ARout;
        when "001" => dataBus <= PCout;
        when "010" => dataBus <= DRout;
        when "011" => dataBus <= ACout;
        when "100" => dataBus <= TRout;
        when "101" => dataBus <= RRout;
        when "110" => dataBus <= memout;
        when others => dataBus <= (others => 'Z');
    end case;
end process;
end arc;
