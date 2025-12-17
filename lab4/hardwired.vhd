library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


use work.hardwiredlib.all;


entity hardwired is
port(
ir : in std_logic_vector(3 downto 0);
clock, reset : in std_logic;
z : in std_logic;
mOPs : out std_logic_vector(26 downto 0)
);
end hardwired;


architecture arc of hardwired is


-- Instruction & state decoding
signal I : std_logic_vector(15 downto 0);
signal T : std_logic_vector(7 downto 0);
signal tc : std_logic_vector(2 downto 0);
signal inc_tc, clr_tc : std_logic;


-- FETCH states
signal FETCH1, FETCH2, FETCH3 : std_logic;
-- Instruction states
signal LDAC1,LDAC2,LDAC3,LDAC4,LDAC5 : std_logic;
signal STAC1,STAC2,STAC3,STAC4,STAC5 : std_logic;
signal ADD1,SUB1,INAC1,CLAC1,MVAC1 : std_logic;
signal AND1,OR1,XOR1,NOT1 : std_logic;
signal JUMP1,JUMP2,JUMP3 : std_logic;
signal JMPZY1,JMPZY2,JMPZY3 : std_logic;
signal JMPZN1,JMPZN2 : std_logic;
signal JPNZY1,JPNZY2,JPNZY3 : std_logic;
signal JPNZN1,JPNZN2 : std_logic;


begin


ID: instr_decoder port map(ir, I);
SD: state_decoder port map(tc, T);
TC_1: counter3 port map(clock, clr_tc, inc_tc, tc);


-- FETCH
FETCH1 <= T(0);
FETCH2 <= T(1);
FETCH3 <= T(2);


-- Instruction states
LDAC1 <= I(1) and T(3); LDAC2 <= I(1) and T(4); LDAC3 <= I(1) and T(5);
LDAC4 <= I(1) and T(6); LDAC5 <= I(1) and T(7);


STAC1 <= I(2) and T(3); STAC2 <= I(2) and T(4); STAC3 <= I(2) and T(5);
STAC4 <= I(2) and T(6); STAC5 <= I(2) and T(7);


ADD1 <= I(3) and T(3); SUB1 <= I(4) and T(3);
INAC1 <= I(5) and T(3); CLAC1 <= I(6) and T(3);
MVAC1 <= I(7) and T(3);


AND1 <= I(9) and T(3); OR1 <= I(10) and T(3);
XOR1 <= I(11) and T(3); NOT1 <= I(12) and T(3);


JUMP1 <= I(13) and T(3); JUMP2 <= I(13) and T(4); JUMP3 <= I(13) and T(5);


JMPZY1 <= I(14) and z and T(3); JMPZY2 <= I(14) and z and T(4); JMPZY3 <= I(14) and z and T(5);
JMPZN1 <= I(14) and not z and T(3); JMPZN2 <= I(14) and not z and T(4);


JPNZY1 <= I(15) and not z and T(3); JPNZY2 <= I(15) and not z and T(4); JPNZY3 <= I(15) and not z and T(5);
JPNZN1 <= I(15) and z and T(3); JPNZN2 <= I(15) and z and T(4);


-- Counter control
clr_tc <= LDAC5 or STAC5 or JUMP3 or JMPZY3 or JPNZY3;
inc_tc <= not clr_tc;


-- =============
-- mOPs mapping 
-- =============


mOPs(0) <= FETCH1 or FETCH3 or LDAC3 or STAC3; -- ARLOAD
mOPs(1) <= LDAC1 or STAC1 or JMPZY1 or JPNZY1; -- ARINC
mOPs(2) <= JUMP3 or JMPZY3 or JPNZY3; -- PCLOAD
mOPs(3) <= FETCH2 or LDAC1 or LDAC2 or STAC1 or STAC2 or JMPZN1 or JMPZN2 or JPNZN1 or JPNZN2; -- PCINC
mOPs(4) <= FETCH2 or LDAC1 or LDAC2 or LDAC4 or STAC1 or STAC2 or STAC4 or JUMP1 or JUMP2 or JMPZY1 or JMPZY2 or JPNZY1 or JPNZY2; -- DRLOAD
mOPs(5) <= LDAC2 or STAC2 or JUMP2 or JMPZY2 or JPNZY2; -- TRLOAD
mOPs(6) <= FETCH3; -- IRLOAD
mOPs(7) <= MVAC1; -- RLOAD
mOPs(8) <= LDAC5 or MVAC1 or ADD1 or SUB1 or INAC1 or CLAC1 or AND1 or OR1 or XOR1 or NOT1; -- ACLOAD
mOPs(9) <= LDAC5 or MVAC1 or ADD1 or SUB1 or INAC1 or CLAC1 or AND1 or OR1 or XOR1 or NOT1; -- ZLOAD
mOPs(10) <= FETCH2 or LDAC1 or LDAC2 or LDAC4 or STAC1 or STAC2 or JUMP1 or JUMP2 or JMPZY1 or JMPZY2 or JPNZY1 or JPNZY2; -- READ
mOPs(11) <= STAC5; -- WRITE
mOPs(12) <= FETCH2 or LDAC1 or LDAC2 or LDAC4 or STAC1 or STAC2 or JUMP1 or JUMP2 or JMPZY1 or JMPZY2 or JPNZY1 or JPNZY2; -- MEMBUS
mOPs(13) <= STAC5; -- BUSMEM
mOPs(14) <= FETCH1 or FETCH3; -- PCBUS
mOPs(15) <= LDAC2 or LDAC3 or LDAC5 or STAC2 or STAC3 or STAC5 or JUMP2 or JUMP3 or JMPZY2 or JMPZY3 or JPNZY2 or JPNZY3; -- DRBUS
mOPs(16) <= LDAC3 or STAC3 or JUMP3 or JMPZY3 or JPNZY3; -- TRBUS
mOPs(17) <= MVAC1 or ADD1 or SUB1 or AND1 or OR1 or XOR1; -- RBUS
mOPs(18) <= STAC4 or MVAC1; -- ACBUS
mOPs(19) <= AND1; -- ANDOP
mOPs(20) <= OR1; -- OROP
mOPs(21) <= XOR1; -- XOROP
mOPs(22) <= NOT1; -- NOTOP
mOPs(23) <= INAC1; -- ACINC
mOPs(24) <= CLAC1; -- ACZERO
mOPs(25) <= ADD1; -- PLUS
mOPs(26) <= SUB1; -- MINUS


end arc;