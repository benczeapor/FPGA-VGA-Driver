library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity snake_driver is
    port
    (
        test: out std_logic;
        clk: in std_logic;
        bH, bV: in std_logic_vector(9 downto 0);
        btnU, btnL, btnD, btnR: in std_logic;
        show: in std_logic;
        snake_mode: in std_logic;
        inRed, inGreen, inBlue: in std_logic_vector(3 downto 0);
        vgaRed, vgaGreen, vgaBlue: out std_logic_vector(3 downto 0);
        dirled: out std_logic_vector(1 downto 0);
        rst: in std_logic;
        seg: out std_logic_vector(0 to 6);
        an: out std_logic_vector(0 to 3)
        
    );
end snake_driver;

architecture Behavioral of snake_driver is
    component snake
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
    end component;
    
    component centisecond
        port
        (
            clk: in std_logic;
            output: out std_logic
        );
    end component;
    
    component mux
        port
        (
            inA, inB: in std_logic_vector(3 downto 0);
            sel: in std_logic;
            output: out std_logic_vector(3 downto 0)
        );
    end component;
    
    signal in_body, move, in_apple: std_logic;
    signal slow_clk: std_logic;
    signal snake_color, apple_color: std_logic_vector(3 downto 0);
    signal score: std_logic_vector(7 downto 0);
--    signal iRed, iGreen, iBlue: std_logic_vector(3 downto 0);

begin
    clk_div: centisecond port map(clk => clk, output => slow_clk);
    snak: snake port map(scoreOut => score, seg => seg, an=> an, en => snake_mode, rst => rst, in_apple => in_apple, clk => clk, bH => bH, bV => bV, in_body => in_body, btnU => btnU, btnL => btnL, btnD => btnD, btnR => btnR, move => move, test => test, dirled => dirled);

    snake_color(0) <= in_body;
    snake_color(1) <= in_body;
    snake_color(2) <= in_body;
    snake_color(3) <= in_body;
    
    apple_color(0) <= in_apple;
    apple_color(1) <= in_apple;
    apple_color(2) <= in_apple;
    apple_color(3) <= in_apple;

    redMux: mux port map(inA => inRed, inB => apple_color, sel => snake_mode, output => vgaRed);
    greenMux: mux port map(inA => inGreen, inB => snake_color, sel => snake_mode, output => vgaGreen);
    blueMux: mux port map(inA => inBlue, inB => "0111", sel => snake_mode, output => vgaBlue);

    process(slow_clk)
        variable count: natural range 0 to 100 := 0;
        variable limit: natural range 0 to 30 := 30;
        variable prevScore: std_logic_vector(7 downto 0) := "00000000";
        
    begin
        if(rising_edge(slow_clk)) then
            count := count + 1;
            
            if(unsigned(score) = 0) then
                limit := 30;
            end if;
            
            if(score(0) = '0' and score /= prevScore) then
                if(limit > 1) then
                    limit := limit - 1;
                end if;
                prevScore := score;
            end if;
            
            if(count >= limit) then
                move <= snake_mode;
                count := 0;
            else
                move <= '0';
            end if;
        end if;
    end process;

end Behavioral;
