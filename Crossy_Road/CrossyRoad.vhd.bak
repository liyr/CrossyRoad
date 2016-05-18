library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity CrossyRoad is
port(
	clk : in std_logic;
	rst : in std_logic
);
end CrossyRoad;

architecture game of CrossyRoad is

------ SD Card Module ------

component SDCard is
port(
	
);
end component;

------ SRAM Module ------

component SRAM is
port(

);
end component;

------ Game Scene Module ------

component GameScene is
port(

);
end component;

------ KeyBoard Control Module ------

component KeyBoard is
port(
	datain, clkin : in std_logic;
	fclk, rst : in std_logic;
	scancode : out std_logic_vector(7 downto 0)
	);
);
end component;

------ VGA Control Module ------

component VGA is
port(

);
end component;