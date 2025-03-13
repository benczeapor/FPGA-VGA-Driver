library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity asd is
    port
    (
        clk: in std_logic;
        clk_up, rst: in std_logic;
        led: out std_logic_vector(9 downto 0)
    );
end asd;

architecture Behavioral of asd is  
    signal intern: std_logic;
    signal rstI: std_logic;
    signal ledstate: std_logic;
begin
    
--    led <= ledstate;
    
   
   
--    process(intern) -- testing of the clock divider
--        variable count: natural range 0 to 25000000 := 0;  
--    begin
--        if(rising_edge(intern)) then
--            count := count + 1;
--            if(count >= 25000000) then
--                ledstate <= not ledstate;
--                count := 0;
--            end if;
--        end if;
--    end process;
    
end Behavioral;
