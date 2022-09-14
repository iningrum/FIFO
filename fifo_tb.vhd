-- based on stsecen/vhdl_fifo
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_tbb is
end fifo_tbb;
architecture elp of fifo_tbb is
    constant  M : integer := 8;
    constant N  : integer := 32;
    constant AF : integer := 30;
    constant AE : integer := 2;

    signal rst,uut_clk, pop_timer, push_timer, push, pop : std_logic := '0';
    signal data_in, uut_data_async, data_out : std_logic_vector(M-1 downto 0) := (others => '0');
    signal uut_empty_async, uut_full_async: std_logic := '0';
    signal uut_aempty_async, uut_afull_async: std_logic := '0';
    signal uut_empty_sync, uut_full_sync: std_logic := '0';
    signal uut_aempty_sync, uut_afull_sync: std_logic := '0';
    constant uut_clk_we_time: time := 100 ns;
    constant pop_timer_time: time := 50 ns;
    constant uut_clk_time: time := 10 ns;
begin
    sync:  entity work.fifo_ync(elp)
           generic map(
                M => M,
                N => N,
                AF=> AF,
                AE=> AE)
            port map(
            rst => rst,
            clk => uut_clk,
            push => push,   
            data_in => data_in,   
            pop => pop,
            data_out => data_out,  
            nopush => uut_afull_sync,
            nopop => uut_aempty_sync,
            empty => uut_empty_sync,
            full => uut_full_sync
           );
    
    gen_wr_clk: process
    begin
        for i in 0 to 100 loop
            wait for uut_clk_we_time/2;
            push_timer <= '1';
            wait for uut_clk_we_time/2;
            push_timer <= '0';
        end loop;
        wait;
    end process;

    gen_rd_clk: process
    begin
        for i in 0 to 200 loop
            wait for pop_timer_time/2;
            pop_timer <= '1';
            wait for pop_timer_time/2;
            pop_timer <= '0';
        end loop;
        wait;
    end process;

    gen_sync_clk: process
    begin
        for i in 0 to 200 loop
            wait for uut_clk_time/2;
            uut_clk <= '1';
            wait for uut_clk_time/2;
            uut_clk <= '0';
        end loop;
        wait;
    end process;

    uut: process
    begin
        rst <= '1';
        wait for 20 * pop_timer_time;
        rst <= '0';

        for i in 1 to 20 loop
            data_in <= std_logic_vector(to_unsigned(i, M));
            wait for uut_clk_we_time;
            push <= '1';
            wait for uut_clk_we_time;
            push <= '0';
        end loop;

        wait until pop_timer = '0';
        pop <= '1';
        wait for 30 * pop_timer_time;
        pop <= '0';

        for i in 1 to 50 loop
            data_in <= std_logic_vector(to_unsigned(i, M));
            wait for uut_clk_we_time;
            push <= '1';
            wait for uut_clk_we_time;
            push <= '0';
        end loop;

        wait until pop_timer = '0';

        for i in 1 to 20 loop
            push <= '1';
            wait for pop_timer_time;
        end loop;
        wait;
    end process uut;
end architecture elp;