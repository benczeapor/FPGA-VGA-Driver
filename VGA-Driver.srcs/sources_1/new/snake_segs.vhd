library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity snake is
    port
    (
        bH, bV: in std_logic_vector(9 downto 0);
        in_body: out std_logic;
        btnU, btnL, btnD, btnR: in std_logic;
        move: in std_logic;
        test: out std_logic;
        dirled: out std_logic_vector(1 downto 0);
        clk: in std_logic;
        in_apple: out std_logic;
        rst, en: in std_logic;
        seg: out std_logic_vector(0 to 6);
        an: out std_logic_vector(0 to 3);
        scoreOut: out std_logic_vector(7 downto 0)
    );
end snake;

architecture Behavioral of snake is
    
    component rng
        port
        (
            clk: in std_logic;
            q: out std_logic_vector(15 downto 0)
        );
    end component;
    component ssd_driver
        port
        (
            clk: in std_logic;
            input: in std_logic_vector(7 downto 0);
            seg: out std_logic_vector(0 to 6);
            an: out std_logic_vector(0 to 3);
            en: in std_logic
        );
    end component;
    
    type segment_mem is array(0 to 255) of std_logic_vector(4 downto 0);
    signal length: std_logic_vector(7 downto 0);
    signal segmentsY, segmentsX: segment_mem;
    signal dir: std_logic_vector(1 downto 0); --00 - up, 01 -- right, 10 - down, 11 - left
    signal dead: std_logic := '0';
    signal init: std_logic := '0';
    signal score: std_logic_vector(7 downto 0) := "00000000";
    signal appleX, appleY: std_logic_vector(4 downto 0);
    signal random, random1: std_logic_vector(15 downto 0);
    signal appleExists, appleGenerated: std_logic := '0';
begin
    
    test <= appleExists;
    scoreOut <= score;
    
    rand: rng port map(clk => move, q => random);
    disp: ssd_driver port map(clk => clk, en => en, input => score, seg => seg, an => an);
    
     
    process(clk)
        variable dirVar: std_logic_vector(1 downto 0);
    begin
        if(rising_edge(clk)) then
            if(btnU = '1' and dir /= "10") then-- and dir /= "10"
                dirVar := "00";
            elsif(btnL = '1' and dir /= "01") then-- and dir /= "01"
                dirVar := "11";
            elsif(btnD = '1' and dir /= "00") then-- and dir /= "00"
                dirVar := "10";
            elsif(btnR = '1' and dir /= "11") then-- and dir /= "11"
                dirVar := "01";
            else
                dirVar := dirVar;
            end if;
            
            dir <= dirVar;
            dirled <= dirVar;
            
            if(appleExists = '0') then
            
                appleX <= std_logic_vector(unsigned(random(4 downto 0) xor random(9 downto 5)) mod 32);
                appleY <= std_logic_vector(unsigned(random(9 downto 5) xor random(14 downto 10)) mod 24);
            
                appleGenerated <= '1';
             else
                appleGenerated <= '0';
            end if;
        end if;
    end process;
    
    process(move, dir)
        variable segX, segY: segment_mem;
    begin
        
        
        if(appleGenerated = '1') then
            appleExists <= '1';
        end if;
        
        segX := segmentsX;
        segY := segmentsY;
        
        if(rising_edge(move) and dead = '0')then
            for i in 254 downto 0 loop
                segY(i+1) := segY(i);
                segX(i+1) := segX(i);
            end loop;
            
            case dir is
                when "00" => --up
                    if(unsigned(segY(0)) = 0) then
                        dead <= '1';
                    end if;
                    
                    for i in 1 to 255 loop
                        if(i < unsigned(length)) then
                            if(unsigned(segY(0)) - 1 = unsigned(segY(i)) and unsigned(segX(0)) = unsigned(segX(i))) then
                                dead <= '1';
                                exit;
                            end if;
                        else
                            exit;
                        end if;
                    end loop;
                    
                    if(unsigned(segY(0)) - 1 = unsigned(appleY) and unsigned(segX(0)) = unsigned(appleX)) then
                        appleExists <= '0';
                        length <= std_logic_vector(unsigned(length) + 1);
                        score <= std_logic_vector(unsigned(score) + 1);
                    end if;
                    
                    segY(0) := std_logic_vector(unsigned(segY(0)) - 1);
                when "01" => -- right
                    if(unsigned(segX(0)) = 31) then
                        dead <= '1';
                    end if;
                    
                    for i in 1 to 255 loop
                        if(i < unsigned(length)) then
                            if(unsigned(segY(0)) = unsigned(segY(i)) and unsigned(segX(0)) + 1 = unsigned(segX(i))) then
                                dead <= '1';
                                exit;
                            end if;
                        else
                            exit;
                        end if;
                    end loop;
                    
                    if(unsigned(segY(0)) = unsigned(appleY) and unsigned(segX(0)) + 1 = unsigned(appleX)) then
                        appleExists <= '0';
                        length <= std_logic_vector(unsigned(length) + 1);
                        score <= std_logic_vector(unsigned(score) + 1);
                    end if;
                    
                    segX(0) := std_logic_vector(unsigned(segX(0)) + 1);
                when "10" => -- down
                    if(unsigned(segY(0)) = 23) then
                        dead <= '1';
                    end if;
                    
                    for i in 1 to 255 loop
                        if(i < unsigned(length)) then
                            if(unsigned(segY(0)) + 1 = unsigned(segY(i)) and unsigned(segX(0)) = unsigned(segX(i))) then
                                dead <= '1';
                                exit;
                            end if;
                        else
                            exit;
                        end if;
                    end loop;
                    
                    if(unsigned(segY(0)) + 1 = unsigned(appleY) and unsigned(segX(0)) = unsigned(appleX)) then
                        appleExists <= '0';
                        length <= std_logic_vector(unsigned(length) + 1);
                        score <= std_logic_vector(unsigned(score) + 1);
                    end if;
                    
                    segY(0) := std_logic_vector(unsigned(segY(0)) + 1);
                when "11" => -- left
                    if(unsigned(segX(0)) = 0) then
                        dead <= '1';
                    end if;
                    
                    for i in 1 to 255 loop
                        if(i < unsigned(length)) then
                            if(unsigned(segY(0)) = unsigned(segY(i)) and unsigned(segX(0)) - 1 = unsigned(segX(i))) then
                                dead <= '1';
                                exit;
                            end if;
                        else
                            exit;
                        end if;
                    end loop;
                    
                    if(unsigned(segY(0)) = unsigned(appleY) and unsigned(segX(0)) - 1 = unsigned(appleX)) then
                        appleExists <= '0';
                        length <= std_logic_vector(unsigned(length) + 1);
                        score <= std_logic_vector(unsigned(score) + 1);
                    end if;
                    
                    segX(0) := std_logic_vector(unsigned(segX(0)) - 1);
            end case;
        end if;
        
        if(init = '0') then -- set initial parameters
            length <= "00000100";
            segY(0) := "01100";
            segX(0) := "10000";
                        
            segY(1) := "01100";
            segX(1) := "10000";
            
            segY(2) := "01100";
            segX(2) := "10000";
            
            segY(3) := "01100";
            segX(3) := "10000";
            
            for item in 4 to 255 loop
                segY(item) := "00000";
                segX(item) := "00000";
            end loop;
            
            init <= '1';
            dead <= '0';
            score <= "00000000";
            appleExists <= '0';
        end if;
    
        

        if(dead = '1' and rst = '1') then
            init <= '0';
        end if;

        segmentsX <= segX;
        segmentsY <= segY;
    end process;
    
    process(clk)
    begin

        for i in 0 to 255 loop
            if(i < unsigned(length)) then                
                if((unsigned(segmentsY(i)) * 20 + 40 <= unsigned(bV)) and ((unsigned(segmentsY(i)) + 1) * 20 + 40 > unsigned(bV))) then
                    if((unsigned(segmentsX(i)) * 20 + 179 <= unsigned(bH)) and ((unsigned(segmentsX(i)) + 1) * 20 + 179 > unsigned(bH))) then
                        in_body <= '1';
                        exit;
                    else
                        in_body <= '0';
                    end if;
                else
                    in_body <= '0';
                end if;
            end if;
        end loop;
        
        if((unsigned(appleY) * 20 + 40 <= unsigned(bV)) and ((unsigned(appleY) + 1) * 20 + 40 > unsigned(bV))) then
            if((unsigned(appleX) * 20 + 179 <= unsigned(bH)) and ((unsigned(appleX) + 1) * 20 + 179 > unsigned(bH))) then
                in_apple <= '1';
            else
                in_apple <= '0';
            end if;
        else
            in_apple <= '0';
        end if;
    
    end process;

end Behavioral;
