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
			OUTPUT : out std_logic_vector(7 downto 0)
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
			OUTPUT : out std_logic_vector(7 downto 0)
		);
	end component;
	signal malloc, free, mem_done : std_logic;
	signal buffr : std_logic_vector(31 downto 0);
	signal size : natural;
	constant capacity : natural := 3;
	
	begin
		ALLOCATOR: process(CLK, INIT) is
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
				if (mem_done = '1') then
					malloc <= '0';
					free <= '0';
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
				--OUTPUT <= "00000000";
				NOPOP <= '0';
				NOPUSH <='0';
				FULL <= '0';
				EMPTY <= '0';
			end if;
		end process;
		MEMORY_DISPLAY : process(CLK) is
		begin
			if (rising_edge(CLK)) then
				if (malloc/=free) then
				if (malloc='1') then
					if (size=0) then
						buffr(7 downto 0) <= INPUT(7 downto 0);
					elsif (size=1) then
						buffr(15 downto 8) <= INPUT(7 downto 0);
					elsif (size=2) then
						buffr(23 downto 16) <= INPUT(7 downto 0);
					elsif (size=3) then
						buffr(31 downto 24) <= INPUT(7 downto 0);
					end if;			
					mem_done <= '1';
				elsif (free='1') then
					OUTPUT <= buffr(31 downto 24);
					buffr <= x"00" & buffr(23 downto 0);
					mem_done <= '1';
				end if;
				elsif (malloc=free AND malloc='0') then
					mem_done<='0';
				end if;
			end if;
		end process;
end architecture;
