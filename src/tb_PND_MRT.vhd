library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture testBehaviour of tb is
	
	--Component under test
	component PND_MRT is
	port(
		numberToCheck		: in std_logic_vector (7 downto 0);
		en					: in std_logic;
		clk					: in std_logic;
		reset				: in std_logic;
		ouput				: out std_logic;
		busy				: out std_logic
	);
	
	--Inputs
	
	signal t_clk			: std_logic := '0';
	signal t_numberToCheck	: std_logic_vector (7 downto 0) := "00000000";
	signal t_en				: std_logic := '0';
	signal t_reset			: std_logic := '0';
	
	--Outputs
	signal t_output			: std_logic := '0';
	signal t_busy			: std_logic := '0';
	
	--Clock Period Defination
	constant CLK_PERIOD		: time := 20ns;

begin
	
	-- UUT Instantiation 
	uut: PND_MRT port map(
		t_numberToCheck,
		t_en,
		t_clk,
		t_reset,
		t_output,
		t_busy
	);
	
	--Clock process
	clk_process : process
	begin
		t_clk <= '0';
		wait for CLK_PERIOD/2;
		t_clk <= '1';
		wait for CLK_PERIOD/2;
	end process;
	
	--Simulus process
	stim_process : process
	begin
		-- reset for 100 ms
		wait for 100ns;
		
		t_reset <= '1';
		t_en	<= '1';
		t_numberToCheck <= "01101001";
		
		wait for 300ns;
		
		t_reset <= '0'
		
		wait;
		
	end process;

end architecture;