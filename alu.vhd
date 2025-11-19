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
    signal add_res    : std_logic_vector(n-1 downto 0);
    signal sub_res    : std_logic_vector(n-1 downto 0);
    signal logic_res  : std_logic_vector(n-1 downto 0);
    signal final_res  : std_logic_vector(n-1 downto 0);
    signal cout_add, cout_sub : std_logic;

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
    ADDER: adder8bit
        port map(
            a    => ac,
            b    => db,
            cin  => '0',
            s    => add_res,
            cout => cout_add
        );

    SUBBER: adder8bit
        port map(
            a    => ac,
            b    => not db,
            cin  => '1',
            s    => sub_res,
            cout => cout_sub
        );

    --------------------------------------------------------------------
    -- Logic unit (AND, OR, XOR, NOT)
    --------------------------------------------------------------------
    LOGIC_MUX: mux4
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
    -- Final multiplexer
    --------------------------------------------------------------------
    with alus select
        final_res <= 
            add_res      when "0000001",  -- ADD
            sub_res      when "0000011",  -- SUB
            logic_res    when others;     -- logical ops

    dout <= final_res;

end arch;
