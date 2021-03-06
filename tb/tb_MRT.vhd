library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_MRT is

end tb_MRT;

architecture test of tb_MRT is 

    component MRT is 
        port(
            numberToCheck               : in std_logic_vector (7 downto 0);
            clk                         : in std_logic;
            reset                       : in std_logic;
            start                       : in std_logic;
            isPrime                     : out std_logic;
            busy                        : out std_logic;
            done                        : out std_logic
        );
    end component;

    signal in_numberToCheck             : std_logic_vector(7 downto 0);
    signal in_clk                       : std_logic;
    signal in_reset                     : std_logic;
    signal in_start                     : std_logic;
    signal out_isPrime                  : std_logic;
    signal out_busy                     : std_logic;
    signal out_done                     : std_logic;

    constant TIME_PERIOD                : time := 20 ns;
    constant DELTA_TIME                 : time := 20 ns;


begin
    
    DUT: MRT 
        port map(
            in_numberToCheck,
            in_clk,
            in_reset,
            in_start,
            out_isPrime,
            out_busy,
            out_done
        );

    clock_process: process
    begin
        in_clk <= '0';
        wait for (TIME_PERIOD/2);
        in_clk <= '1';
        wait for (TIME_PERIOD/2);
    end process;

    simulation: process
    begin
        --INITIAL RESET
        in_reset <= '0';
        wait for 15 ns;
        in_reset <= '1';
        wait for 5 ns;

        in_start <= '1';
        in_numberToCheck <= "00101111"; -- (47)10
        wait for 15 ns;
        in_start <= '0';
        wait until (out_done = '1');
        --result: 1
        wait for DELTA_TIME;

        in_start <= '1';
        in_numberToCheck <= "10010010"; -- (146)10
        wait for 15 ns;
        in_start <= '0';
        wait until (out_done = '1');
        --result: 0
        wait for DELTA_TIME;

        in_start <= '1';
        in_numberToCheck <= "01001011"; -- (75)10
        wait for 15 ns;
        in_start <= '0';
        wait until (out_done = '1');
        --result: 0
        wait for DELTA_TIME;

        in_start <= '1';
        in_numberToCheck <= "11111011"; --(251)10
        wait for 15 ns;
        in_start <= '0';
        wait until (out_done = '1');
        --result: 1
        wait for DELTA_TIME;

        in_start <= '1';
        in_numberToCheck <= "11111101"; --(253)10
        wait for 15 ns;
        in_start <= '0';
        wait until (out_done = '1');
        --result: 0
        wait for DELTA_TIME;

        in_start <= '1';
        in_numberToCheck <= "11111110"; --(254)10
        wait for 15 ns;
        in_start <= '0';
        wait until (out_done = '1');
        --result: 0
        wait for DELTA_TIME;

        in_start <= '1';
        in_numberToCheck <= "10010111"; -- (151)10
        wait for 15 ns;
        in_start <= '0';
        wait until (out_done = '1');
        --result: 1
        wait for DELTA_TIME;

        in_start <= '1';
        in_numberToCheck <= "10011001"; -- (153)10
        wait for 15 ns;
        in_start <= '0';
        wait until (out_done = '1');
        --result: 0
        wait for DELTA_TIME;

        in_start <= '1';
        in_numberToCheck <= "00000011"; -- (3)10
        wait for 15 ns;
        in_start <= '0';
        wait until (out_done = '1');
        --result: 1
        wait for DELTA_TIME;

        in_start <= '1';
        in_numberToCheck <= "00000000"; -- (0)10
        wait for 15 ns;
        in_start <= '0';
        wait until (out_done = '1');
        --result: 0
        wait for DELTA_TIME;

        in_start <= '1';
        in_numberToCheck <= "00000001"; -- (1)10
        wait for 15 ns;
        in_start <= '0';
        wait until (out_done = '1');
        --result: 0
        wait for DELTA_TIME;

    end process;

end architecture;
