library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package mseqlib is

    component mseq_rom
        port(
            address : in std_logic_vector(5 downto 0);
            clock   : in std_logic;
            q       : out std_logic_vector(35 downto 0)
        );
    end component;

    component regnbit
        generic( n : integer := 6 );
        port(
				din				: in std_logic_vector(n-1 downto 0);
				clk,rst,ld		: in std_logic;
				inc			   : in std_logic;
				dout				: out std_logic_vector(n-1 downto 0)
        );
    end component;

    component mux4 is
        generic (n : integer := 6 );
        port(
            d0, d1, d2, d3 : in  std_logic_vector(n-1 downto 0);
            sel           : in  std_logic_vector(1 downto 0);
            y             : out std_logic_vector(n-1 downto 0)
        );
    end component;

end mseqlib;
