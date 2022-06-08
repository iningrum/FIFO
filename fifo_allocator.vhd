library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- ENTITY
entity fifo is
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
			OUTPUT : out std_logic_vector(31 downto 0)
		);
end entity;
architecture bechaviour of fifo is
	component fifo_allocator
		port(
			PUSH : in std_logic;
			POP : in std_logic;
			INIT : in std_logic;
			CLK : in std_logic;
			-- outputs
			FULL : out std_logic;
			EMPTY : out std_logic;
			NOPOP : out std_logic;
			NOPUSH : out std_logic
		);
	end component;
	component memory
		port(
			INPUT : in std_logic_vector(7 downto 0);
			OUTPUT : out std_logic_vector(31 downto 0)
		);
	end component;
	signal malloc, free : std_logic;
	signal size : natural;
	constant capacity : natural := 3;
	
	begin
		ALLOCATOR: process(CLK, PUSH, POP, free, malloc) is
		begin
			if (rising_edge(CLK) AND INIT='1') then
				EMPTY <= '0';
				FULL <= '0';
				NOPOP <='0';
				NOPUSH <='0';
				if (size=capacity) then
					FULL <= '1';
				elsif (size=0) then
					EMPTY <='1';
				end if;
				if (PUSH='1' AND POP='0') then
					if(size=capacity) then
						NOPUSH <= '1';
					elsif (malloc='0') then
						malloc <= '1';
						size <= size +1;
						if(size=capacity) then
							FULL <= '1';
						end if;
					end if;
				elsif (POP='1' AND PUSH='0') then
					if (size=0) then
						NOPOP <='1';
					elsif (free='0') then
						free <= '1';
						size <= size - 1;
						if (size = 0) then
							EMPTY<='1';
						end if;
					end if;
				end if;
			else
				size <= 0;
				OUTPUT <= "00000000000000000000000000000000";
				NOPOP <= '0';
				NOPUSH <='0';
				FULL <= '0';
				EMPTY <= '0';
			end if;
		end process;
		MEMORY_DISPLAY : process(INPUT, free, malloc) is
		begin
			if (malloc/=free) then
				if (malloc='1') then
					for i in size*8 to size*8+7  loop
						OUTPUT(i) <= INPUT(i-size*8);
					end loop;
					malloc <= '0';
				elsif (free='1') then
					for i in size*8-1 downto size*8+8  loop
						OUTPUT(i) <= '0';
					end loop;
					free <= '0';
				end if;
			end if;
		end process;
end architecture;