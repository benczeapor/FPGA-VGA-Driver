library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity rng is
    port
    (
        clk: in std_logic;
        q: out std_logic_vector(15 downto 0)
    );
end rng;

architecture Behavioral of rng is

begin

    process(clk)
        variable state: std_logic_vector(15 downto 0) := "1001010000010100";
        variable sin: std_logic;
    begin
        if(rising_edge(clk)) then
            if(unsigned(state) = 0) then
                sin := '1';
            else
                sin := state(5) xor state(1) xor state(10) xor state(4) xor state(6);
            end if;
            
            state(0) := sin;
            for i in 14 downto 0 loop
                state(i + 1) := state(i);
            end loop;
        end if;
        q <= state;
    end process;

end Behavioral;
