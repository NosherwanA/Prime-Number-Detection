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

    type State_Type is (IDLE,
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
                        COMPARE_T_SW
                        );
    
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
    signal counter_j_clear      : std_logic;

    signal int_t                : integer;
    signal int_p                : integer;

    signal d_while              : std_logic_vector(7 downto 0);

    signal int_p_temp           : integer;
    signal int_t_temp           : integer;
    signal check_d_one          : std_logic;

    signal counter_k            : integer;
    signal counter_k_flag       : std_logic;
    signal counter_k_clear      : std_logic;

        


    begin

        Register_Section    : process(clk, reset)
        begin
            if (rising_edge(clk)) then
                if (reset = '0') then
                    curr_state <= IDLE;
                else
                    curr_state <= next_state;
                end if;
            end if;
        end process;

        Transition_Section  : process(clk, curr_state)
        begin
            case curr_state is
                when IDLE =>
                    int_p <= 0;
                    int_t <= 0;
                    int_N <= 0;
                    int_N_minus_one <= 0;
                    int_p_temp <= 0;
                    int_t_temp <= 0;
                    N_minus_one <= "00000000";
                    d_in <= "00000000";
                    d <= "00000000";
                    d_while <= "00000000";
                    counter_j_flag <= '0';
                    counter_k_flag <= '0';

                    counter_j_clear <= '0';
                    counter_k_clear <= '0';

                    if (start = '1') then 
                        next_state <= INITIAL_SETUP;
                    else
                        next_state <= IDLE;
                    end if;

                when INITIAL_SETUP =>
                    counter_j_clear <= '1';
                    counter_k_clear <= '1';
                    int_N <= to_integer(unsigned(numberToCheck));
                    if (numberToCheck = "00000000") then
                        N_minus_one <= "00000000";
                        int_N_minus_one <= 0;
                    else
                        N_minus_one <= std_logic_vector(to_unsigned(((to_integer(unsigned(numberToCheck))) - 1),8));
                        int_N_minus_one <= (to_integer(unsigned(numberToCheck)) - 1);
                    end if;
                    d_in <= N_minus_one;
                    

                    if (numberToCheck(0) = '0') then --checking for even numbers
                        prime <= '0';
                        next_state <= IDLE;
                    elsif (numberToCheck = "00000000") then --EDGE CASE 0
                        prime <= '0';
                        next_state <= IDLE;
                    elsif (numberToCheck = "00000001") then -- EDGE CASE 1
                        prime <= '0';
                        next_state <= IDLE;
                    else
                        prime <= '0';
                        next_state <= BITSHIFT_D;
                    end if;

                when BITSHIFT_D =>
                    d <= '0' & d_in(7 downto 1);
                    counter_j_flag <= '1';
                    check <= d(0) and '1';

                    next_state <= CHECK_D_AND_ONE;

                when CHECK_D_AND_ONE =>
                    if (check = '0') then
                        next_state <= BITSHIFT_D;
                        d_in <= d;
                    else
                        next_state <= COMPUTE_T_P;
                    end if;
                    counter_j_flag <= '0';

                when COMPUTE_T_P =>
                    int_t <= 2;
                    int_p <= 2;
                    
                    next_state <= BITSHIFT_D_FWHILE;

                when BITSHIFT_D_FWHILE =>
                    d_while <= '0' & d(7 downto 1);

                    next_state <= CHECK_D_FWHILE;

                when CHECK_D_FWHILE =>
                    if (d_while = "00000000") then 
                        next_state <= COMPARE_T;
                    else
                        d <= d_while;
                        next_state <= COMPUTE_P;
                    end if;

                when COMPUTE_P =>
                    int_p_temp <= ((int_p * int_p) mod int_N);
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
                        next_state <= IDLE;
                    elsif (int_t = int_N_minus_one) then
                        prime <= '1';
                        next_state <= IDLE;
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
                        next_state <= IDLE;
                    end if;

                when COMPUTE_T_SW =>
                    int_t_temp <= ((int_t * int_t) mod int_N);

                    next_state <= STORE_T_SW;

                when STORE_T_SW =>
                    int_t <= int_t_temp;

                    next_state <= COMPARE_T_SW;

                when COMPARE_T_SW =>
                    counter_k_flag <= '1';
                    if (int_t = int_N_minus_one) then
                        prime <= '1';
                        next_state <= IDLE;
                    else
                        prime <= '0';
                        next_state <= SECOND_WHILE;
                    end if;       
            end case;
        end process;

        Decoder_Section     : process(curr_state)
        begin
            case curr_state is
					when IDLE =>
						busy <= '0';
						done <= '1';
						isPrime <= prime;
	
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
            end case;
        end process;

        Counter_J_Section   : process(clk, counter_j_clear, counter_j_flag)
        begin
            if (rising_edge(clk)) then
                if (reset = '0') then 
                    counter_j <= 0;
                elsif (counter_j_flag = '0') then
                    counter_j <= 0;
                elsif (counter_j_flag = '1') then
                    counter_j <= counter_j + 1;
                end if;
            end if;
        end process;

        Counter_K_Section   : process(clk, counter_k_clear, counter_k_flag)
        begin
            if (rising_edge(clk)) then
                if (reset = '0') then 
                    counter_k <= 0;
                elsif (counter_k_clear = '0') then
                    counter_k <= 0;
                elsif (counter_k_flag = '1') then
                    counter_k <= counter_k + 1;
                end if;
            end if;
        end process;

end architecture;
