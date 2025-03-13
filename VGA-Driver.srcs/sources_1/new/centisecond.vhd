library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity centisecond is
    port
    (
        clk: in std_logic; -- 100mhz clk signal
        output: out std_logic -- 100 hz output signal
    );
end centisecond;

architecture Behavioral of centisecond is

begin

    process(clk)
        variable count: natural range 0 to 1000000 := 0;
        variable state: std_logic := '0';
    begin
    
        if(rising_edge(clk)) then
            count := count + 1;
            
            if(count >= 500000) then
                state := not state;
                count := 0;
            end if;
        end if;
        output <= state;
    end process;

end Behavioral;
