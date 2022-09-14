library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity fifo is
    generic (ELEM_NUM : positive := 8;  -- number of elements
             ELEM_BITS : positive := 4); -- number of bits per element

    port    (WRITE, READ, CLK : in std_logic; -- WRITE/READ to instrukcje
             INPUT : in std_logic_vector (ELEM_BITS-1 downto 0);
             OUTPUT : out std_logic_vector (ELEM_BITS-1 downto 0);
             NO_PUSH, NO_POP: out std_logic);
end fifo;


architecture basic of fifo is
    type BUFFR_TYPE is array(ELEM_NUM-1 downto 0) of std_logic_vector (ELEM_BITS-1 downto 0);
    signal BUFFR : BUFFR_TYPE;
    constant empty_elem : std_logic_vector (ELEM_BITS-1 downto 0) := (others =>'0') ;
    signal u1 : unsigned (2 downto 0);

begin

    main : process(CLK) is
        variable counter : natural range 0 to ELEM_NUM := 0;
        variable READ_BEFORE : boolean  := false;
    begin
        if(rising_edge(CLK)) then -- zegar?
            if(READ_BEFORE) then -- był odczyt?
                BUFFR <= empty_elem & BUFFR(ELEM_NUM-1 downto 1);
                -- w poprzednim cyklu był odczyt, wszystko jest zatem shiftowane w lewo
                -- [0101][1100][1111][...] -> [1100][1111][...][empty_elenm]
            end if;

            if(WRITE='1' and (counter /= ELEM_NUM)) then -- zapis
                BUFFR(counter) <= INPUT;
                counter := counter +1;
            elsif(WRITE='1') then
                NO_PUSH<='1';
            end if;

            if(READ='1' and (counter /= 0)) then -- odczyt
                counter := counter -1;
                READ_BEFORE:= true;
            elsif(READ='1') then
                NO_POP<='1';
            end if;

            if(READ='0') then -- reset flagi READ_BEFORE
                READ_BEFORE := false;
                NO_POP<='0';
            elsif(WRITE='0') then
                NO_PUSH<='0';
            end if;
        end if;
    end process main;

    OUTPUT <= BUFFR(0);

end basic;