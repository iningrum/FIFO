library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity prs is
    port(
        ck: in std_logic;
        max: in std_logic_vector(7 downto 0);
        clk_slow : buffer std_logic := '0');
end;
architecture sequential of prs is
    begin
        COUNT: process(ck)
        variable ctr: unsigned (7 downto 0) := (others => '0');
        begin
        if (rising_edge(ck)) then 
            ctr := ctr+1;
            if (ctr = unsigned('0'&MAX(7 downto 1))) then
                ctr := (others => '0');
                clk_slow <= not clk_slow;
            end if;
        end if;
        end process COUNT;
end sequential;
