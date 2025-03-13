library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
--    generic
--    (
--        bits: natural := 4;
--        inputs: natural := 1 -- 2 to the power 
--    );
    port
    (
        inA, inB: in std_logic_vector(3 downto 0);
        sel: in std_logic;
        output: out std_logic_vector(3 downto 0)
    );
end mux;

architecture Behavioral of mux is

begin

    output(0) <= ((not sel and inA(0)) or (sel and inB(0)));
    output(1) <= ((not sel and inA(1)) or (sel and inB(1)));
    output(2) <= ((not sel and inA(2)) or (sel and inB(2)));
    output(3) <= ((not sel and inA(3)) or (sel and inB(3)));

end Behavioral;
