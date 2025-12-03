library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.mseqlib.all;

entity mseq is
    port(
        ir          : in std_logic_vector(3 downto 0);
        clock, reset: in std_logic;
        z           : in std_logic;
        code        : out std_logic_vector(35 downto 0);
        mOPs        : out std_logic_vector(26 downto 0)
    );
end mseq;


architecture arc of mseq is


    signal microcode  : std_logic_vector(35 downto 0);
    signal addr_rom   : std_logic_vector(5 downto 0);
    signal addr_next  : std_logic_vector(5 downto 0);

    signal sel        : std_logic_vector(2 downto 0);
    signal sel_mux    : std_logic_vector(1 downto 0);
    signal addr_field : std_logic_vector(5 downto 0);

    signal ir_addr    : std_logic_vector(5 downto 0);
    signal z_addr     : std_logic_vector(5 downto 0);
    signal zero      : std_logic_vector(5 downto 0);

    signal ld_sig, inc_sig : std_logic;

begin

    zero <= (others => '0');

    -- Microcode ROM

    rom_inst : mseq_rom
        port map(
            address => addr_rom,
            clock   => clock,
            q       => microcode
        );

    code  <= microcode;
    mOPs  <= microcode(35 downto 9);

    sel        <= microcode(8 downto 6);
    sel_mux    <= microcode(7 downto 6);     
    addr_field <= microcode(5 downto 0);



    -- Address sources for the multiplexer


    ir_addr <= "00" & ir;
    z_addr  <= addr_field when z='1' else addr_rom;  -- fallback

    -- 4:1 multiplexer for next address selection

    mux_inst : mux4
        generic map( n => 6 )
        port map(
            d0  => addr_rom,
            d1  => addr_field,
            d2  => ir_addr,
            d3  => z_addr,
            sel => sel_mux,
            y   => addr_next
        );



    -- Program counter register for microinstructions

    pc_inst : regnbit
        generic map( n => 6 )
        port map(
            din    => addr_next,		  
            clk  => clock,
            rst  => reset,
            ld => ld_sig,
				inc => inc_sig,
            dout    => addr_rom
        );

end arc;
