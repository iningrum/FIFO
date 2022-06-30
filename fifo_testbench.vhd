library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- ENTITY
entity fifo_tb is
end entity;
architecture behaviour of fifo_tb is
	component fifo
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
	-- additional signals
	constant CKperiod : time := 5 ns;
	
begin
	uut: fifo port map (
		PUSH => PUSH,
		CLK => CLK,
		POP => POP,
		INIT => INIT,
		FULL => FULL,
		EMPTY => EMPTY,
		NOPOP => NOPOP,
		NOPUSH => NOPUSH,
		INPUT => INPUT,
		OUTPUT => OUTPUT
	);

--	INIT - then
--	5 writes and 5 reads - fifth one should be either NOPOP or NOPUSH fourth one should be FULL or EMPTY
-- testing behaviour of control unit
TEST_CONTROL_UNIT: process
begin
	PUSH <= '0';
	POP <= '0';
	INIT <= '0';
	INPUT <= "00000000";
	-- execution
	INIT <= '1';
	-- pushing
	for i in 0 to 12 loop
		PUSH <= '1';
		wait until rising_edge(CLK);
		assert NOPUSH = '0' AND NOPOP = '0' AND FULL = '0' AND EMPTY = '0'
			report "Invalid allocation"
			severity failure;
		PUSH <= '0';
	end loop;
	wait until rising_edge(CLK);
	assert NOPUSH = '0' AND NOPOP = '0' AND FULL = '1' AND EMPTY = '0'
		report "Memory should be full"
		severity failure;
	PUSH <= NOT PUSH;
	wait until rising_edge(CLK);
	assert NOPUSH = '1' AND NOPOP = '0' AND FULL = '1' AND EMPTY = '0'
		report "Memory overflow"
		severity failure;
	POP <= NOT POP;
	wait until rising_edge(CLK);
	assert NOPUSH = '0' AND NOPOP = '0' AND FULL = '0' AND EMPTY = '0'
		report "NOPUSH shouldn't be in HIGH state as FIFO is no longer full"
		severity failure;
	PUSH <= NOT PUSH;
	wait until rising_edge(CLK);
	assert NOPUSH = '0' AND NOPOP = '0' AND FULL = '1' AND EMPTY = '0'
		report "Memory should be full"
		severity failure;
	-- popping
	for i in 0 to 2 loop
		POP <= NOT POP;
		wait until rising_edge(CLK);
		assert NOPUSH = '0' AND NOPOP = '0' AND FULL = '0' AND EMPTY = '0'
			report "Invalid allocation"
			severity failure;
	end loop;
	POP <= NOT POP;
	wait until rising_edge(CLK);
	assert NOPUSH = '0' AND NOPOP = '0' AND FULL = '0' AND EMPTY = '1'
		report "Memory should be empty"
		severity failure;
	POP <= NOT POP;
	wait until rising_edge(CLK);
	assert NOPUSH = '0' AND NOPOP = '1' AND FULL = '0' AND EMPTY = '1'
		report "Memory overflow"
		severity failure;
	PUSH <= NOT PUSH;
	wait until rising_edge(CLK);
	assert NOPUSH = '0' AND NOPOP = '0' AND FULL = '0' AND EMPTY = '0'
		report "NOPOP shouldn't be in HIGH state as FIFO is no longer empty"
		severity failure;
	POP <= NOT POP;
	wait until rising_edge(CLK);
	assert NOPUSH = '0' AND NOPOP = '0' AND FULL = '0' AND EMPTY = '1'
		report "Memory should be empty"
		severity failure;
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
	END;
