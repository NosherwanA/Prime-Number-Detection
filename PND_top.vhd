library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.Montgomery_exponentiator_parameters.all;

entity PND_top is port (
	
	--Clocks
	CLOCK_50			: in std_logic;
	CLOCK2_50			: in std_logic;
	CLOCK3_50			: in std_logic;
	CLOCK4_50			: in std_logic;
	
	--Reset Button
	RESET_N				: in std_logic;
	
	--Keys (Push Buttons) ACTIVE LOW
	KEY					: in std_logic_vector(3 downto 0);
		
	--Switches
	SW					: in std_logic_vector(9 downto 0);
	
	--LEDR (Red LEDs)
	LEDR				: out std_logic_vector(9 downto 0);
	
	--Seven Segment Displays
	HEX0				: out std_logic_vector(6 downto 0);
	HEX1				: out std_logic_vector(6 downto 0);
	HEX2				: out std_logic_vector(6 downto 0);
	HEX3				: out std_logic_vector(6 downto 0);
	HEX4				: out std_logic_vector(6 downto 0);
	HEX5				: out std_logic_vector(6 downto 0);
	
	--DRAM
	DRAM_ADDR			: out std_logic_vector(12 downto 0);
	DRAM_BA				: out std_logic_vector(1 downto 0);
	DRAM_CAS_N			: out std_logic;
	DRAM_CKE				: out std_logic;
	DRAM_CLK				: out std_logic;
	DRAM_CS_N			: out std_logic;
	DRAM_DQ				: inout std_logic_vector(15 downto 0);
	DRAM_LDQM			: out std_logic;
	DRAM_RAS_N			: out std_logic;
	DRAM_UDQM			: out std_logic;
	DRAM_WE_N			: out std_logic;
	
	--GPIOs
	GPIO_0				: inout std_logic_vector(35 downto 0);
	GPIO_1				: inout std_logic_vector(15 downto 0);
	
	--PS2
	PS2_CLK				: inout std_logic;
	PS2_CLK2				: inout std_logic;
	PS2_DAT				: inout std_logic;
	PS2_DAT2				: inout std_logic;
	
	--SD
	SD_CLK				: out std_logic;
	SD_CMD				: inout std_logic;
	SD_DATA				: inout std_logic_vector(3 downto 0);
	
	
	--VGA
	VGA_B					: out std_logic_vector(3 downto 0);
	VGA_G					: out std_logic_vector(3 downto 0);
	VGA_HS				: out std_logic;
	VGA_R					: out std_logic_vector(3 downto 0);
	VGA_VS				: out std_logic
	
);
end PND_top ;

architecture overall of PND_top is

	-- COMPONENT DECLARATION
	
	component PB_Sync is 
		 port(
			  PB_clk         : in std_logic;
			  PB_reset       : in std_logic; --Active low
			  PB_in     : in std_logic_vector(3 downto 0);
			  PB_out    : out std_logic_vector(3 downto 0)
		 );
	end component;
	
	component Switch_Sync is 
		 port(
			  SW_clk         : in std_logic;
			  SW_reset       : in std_logic; --Active low
			  SW_in     : in std_logic_vector(9 downto 0);
			  SW_out    : out std_logic_vector(9 downto 0)
		 );
	end component;
	
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
	
	
	-- INTERNAL SIGNALS 
	
	signal Sync_SW			: std_logic_vector(9 downto 0);
	signal Sync_PB			: std_logic_vector(3 downto 0);
	
	signal inputNumber	: std_logic_vector(9 downto 0);
	signal isPrime			: std_logic;

begin

	
	Sync1: PB_Sync
		port map(
					CLOCK_50,
					RESET_N,
					KEY(3 downto 0),
					Sync_PB(3 downto 0)
					);
					
	Sync2: Switch_Sync
		port map(
					CLOCK_50,
					RESET_N,
					SW(9 downto 0),
					Sync_SW(9 downto 0)
					);
	
	
	
	primetest: MRT 
		port map(
					Sync_SW(7 downto 0),
					CLOCK_50,
					RESET_N,
					Sync_PB(0),
					LEDR(0),
					LEDR(1),
					LEDR(2)
					);
	

end overall;