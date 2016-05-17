library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity vga640480 is
	 port(
			direction : in std_logic_vector(7 downto 0);
			address : out std_logic_vector(13 downto 0);
			reset : in  std_logic;
			clk25 : out std_logic; 
			q : in std_logic_vector(7 downto 0);
			clk_0 : in std_logic;  --100M CLOCK
			hs,vs : out std_logic; --��ͬ������ͬ���ź�
			r,g,b : out std_logic_vector(2 downto 0)
	  );
end vga640480;

architecture behavior of vga640480 is

signal r1,g1,b1 : std_logic_vector(2 downto 0);					
signal hs1,vs1 : std_logic;				
signal vector_x : std_logic_vector(9 downto 0);		--X����
signal vector_y : std_logic_vector(8 downto 0);		--Y����
signal clk1	: std_logic;
signal clk : std_logic;
signal delta : std_logic_vector(9 downto 0):="0000000000";
signal modify : std_logic_vector(9 downto 0);
signal old : std_logic_vector(7 downto 0):="00000000";
signal move: std_logic:='0';

begin
	clk25 <= clk;
-----------------------------------------------------------------------
	process(clk_0)	--��100M�����źŶ���Ƶ
	begin
		if clk_0'event and clk_0='1' then 
			clk1 <= not clk1;
		end if;
	end process;
	process(clk1)	--��50M�����źŶ���Ƶ
   begin
		if clk1'event and clk1='1' then 
			clk <= not clk;
		end if;
	end process;
-----------------------------------------------------------------------
	process(clk,reset)	--������������������������
	begin
		if reset='0' then
			vector_x <= (others => '0');
	  	elsif clk'event and clk='1' then
			if vector_x=799 then
				vector_x <= (others => '0');
	   	else
	    		vector_x <= vector_x + 1;
	   	end if;
	  	end if;
	 end process;
-----------------------------------------------------------------------
	process(clk,reset)	--����������������������
	begin
		if reset='0' then
			vector_y <= (others => '0');
		elsif clk'event and clk='1' then
	   	if vector_x=799 then
	    		if vector_y=524 then
	     			vector_y <= (others => '0');
				else
	     			vector_y <= vector_y + 1;
	    		end if;
	   	end if;
		end if;
	end process;
-----------------------------------------------------------------------
	process(clk,reset) --��ͬ���źŲ�����ͬ������96��ǰ��16��
	begin
		if reset='0' then
			hs1 <= '1';
		elsif clk'event and clk='1' then
			if vector_x>=656 and vector_x<752 then
				hs1 <= '0';
			else
		    	hs1 <= '1';
		   end if;
		end if;
	 end process;
-----------------------------------------------------------------------
	process(clk,reset) --��ͬ���źŲ�����ͬ������2��ǰ��10��
	begin
		if reset='0' then
			vs1 <= '1';
		elsif clk'event and clk='1' then
			if vector_y>=490 and vector_y<492 then
				vs1 <= '0';
			else
				vs1 <= '1';
			end if;
	  	end if;
	 end process;
-----------------------------------------------------------------------
	process(clk,reset) --��ͬ���ź�����
	begin
		if reset='0' then
	   	hs <= '0';
	  	elsif clk'event and clk='1' then
	   	hs <=  hs1;
	  	end if;
	end process;
-----------------------------------------------------------------------
	process(clk,reset) --��ͬ���ź�����
	begin
		if reset='0' then
			vs <= '0';
		elsif clk'event and clk='1' then
	   	vs <=  vs1;
	  	end if;
	end process;
-----------------------------------------------------------------------	
	process(reset,clk,vector_x,vector_y) -- XY���궨λ����
	begin  
		if reset='0' then
			r1 <= "000";
			g1	<= "000";
			b1	<= "000";	
		elsif(clk'event and clk='1')then	
			modify <= vector_x - delta;
			if vector_y(8 downto 7) = "01" and modify(9 downto 7) = "001" then
				address <= vector_y(6 downto 0) & modify(6 downto 0);
				r1 <= q(7 downto 5);
				g1	<= q(4 downto 2);
				b1	<= q(1 downto 0) & "1";
			else 
				r1 <= "000";
				g1	<= "000";
				b1	<= "000";
			end if;
		end if;		 
	end process;	
-----------------------------------------------------------------------
	process (hs1, vs1, r1, g1, b1)	--ɫ������
	begin
		if hs1 = '1' and vs1 = '1' then
			r	<= r1;
			g	<= g1;
			b	<= b1;
		else
			r	<= (others => '0');
			g	<= (others => '0');
			b	<= (others => '0');
		end if;
	end process;
-----------------------------------------------------------------------
	process(clk, reset, direction)
	begin
		if reset = '0' then
			delta <= "0000000000";
		elsif clk'event and clk = '1' and old /= direction then
			old <= direction;
			if(direction = "11110000") then
				if (old = "00100011") then
					delta <= delta + "0000001111";
				elsif (old = "00011100") then
					delta <= delta - "0000001111";
				end if;
			end if;
		end if;
	end process;
-----------------------------------------------------------------------
end behavior;

