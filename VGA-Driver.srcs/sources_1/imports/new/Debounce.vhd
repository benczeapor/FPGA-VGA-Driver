library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity debouncer is
    port 
    (
        clk: in std_logic;
        input: in std_logic;
        output: out std_logic
    );

end debouncer;

architecture Behavioral of debouncer is

begin
    
    process(clk)
        variable delay: natural range 0 to 10000000 := 10000000;
    begin
    
        if(rising_edge(clk)) then
            if(input = '1') then
                if(delay = 0) then
                    output <= '1';
                else
                    delay := delay - 1;
                end if;
            else
                output <= '0';
                delay := 10000000;
            end if;
        end if;
    end process;
end Behavioral;
