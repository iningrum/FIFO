library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fifo_tb is
end entity;

architecture dataflow of fifo_tb is
component fifo is
port(
	init,pop,push : IN std_logic;
	clk: in std_logic;
	nopop,nopush,f_ll,e_pty : OUT std_logic);
end component;

signal init,pop,push,clk,nopop,nopush,f_ll,e_pty : std_logic;
constant CKperiod : time := 5 ns;
begin

uut : fifo port map(
	init=>init,
	pop=>pop,
	push=>push,
	clk=>clk,
	nopop=>nopop,
	nopush=>nopush,
	f_ll=>f_ll,
	e_pty=>e_pty);

stim : process 
begin

pop <= '0';
push <= '0';
init <='0';
report "[0] setup" severity warning;
-- ensure reset
wait until rising_edge(clk);
init <= '1';
-- ensure initialization
report "[1]  testing initialization" severity warning;
wait until rising_edge(clk);
assert e_pty='1' and f_ll = '0' and nopop='0' and nopush='0'
report "Stack should be empty after init" severity error;
-- state EMPTY :: test pop
report "[2]   popping from empty stack" severity warning;
pop <='1';
wait until rising_edge(clk);
pop<='0';
wait until rising_edge(clk);
-- 		check if nopop works
assert e_pty='1' and f_ll ='0' and nopop='1' and nopush='0'
report "double free - Stack shout return nopop" severity failure;
--		check if nopop=0 after no popping occured
report "[3]    veryfying that nopop defaults to 0" severity warning;
pop <='0';
wait until rising_edge(clk);
assert e_pty='1' and f_ll ='0' and nopop='0' and nopush='0'
report "nopop should default to 0" severity failure;
--		check if reset(init=0) works
init<='0';
wait until rising_edge(clk);
init<='1';
assert e_pty='1' and f_ll = '0' and nopop='0' and nopush='0'
report "Stack should be empty after init" severity failure;
-- state EMPTY :: test transition EMPTY->UNDEFINED->EMPTY
push<='1';
pop<='0';
wait until rising_edge(clk);
push<='0';
wait until rising_edge(clk);
wait until rising_edge(clk);
wait until rising_edge(clk);
assert e_pty='0' --and f_ll='0' and nopop='0' and nopush='0'
report "Stack should be no longer empty after pushing" severity failure;
pop<='1';
push<='0';
wait until rising_edge(clk);
wait until rising_edge(clk);
wait until rising_edge(clk);
wait until rising_edge(clk);
assert e_pty='1' and f_ll='0' and nopop='0' and nopush='0'
report "Stack should be empty after popping last item" severity failure;
wait until rising_edge(clk);
-- state EMPTY :: test transition EMPTY->UNDEFINED->FULL->UNDEFINED

assert 1=1
report "------------------TEST PASSED------------------" severity failure;
end process;
CLK_GEN : process
	begin
		CLK <= '0';
		loop
			wait for CKperiod;
			CLK <= not CLK;
		end loop;
	wait;
	end process;
end ;