library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- ENTITY
entity fifo_tb is
end entity;
architecture behaviour of fifo_tb is
	component FIFO_allocator
		PORT(
			-- inputs 1B
			PUSH : in std_logic;
			POP : in std_logic;
			INIT : in std_logic;
			CLK : in std_logic;
			-- outputs 1B
			FULL : out std_logic;
			EMPTY : out std_logic;
			NOPOP : out std_logic;
			NOPUSH : out std_logic;
			-- 8B I/O
			INPUT : in std_logic_vector(7 downto 0);
			OUTPUT : out std_logic_vector(7 downto 0)
		);
	end component;
	-- 1B in
	signal PUSH : std_logic;
	signal POP : std_logic;
	signal INIT : std_logic;
	signal CLK : std_logic;
	-- 1B out
	signal FULL : std_logic;
	signal EMPTY : std_logic;
	signal NOPOP : std_logic;
	signal NOPUSH : std_logic;
	-- 8B I/O
	signal INPUT : std_logic_vector(7 downto 0);
	signal OUTPUT : std_logic_vector(7 downto 0);
	constant ckPERIOD : time := 5 ns;
begin
	uut: FIFO_allocator port map (
		PUSH => PUSH,
		POP => POP,
		INIT => INIT,
		CLK => CLK,
		FULL => FULL,
		EMPTY => EMPTY,
		NOPOP => NOPOP,
		NOPUSH => NOPUSH,
		INPUT => INPUT,
		OUTPUT => OUTPUT
	);

--	INIT - then
--	5 writes and 5 reads - fifth one should be either NOPOP or NOPUSH fourth one should be FULL or EMPTY
CLK_GEN: process
begin
	CLK <= '0';
	loop
		wait for ckPERIOD;
		CLK <= not CLK;
	end loop;
	wait;
end process CLK_GEN;
-- testing behaviour of control unit
TEST_CONTROL_UNIT: process
begin
	PUSH <= '0';
	POP <= '0';
	INIT <= '0';
	INPUT <= "00000000";
	-- execution
	INIT <= '1';
	for i in 0 to 4 loop
		wait until CLK = '1' ;
		PUSH <= not PUSH;
		INPUT <= std_logic_vector(unsigned(INPUT) + 1);
		wait until CLK = '1' ;
		PUSH <= not PUSH;
	end loop;
	for i in 0 to 4 loop
		wait until CLK = '1' ;
		POP <= not POP;
		wait until CLK = '1' ;
		POP <= not POP;
	end loop;
	end process;
	END;