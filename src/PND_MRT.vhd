library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
--		D => Output
	
	
	
	signal Curr_State		: State_Type;
	signal Next_State		: State_Type;
	
	signal N					: std_logic_vector(7 downto 0);
	signal N_One			: std_logic_vector(7 downto 0);
	signal One				: std_logic_vector(7 downto 0) := "00000001";
	
	signal isPrime			: std_logic;
	
	
	-- COMPONENTS
	


begin


Register_Section: process (clk,reset)
	begin
		
		IF (reset = '0') THEN
		
			Curr_State <= A;
			
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
			
				N <= numberToCheck;
				N_One <= std_logic_vector(unsigned(N) - unsigned(One));
			
			
			When B =>
			
			When C =>
			
			When D =>
			
				if (en = '1') then
					Next_State <= A;
				else
					Next_State <= D;
				end if;
			
			When others =>
			
				Curr_State <= A;
				
		end case;
	
	end process;
	
	
Decoder_Section : process(curr_State)
	
	begin
	
		case Curr_State is 
		
			when A =>
			
			when B =>
			
			when C =>
			
			When D =>
			
			When others =>
			
		end case;
			
	
		
	end process;
	
	

end architecture;