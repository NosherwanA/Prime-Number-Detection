library ieee;
use ieee.std_logic_1164.all;

entity Switch_Sync is 
    port(
        SW_clk         : in std_logic;
        SW_reset       : in std_logic; --Active low
        SW_in     : in std_logic_vector(9 downto 0);
        SW_out    : out std_logic_vector(9 downto 0)
    );
end Switch_Sync;

architecture internal of Switch_Sync is 
    signal intermediate     : std_logic_vector(9 downto 0);
    signal outp             : std_logic_vector(9 downto 0);

begin
    
    Left : process(SW_clk,SW_reset)
    begin

        If (SW_reset = '0') then 
            intermediate <= "0000000000";
        elsif (rising_edge(SW_clk)) then
            intermediate <= SW_in;
        else
            intermediate <= intermediate;
        end if;
            
    end process;

    Right : process(SW_clk,SW_reset)
    begin

        If (SW_reset = '0') then 
            outp <= "0000000000";
        elsif (rising_edge(SW_clk)) then
            outp <= intermediate;
        else
            outp <= outp;
        end if;
   
    end process;

    SW_out <= outp;

end internal;