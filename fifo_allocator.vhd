library IEEE;
use IEEE.std_logic_1164.all;

entity fifo is
port(
init,pop,push : IN std_logic;
clk: in std_logic;
nopop,nopush,f_ll,e_pty : OUT std_logic);
end fifo;

architecture mealymodel of fifo is
	type STATE is (EMPTY, UNDEFINED, FULL);
	signal current_state, next_state : STATE; 
	signal size : natural;
	constant capacity : natural := 3;
	begin
		process(init, clk) begin
			if init='1' then  
				-- proper code
				if rising_edge(CLK)  then
					case current_state is
						when EMPTY =>
							if push='1' and pop='0' then
								next_state <= UNDEFINED;
								size <= size+1;
							end if;
						when UNDEFINED =>
							if push='1' and pop='0' and size=capacity-1 then
								next_state <= FULL;
							elsif push='0' and pop='1' and size=1 then
								next_state <= EMPTY;	
							end if;
						when FULL =>
							if push='0' and pop='1' then
								next_state <= UNDEFINED;
								size <= size-1;
							end if;
						end case;
						------------------------
					current_state <= next_state;
					case current_state is
						when EMPTY => -- Empty stack
						report "STATE IS EMPTY | "& integer'image(size) severity warning;
							if push='1' and pop='0' then
								nopop <= '0';
							elsif push='0' and pop='1' then
								nopop <= '1';
							elsif push='0' and pop='0' then
								nopop <='0';
							end if;
							nopush<= '0';
							f_ll <= '0';
							e_pty <= '1';
						when UNDEFINED => -- Neither full nor empty
						report "STATE IS UNDEFINED | "& integer'image(size) severity warning;
							e_pty<='0';
							f_ll<='1';
							if push='1' and pop='0' and size<=capacity then
								size <= size + 1;
							elsif push='0' and pop='1' and size/=0 then
								size <= size - 1;
							end if;
						when FULL => -- Full stack
						report "STATE IS FULL | "& integer'image(size) severity warning;
							if push='1' and pop='0' then
								nopush <= '1';
							elsif push='0' and pop='1' then
								nopush<='0';
							end if;

						end case;
					end if;
			elsif init='0' and rising_edge(clk) then
				report "----RESET-----" severity warning;
				-- reset
				next_state <= EMPTY;
				current_state <= EMPTY;
				size <= 0;
				e_pty <= '1';
				f_ll <= '0';
				nopop<='0';
				nopush<='0';
			end if;
		end process;

end mealymodel;