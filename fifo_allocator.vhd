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

	--signal malloc, free, mem_done : std_logic;
	signal buffr : std_logic_vector(31 downto 0);
	signal size : natural;
	constant capacity : natural := 3;
	
	begin
		ALLOCATOR: process(CLK, INIT) is
		begin
			if rising_edge(CLK) and INIT='1' then
				if PUSH /= POP then
					if size = '0' then
						EMPTY <= '1';
					elsif size = '3' then
						FULL <= '1';
					else
						EMPTY <= '0';
						FULL <= '0';
						NOPOP <= '0';
						NOPUSH <='0';
					end if;
					if PUSH ='1' AND FULL='0' then
						if size =0 then
							buffr(7 downto 0) <= INPUT(7 downto 0);
						elsif size=1 then
							buffr(15 downto 8) <= INPUT(7 downto 0);
						elsif size=2 then
							buffr(23 downto 16) <= INPUT(7 downto 0);
						elsif (size=3) then
							buffr(7 downto 0) <= INPUT(7 downto 0);
						end if;
						size <= size +1;
					elsif POP ='1' and EMPTY='0' then
						OUTPUT <= buffr(31 downto 24); 
						buffr <= x"00" & buffr(23 downto 0);
					elsif PUSH = '1' and FULL ='1' then
						NOPUSH <='1';
					elsif POP = '1' and EMPTY = '1' then
						NOPOP <= '1';
					end if;
				end if;
			elsif INIT='0' then
			size <=0;
			end if;
		end process;
end architecture;
