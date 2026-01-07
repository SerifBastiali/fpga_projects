library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_cpu is
end tb_cpu;

architecture sim of tb_cpu is
  signal ARdata, PCdata : std_logic_vector(15 downto 0);
  signal DRdata, ACdata : std_logic_vector(7 downto 0);
  signal IRdata, TRdata : std_logic_vector(7 downto 0);
  signal RRdata         : std_logic_vector(7 downto 0);
  signal ZRdata         : std_logic;
  signal clock, reset   : std_logic := '0';
  signal MOP            : std_logic_vector(31 downto 0);
  signal addressBus     : std_logic_vector(15 downto 0);
  signal cpu_data_bus   : std_logic_vector(7 downto 0);
begin

  -- Clock: 20 ns period
  clock <= not clock after 10 ns;

  DUT: entity work.rs_cpu
    port map(
      ARdata => ARdata, PCdata => PCdata,
      DRdata => DRdata, ACdata => ACdata,
      IRdata => IRdata, TRdata => TRdata,
      RRdata => RRdata,
      ZRdata => ZRdata,
      clock  => clock,
      reset  => reset,
      MOP    => MOP,
      addressBus => addressBus,
      cpu_data_bus => cpu_data_bus
    );

  process
  begin
    -- reset
    reset <= '1';
    wait for 60 ns;
    reset <= '0';

    -- run some cycles
    wait for 3000 ns;

    assert false report "Simulation finished" severity failure;
  end process;

end sim;