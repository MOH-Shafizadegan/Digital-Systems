----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:14:30 07/30/2022 
-- Design Name: 
-- Module Name:    sevenSeg - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sevenSeg is
	port (
	 clock : in std_logic;
	 digit1 : in std_logic_vector(3 downto 0);
    digit2 : in std_logic_vector(3 downto 0);
    digit3 : in std_logic_vector(3 downto 0);
    digit4 : in std_logic_vector(3 downto 0);
    sevenSeg : out std_logic_vector(7 downto 0);
    digitLoc : out std_logic_vector(3 downto 0) := "1110"
  ) ;
end sevenSeg;

architecture Behavioral of sevenSeg is

    constant delay : std_logic_vector(11 downto 0) := "100101100000";
    signal timeCounter : std_logic_vector(11 downto 0) := (others => '0');
	 shared variable location : integer := 1;


	function bcdTo7seg (signal bcd : std_logic_vector(3 downto 0)) return std_logic_vector is
        variable result : std_logic_vector(7 downto 0);
    begin
        case( bcd ) is
        
            when "0000" => result := "00000011";
            when "0001" => result := "10011111";
            when "0010" => result := "00100101";
            when "0011" => result := "00001101";
            when "0100" => result := "10011001";
            when "0101" => result := "01001001";
            when "0110" => result := "01000001";
            when "0111" => result := "00011111";
            when "1000" => result := "00000001";
            when "1001" => result := "00001001";        
            when others => result := "11111111";
        
        end case;
        return result;
    end function bcdTo7seg;

begin

	 process( clock )
    begin
		  
        if rising_edge(clock) then
            if timeCounter < delay then
                timeCounter <= timeCounter + '1';
            else
                timeCounter <= (others => '0');
                case( location ) is
                
                    when 1 => 
								sevenSeg <= bcdTo7seg(digit1);
								digitLoc <= "1110";
                    when 2 =>
								sevenSeg <= bcdTo7seg(digit2);
								digitLoc <= "1101";

                    when 3 =>
								sevenSeg <= bcdTo7seg(digit3);
							   digitLoc <= "1011";

                    when 4 => 
								sevenSeg <= bcdTo7seg(digit4); 
								digitLoc <= "0111";

						  when others => 
								sevenSeg <= "00000000";
                                
                 end case ; 
					 
					 location := location + 1;
					 if location > 4 then
							location := 1;
					 end if;
					 
				end if ;
		  end if ;
    end process ;

end Behavioral;

