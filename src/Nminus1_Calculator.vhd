library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Nminus1_Calculator is  
port(

	A	 : in std_logic_vector(7 downto 0);  
   Output : out std_logic_vector(7 downto 0)
	
);  
end Nminus1_Calculator;  


architecture archi of Nminus1_Calculator is  

	signal One	: std_logic_vector(7 downto 0) := "00000001";
  
  begin  
  
  output <= std_logic_vector(unsigned(A) - unsigned(One));
     
end archi; 