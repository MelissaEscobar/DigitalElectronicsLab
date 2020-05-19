
------------------------------------------------------------------------------------------
--ejemplo de uso del módulo bluetooth HC06 como receptor
--conectado a la tarjeta Basys2, usando protocolo RS-232 y
--una aplicación de celular  que envía código ASCII.
------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



----------------------------------------------------------
entity receiver is port(
	clk: in std_logic; --50MHz
	reset: in std_logic; --reset
	rx: in std_logic; --entrada de datos del modulo bluetooth (a DO)	
	leds: out std_logic_vector(7 downto 0) --salida a leds
);
end receiver;
----------------------------------------------------------


architecture rx of receiver is

--FSM states
	type state_type is (EDO_1, EDO_2);
	signal presentstate: state_type:=EDO_1; --estado presente
	signal nextstate: state_type; --estado futuro
	
	
--señales-----------------------------
	signal control: std_logic:='0'; --indica cuando ocurre el bit de start
	signal done: std_logic:='0'; --indica cuando termina la recepción de datos
	signal tmp: std_logic_vector(8 downto 0):="000000000"; --registro de datos
	
--contadores para los retardos-----------------------------
--signal i: std_logic_vector(3 downto 0):="0000"; --contador de los bits recibidos

	signal c: std_logic_vector(9 downto 0):="1111111111"; --contador de retardos(868)
	signal delay: std_logic:='0'; -- reloj de C2
	signal c2: std_logic_vector(1 downto 0):="11"; --contador de muestreo
	signal capture: std_logic:='0'; --señal  de captura


begin
----------------------------- ok delay
--proceso de retardor al triple de la frecuencia
process (clk)
		begin
			if clk'event and clk='1' then
					if c <"1101100100" then c <= c + '1'; --868
				
					else c <= (others=>'0');
					delay <= not delay;

					end if;
			end if;
end process;

----------------------------- ok c2
--proceso para el contador C2 para la captura
process (delay)
		begin
			if delay'event and delay='1' then
					if c2 > "01" then c2 <= "00"; --
					else c2 <= c2 + '1';
					end if;
			end if;
end process;


----------------------------- ok capture
--proceso para capturar en el bit de en medio (capture)

process (c2)
		begin
			if c2 = "01" then capture <= '1'; --
			else capture <= '0'; --
			end if;
end process;


----------------------------- ok fsm
--FSM

process (reset,capture)
		begin
			if capture'event and capture='1' then
					if reset='1' then presentstate <= EDO_1;
					else presentstate <= nextstate;
					end if;
			end if;
end process;


----------------------------- ok fsm
process (presentstate, rx, done)

	begin
			case (presentstate) is
			when EDO_1 => if rx='1' and done='0' then control <= '0'; --
													            nextstate <= EDO_1;

				elsif rx='0' and done='0' then control <= '1'; --
													    nextstate <= EDO_2;

				else control <= '0'; --
												  nextstate <= EDO_1;

				end if;
				
			when EDO_2 =>
			
				if done='0' then control <= '1'; --
													 nextstate <= EDO_2;
													 
				else control <= '0'; --
													 nextstate <= EDO_1;
				end if;
				
				
				
			when others => nextstate <= EDO_1;
		 end case; -- fin del case
end process; -- fin del proceso fsm state


----------------------------- ok capture rx
--proceso de recepción de datos
process (capture)
		begin
			if capture'event and capture ='1' then
					if control='1' and done='0' then tmp <= rx & tmp(8 downto 1); -- captura rx
					end if;
			end if;
end process;


----------------------------- ok capture conteo
--proceso que cuenta los bits que llegan (9 bits)
process (capture,control,reset)
variable i: std_logic_vector(3 downto 0):="0000"; --contador de los bits recibidos

begin
			if reset ='1' then leds <= x"00";
			elsif capture'event and capture ='1' then
			
					if control='1' then
							if (i >= "1001") then i:=x"0";
									done <= '1';
									leds <= tmp(8 downto 1);

							else i:= i + '1';
									done <= '0';

							end if;

					else done <= '0';
					end if;
			end if;
end process;
end rx; --fin de la arquitectura