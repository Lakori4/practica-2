library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor_3 is
    port(
        clk         : in  std_logic;
        ena         : in  std_logic;  -- reset asÃ­ncrono (activo en '0')
        f_div_2_5   : out std_logic;  -- salida de 2.5MHz (10MHz/4)
        f_div_1_25  : out std_logic;  -- salida de 1.25MHz (10MHz/8)
        f_div_500   : out std_logic   -- salida de 500KHz (10MHz/20)
    );
end entity divisor_3;

architecture Behavioral of divisor_3 is
     -- Contador de mÃ³dulo 4
     signal count4 : unsigned(1 downto 0) := (others => '0');
     -- Contador de mÃ³dulo 2 (para dividir la seÃ±al de 2.5MHz a 1.25MHz)
     signal count2 : unsigned(0 downto 0) := (others => '0');
     -- Contador de mÃ³dulo 5 (para dividir la seÃ±al de 2.5MHz a 500KHz)
     signal count5 : unsigned(2 downto 0) := (others => '0');

     signal pulse_div4 : std_logic;  -- pulso de 1 ciclo a 10MHz, cada vez que el contador de mÃ³dulo 4 se resetea
begin
     -- Proceso del contador de mÃ³dulo 4
     process(clk, ena )
     begin
       if (ena = '0') then
           pulse_div4 <= '0';
       end if; 
        
       if(rising_edge(clk)) then
           count4 <= count4 +1;
           if(count4 = "11") then
            pulse_div4 <= '1';
           end if;    
        end if;
        
        if (falling_edge(clk)) then
           pulse_div4 <= '0';
        end if;    
     end process;
     
      f_div_2_5  <= pulse_div4;

 

     -- Procesos para actualizar los contadores secundarios (mod 2 y mod 5)
     process(clk, ena )
     begin
       if (ena = '0') then
           f_div_2_5 <= '0';
           f_div_1_25 <= '0';
           f_div_500 <= '0';

       end if; 
        
       if(rising_edge(clk)) then
           if(count4 = "11") then
            count2 <= not count2;
            count5 <= count5 +1;
           end if;    
        end if;
        
        if (falling_edge(clk)) then
           count2 <= "0";
        end if;    
        
        if (count2 = "0") then 
            f_div_1_25 <= '1';
           else
            f_div_1_25 <= '0';
        end if;
     end process;

     -- Asignaciones de salida: cada seÃ±al es un pulso de 1 ciclo de reloj
     -- f_div_2_5  <= 
     --f_div_1_25 <= pulse_div4 mod 2;
     -- f_div_500  <= 
end Behavioral;