library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;
	 use ieee.std_logic_arith.all;
	 use ieee.std_logic_unsigned.all;

entity pushBtn is
  port (
	 clock : in std_logic;
    btn : in std_logic;
    led : out std_logic := '0'
  ) ;
end pushBtn ; 

architecture Behavioral of pushBtn is
	signal led_state : std_logic := '1';
	shared variable flag : std_logic;
	signal counter : integer := 0;
begin
	process (clock) 
	begin
		if rising_edge(clock) then
			if btn = '0' then
				flag := '1';
			end if;
			
			if flag = '1' then
				counter <= counter + 1;
				if counter > 2400 then
					counter <= 0;
					flag := '0';
					led_state <= not led_state;
				end if;
			end if;
			led <= led_state;
		end if;
	end process;
end Behavioral ;