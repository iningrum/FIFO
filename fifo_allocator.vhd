library IEEE;
use IEEE.std_logic_1164.all;

entity fifo is
port(
reset,pop,push : IN std_logic;
clk: in std_logic;
nopop,nopush : OUT std_logic);
end fifo;

architecture mealymodel of fifo is
	type STATE is (EMPTY, UNDEFINED, FULL);
	signal current_state, next_state : STATE; 
	signal size : natural range 0 to 3 := 0;
	constant capacity : natural := 3;
	constant mcap: natural := capacity-1; 
	begin
		StateRegister: PROCESS (clk, reset)
  BEGIN
    IF (reset = '1') THEN
    	current_state <= EMPTY;
    ELSIF rising_edge(clk) THEN
	  report "=======>> STATE UPDATE" severity warning;
	  report "                                              STATE | "& STATE'image(current_state)&" | "& STATE'image(next_state) severity warning;
      current_state <= next_state;
    END IF;
  END PROCESS;

  CombLogic: PROCESS (clk,push,pop)
  BEGIN
  report "STATE | "& STATE'image(current_state)&" | "& STATE'image(next_state) severity warning;
    case current_state is
		when EMPTY =>
		report "STATE IS EMPTY | "& integer'image(size)&" | "& std_logic'image(nopop) severity warning;
			
			if (push='1' and push/=pop) THEN
				next_state <= UNDEFINED;
				--size <= size +1;
			elsif (pop='1' and push/=pop) THEN
				nopop <= '1';
			else
				nopop <= '0';
			end if;
			nopush<='0';
		when UNDEFINED =>
		report "STATE IS UNDEFINED | "& integer'image(size)&" | "&std_logic'image(nopop) severity warning;
			next_state<=FULL;
		when FULL =>
			report "STATE IS FULL | "& integer'image(size)&" | "& std_logic'image(nopush) severity warning;
			if (push='1' and push/=pop) THEN
				nopush <= '1';
			elsif (pop='1' and push/=pop) THEN
				--size <= size - 1;
				next_state <= UNDEFINED;
			else
				nopop <= '0';
			end if;
		end case;
  END PROCESS;

end mealymodel;