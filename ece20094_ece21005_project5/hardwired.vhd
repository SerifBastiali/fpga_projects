library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity hardwired is
  port(
    ir           : in  std_logic_vector(7 downto 0);
    clock, reset : in  std_logic;
    z            : in  std_logic;
    mOPs         : out std_logic_vector(31 downto 0)
  );
end hardwired;

architecture rtl of hardwired is
    -- Sequence Counter
    signal sc : std_logic_vector(3 downto 0);
    -- Signal to clear Sequence Counter
    signal clr_sc : std_logic;
begin

    -- Sequence Counter Process
    process(clock, reset)
    begin
        if reset = '1' then
            sc <= "0000";
        elsif rising_edge(clock) then
            if clr_sc = '1' then
                sc <= "0000"; 
            else
                sc <= sc + 1;
            end if;
        end if;
    end process;

    -- Control Logic Process
    process(sc, ir, z)
    begin
        -- Default values
        mOPs <= (others => '0');
        clr_sc <= '0';

        case sc is
            -- FETCH CYCLE
            WHEN "0000" => -- T0: AR <- PC
                mOPs(12) <= '1'; mOPs(26) <= '1';

            WHEN "0001" => -- T1: IR <- Mem, PC++
                mOPs(14) <= '1'; mOPs(20) <= '1'; mOPs(23) <= '1';

            WHEN "0010" => -- T2: Decode
                null;

            -- EXECUTE CYCLES
            WHEN OTHERS =>
                case ir is
                    -- CALL (82H)
                    WHEN x"82" =>
                        if sc = "0011" then
                            mOPs(12) <= '1'; mOPs(26) <= '1';
                        elsif sc = "0100" then
                            mOPs(14) <= '1'; mOPs(21) <= '1'; mOPs(23) <= '1';
                        elsif sc = "0101" then
                            mOPs(27) <= '1'; -- SP Dec
                        elsif sc = "0110" then
                            mOPs(31) <= '1'; mOPs(12) <= '1'; mOPs(15) <= '1';
                        elsif sc = "0111" then
                            mOPs(10) <= '1'; mOPs(24) <= '1';
                            clr_sc <= '1';
                        end if;

                    -- RET (83H)
                    WHEN x"83" =>
                        if sc = "0011" then
                            mOPs(31) <= '1'; mOPs(14) <= '1'; mOPs(24) <= '1';
                        elsif sc = "0100" then
                            mOPs(28) <= '1'; -- SP Inc
                            clr_sc <= '1';
                        end if;

                    -- LDAC (01H)
                    WHEN x"01" => 
                        if sc = "0011" then mOPs(12) <= '1'; mOPs(26) <= '1';
                        elsif sc = "0100" then mOPs(14) <= '1'; mOPs(26) <= '1'; mOPs(23) <= '1';
                        elsif sc = "0101" then mOPs(14) <= '1'; mOPs(22) <= '1';
                        elsif sc = "0110" then mOPs(11) <= '1'; mOPs(18) <= '1'; mOPs(17) <= '1'; clr_sc <= '1';
                        end if;

                    -- STAC (02H)
                    WHEN x"02" =>
                        if sc = "0011" then mOPs(12) <= '1'; mOPs(26) <= '1';
                        elsif sc = "0100" then mOPs(14) <= '1'; mOPs(26) <= '1'; mOPs(23) <= '1';
                        elsif sc = "0101" then mOPs(8) <= '1'; mOPs(15) <= '1'; clr_sc <= '1';
                        end if;

                    -- MVAC (03H)
                    WHEN x"03" =>
                        if sc = "0011" then mOPs(8) <= '1'; mOPs(19) <= '1'; clr_sc <= '1'; end if;

                    -- MOVR (04H)
                    WHEN x"04" =>
                        if sc = "0011" then mOPs(9) <= '1'; mOPs(18) <= '1'; mOPs(17) <= '1'; clr_sc <= '1'; end if;

                    -- JUMP (05H)
                    WHEN x"05" =>
                        if sc = "0011" then mOPs(12) <= '1'; mOPs(26) <= '1';
                        elsif sc = "0100" then mOPs(14) <= '1'; mOPs(24) <= '1'; clr_sc <= '1';
                        end if;

                    -- JMPZ (06H)
                    WHEN x"06" =>
                        if sc = "0011" then mOPs(12) <= '1'; mOPs(26) <= '1';
                        elsif sc = "0100" then
                            if z = '1' then mOPs(14) <= '1'; mOPs(24) <= '1'; else mOPs(23) <= '1'; end if;
                            clr_sc <= '1';
                        end if;

                    -- JPNZ (07H)
                    WHEN x"07" =>
                        if sc = "0011" then mOPs(12) <= '1'; mOPs(26) <= '1';
                        elsif sc = "0100" then
                            if z = '0' then mOPs(14) <= '1'; mOPs(24) <= '1'; else mOPs(23) <= '1'; end if;
                            clr_sc <= '1';
                        end if;

                    -- ADD (08H)
                    WHEN x"08" =>
                        if sc = "0011" then mOPs(12) <= '1'; mOPs(26) <= '1';
                        elsif sc = "0100" then mOPs(14) <= '1'; mOPs(26) <= '1'; mOPs(23) <= '1';
                        elsif sc = "0101" then mOPs(14) <= '1'; mOPs(22) <= '1';
                        elsif sc = "0110" then mOPs(9)<='1'; mOPs(18)<='1'; mOPs(17)<='1'; mOPs(1)<='1'; clr_sc <= '1';
                        end if;

                    -- SUB (09H)
                    WHEN x"09" =>
                        if sc = "0011" then mOPs(12) <= '1'; mOPs(26) <= '1';
                        elsif sc = "0100" then mOPs(14) <= '1'; mOPs(26) <= '1'; mOPs(23) <= '1';
                        elsif sc = "0101" then mOPs(14) <= '1'; mOPs(22) <= '1';
                        elsif sc = "0110" then mOPs(9)<='1'; mOPs(18)<='1'; mOPs(17)<='1'; mOPs(0)<='1'; clr_sc <= '1';
                        end if;

                    -- INAC (0AH)
                    WHEN x"0A" =>
                         if sc = "0011" then mOPs(18) <= '1'; mOPs(17) <= '1'; mOPs(3) <= '1'; clr_sc <= '1'; end if;

                    -- CLAC (0BH)
                    WHEN x"0B" =>
                         if sc = "0011" then mOPs(18) <= '1'; mOPs(17) <= '1'; mOPs(2) <= '1'; clr_sc <= '1'; end if;

                    -- AND (0CH)
                    WHEN x"0C" => 
                        if sc = "0011" then mOPs(12) <= '1'; mOPs(26) <= '1';
                        elsif sc = "0100" then mOPs(14) <= '1'; mOPs(26) <= '1'; mOPs(23) <= '1';
                        elsif sc = "0101" then mOPs(14) <= '1'; mOPs(22) <= '1';
                        elsif sc = "0110" then mOPs(9)<='1'; mOPs(11)<='1'; mOPs(18)<='1'; mOPs(17)<='1'; mOPs(7)<='1'; clr_sc <= '1';
                        end if;

                    -- OR (0DH)
                    WHEN x"0D" => 
                        if sc = "0011" then mOPs(12) <= '1'; mOPs(26) <= '1';
                        elsif sc = "0100" then mOPs(14) <= '1'; mOPs(26) <= '1'; mOPs(23) <= '1';
                        elsif sc = "0101" then mOPs(14) <= '1'; mOPs(22) <= '1';
                        elsif sc = "0110" then mOPs(9)<='1'; mOPs(11)<='1'; mOPs(18)<='1'; mOPs(17)<='1'; mOPs(6)<='1'; clr_sc <= '1';
                        end if;
                         
                    -- XOR (0EH)
                    WHEN x"0E" =>
                        if sc = "0011" then mOPs(12) <= '1'; mOPs(26) <= '1';
                        elsif sc = "0100" then mOPs(14) <= '1'; mOPs(26) <= '1'; mOPs(23) <= '1';
                        elsif sc = "0101" then mOPs(14) <= '1'; mOPs(22) <= '1';
                        elsif sc = "0110" then mOPs(9)<='1'; mOPs(11)<='1'; mOPs(18)<='1'; mOPs(17)<='1'; mOPs(5)<='1'; clr_sc <= '1';
                        end if;

                    -- NOT (0FH)
                    WHEN x"0F" =>
                         if sc = "0011" then mOPs(18) <= '1'; mOPs(17) <= '1'; mOPs(4) <= '1'; clr_sc <= '1'; end if;

                    WHEN OTHERS =>
                        clr_sc <= '1';
                end case;
        end case;
    end process;
end rtl;