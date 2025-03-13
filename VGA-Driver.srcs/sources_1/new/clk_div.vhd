library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity clk_div is
    port
    (
        clk: in std_logic;
        output: out std_logic
    );
end clk_div;

architecture Behavioral of clk_div is
    signal state: std_logic := '0';
begin
    
    output <= state;
    
    process(clk)
        variable count: natural range 0 to 4 := 0;
    begin
        if(rising_edge(clk)) then
            count := count + 1;
            if(count >= 2) then
                state <= not state;
                count := 0;
            end if;
        end if;
    end process;


end Behavioral;
