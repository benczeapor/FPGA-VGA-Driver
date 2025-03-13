-- todo: subtract porches

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity range_finder is -- calculates if the beam is inside the are of the shape and the position of the beam inside the shape
    generic
    (
        horizontal: boolean := true
    );
    port
    (
        beam: in std_logic_vector(9 downto 0); -- position of the beam
        shape: in std_logic_vector(9 downto 0); -- position of the shape
        show: out std_logic; -- true if the beam is inside the area of the shape
        addr: out std_logic_vector(5 downto 0); -- the position of the beam inside the shape
        display: in std_logic -- true if the beam is in the display area
    );
end range_finder;

architecture Behavioral of range_finder is

begin

    process
        variable temp: std_logic_vector(9 downto 0);
    begin
        if(display = '1') then
            if(horizontal and unsigned(beam) - 179 > unsigned(shape) and unsigned(beam) - 179 < unsigned(shape) + 64) then
                show <= '1';
                temp := std_logic_vector((unsigned(beam) - 179) - unsigned(shape));
                addr <= temp(5 downto 0);
            elsif(not horizontal and unsigned(beam) - 41 > unsigned(shape) and unsigned(beam) - 41 < unsigned(shape) + 64) then
                show <= '1';
                temp := std_logic_vector((unsigned(beam) - 41) - unsigned(shape));
                addr <= temp(5 downto 0);
            else
                addr <= "000000";
                show <= '0';
            end if;
        else
            addr <= "000000";
            show <= '0';
        end if;
    end process;

end Behavioral;
