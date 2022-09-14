library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity fifo_ync is
generic(
    M : integer := 8;    --> width 
    N : integer := 4;   --> depth 
    AF: integer := 4;   --> nopush 
    AE: integer := 0    --> nopop
);
port(
    rst,clk         :  in std_logic;
    push            :  in std_logic;
    data_in          :  in std_logic_vector(M-1 downto 0);
    pop            :  in std_logic;
    data_out          : out std_logic_vector(M-1 downto 0);
    empty,nopop         : out std_logic;
    full,nopush          : out std_logic
);
end fifo_ync;

architecture elp of fifo_ync is
    type fifo_type is array(0 to N-1) of std_logic_vector(M-1 downto 0);
    signal r_fifo     : fifo_type := (others => (others => '0'));
    signal s_counter  : integer range 0 to N   := 0;
    signal s_write_count   : integer range 0 to N-1 := 0;
    signal s_read_count   : integer range 0 to N-1 := 0;
    signal s_full, s_empty, s_nopop, s_nopush : std_logic := '0';
begin
    full <= s_full;
    empty <= s_empty;
    nopush <= s_nopush;
    nopop <= s_nopop;
    write: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_write_count <= 0;
            else
                if push = '1' then
                    if s_full = '0' then 
                        r_fifo(s_write_count) <= data_in;
                        if s_write_count = N-1 then
                            s_write_count <= 0;
                        else 
                            s_write_count <= s_write_count+1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process write;

    read: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_read_count <= 0;
            else
                if pop = '1' then
                    if s_empty = '0' then 
                        if s_read_count = N-1 then
                            s_read_count <= 0;
                        else 
                            s_read_count <= s_read_count+1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process read;
    
    count: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_counter <= 0;
            else
                if (push = '1' and pop = '0') then
                    if s_full = '0' then
                        s_counter <= s_counter + 1;
                    end if;
                elsif (push = '0' and pop = '1') then
                    if s_empty = '0' then 
                        s_counter <= s_counter - 1;
                    end if;
                end if;
            end if;
        end if;
    end process count;

    s_empty <= '1' when s_counter = 0 else '0';
    s_full  <= '1' when s_counter = N else '0';
    s_nopop <= '1' when s_counter <= AE else '0';
    s_nopush <= '1' when s_counter >= AF else '0';
    
end architecture elp;