
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;

entity carrito is
    Port ( Switch : in  STD_LOGIC;
           Clock : in  STD_LOGIC;
           Motor1a : out  STD_LOGIC;
           Motor1b : out  STD_LOGIC;
           Motor2a : out  STD_LOGIC;
           Motor2b : out  STD_LOGIC);
end carrito;

architecture Behavioral of carrito is

	signal contador: INTEGER range 0 to 300000000;

begin

	ccont: process (Switch,Clock)
	begin
		if (Clock'event and Clock='1') then
			if (Switch='1') then
				contador <= contador + 1;
				if(contador>300000000) then
					contador <= 0;
				end if;	
			else 
				contador <= 0;
			end if;
		end if;
	end process;

	salidas: process (Clock)
	begin
		if (contador>0 and contador<100000000) then 
			Motor1a <= '1';
			Motor1b <= '0';
			Motor2a <= '1';
			Motor2b <= '0';
		elsif (contador>100000000 and contador<200000000) then
			Motor1a <= '0';
			Motor1b <= '0';
			Motor2a <= '0';
			Motor2b <= '0';
		elsif (contador>200000000 and contador<300000000) then
			Motor1a <= '0';
			Motor1b <= '1';
			Motor2a <= '0';
			Motor2b <= '1';
		else
			Motor1a <= '0';
			Motor1b <= '0';
			Motor2a <= '0';
			Motor2b <= '0';
		end if;
	end process;
end Behavioral;



