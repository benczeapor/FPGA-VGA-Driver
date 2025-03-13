library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity main is
    port
    (
        clk: in std_logic; --internal clock
        btnU, btnL, btnD, btnR, rst: in std_logic; -- buttons to change the position of the displayed shape
        shape: in std_logic_vector(0 to 1); --switches to select shape
        color: in std_logic_vector(0 to 1); -- switcehs to select color
        vgaRed, vgaGreen, vgaBlue: out std_logic_vector(3 downto 0); -- color pins of the vga connector
        Hsync, Vsync: out std_logic; -- sync pins of the vga connnector
        snake_mode: in std_logic;
        test: out std_logic;
        dir: out std_logic_vector(1 downto 0);
        seg: out std_logic_vector(0 to 6);
        an: out std_logic_vector(0 to 3)
    );
end main;

architecture Behavioral of main is
    
    component clk_div
        port
        (
            clk: in std_logic;
            output: out std_logic
        );
    end component;

    component debouncer
        port
        (
            clk: in std_logic;
            input: in std_logic;
            output: out std_logic
        );
    end component;

    component beam_position_register
        generic
        (
            horizontal: boolean
        );
        port
        (
            clk_in: in std_logic;
            q: out std_logic_vector(9 downto 0);
            sync: out std_logic; -- hsync or vsync
            carry: out std_logic;
            display: out std_logic
        );
    end component;
    
    component shape_position_register
        generic
        (
            horizontal: boolean
        );
        port
        (
            clk: in std_logic;
            up_clk, down_clk: in std_logic;
            q: out std_logic_vector(9 downto 0)
        );
    end component;
    
    component color_selector
        port
        (
            addr: in std_logic_vector(0 to 1);
            show: in std_logic;
            outRed, outGreen, outBlue: out std_logic_vector(3 downto 0)
        );
    end component;
    
    component shape_selector
         port
        (
            addr: in std_logic_vector(11 downto 0);
            sel: in std_logic_vector(1 downto 0);
            show: out std_logic
        );
    end component;
    
    component range_finder
        generic
        (
            horizontal: boolean
        );
        port
        (
            beam: in std_logic_vector(9 downto 0);
            shape: in std_logic_vector(9 downto 0);
            show: out std_logic;
            addr: out std_logic_vector(5 downto 0);
            display: in std_logic
        );
    end component;
    
    component snake_driver
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
    end component;
    
    component mux
        port
        (
            inA, inB: in std_logic_vector(3 downto 0);
            sel: in std_logic;
            output: out std_logic_vector(3 downto 0)
        );
    end component;
    
    signal vgaClk: std_logic;
    signal beamCarry: std_logic;
    signal horizontalCount, verticalCount: std_logic_vector(9 downto 0);
    signal uIn, lIn, dIn, rIn, rstIn: std_logic; -- internal signals for the debounced buttons
    signal horizontalPos, verticalPos: std_logic_vector(9 downto 0);
    signal showHor, showVer: std_logic;
    signal addrHor, addrVer: std_logic_vector(5 downto 0);
    signal showShape: std_logic;
    signal addrShape: std_logic_vector(11 downto 0);
    signal show, showFull: std_logic;
    signal tempSync: std_logic;
    signal displayHor, displayVer, display: std_logic;
    signal iRed, iGreen, iBlue: std_logic_vector(3 downto 0); -- internal color signal
    signal iRed1, iGreen1, iBlue1: std_logic_vector(3 downto 0);
begin

    clkDiv: clk_div port map(clk => clk, output => vgaClk);
    
    horizontalCounter: beam_position_register generic map(horizontal => true) port map(clk_in => vgaClk, q => horizontalCount, sync => Hsync, carry => beamCarry, display => displayHor);
    verticalCounter:   beam_position_register generic map(horizontal => false) port map(clk_in => beamCarry, q => verticalCount, sync => tempSync, display => displayVer);
    Vsync <= tempSync;
    
    uDeb: debouncer port map(clk => clk, input => btnU, output => uIn); -- debouncers fo the buttons
    lDeb: debouncer port map(clk => clk, input => btnL, output => lIn);
    dDeb: debouncer port map(clk => clk, input => btnD, output => dIn);
    rDeb: debouncer port map(clk => clk, input => btnR, output => rIn);
    rstDeb: debouncer port map(clk => clk, input => rst, output => rstIn);

    horizontalPosition: shape_position_register generic map(horizontal => true) port map(clk => clk, up_clk => rIn, down_clk => lIn, q => horizontalPos);
    verticalPosition:   shape_position_register generic map(horizontal => false) port map(clk => clk, up_clk => dIn, down_clk => uIn, q => verticalPos);
        
    horizontalRange: range_finder generic map(horizontal => true) port map(beam => horizontalCount, shape => horizontalPos, show => showHor, addr => addrHor, display => displayHor);
    verticalRange:   range_finder generic map(horizontal => false) port map(beam => verticalCount, shape => verticalPos, show => showVer, addr => addrVer, display => displayVer);    
    
    addrShape(5 downto 0) <= addrHor;
    addrShape(11 downto 6) <= addrVer;
    
    shapeSelector: shape_selector port map(addr => addrShape, sel => shape, show => showShape);
    show <= showHor and showVer;
    showFull <= show and showShape;
    colorSelector: color_selector port map(addr => color, show => showFull, outRed => iRed, outGreen => iGreen, outBlue => iBlue);
    
    snake: snake_driver port map(seg => seg, an => an, rst => rstIn, test => test, clk => clk, bH => horizontalCount, bV => verticalCount, btnU => uIn, btnL => lIn, btnD => dIn, btnR => rIn, show => show, snake_mode => snake_mode, inRed => iRed, inGreen => iGreen, inBlue => iBlue, vgaRed => iRed1, vgaGreen => iGreen1, vgaBlue => iBlue1, dirled => dir);
    
    display <= displayHor and displayVer;
    
    redMux: mux port map(inA => "0000", inB => iRed1, sel => display, output => vgaRed);
    greenMux: mux port map(inA => "0000", inB => iGreen1, sel => display, output => vgaGreen);
    blueMux: mux port map(inA => "0000", inB => iBlue1, sel => display, output => vgaBlue);
    
end Behavioral;
