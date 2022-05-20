library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fsm_sclk is
    generic(
        g_freq_SCLK_KHZ	: integer := 1500000; -- Frequency in MHz (Santiago) of the 
        --synchronous generated clk
        g_system_clock 	: integer := 100000000 --Frequency in MHz (Santiago) of the system clk
    );
    port (
        rst_n		: in std_logic; -- asynchronous reset, low active
        clk 		: in std_logic; -- system clk
        start		: in std_logic; -- signal to start the synchronous clk
        SCLK 		: out std_logic;-- Synchronous clock at the g_freq_SCLK_KHZ
        SCLK_rise	: out std_logic;-- one cycle signal of the rising edge of SCLK
        SCLK_fall	: out std_logic -- one cycle signal of the falling edge of SCLK
    );
end fsm_sclk;

architecture behavioural of fsm_sclk is
    -- Divido una frecuencia de 100MHz en pequeños tramos de 1,5MHz lo que obtenermos 66,6 flancos que forman parte del 1,5MHz.
    constant c_half_T_SCLK : integer := integer (floor(real(g_system_clock) / real( g_freq_SCLK_KHZ ))); --constant value to compare and generate the rising/falling edge 
    -- c_counter_width debe recoger el Log2(C_half_T_SCLK) para poder darle la amplitud a count
    constant c_counter_width : integer := integer(ceil(log2(real(c_half_T_SCLK)))); -- the width of the counter, take as reference the debouncer
    signal count : unsigned (c_counter_width-1 downto 0);--Preguntar si es así

    --Genero los estados necesarios para poder dividir bien el código.
    type state_type is (IDLE,SCLK_A0,SCLK_A1);
    signal current_state,next_state:state_type;

    signal time_elapsed, enable_count,SCLK_f_aux,SCLK_r_aux: std_logic;
begin

    Controlador_estados:process (clk ,rst_n ) begin
        if( rst_n = '0') then
            current_state <= IDLE;
            count <= (others =>'0');
            time_elapsed <= '0';
            SCLK_fall <= '0';
            SCLK_rise <= '0';
        else
            if ( rising_edge(clk) ) then
                current_state <= next_state;
                SCLK_fall <= SCLK_f_aux;
                SCLK_rise <= SCLK_r_aux;
                if(enable_count = '1') then
                    if (count < to_unsigned(c_half_T_SCLK -1 , count'length)) then
                        count <= count +1;
                        time_elapsed <=  '0';
                    else
                        time_elapsed <= '1';
                        count <= (others=>'0');
                    end if;
                end if;
            end if;
        end if;
    end process;

    Combinacional: process (current_state,start,time_elapsed, count) begin
        if(rst_n ='0')then
            SCLK<='0';
            SCLK_f_aux <= '0';
            SCLK_r_aux <= '0';
        end if;
        SCLK_f_aux <= '0';
        SCLK_r_aux <= '0';
        case current_state is
            when IDLE =>
                enable_count <= '0';
                if ( start = '1' ) then
                    next_state <= SCLK_A0;
                    enable_count <='1';
                else
                    next_state <= current_state;
                end if;
            when SCLK_A0 =>
                SCLK <='0';
                if (time_elapsed ='1') then
                    next_state <= SCLK_A1;
                    SCLK_r_aux <= '1';
                else
                    next_state <= current_state;
                end if;
            when SCLK_A1 =>
                SCLK <= '1';
                if (time_elapsed ='1') then
                    next_state <= SCLK_A0;
                    SCLK_f_aux <= '1';
                else
                    next_state <= current_state;
                end if;
            when others =>
                next_state <= IDLE;
        end case;

    end process;

end architecture;