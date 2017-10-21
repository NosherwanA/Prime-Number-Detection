library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
--use ieee.std_logic_unsigned.all;

entity PND_TrialDivision is port (
	
	input		: in std_logic_vector(9 downto 0);
	isPrime	: out std_logic
	
);
end PND_TrialDivision;


architecture internal of PND_TrialDivision is 

	signal numToCheck	: integer;
	signal temp			: std_logic;

begin

	numToCheck <= to_integer(unsigned(input));
	
	
	process(numToCheck)
		
	begin
	
		temp <= '1';
		
		if ((numToCheck = 1) OR (numToCheck = 0)) then
			
			temp <= '0';		--Not Prime
			
		elsif(numToCheck > 2) then
			
			for i in 2 to 32 loop -- We know the maximum number possible is 1024 which is equal to (32)^2
			
				if (numToCheck mod i = 0) then
					
					-- if the number is divisible
					temp <= '0';
					exit;
					
				end if;
			
			end loop;
			
		end if;
		
		isPrime <= temp;
			
	end process;
	
end architecture;

--component PND_TrialDivision is port (
--	
--	input		: in std_logic_vector(9 downto 0);
--	isPrime	: out std_logic
--	
--);
--end component;