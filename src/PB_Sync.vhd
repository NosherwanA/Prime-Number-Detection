library ieee;
use ieee.std_logic_1164.all;

entity PB_Sync is 
    port(
        PB_clk         : in std_logic;
        PB_reset       : in std_logic; --Active low
        PB_in     : in std_logic_vector(3 downto 0);
        PB_out    : out std_logic_vector(3 downto 0)
    );
end PB_Sync;

architecture internal of PB_Sync is 
    signal intermediate     : std_logic_vector(3 downto 0);
    signal outp             : std_logic_vector(3 downto 0);

begin
    
    Left : process(PB_clk,PB_reset)
    begin

        If (PB_reset = '0') then 
            intermediate <= "0000";
        elsif (rising_edge(PB_clk)) then
            intermediate <= PB_in;
        else
            intermediate <= intermediate;
        end if;
            
    end process;

    Right : process(PB_clk,PB_reset)
    begin

        If (PB_reset = '0') then 
            outp <= "0000";
        elsif (rising_edge(PB_clk)) then
            outp <= intermediate;
        else
            outp <= outp;
        end if;
   
    end process;

    PB_out <= outp;

end internal;