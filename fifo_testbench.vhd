library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fifo_tb is
end entity;

architecture dataflow of fifo_tb is
component fifo is
port(
	reset,pop,push : IN std_logic;
	clk: in std_logic;
	nopop,nopush : OUT std_logic);
end component;

signal reset,pop,push,clk,nopop,nopush : std_logic;
constant CKperiod : time := 5 ns;
begin

uut : fifo port map(
	reset=>reset,
	pop=>pop,
	push=>push,
	clk=>clk,
	nopop=>nopop,
	nopush=>nopush);

stim : process 
begin

pop <= '0';
push <= '0';
reset <='0';
report "[0] setup" severity warning;
-- ensure reset
wait until rising_edge(clk);
reset <= '1';
-- ensure initialization
report "[1]  testing resetialization" severity warning;
wait until rising_edge(clk);
assert nopop='0' and nopush='0'
report "Stack should be empty after init" severity error;
-- state EMPTY :: test pop
report "[2]   popping from empty stack" severity warning;
pop <='1';
wait until rising_edge(clk);
pop<='0';
-- 		check if nopop works
assert nopop='1' and nopush='0'
report "double free - Stack shout return nopop" severity failure;
--		check if nopop=0 after no popping occured
report "[3]    veryfying that nopop defaults to 0" severity warning;
wait until rising_edge(clk);
assert nopop='0' and nopush='0'
report "nopop should default to 0" severity failure;
--		check if reset(reset=1) works
reset<='1';
wait until rising_edge(clk);
reset<='0';
assert nopop='0' and nopush='0'
report "Stack should be empty after reset" severity failure;
-- state EMPTY :: test transition EMPTY->UNDEFINED->EMPTY
push<='1';
pop<='0';
wait until rising_edge(clk);
push<='0';
wait until rising_edge(clk);
-- mmm
push<='1';
report "ww" severity warning;
wait until rising_edge(clk);
wait until rising_edge(clk);wait until rising_edge(clk);wait until rising_edge(clk);wait until rising_edge(clk);wait until rising_edge(clk);wait until rising_edge(clk);
report "ww" severity warning;
-- state EMPTY :: test transition EMPTY->UNDEFINED->FULL->UNDEFINED

assert 1=0
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