library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity beam_position_register is
    generic
    (
        horizontal: boolean := true
    );
    port
    (
        clk_in: in std_logic;
        q: out std_logic_vector(9 downto 0);
        sync: out std_logic; -- hsync or vsync
        carry: out std_logic;
        display: out std_logic -- truen when the beam is in the display area
    );
end beam_position_register;
architecture Behavioral of beam_position_register is

begin

    process(clk_in)
        variable state: std_logic_vector(9 downto 0);
    begin
        carry <= '0';
        if(rising_edge(clk_in)) then
        
            if((horizontal and unsigned(state) > 799) or (not horizontal and unsigned(state) > 520)) then
                state := "0000000000";
--                for i in 0 to 9 loop
--                    state(i) := '0';
--                end loop;
                carry <= '1';
            else
                state := std_logic_vector(unsigned(state) + 1);
            end if;            
        end if;
        
        if(horizontal and (unsigned(state) >= 15) and unsigned(state) < 112) then
            sync <= '0';
        elsif(not horizontal and unsigned(state) >= 9 and unsigned(state) < 12) then
            sync <= '0';
        else 
            sync <= '1';
        end if;
        
        if(horizontal and unsigned(state) >= 160) then
            display <= '1';
        elsif(not horizontal and unsigned(state) >= 41) then
            display <= '1';
        else
            display <= '0';
        end if;
        
        q <= state;
    end process;

end Behavioral;
