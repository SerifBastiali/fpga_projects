LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE cpulib IS

COMPONENT hardwired IS
        PORT (
            ir           : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            clock, reset : IN  STD_LOGIC;
            z            : IN  STD_LOGIC;
            mOPs         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

COMPONENT decoder4to16 IS

PORT(

Din : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
Dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);

END COMPONENT;

COMPONENT decoder3to8 IS

PORT(

Din : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
Dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);

END COMPONENT;

COMPONENT counter3bit IS

PORT(
clock, rst, inc : IN STD_LOGIC;
count : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
);

END COMPONENT;

COMPONENT alus IS

PORT ( rbus, acload, zload, andop, orop, notop, xorop, aczero, acinc, plus, minus, drbus : IN STD_LOGIC;
alus_out : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
);

END COMPONENT;


COMPONENT data_bus IS
PORT(
  AR_IN, PC_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
  DR_IN, TR_IN, R_IN, AC_IN, MEM_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  PCBUS, DRBUS, TRBUS, RBUS, ACBUS, MEMBUS : IN STD_LOGIC;
  BUS_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END COMPONENT;


COMPONENT ram

PORT (

address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
clock   : IN STD_LOGIC  := '1';
data    : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
wren    : IN STD_LOGIC;
q       : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)

);

end component;


-- 16-bit register
COMPONENT reg16 IS
PORT(
  clk, rst, ld, inc, dec : IN STD_LOGIC;
  d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
  q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END COMPONENT;


-- 8-bit register
COMPONENT reg8 IS
PORT(
  clk, rst, ld, inc, clr : IN STD_LOGIC;
  d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END COMPONENT;


COMPONENT reg1 IS

PORT(
clk, rst, ld : IN STD_LOGIC;
d : IN STD_LOGIC;
q : OUT STD_LOGIC
);
END COMPONENT;

END PACKAGE cpulib;