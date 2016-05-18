library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity SRAM is
port (
	FpgaC_Ram_Data : inout std_logic_vector(31 downto 0);
	FpgaC_RamRW : out std_logic_vector(1 downto 0);
	FpgaC_RamAdd : out std_logic_vector(20 downto 0);
	FpgaC_Judgement : in std_logic;
	FpgaC_Clk : in std_logic;
	FpgaC_Reset : in std_logic
);
end SRAM;

architecture ReadWrite of SRAM is
signal counter : std_logic_vector(25 downto 0);
signal write_request : std_logic;
signal read_request : std_logic;
signal address_buff : std_logic_vector(20 downto 0);
signal data_buff : std_logic_vector(31 downto 0);
type State is (IDLE, READ_1, READ_2, WRITE_1, WRITE_2);
signal CurrentState : State;
signal NextState : State;

begin
	process(FpgaC_Clk, FpgaC_Reset)
	begin
		if FpgaC_Reset = '0' then
			counter <= (others => '0');
		elsif rising_edge(FpgaC_Clk) then
			counter <= counter + '1';
		end if;
	end process;
-----------------------------------------------------------
	process(FpgaC_Clk, FpgaC_Reset)
	begin
		if FpgaC_Reset = '0' then
			data_buff <= (others => '0');
		elsif rising_edge(FpgaC_Clk) then
			if counter = 50000000 then
				data_buff <= data_buff + '1';
			else
				data_buff <= data_buff;
			end if;
		end if;
	end process;
-----------------------------------------------------------
	process(FpgaC_Clk, FpgaC_Reset)
	begin
		if FpgaC_Reset = '0' then
			CurrentState <= IDLE;
		elsif rising_edge(FpgaC_Clk) then
			CurrentState <= NextState;
		end if;
	end process;
-----------------------------------------------------------
	process(FpgaC_Clk, FpgaC_Reset)
	begin
		if rising_edge(FpgaC_Clk) then
			case CurrentState is
				when IDLE =>
					FpgaC_RamAdd <= address_buff;
					if write_request = '1' then
						NextState <= WRITE_1;
					elsif read_request = '1' then
						NextState <= READ_1;
					else
						NextState <= IDLE;
					end if;
				when WRITE_1 =>
					NextState <= WRITE_2;
				when WRITE_2 =>
					NextState <= IDLE;
				when READ_1 =>
					NextState <= READ_2;
				when READ_2 =>
					NextState <= IDLE;
				when others =>
					NextState <= IDLE;
			end case;
		end if;
	end process;
-----------------------------------------------------------
	process(FpgaC_Clk, FpgaC_Reset)
	begin
		if FpgaC_Reset = '0' then
			FpgaC_RamRW <= "11";
		elsif rising_edge(FpgaC_Clk) then
			case NextState is
				when IDLE =>
					FpgaC_RamRW <= "XX";
				when WRITE_1 =>
					FpgaC_RamRW <= "11";
				when WRITE_2 =>
					FpgaC_RamRW <= "11";
				when READ_1 =>
					FpgaC_RamRW <= "11";
					FpgaC_RamRW <= "10";
					FpgaC_RamRW <= "01";
				when READ_2 =>
					FpgaC_RamRW <= "01";
			end case;
		end if;
	end process;
end ReadWrite;
			
		
		
