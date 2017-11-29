library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MRT is
    port(
        numberToCheck               : in std_logic_vector (7 downto 0);
        clk                         : in std_logic;
        reset                       : in std_logic;
        start                       : in std_logic;
        isPrime                     : out std_logic;
        busy                        : out std_logic;
        done                        : out std_logic
    );
end entity;

architecture internal of MRT is

    type State_Type is (START,
                        INITIAL_SETUP,
                        CHECK_D_AND_ONE,
                        BITSHIFT_D,
                        COMPUTE_T_P,
                        DONE);
    
    signal curr_state           : State_Type;
    signal next_state           : State_Type;

    signal int_N                : integer;
    signal int_N_minus_one      : integer;
    signal N_minus_one          : std_logic_vector (7 downto 0);

    signal d_in                 : std_logic_vector(7 downto 0);
    signal d                    : std_logic_vector(7 downto 0);
    signal check                : std_logic;
    signal counter_j            : integer;
    signal counter_j_flag       : std_logic;

        


    begin

        Register_Section    : process(clk, reset)
        begin
            if (rising_edge(clk)) then
                if (reset = '0') then
                    curr_state <= START;
                else
                    curr_state <= next_state;
                end if;
            end if;
        end process;

        Transition_Section  : process(clk, curr_state)
        begin
            case curr_state is
                when START =>
                    if (start = '1') then 
                        next_state <= INITIAL_SETUP;
                    else
                        next_state <= START;
                    end if;

                when INITIAL_SETUP =>
                    int_N <= unsigned(numberToCheck);
                    N_minus_one <= std_logic_vector((unsigned(numberToCheck)) - 1 );
                    int_N_minus_one <= (unsigned(numberToCheck) - 1);
                    d_in <= N_minus_one;

                    next_state <= BITSHIFT_D;

                when BITSHIFT_D =>
                    d <= '0' & d_in(7 downto 1);
                    counter_j_flag <= '1';
                    check <= d(0) and '1';

                    next_state <= CHECK_D_AND_ONE;

                when CHECK_D_AND_ONE =>
                    if (check = '0') then
                        next_case <= BITSHIFT_D ;
                    else
                        next_case <= COMPUTE_T_P; --state to be defined
                    end if;
                    counter_j_flag <= '0';

                when COMPUTE_T_P =>

                when DONE =>
                
            end case;
        end process;

        Decoder_Section     : process(curr_state)
        begin
            case curr_state is
                when START =>

                when INITIAL_SETUP =>

                when BITSHIFT_D =>
                
                when CHECK_D_AND_ONE =>

                when COMPUTE_T_P =>

                when DONE =>

            end case;
        end process;

        Counter_J_Section   : process(clk, reset, counter_j_flag)
        begin
            if (rising_edge(clk)) then
                if (reset = '0') then 
                    counter_j <= 0;
                else
                    counter_j <= counter_j + 1;
                end if;
            end if;
        end process;



end architecture;