library ieee;
use ieee.std_logic_1164.all;

entity vga_rom is
port(
	opt: out std_LOGIC_vector(6 downto 0);
	datain, clkin: in std_logic; 
	clk_0,reset: in std_logic;
	hs,vs: out STD_LOGIC; 
	r,g,b: out STD_LOGIC_vector(2 downto 0)
);
end vga_rom;

architecture vga_rom of vga_rom is

component seg7 is
port (
	code: in std_logic_vector(3 downto 0);
	seg_out : out std_logic_vector(6 downto 0)
);
end component;

component Keyboard is
port (
	datain, clkin : in std_logic ; -- PS2 clk and data
	fclk, rst : in std_logic ;  -- filter clock
	scancode : out std_logic_vector(7 downto 0) -- scan code signal output
	);
end component;

component vga640480 is
	 port(
			direction   :       in std_LOGIC_vector(7 downto 0);
			address		:		  out	STD_LOGIC_VECTOR(13 DOWNTO 0);
			reset       :         in  STD_LOGIC;
			clk25       :		  out std_logic; 
			q		    :		  in STD_LOGIC_vector(7 downto 0);
			clk_0       :         in  STD_LOGIC; --100Mʱ������
			hs,vs       :         out STD_LOGIC; --��ͬ������ͬ���ź�
			r,g,b       :         out STD_LOGIC_vector(2 downto 0)
	  );
end component;

component digital_rom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END component;

signal address_tmp: std_logic_vector(13 downto 0);
signal clk25: std_logic;
signal q_tmp: std_logic_vector(7 downto 0);
signal mark : std_LOGIC_vector(7 downto 0);
signal dir_code: std_logic_vector(7 downto 0);
signal anti_rst: std_logic;
begin

anti_rst <= not reset;
u1: vga640480 port map(
						direction=>dir_code,
						address=>address_tmp, 
						reset=>reset, 
						clk25=>clk25, 
						q=>q_tmp, 
						clk_0=>clk_0, 
						hs=>hs, vs=>vs, 
						r=>r, g=>g, b=>b
					);
u2: digital_rom port map(	
						address=>address_tmp, 
						clock=>clk25, 
						q=>q_tmp
					);
					
u3: Keyboard port map (
	datain=>datain,
	clkin=>clkin,
	fclk=>clk_0,
	rst=>anti_rst,
	scancode=>dir_code
);

u4: seg7 port map (
	code=>dir_code(7 downto 4),
	seg_out=>opt
);				
end vga_rom;