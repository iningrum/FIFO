library IEEE;
use IEEE.std_logic_1164.all;

entity fifo is
port(
reset,pop,push : IN std_logic;
clk: in std_logic;
nopop,nopush,f_ll,e_pty : OUT std_logic);
end fifo;

architecture mealymodel of fifo is
	type STATE is (EMPTY, UNDEFINED, FULL);
	signal current_state, next_state : STATE; 
	signal size : natural;
	constant capacity : natural := 3;
	begin
		StateRegister: PROCESS (clk, reset)
  BEGIN
    IF (reset = '1') THEN
      current_state <= EMPTY;
    ELSIF rising_edge(clk) THEN
      current_state <= next_state;
    END IF;
  END PROCESS;

  CombLogic: PROCESS (current_state, push, pop)
  BEGIN
    case current_state is
		when EMPTY =>
			e_pty <= '1';
			if (push='1' and push xor pop) THEN
				next_state <= UNDEFINED;
				size <= size +1;
			elsif (pop='1' and push xor pop) THEN
				nopop <= '1';
			else
				nopop <= '0';
			end if;
		when UNDEFINED =>
			e_pty <= '0';
			f_ll <= '0';
			if (push='1' and push xor pop) then
				if size=capacity-1 then
					next_state <= FULL;
				end if;
				size <= size +1;
			elsif (pop='1' and push xor pop) then
				if size=1 then
					next_state <= EMPTY;
				end if;
				size <= size -1;
			end if;
		when FULL =>
			f_ll <= '1';
			if (push='1' and push xor pop) THEN
				nopush <= '1';
			elsif (pop='1' and push xor pop) THEN
				size <= size - 1;
				next_state <= UNDEFINED;
			else
				nopop <= '0';
			end if;
		end case;
  END PROCESS;

end mealymodel;