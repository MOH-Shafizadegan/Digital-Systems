----------------------------------------------------------------------------------
-- Mohsen Sadeghi Moghaddam
-- Test UART Component
-- m.sadeghimoghaddam@yahoo.com
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;

entity test is
				port (	
						clk	: in	std_logic;
						i_rst : in std_logic;
						uart_rxd  : in  std_logic;
						uart_txd  : out std_logic;
						sevenSegOut  : out std_logic_vector(7 downto 0);
						digitLoc  : out std_logic_vector(3 downto 0);
						led : out std_logic_vector(3 downto 0)
						);

end test;


architecture Behavioral of test is

	type 		state is (IDLE,Listen,Send,Send1,Send_en,Finish);
	signal		pr_state : state:=IDLE; 
	signal		interface_buff : std_logic_vector(7 downto 0);
--------Uart => signal-------------------------------------------------------------------------------
						signal		rx_avail	:std_logic:='0';
						signal		reset		:std_logic:='1';
						signal		rx_full		:std_logic:='0';
						signal		rx_error	:std_logic:='0';
						signal		wr			:std_logic:='0';
						signal		rd			:std_logic:='0';
						signal		tx_avail	:std_logic:='0';
						signal		tx_busy		:std_logic:='0';
						signal		txdata    	:std_logic_vector(7 downto 0);
						signal		rxdata      :std_logic_vector(7 downto 0);
						signal 		counter		:integer := 1;
						signal		i_packet_num  :std_logic_vector(7 downto 0) := (others => '0');
						signal		i_reg			: std_logic_vector(31 downto 0) := (others => '1');
						signal		i_7seg		: std_logic_vector(31 downto 0);
------- component-------------------------------------------------------------------------------------
	COMPONENT uart
				PORT(
						clk : IN std_logic;
						reset : IN std_logic;
						txdata : IN std_logic_vector(7 downto 0);
						wr : IN std_logic;
						rd : IN std_logic;
						uart_rxd : IN std_logic;          
						rxdata : OUT std_logic_vector(7 downto 0);
						tx_avail : OUT std_logic;
						tx_busy : OUT std_logic;
						rx_avail : OUT std_logic;
						rx_full : OUT std_logic;
						rx_error : OUT std_logic;
						uart_txd : OUT std_logic
						);
	END COMPONENT;
	
	component sevenSeg
		port(
			 clock : in std_logic;
			 digit1 : in std_logic_vector(3 downto 0);
			 digit2 : in std_logic_vector(3 downto 0);
			 digit3 : in std_logic_vector(3 downto 0);
			 digit4 : in std_logic_vector(3 downto 0);
			 SevenSeg : out std_logic_vector(7 downto 0);
			 digitLoc : out std_logic_vector(3 downto 0) := "1110"
		);
	end component;
	
begin

	Inst_uart: uart PORT MAP(
						clk => clk,
						reset => reset,
						txdata => txdata,
						rxdata => rxdata,
						wr => wr,
						rd => rd ,
						tx_avail => tx_avail ,
						tx_busy => tx_busy ,
						rx_avail => rx_avail ,
						rx_full => rx_full ,
						rx_error => rx_error ,
						uart_rxd => uart_rxd,
						uart_txd => uart_txd
									);
									
	Inst_sevenSeg : sevenSeg port map(
		clock => clk,
		digit4 => i_reg(3 downto 0),
		digit3 => i_reg(11 downto 8),
		digit2 => i_reg(19 downto 16),
		digit1 => i_reg(27 downto 24),
		sevenSeg => sevenSegOut,
		digitLoc => digitLoc
	);
	
-----------------------------------------------------------------------------------
		
	m1:	process (clk)
		
		begin
		if (clk'event and clk ='1') then
						
			if i_rst = '0' then
				counter <= 1;
				i_packet_num <= (others => '0');
				i_reg <= (others => '1');
				led <= "1000";
			end if;
						
			case pr_state is
			
				when IDLE =>
					wr <= '0';
					reset <= '0';
					pr_state <= Listen;
			----------------------------------------
				when Listen =>
					if (rx_full ='1') then
						rd <= '1';
						pr_state <= Send1 ;
						counter <= counter + 1;
						i_packet_num <= i_packet_num + '1';
						 
						if (counter mod 4) = 1 then
							i_reg(7 downto 0) <= rxdata - X"30";
							led <= "0100";
						elsif (counter mod 4) = 2 and counter /= 0 then
							i_reg(15 downto 8) <= rxdata - X"30";
							led <= "0010";
						elsif (counter mod 4) = 3 and counter /= 0 then
							i_reg(23 downto 16) <= rxdata - X"30";
							led <= "0001";
						elsif (counter mod 4) = 0 and counter /= 0 then
							i_reg(31 downto 24) <= rxdata - X"30";
							led <= "1000";
						end if;
--						interface_buff <= counter ;
					else
						pr_state <= Listen;
					end if;
			---------------------------------------
				when Send1 =>
					interface_buff <= i_packet_num ;
					rd <= '0';
					pr_state <= Send ;
--			----------------------------------------
				when Send =>
					txdata <= interface_buff;
					pr_state <= Send_En;
--			----------------------------------------
				when Send_En => 
					wr <= '1' ;
					pr_state <= Finish;
			---------------------------------------
				when Finish =>
						pr_state <= IDLE;
			----------------------------------------
				end case;
		end if;
		end process m1;
end Behavioral;

