library ieee;
use ieee.std_logic_1164.all;


package cpulib is
component extRAM
port(clk,we: in std_logic;
addr: in std_logic_vector(7 downto 0);
din: in std_logic_vector(7 downto 0);
dout: out std_logic_vector(7 downto 0));
end component;


component alus
port(rbus,acload,zload,andop,orop,notop,xorop,aczero,acinc,plus,minus,drbus: in std_logic;
alus: out std_logic_vector(6 downto 0));
end component;


component data_bus
port(ARout, PCout, DRout, ACout, RRout,TRout  : in std_logic_vector(7 downto 0);
memout : in std_logic_vector(7 downto 0);
sel : in std_logic_vector(2 downto 0);
databus : out std_logic_vector(7 downto 0));
end component;
end package;