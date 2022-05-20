library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_top is 
end tb_top;

architecture testBench of tb_top is
  file file_input : text;
  file f: text;
  component top_practica1 is
  generic (
      g_sys_clock_freq_KHZ  : integer := 100e3; -- Value of the clock frequencies in KHz
      g_debounce_time 		: integer := 20;  -- Time for the debouncer in ms
      g_reset_value 		: std_logic := '0'; -- Value for the synchronizer 
      g_number_flip_flps 	: natural := 2 	-- Number of ffs used to synchronize	
  );
  port (
      rst_n         : in std_logic;
      clk100Mhz     : in std_logic;
      BTNC           : in std_logic;
      LED           : out std_logic
  );
end component;

  constant timer_debounce : integer := 5; --ms
  constant freq : integer := 10; --KHZ
  constant clk_period : time := (1 ms/ freq);

  -- Inputs 
  signal  rst_n       :   std_logic := '1';
  signal  clk         :   std_logic := '0';
  signal  BTN     :   std_logic := '0';
  -- Output
  signal  LED   :   std_logic;

begin
  UUT: top_practica1
    port map (
      rst_n     => rst_n,
      clk100Mhz => clk,
      BTNC       => BTN,
      LED       => LED
    );
  process begin
    wait for 50ns; clk<='0';
    wait for 50ns; clk<='1';
  end process;
  
  process is
  
  --READ
    file text_file: text open read_mode is "E:\Maria\4 II\2 cuatri\desig system automatic VHDL practicas\practica_3\inputs.csv";                    --FICHERO QUE VAMOS A LEER
    variable text_line : line;                                              --VARIABLE DONDE GUARDAREMOS CADA LINEA
    variable ok: boolean;                                                   --ESTADO
    
    --VARIABLES QUE QUEREMOS LEER              
    variable delay: time; 
    variable rst_n2: std_logic; 
    variable BTN2: std_logic; 
    variable LED2: std_logic; 
    variable char : character;

    --VARIABLES QUE QUEREMOS LEER
   
   --WRITE
    file output_buf:text;                                                    --FICHERO EN EL QUE VAMOS A ESCRIBIR
    variable write_col: line;                                                --LINEA EN LA QUE ESTAMOS ESCRIBIENDO
    variable status: file_open_status;                                       --ESTADO
    
    begin
        
          file_open(status,f,"C:\Users\Asus\Desktop\practicas_vhdl\test.csv",write_mode);  --CREAMOS FICHERO TXT PARA ESCRIBIR EN EL
          assert status=open_ok                                              --COMPROBACIONES DE SI SE HA CREADO O NO
             report "No se pudo crear test.txt"                              --MENSAJES POR CONSOLA DENTRO DE UN ASSERT
             severity failure;                                               --"PRIORIDAD" FALLO, WARNING...
          write(write_col,string'("Simulation of top_practica1.vhd"));
          writeline(f,write_col);  
          writeline(f,write_col);   
          
        while not endfile(text_file) loop                                    --MIENTRAS NO LLEGUES AL FINAL DEL FICHERO 
            readline(text_file, text_line);                                  -- LEE LA LINEA DEL FICHERO inputs.csv Y ALMACENALA EN text_line
                
            if text_line.all'length = 0 or text_line.all(1) = '#' then       --SI LA LINEA ESTÁ VACIA O CONTIENE UN #, SALTA A LA SIGUIENTE LINEA
                next;
            end if;
            
            read(text_line, delay, ok);                                      --LEE EL PRIMER PARÁMETRO
            
            assert ok 
                report "Read 'delay' failed for line: " & text_line.all
                severity failure;
               
                                                     
            
            read(text_line, rst_n2, ok);
            assert ok
                report "Read 'rst_n' failed for line: " & text_line.all
                severity failure;
            rst_n<=rst_n2; 
            
            
            read(text_line, BTN2, ok);
            assert ok
                report "Read 'B' failed for line: " & text_line.all
                severity failure;
            BTN<=BTN2;
           
           
            read(text_line, LED2, ok);
            assert ok
                report "Read 'LED' failed for line: " & text_line.all
                severity failure;
                
          
             wait for delay;
            
          
            --ESCRIBIMOS TODO EL MENSAJE 
            write(write_col,string'("Time:"));
            write(write_col,delay);
            write(write_col,string'(";rst_n:"));
            write(write_col,rst_n);
            write(write_col,string'(";BTNC:"));
            write(write_col,BTN);
           
            writeline(f,write_col);  --SALTO DE LINEA
            
            --ESCRIBIMOS TODO EL MENSAJE

                                                      
             if LED/=LED2 then
                write(write_col,string'("ERROR expected LED to be "));
                write(write_col,LED2);
                write(write_col,string'(" actual value "));
                write(write_col,LED);
                 writeline(f,write_col); 
             end if;

            read(text_line, char, ok); -- Skip expected newline
            read(text_line, char, ok);
            if char = '#' then
                read(text_line, char, ok); -- Skip expected newline
                report text_line.all;
            end if;
         end loop;
            writeline(f,write_col); 
            write(write_col,string'("Finished simulation "));
            report "Finished" severity FAILURE;
    
    
   end process;
end testBench;