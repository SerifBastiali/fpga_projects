library ieee;
use ieee.std_logic_1164.all;
use work.alulib.all;

entity adder8bit is
    port(
        a    : in  std_logic_vector(7 downto 0);
        b    : in  std_logic_vector(7 downto 0);
        cin  : in  std_logic;
        s    : out std_logic_vector(7 downto 0);
        cout : out std_logic
    );
end adder8bit;

architecture structural of adder8bit is
    signal c : std_logic_vector(8 downto 0);
begin
    c(0) <= cin;

    gen_adders : for i in 0 to 7 generate
        FA : adder1bit
            port map(
                a    => a(i),
                b    => b(i),
                cin  => c(i),
                s    => s(i),
                cout => c(i+1)
            );
    end generate;

    cout <= c(8);

end structural;