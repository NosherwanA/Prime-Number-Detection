library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prime_decoder is
    port(
        isPrime         : in std_logic;
        hexdisplay      : out std_logic_vector(20 downto 0)
    );
end prime_decoder;

architecture internal of prime_decoder is

    begin 
        
        with isPrime select hexdisplay <= 
            "010101100011000101111" when '0', -- display nPr
            "111111100011000101111" when '1', -- display Pr
            "111111111111111111111" when others; -- Display nothing

end architecture;

-- 6, 5, 4, 3, 2, 1, 0

-- n : 0101011
-- P : 0001100
-- r : 0101111