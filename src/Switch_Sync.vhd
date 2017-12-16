library ieee;
use ieee.std_logic_1164.all;

entity Switch_Sync is 
    port(
        clk         : in std_logic;
        reset       : in std_logic; --Active low
        data_in     : in std_logic_vector(9 downto 0);
        data_out    : out std_logic_vector(9 downto 0)
    );
end Switch_Sync;

architecture internal of Switch_Sync is 
    signal intermediate     : std_logic_vector(9 downto 0);
    signal outp             : std_logic_vector(9 downto 0);

begin
    
    Left : process(clk,reset)
    begin

        If (reset = '0') then 
            intermediate <= "0000000000";
        elsif (rising_edge(clk)) then
            intermediate <= data_in;
        else
            intermediate <= intermediate;
        end if;
            
    end process;

    Right : process(clk,reset)
    begin

        If (reset = '0') then 
            outp <= "0000000000";
        elsif (rising_edge(clk)) then
            outp <= intermediate;
        else
            outp <= outp;
        end if;
   
    end process;

    data_out <= outp;

end internal;