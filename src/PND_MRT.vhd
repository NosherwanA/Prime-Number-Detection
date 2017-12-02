library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Montgomery_exponentiator_parameters.all;

entity PND_MRT is 
port(
	
	numberToCheck		: in std_logic_vector(7 downto 0);
	en						: in std_logic;
	clk					: in std_logic;
	reset					: in std_logic;
	output				: out std_logic; -- 1 if it is prime
	busy					: out std_logic

);
end PND_MRT;

architecture internal of PND_MRT is 
	
	type State_Type is (A,B,C,D);
		
--		A => Input
--		B => Calculate k and m 
--		C => Calculate b sub i
--		D => Output (RESET state)redid
	
	
	
	signal Curr_State		: State_Type;
	signal Next_State		: State_Type;
	
	signal Two				: std_logic_vector(7 downto 0):= "00000010";
	
	signal N					: std_logic_vector(7 downto 0);
	signal N_One			: std_logic_vector(7 downto 0);
	signal One				: std_logic_vector(7 downto 0) := "00000001";
	
	signal temp				: std_logic_vector(7 downto 0):= "00000000";
	signal j					: integer:=0;
	
	signal isPrime			: std_logic;
	signal computation_StateB_Complete	: std_logic:='0';
	
	--Signals for the mult component
	
	signal in_mpand		: std_logic_vector( 7 downto 0 ):= "00000000";
	signal in_mplier		: std_logic_vector( 7 downto 0 ):= "00000000";
	signal in_modulus		: std_logic_vector( 7 downto 0 ):= "00000000";
	signal in_ds			: std_logic;
	signal in_reset		: std_logic:= '1';
	signal out_product	: std_logic_vector( 7 downto 0 ):= "00000000";
	signal out_ready		: std_logic;
	
	---------------
	
	signal t					: std_logic_vector (7 downto 0);
	signal p					: std_logic_vector (7 downto 0);
	
	signal second_while_complete	: std_logic;
	
	
	
	
	
	-- COMPONENTS
	
	component modmult is
	Generic (MPWID: integer := 8);
	port(
		mpand : in std_logic_vector(MPWID-1 downto 0);
		mplier : in std_logic_vector(MPWID-1 downto 0);
		modulus : in std_logic_vector(MPWID-1 downto 0);
		product : out std_logic_vector(MPWID-1 downto 0);
		clk : in std_logic;
		ds : in std_logic; -- Sort of start signal
		reset : in std_logic;
		ready : out std_logic
	);
	end component;



begin

my_mult: modmult port map(in_mpand, in_mplier, in_modulus, out_product, clk, in_ds, in_reset, out_ready);


Register_Section: process (clk,reset)
	begin
		
		IF (reset = '0') THEN
		
			Curr_State <= D;
			in_reset <= '1'; -- keeping the multiplier in reset state
			computation_StateB_Complete <= '0';
			second_while_complete <= '0';
			
		ELSIF(rising_edge(clk)) THEN
		
			Curr_State <= Next_State;
			
		ELSE
		
			Curr_State <= Curr_State;
			
		END IF;
	
	end process;

	
Transition_Section: process (Curr_State)
	begin
		
		case Curr_State is 
		
			When A =>
			
				if (en = '1') then
				
					N <= numberToCheck;
					N_One <= std_logic_vector(unsigned(N) - unsigned(One));
					
					Next_State <= B;
					
				else
					
					N <= "00000000";
					N_One <= "00000000";
					
					Next_State <= A;
					
				end if;
			
			When B => -- compute k and m 
				
				If (j = 0) then
					
					temp <= shift_right(unsigned(N_One),1);
					j <= (j + 1);
				
				else
					
					temp <= shift_right(unsigned(temp),1);
					j <= (j + 1);
			
				end if;
				
				if ( (temp(0) AND '1') = '1') then
					Next_State <= C;
					computation_StateB_Complete <= '1';
				else
					Next_State <= B;
				end if;
			
			When C =>
				
				if ( computation_StateB_Complete = '1' ) then 
					
					t <= Two;
					p <= Two;
					
					computation_StateB_Complete <= '0';
				
				else
					
					t <= t;
					p <= p;
				
				end if; 
				
				-- SImilar to the while loop number 2
				if ( temp /= "00000000" ) then 
				
					
				
				else
					-- break out
					second_while_complete <= '1';
				
				end if;
				
			
			
			When D =>
			
				if (en = '1') then
					Next_State <= A;
				else
					Next_State <= D;
				end if;
			
			When others =>
			
				Curr_State <= D;
				
		end case;
	
	end process;
	
	
Decoder_Section : process(curr_State)
	
	begin
	
		case Curr_State is 
		
			when A =>
				busy <= '0';
				output <= '0';
			when B =>
				busy <= '1';
				output <= '0';
			when C =>
				busy <= '1';
				output <= '0';
			When D =>
				busy <= '0';
				output <= isPrime;
			When others =>
			
		end case;
			
	
		
	end process;
	
	

end architecture;
