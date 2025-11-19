library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.alulib.all;

entity alu is
    generic (n : integer := 8);
    port(
        ac   : in  std_logic_vector(n-1 downto 0);
        db   : in  std_logic_vector(n-1 downto 0);
        alus : in  std_logic_vector(7 downto 1);
        dout : out std_logic_vector(n-1 downto 0)
    );
end alu;

architecture arch of alu is


    -- Internal signals
    signal ac_sel     : std_logic_vector(n-1 downto 0);
    signal db_sel     : std_logic_vector(n-1 downto 0);
    signal addsub_res : std_logic_vector(n-1 downto 0);
    signal logic_res  : std_logic_vector(n-1 downto 0);
    signal final_res  : std_logic_vector(n-1 downto 0);
    signal cout_addsub: std_logic;

begin
    --------------------------------------------------------------------
    -- MUX1 (2→1): AC or zero
    -- Select signal: ALUS(1)
    --------------------------------------------------------------------
    MUX1_AC : mux2
        generic map(n)
        port map(
            d0  => ac,
            d1  => (others => '0'),
            sel => alus(1),
            y   => ac_sel
        );

    --------------------------------------------------------------------
    -- MUX2 (4→1 but used as 3→1): DB, DB', zero
    -- select = ALUS(3 downto 2)
    --------------------------------------------------------------------
    MUX2_DB : mux4
        generic map(n)
        port map(
            d0  => db,
            d1  => not db,
            d2  => (others => '0'),
            d3  => (others => '0'),  -- unused
            sel => alus(3 downto 2),
            y   => db_sel
        );

    --------------------------------------------------------------------
    -- Arithmetic unit (ADD / SUB)
    --------------------------------------------------------------------
    ADD_SUB: adder8bit
        port map(
            a    => ac_sel,
            b    => db_sel,
            cin  => alus(4),
            s    => addsub_res,
            cout => cout_addsub
        );
	  
    --------------------------------------------------------------------
    -- Logic unit (AND, OR, XOR, NOT)
    --------------------------------------------------------------------
    MUX3_LOGIC: mux4
        generic map(n)
        port map(
            d0  => ac and db,      -- AND
            d1  => ac or db,       -- OR
            d2  => ac xor db,      -- XOR
            d3  => not ac,         -- NOT
            sel => alus(7 downto 6),
            y   => logic_res
        );

    --------------------------------------------------------------------
    -- MUX4 (2→1): final selection between Arithmetic and Logic output
    -- ALUS(7)
    --------------------------------------------------------------------
    MUX_OUTPUT : mux2
        generic map(n)
        port map(
            d0 => addsub_res,
            d1 => logic_res,
            sel => alus(7),
            y   => final_res
        );

    dout <= final_res;

end arch;

