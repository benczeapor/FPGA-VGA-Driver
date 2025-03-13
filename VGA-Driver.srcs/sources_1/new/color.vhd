library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity color_selector is -- color selector
    port
    (
        addr: in std_logic_vector(0 to 1);
        show: in std_logic;
        outRed, outGreen, outBlue: out std_logic_vector(3 downto 0)
    );
end color_selector;

architecture Behavioral of color_selector is
    -- the definitions of the 4 colors
    signal r1: std_logic_vector(3 downto 0) := "1111"; -- first color is red
    signal g1: std_logic_vector(3 downto 0) := "0000";
    signal b1: std_logic_vector(3 downto 0) := "0000";
    
    signal r2: std_logic_vector(3 downto 0) := "0000"; -- second color is green
    signal g2: std_logic_vector(3 downto 0) := "1111";
    signal b2: std_logic_vector(3 downto 0) := "0000";
    
    signal r3: std_logic_vector(3 downto 0) := "0000"; --  third color is blue
    signal g3: std_logic_vector(3 downto 0) := "0000";
    signal b3: std_logic_vector(3 downto 0) := "1111";
    
    signal r4: std_logic_vector(3 downto 0) := "0000"; -- fourth color is yellow
    signal g4: std_logic_vector(3 downto 0) := "1000";
    signal b4: std_logic_vector(3 downto 0) := "1000";
begin

    process(addr, show)
    begin
        
        if(show = '1') then
            case addr is
                when "00" =>
                    outRed   <= r1;
                    outGreen <= g1;
                    outBlue  <= b1;
                when "01" =>
                    outRed   <= r2;
                    outGreen <= g2;
                    outBlue  <= b2;
                when "10" =>
                    outRed   <= r3;
                    outGreen <= g3;
                    outBlue  <= b3;
                when "11" =>
                    outRed   <= r4;
                    outGreen <= g4;
                    outBlue  <= b4;
            end case;
        else
        
            outRed   <= "0000";
            outGreen <= "0000";
            outBlue  <= "0000";
        
        end if;
    end process;

end Behavioral;
