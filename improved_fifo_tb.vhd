-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 29.8.2022 11:45:58 UTC

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use IEEE.NUMERIC_STD.ALL;
entity tb_fifo is
end tb_fifo;

architecture tb of tb_fifo is

    component fifo
        port (WRITE   : in std_logic;
              READ    : in std_logic;
              CLK     : in std_logic;
              INPUT   : in std_logic_vector (4-1 downto 0);
              OUTPUT  : out std_logic_vector (4-1 downto 0);
              NO_PUSH : out std_logic;
              NO_POP  : out std_logic);
    end component;

    signal WRITE   : std_logic;
    signal READ    : std_logic;
    signal CLK     : std_logic;
    signal INPUT   : std_logic_vector (4-1 downto 0);
    signal OUTPUT  : std_logic_vector (4-1 downto 0);
    signal NO_PUSH : std_logic;
    signal NO_POP  : std_logic;

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : fifo
    port map (WRITE   => WRITE,
              READ    => READ,
              CLK     => CLK,
              INPUT   => INPUT,
              OUTPUT  => OUTPUT,
              NO_PUSH => NO_PUSH,
              NO_POP  => NO_POP);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        WRITE <= '0';
        READ <= '1'; -- Empty buffer so raises NOPOP
        INPUT <= (others => '0');
        wait for TbPeriod;
        assert (NO_POP='1' AND NO_PUSH='0') -- NOPOP should be raised
            report "BOTH FLAGS SHOULD DROP" severity error;

        
        -- EDIT ORDER [15, 9, 6, 3, 12, 10, 5, 1]
        WRITE <= '1';
        READ <= '0';
        INPUT <= "1111"; -- writing 15
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="1111" AND NO_POP='0') -- we should read 15, NOPOP drops
            report "OUT should point at the first item" severity error;
        

        INPUT <= "1001"; -- writing 9
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="1111") -- we should still read 15
            report "OUT should point at the first item" severity error;
        
            
            
        INPUT <= "0110"; -- writing 6
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="1111") -- we should still read 15
            report "OUT should point at the first item" severity error;
            
            
        INPUT <= "0011"; -- writing 3
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="1111") -- we should still read 15
            report "OUT should point at the first item" severity error;
            
            
        INPUT <= "1100"; -- writing 12
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="1111") -- we should still read 15
            report "OUT should point at the first item" severity error;
            
            
        INPUT <= "1010"; -- writing 10
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="1111") -- we should still read 15
            report "OUT should point at the first item" severity error;
            
            
        INPUT <= "0101"; -- writing 5
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="1111") -- we should still read 15
            report "OUT should point at the first item" severity error;
            
            
        INPUT <= "0001"; -- writing 1
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="1111") -- we should still read 15
            report "OUT should point at the first item" severity error;
        
           
        INPUT <= "0000"; -- writing to FULL BUFFER
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (NO_PUSH='1' AND NO_POP='0' AND OUTPUT="1111") -- we should still read 15
            report "OUT should point at the first item" severity error;

        INPUT <= "0000"; -- writing to FULL BUFFER
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (NO_PUSH='1' AND NO_POP='0' AND OUTPUT="1111") -- we should still read 15
            report "OUT should point at the first item" severity error;
        
        
        WRITE <= '0';
        READ <= '1';
        wait for TbPeriod;
        report "READ: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="1111" AND NO_PUSH='0' AND NO_POP='0') -- we should still read 15
            report "OUT FLAG SHOULD HAVE BEEN DROPPED" severity error;
        

        report "                    ";
        report "                    ";
        report "                    ";
        report "                    ";
        -- READING
        WRITE <= '0';
        READ <= '1';

            
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="1001") -- we should read 9
            report "OUT should point at the first item" severity error;

            
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="0110") -- we should read 6
            report "OUT should point at the first item" severity error;
        
            
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="0011") -- we should  read 9
            report "OUT should point at the first item" severity error;
        
            
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="1100") -- we should read 12
            report "OUT should point at the first item" severity error;
        
            
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="1010") -- we should read 10
            report "OUT should point at the first item" severity error;
        
            
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="0101") -- we should read 5
            report "OUT should point at the first item" severity error;
        
            
        wait for TbPeriod;
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="0001") -- we should read 1
            report "OUT should point at the first item" severity error;

        
        wait for TbPeriod; -- popping from empty buffer
        report "Entity: OUTPUT=" & integer'image(to_integer(unsigned(OUTPUT)));
        assert (OUTPUT="0000" AND NO_POP='1' AND NO_PUSH='0') -- we should read 0 AND NOPOP
            report "OUT should point at the first item" severity error;
            

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

--configuration cfg_tb_fifo of tb_fifo is
--    for tb
--    end for;
--end cfg_tb_fifo;