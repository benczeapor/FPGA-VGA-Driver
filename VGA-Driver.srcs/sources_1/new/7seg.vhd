library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ssd_driver is
    generic
    (
        digits: natural := 3;
        display_zero: boolean := false
    );
    port
    (
        clk: in std_logic;
        input: in std_logic_vector(((4 * digits) - 1) downto 0);
        seg: out std_logic_vector(0 to 6);
        an: out std_logic_vector(0 to 3)
    );
end ssd_driver;

architecture Behavioral of ssd_driver is
    signal digit_val: std_logic_vector(3 downto 0) := "0000";
begin
    
    process(clk)
        variable delay: natural range 0 to 4500000 := 4500000;
        variable digit: natural range 0 to 3 := 0;
    begin
        if(rising_edge(clk)) then
            delay := delay - 1;
            if(delay = 0) then
                delay := 450000;
                
                if(digits <= 2) then
                    digit := digit + 1;
                else
                    digit := 0;
                end if;   
            end if;
        end if;
        
        case digit is
            when 0 =>
                an <= "0111";
                digit_val <= input(3 downto 0);
            when 1 =>
--                an <= "1011";
                if(digits >= 2) then
                    an <= "1011";
                    digit_val <= input(7 downto 4);
                else
                    if(display_zero) then
                        an <= "1011";
                    else
                        an <= "1111";
                    end if;
                    
                    digit_val <= X"0";
                end if;
            when 2 =>
                
                if(digits >= 3) then
                    an <= "1101";
                    digit_val <= input(11 downto 8);
                else
                    if(display_zero) then
                        an <= "1101";
                    else
                        an <= "1111";
                    end if;
                    digit_val <= X"0";
                end if;
            when 3 =>
                
                if(digits = 4) then
                    an <= "1110";
                    digit_val <= input(15 downto 12);
                else
                    if(display_zero) then
                        an <= "1110";
                    else
                        an <= "1111";
                    end if;
                    digit_val <= X"0";
                end if;
        end case;
        
        case digit_val is
            when X"0" => seg <= "0000001";
            when X"1" => seg <= "1001111";
            when X"2" => seg <= "0010010";
            when X"3" => seg <= "0000110";
            when X"4" => seg <= "1001100";
            when X"5" => seg <= "0100100";
            when X"6" => seg <= "0100000";
            when X"7" => seg <= "0001111";
            when X"8" => seg <= "0000000";
            when X"9" => seg <= "0000100";
            when X"A" => seg <= "0001000";
            when X"B" => seg <= "1100000";
            when X"C" => seg <= "0110001";
            when X"D" => seg <= "1000010";
            when X"E" => seg <= "0110000";
            when X"F" => seg <= "0111000";
        end case;
    end process;

--    with input select
--        seg <=
--        "0000001" when X"0",
--        "1001111" when X"1",
--        "0010010" when X"2",
--        "0000110" when X"3",
--        "1001100" when X"4",
--        "0100100" when X"5",
--        "0100000" when X"6",
--        "0001111" when X"7",
--        "0000000" when X"8",
--        "0000100" when X"9",
--        "0001000" when X"A",
--        "1100000" when X"B",
--        "0110001" when X"C",
--        "1000010" when X"D",
--        "0110000" when X"E",
--        "0111000" when X"F";

end Behavioral;