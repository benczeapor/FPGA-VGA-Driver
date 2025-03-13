library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity ssd_driver is
    port
    (
        clk: in std_logic;
        input: in std_logic_vector(7 downto 0);
        seg: out std_logic_vector(0 to 6);
        an: out std_logic_vector(0 to 3);
        en: in std_logic
    );
end ssd_driver;

architecture Behavioral of ssd_driver is
    signal digit_val: std_logic_vector(3 downto 0) := "0000";
begin
    
    process(clk)
        variable delay: natural range 0 to 4500000 := 4500000;
        variable digit: natural range 0 to 3 := 0;
        variable value: unsigned(7 downto 0);
        variable d0, d1, d2: std_logic_vector(7 downto 0);
    begin
        if(rising_edge(clk)) then
            delay := delay - 1;
            if(delay = 0) then
                delay := 450000;
                
                if(digit < 3) then
                    digit := digit + 1;
                else
                    digit := 0;
                end if;   
            end if;
            
            value := unsigned(input);
            
            d0 := std_logic_vector(unsigned(value) mod 10);
            d1 := std_logic_vector((unsigned(value) / 10) mod 10);
            d2 := std_logic_vector(unsigned(value) / 100);
            
        end if;
        
        
        
        case digit is
            when 0 =>
                an <= "0111";
                digit_val <= d0(3 downto 0);
            when 1 =>
                an <= "1011";
                digit_val <= d1(3 downto 0);
            when 2 =>
                an <= "1101";
                digit_val <= d2(3 downto 0);
            when 3 => NULL;
        end case;
        
--        digit_val <= X"0";
        
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
        
        if(en = '0') then
            an <= "1111";
        end if;
        
    end process;
end Behavioral;