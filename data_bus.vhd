library ieee;
use ieee.std_logic_1164.all;

entity data_bus is

port(

AR_in, PC_in : in std_logic_vector(15 downto 0);
DR_in, TR_in, R_in, AC_in, MEM_in : in std_logic_vector(7 downto 0);

PCBUS, DRBUS, TRBUS, RBUS, ACBUS, MEMBUS : in std_logic;
BUS_OUT : out std_logic_vector(7 downto 0)
);

end data_bus;



architecture behavioral of data_bus is

begin

BUS_OUT <= PC_in(7 downto 0) WHEN PCBUS = '1' ELSE
DR_in WHEN DRBUS = '1' ELSE
TR_in WHEN TRBUS = '1' ELSE
R_in WHEN RBUS  = '1' ELSE
AC_in WHEN ACBUS = '1' ELSE
MEM_in WHEN MEMBUS= '1' ELSE
(others => '0'); -- Default case

end behavioral;