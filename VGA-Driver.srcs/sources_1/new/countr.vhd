library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity countr is
    generic
    (
        bits: natural := 10
    );
    port
    (
        up_clk, down_clk: in std_logic;
        rst: in std_logic;
        q: out std_logic_vector(bits-1 downto 0)
    );
end countr;

architecture Behavioral of countr is

begin

    process(up_clk, down_clk, rst)
        variable state: std_logic_vector(bits-1 downto 0);
    begin
        
        if(rst = '1') then
        
            for i in 0 to bits-1 loop
                state(i) := '0';
            end loop;
            
        else
        
        if(rising_edge(up_clk)) then
--            state := state + 1;
            state := std_logic_vector(unsigned(state) + 1);
        end if;
        
        end if;
        
        q <= state;
    end process;

end Behavioral;
