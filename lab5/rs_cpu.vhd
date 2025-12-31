library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.cpulib.all;


entity rs_cpu is
port(
ARdata,PCdata : buffer std_logic_vector(15 downto 0);
DRdata,ACdata : buffer std_logic_vector(7 downto 0);
IRdata,TRdata : buffer std_logic_vector(7 downto 0);
RRdata : buffer std_logic_vector(7 downto 0);
ZRdata : buffer std_logic;
clock,reset : in std_logic;
mOP : buffer std_logic_vector(26 downto 0);
addressBus : buffer std_logic_vector(15 downto 0);
dataBus : buffer std_logic_vector(7 downto 0)
);
end rs_cpu;


architecture arc of rs_cpu is
signal memout : std_logic_vector(7 downto 0);
begin
MEM: extRAM port map(clock,'0',PCdata(7 downto 0),dataBus,memout);


process(clock,reset)
begin
if reset='1' then
PCdata <= (others=>'0');
ACdata <= (others=>'0');
ZRdata <= '0';
elsif rising_edge(clock) then
IRdata <= memout;
PCdata <= PCdata + 1;
end if;
end process;
end arc;