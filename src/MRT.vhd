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
                        BITSHIFT_D_FWHILE,
                        CHECK_D_FWHILE,
                        COMPUTE_P,
                        STORE_P,
                        COMPUTE_T,
                        STORE_T,
                        COMPARE_T,
                        SECOND_WHILE,
                        COMPUTE_T_SW,
                        STORE_T_SW,
                        COMPARE_T_SW,
                        DONE);
    
    signal prime                : std_logic:= '0';
    
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

    signal int_t                : integer;
    signal int_p                : integer;

    signal d_while              : std_logic_vector(7 downto 0);
    signal check_d              : std_logic;

    signal int_p_temp           : integer;
    signal int_t_temp           : integer;
    signal check_d_one          : std_logic;

    signal counter_k            : integer;
    signal counter_k_flag       : std_logic;

        


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
                        d_in <= d;
                    else
                        next_case <= COMPUTE_T_P;
                    end if;
                    counter_j_flag <= '0';

                when COMPUTE_T_P =>
                    int_t <= 2;
                    int_p <= 2;
                    
                    next_state <= BITSHIFT_D_FWHILE; --state to be determined

                when BITSHIFT_D_FWHILE =>
                    d_while <= '0' & d(7 downto 1);
                    check_d <= d_while and "00000000";

                    next_state <= CHECK_D_FWHILE;

                when CHECK_D_FWHILE =>
                    if (check_d = '0') then
                        next_state <= COMPARE_T; --TBD
                    else
                        d <= d_while;
                        next_state <= COMPUTE_P;
                    end if;

                when COMPUTE_P =>
                    int_p_temp <= ((int_p * Int_p) mod int_N);
                    check_d_one <= d(0) and '1';

                    next_state <= STORE_P;
                    
                when STORE_P =>
                    int_p <= int_p_temp;
                    if (check_d_one = '1') then
                        next_state <= COMPUTE_T;
                    else
                        next_state <= BITSHIFT_D_FWHILE;
                    end if;

                when COMPUTE_T =>
                    int_t_temp <= ((int_t * int_p) mod int_N);

                    next_state <= STORE_T;

                when STORE_T =>
                    int_t <= int_t_temp;
                    
                    next_state <= BITSHIFT_D_FWHILE;

                when COMPARE_T =>
                    if (int_t = 1) then
                        prime <= '1';
                        next_state <= DONE;
                    elsif (int_t = int_N_minus_one) then
                        prime <= '1';
                        next_state <= DONE;
                    else
                        prime <= '0';
                        next_state <= SECOND_WHILE;
                    end if;
                        
                when SECOND_WHILE =>
                    counter_k_flag <= '0';
                    if (counter_k < counter_j) then
                        prime <= '0';
                        next_state <= COMPUTE_T_SW;
                    else
                        prime <= '0';
                        next_state <= DONE;
                    end if;

                when COMPUTE_T_SW =>
                    int_t_temp <= ((int_t * int_t) mod int_N);

                    next_state <= STORE_T_SW;

                when STORE_T_SW =>
                    int_t <= int_t_temp;

                    next_state <= STORE_T_SW;

                when COMPARE_T_SW =>
                    counter_k_flag <= '1';
                    if (int_t = int_N_minus_one) then
                        prime <= '1';
                        next_state <= DONE;
                    else
                        prime <= '0';
                        next_state <= SECOND_WHILE;
                    end if;

                when DONE =>
                    if (reset = '0') then 
                        next_state <= START;
                    else
                        next_state <= DONE;
                    end if;
                
            end case;
        end process;

        Decoder_Section     : process(curr_state)
        begin
            case curr_state is
					when START =>
						busy <= '0';
						done <= '0';
						isPrime <= '0';
	
					when INITIAL_SETUP =>
						busy <= '1';
						done <= '0';
						isPrime <= '0';
	
					when BITSHIFT_D =>
						busy <= '1';
						done <= '0';
						isPrime <= '0';
	
					when CHECK_D_AND_ONE =>
						busy <= '1';
						done <= '0';
						isPrime <= '0';
	
					when COMPUTE_T_P =>
						busy <= '1';
						done <= '0';
						isPrime <= '0';
	
					when BITSHIFT_D_FWHILE =>
						busy <= '1';
						done <= '0';
						isPrime <= '0';
	
					when CHECK_D_FWHILE =>
						busy <= '1';
						done <= '0';
						isPrime <= '0';
	
					when COMPUTE_P =>
						busy <= '1';
						done <= '0';
						isPrime <= '0';
	
					when STORE_P =>
						busy <= '1';
						done <= '0';
						isPrime <= '0';
	 
					when COMPUTE_T =>
						busy <= '1';
						done <= '0';
						isPrime <= '0';
	 
					when STORE_T =>
						busy <= '1';
						done <= '0';
						isPrime <= '0';
	
					when COMPARE_T =>
						busy <= '1';
						done <= '0';
						isPrime <= '0';
				
					when SECOND_WHILE =>
						busy <= '1';
						done <= '0';
						isPrime <= '0';
	
					when COMPUTE_T_SW =>
						busy <= '1';
						done <= '0';
						isPrime <= '0';
	
					when STORE_T_SW =>
						busy <= '1';
						done <= '0';
						isPrime <= '0';
	
					when COMPARE_T_SW =>
						busy <= '1';
						done <= '0';
						isPrime <= '0';
	
					when DONE =>
						busy <= '0';
						done <= '1';
						isPrime <= prime;
	
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

        Counter_K_Section   : process(clk, reset, counter_k_flag)
        begin
            if (rising_edge(clk)) then
                if (reset = '0') then 
                    counter_k <= 0;
                else
                    counter_k <= counter_k + 1;
                end if;
            end if;
        end process;

end architecture;