library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.cpulib.all;

entity rs_cpu is
    port(
        ARdata, PCdata : buffer std_logic_vector(15 downto 0);
        DRdata, ACdata : buffer std_logic_vector(7 downto 0);
        IRdata, TRdata : buffer std_logic_vector(7 downto 0);
        RRdata         : buffer std_logic_vector(7 downto 0);
        ZRdata         : buffer std_logic;
        clock, reset   : in std_logic;
        MOP            : buffer std_logic_vector(31 downto 0);
        addressBus     : buffer std_logic_vector(15 downto 0);
        cpu_data_bus   : buffer std_logic_vector(7 downto 0)
    );
end rs_cpu;

architecture arc of rs_cpu is

    signal internal_bus_8bit  : std_logic_vector(7 downto 0);
    signal internal_bus_16bit : std_logic_vector(15 downto 0);
    signal mem_to_bus         : std_logic_vector(7 downto 0);
    signal alu_out            : std_logic_vector(7 downto 0);
    signal alu_ctrl           : std_logic_vector(6 downto 0);
    signal z_calc             : std_logic;

    signal SPdata    : std_logic_vector(15 downto 0);
    signal mem_addr8 : std_logic_vector(7 downto 0);
    signal mem_din   : std_logic_vector(7 downto 0);

begin

    -- 1. Control Unit
    CU_inST: hardwired port map(
        ir    => IRdata,
        z     => ZRdata,
        clock => clock,
        reset => reset,
        mOPs  => MOP
    );

    -- 2. Data Bus (8-bit)
    BUS_inST: data_bus port map(
        AR_in  => ARdata,
        PC_in  => PCdata,
        DR_in  => DRdata,
        TR_in  => TRdata,
        R_in   => RRdata,
        AC_in  => ACdata,
        MEM_in => mem_to_bus,

        PCBUS  => MOP(12),
        DRBUS  => MOP(11),
        TRBUS  => MOP(10),
        RBUS   => MOP(9),
        ACBUS  => MOP(8),
        MEMBUS => MOP(14),

        BUS_OUT => internal_bus_8bit
    );

    -- Zero-extend for 16-bit loads
    internal_bus_16bit <= "00000000" & internal_bus_8bit;

    -- Memory address mux: AR vs SP
    mem_addr8 <= ARdata(7 downto 0) WHEN MOP(31)='0'
                ELSE SPdata(7 downto 0);

    -- Memory data-in mux: BUS vs PC(low)
    mem_din <= internal_bus_8bit WHEN MOP(30)='0'
              ELSE PCdata(7 downto 0);

    -- 3. Memory
    MEMORY_UNIT: ram port map(
        address => mem_addr8,
        clock   => clock,
        data    => mem_din,
        wren    => MOP(15),   -- WRITE_s
        q       => mem_to_bus
    );

    -- 4. Registers
    AR_REG: reg16 port map(
        clk => clock, rst => reset,
        ld  => MOP(26), inc => MOP(25), dec => '0',
        d   => internal_bus_16bit,
        q   => ARdata
    );

    PC_REG: reg16 port map(
        clk => clock, rst => reset,
        ld  => MOP(24), inc => MOP(23), dec => '0',
        d   => internal_bus_16bit,
        q   => PCdata
    );

    DR_REG: reg8 port map(
        clk => clock, rst => reset,
        ld  => MOP(22), inc => '0', clr => '0',
        d   => internal_bus_8bit, q => DRdata
    );

    TR_REG: reg8 port map(
        clk => clock, rst => reset,
        ld  => MOP(21), inc => '0', clr => '0',
        d   => internal_bus_8bit, q => TRdata
    );

    IR_REG: reg8 port map(
        clk => clock, rst => reset,
        ld  => MOP(20), inc => '0', clr => '0',
        d   => internal_bus_8bit, q => IRdata
    );

    R_REG: reg8 port map(
        clk => clock, rst => reset,
        ld  => MOP(19), inc => '0', clr => '0',
        d   => internal_bus_8bit, q => RRdata
    );

    AC_REG: reg8 port map(
        clk => clock, rst => reset,
        ld  => MOP(18),
        inc => MOP(3),
        clr => MOP(2),
        d   => alu_out,
        q   => ACdata
    );

    -- Stack Pointer
    SP_REG: reg16 port map(
        clk => clock, rst => reset,
        ld  => MOP(29),
        inc => MOP(28),
        dec => MOP(27),
        d   => internal_bus_16bit,
        q   => SPdata
    );

    -- 5. ALU Controller
    ALU_CTRL_UNIT: alus port map(
        rbus   => MOP(9),
        drbus  => MOP(11),
        acload => MOP(18),
        zload  => MOP(17),
        andop  => MOP(7),
        orop   => MOP(6),
        notop  => MOP(4),
        xorop  => MOP(5),
        aczero => MOP(2),
        acinc  => MOP(3),
        plus   => MOP(1),
        minus  => MOP(0),
        alus_out => alu_ctrl
    );

    -- 6. ALU Logic
    process(ACdata, RRdata, DRdata, alu_ctrl)
    begin
        CASE alu_ctrl is
            WHEN "1000000" => alu_out <= ACdata AND DRdata;
            WHEN "1100000" => alu_out <= ACdata OR DRdata;
            WHEN "1110000" => alu_out <= NOT ACdata;
            WHEN "1010000" => alu_out <= ACdata XOR DRdata;
            WHEN "0000101" => alu_out <= ACdata + DRdata;
            WHEN "0001011" => alu_out <= ACdata - DRdata;
            WHEN "0000100" => alu_out <= RRdata;
            WHEN OTHERS    => alu_out <= ACdata;
        end CASE;
    end process;

    -- Z flag
    z_calc <= '1' WHEN alu_out = "00000000" ELSE '0';

    Z_REG: reg1 port map(
        clk => clock, rst => reset,
        ld  => MOP(17),     
        d   => z_calc,
        q   => ZRdata
    );

    -- External connections
    addressBus   <= ARdata;
    cpu_data_bus <= internal_bus_8bit;

end arc;
