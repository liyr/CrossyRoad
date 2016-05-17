library ieee;
use ieee.std_logic_1164.all;

entity vga_rom is
port(
	datain, clkin: in std_logic; 
	clk_0, reset : in std_logic;
	hs, vs : out std_logic; 
	r, g, b : out std_logic_vector(2 downto 0)
);
end vga_rom;

architecture vga_rom of vga_rom is
component Keyboard is
port(
	datain, clkin : in std_logic ; -- PS2 clk and data
	fclk, rst : in std_logic ;  -- filter clock
	scancode : out std_logic_vector(7 downto 0) -- scan code signal output
	);
end component;

component vga640480 is
port(
	direction : in std_logic_vector(7 downto 0);
	address : out std_logic_vector(13 downto 0);
	reset : in std_logic;
	clk25 : out std_logic; 
	q : in std_logic_vector(7 downto 0);
	clk_0 : in std_logic; --100Mʱ������
	hs, vs : out std_logic; --��ͬ������ͬ���ź�
	r, g, b : out std_logic_vector(2 downto 0)
);
end component;

component digital_rom is
port(
	address : in std_logic_vector(13 downto 0);
	clock : in std_logic;
	q : out std_logic_vector(7 downto 0)
);
end component;

signal address_tmp : std_logic_vector(13 downto 0);
signal clk25 : std_logic;
signal q_tmp : std_logic_vector(7 downto 0);
signal mark : std_logic_vector(7 downto 0);
signal dir_code : std_logic_vector(7 downto 0);
signal anti_rst : std_logic;
begin
	anti_rst <= not reset;
	u1: vga640480 port map(
							direction => dir_code,
							address => address_tmp, 
							reset => reset, 
							clk25 => clk25, 
							q => q_tmp, 
							clk_0 => clk_0, 
							hs => hs, vs => vs, 
							r => r, g => g, b => b
						);
	u2: digital_rom port map(	
							address => address_tmp, 
							clock => clk25, 
							q => q_tmp
						);
						
	u3: Keyboard port map (
		datain => datain,
		clkin => clkin,
		fclk => clk_0,
		rst => anti_rst,
		scancode => dir_code
	);				
end vga_rom;