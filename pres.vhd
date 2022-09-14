library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity ctrl7seg is
    port(
        inputs: in std_logic_vector(3 downto 0);
        outs: out std_logic_vector(7 downto 0));
end;
architecture prs of ctrl7seg is
    begin
        process(inputs) begin
            case (inputs) is
                when "0000" => outs<= "00000011";
                when "0001" => outs<="10011111";
                when "0010" => outs<="00100101";
                when "0011" =>outs<="00001101";
                --
                when "0100" =>outs<="10011001";
                when "0101" =>outs<="01001001";
                when "0110" =>outs<="01000001";
                when "0111" =>outs<="00011111";
                --
                when "1000" =>outs<="00000001";
                when "1001" =>outs<="00001001";
                when others =>outs<="11111111";
    
                end case;
        end process;
end prs;
