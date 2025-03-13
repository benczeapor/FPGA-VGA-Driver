library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity shape_position_register is
    generic
    (
        horizontal: boolean := true
    );
    port
    (
        clk: in std_logic;
        up_clk, down_clk: in std_logic;
        q: out std_logic_vector(9 downto 0)
    );
end shape_position_register;

architecture Behavioral of shape_position_register is

begin

    process(clk)
        variable state: std_logic_vector(9 downto 0) := "0000000000";
        variable upPrev, downPrev: bit := '0';
    begin
        if(rising_edge(clk)) then
        
            if(up_clk = '1' and upPrev = '0') then
                if(unsigned(state) < 590) then
                    state := state + 10;
                end if;
                upPrev := '1';
            elsif(up_clk = '0') then
                upPrev := '0';
            end if;
            
            if(down_clk = '1' and downPrev = '0') then
                if(unsigned(state) >= 10) then
                    state := state - 10;
                end if;
                downPrev := '1';
            elsif(down_clk = '0') then
                downPrev := '0';
            end if;
        
        end if;
        q <= state;
    end process;

end Behavioral;
