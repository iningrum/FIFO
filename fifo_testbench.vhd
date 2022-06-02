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
	-- 1B out
	signal FULL : std_logic;
	signal EMPTY : std_logic;
	signal NOPOP : std_logic;
	signal NOPUSH : std_logic;
	-- 8B I/O
	signal INPUT : std_logic_vector(7 downto 0);
	signal OUTPUT : std_logic_vector(7 downto 0);
	-- additional signals
	signal lastPUSH : std_logic;
	signal lastPOP : std_logic;
	signal OPERATION_DONE : std_logic;
begin
	uut: FIFO_allocator port map (
		PUSH => PUSH,
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
	lastPUSH <= '0';
	lastPOP <= '0';
	POP <= '0';
	INIT <= '0';
	INPUT <= "00000000";
	OPERATION_DONE <= '0';
	-- execution
	INIT <= '1';
	-- pushing
	for i in 0 to 2 loop
		PUSH <= NOT PUSH;
		assert NOPUSH = '0' AND NOPOP = '0' AND FULL = '0' AND EMPTY = '0'
			report "Invalid allocation"
			severity failure;
	end loop;
	PUSH <= NOT PUSH;
	assert NOPUSH = '0' AND NOPOP = '0' AND FULL = '1' AND EMPTY = '0'
		report "Memory should be full"
		severity failure;
	PUSH <= NOT PUSH;
	assert NOPUSH = '1' AND NOPOP = '0' AND FULL = '1' AND EMPTY = '0'
		report "Memory overflow"
		severity failure;
	-- popping
	for i in 0 to 2 loop
		POP <= NOT POP;
		assert NOPUSH = '0' AND NOPOP = '0' AND FULL = '0' AND EMPTY = '0'
			report "Invalid allocation"
			severity failure;
	end loop;
	POP <= NOT POP;
	assert NOPUSH = '0' AND NOPOP = '0' AND FULL = '0' AND EMPTY = '1'
		report "Memory should be full"
		severity failure;
	POP <= NOT POP;
	assert NOPUSH = '0' AND NOPOP = '1' AND FULL = '0' AND EMPTY = '1'
		report "Memory overflow"
		severity failure;
	end process;
	
	process(PUSH, POP, lastPUSH, lastPOP, OPERATION_DONE)
   begin
     if PUSH /= lastPUSH then
			if OPERATION_DONE = '1' then
            	lastPUSH <= PUSH;
				OPERATION_DONE <= '0';
			end if;
	elsif POP /= lastPOP then
			if OPERATION_DONE = '1' then
            	lastPOP <= POP;
				OPERATION_DONE <= '0';
			end if;
     end if;
   end process;
	END;