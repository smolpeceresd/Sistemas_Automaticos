library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_filter is
    generic(
        g_width: integer := 8
    );
    port (
        clk		:in std_logic;
        rst		:in std_logic;
        -- Coeficientes
        beta1	:in std_logic_vector(g_width -1 downto 0);-- 7 para que sean 8
        beta2	:in std_logic_vector(g_width -1 downto 0);-- 7 para que sean 8
        beta3	:in std_logic_vector(g_width -1 downto 0);-- 7 para que sean 8
        beta4	:in std_logic_vector(g_width -1 downto 0);-- 7 para que sean 8
        -- Data input 8 bit
        i_data 	:in std_logic_vector(g_width -1 downto 0);-- 7 para que sean 8
        -- Filtered data
        o_data 	:out std_logic_vector(9 downto 0)-- puesto a 17 para que sean 18
    );

end fir_filter;

architecture Behavioral of fir_filter is
    -- refistro de b1,b2,b3,b4
    signal b1,b2,b3,b4 :signed(g_width -1 downto 0 );
    -- propagación de x , es decir din / i_data
    signal din_0,din_1,din_2,din_3:signed(g_width -1 downto 0);
    -- registros de b1,b2,b3,b4 , bx * n son 16 bits , 8*2 = 16 -1 = 15 downto 0 => 16 
    signal b1n,b2n_1,b3n_2,b4n_3,b1aux,b2aux,b3aux,b4aux:signed((g_width*2) -1 downto 0);
    -- registros suma son 17 bits , 8*2 16 +1 de suma = 17 => 16 downto 0
    signal sumb1n_b2n_1, sumb3n_2_b4n_3,sumb12Aux,sumb34aux:signed((g_width*2) downto 0);
    -- señal auxiliar de salida son 18 bits 16+1 +1 de suma final => 17 downto 0
    signal o_aux : signed(9 downto 0);
begin

    syncronous_din: process(clk,rst) begin
        if(rst ='0') then
            din_0 <= (others=>'0');
            din_1 <= (others=>'0');
            din_2 <= (others=>'0');
            din_3 <= (others=>'0');
        elsif(rising_edge(clk))then
            din_0   <= signed(i_data);
            din_1   <= din_0;
            din_2   <= din_1;
            din_3   <= din_2;
        end if;
    end process;

    syncronous_BData:process (clk, rst) begin
        if(rst ='0') then
            b1n      <= (others=>'0');
            b2n_1    <= (others=>'0');
            b3n_2    <= (others=>'0');
            b4n_3    <= (others=>'0');
        elsif(rising_edge(clk)) then
            b1n      <= b1aux;
            b2n_1    <= b2aux;
            b3n_2    <= b3aux;
            b4n_3    <= b4aux;
        end if;
    end process;


    syncronous_SData:process (clk, rst) begin
        if(rst ='0') then
            sumb1n_b2n_1    <= (others =>'0');
            sumb3n_2_b4n_3  <= (others =>'0');
        elsif(rising_edge(clk)) then
            sumb1n_b2n_1    <= sumb12Aux;
            sumb3n_2_b4n_3  <= sumb34aux;
        end if;
    end process;

    Combinational_Bdata:process (beta1,beta2,beta3,beta4,din_0,din_1,din_2,din_3 )begin
        if(rst = '0') then
            b1aux  <= (others=>'0');
            b2aux  <=  (others=>'0');
            b3aux  <=  (others=>'0');
            b4aux  <=  (others=>'0');
        end if;
        b1     <= signed(beta1);
        b2     <= signed(beta2);
        b3     <= signed(beta3);
        b4     <= signed(beta4);
        b1aux  <= resize((b1*din_0),b1aux'length);
        b2aux  <= resize((b2*din_1),b2aux'length);
        b3aux  <= resize((b3*din_2),b3aux'length);
        b4aux  <= resize((b4*din_3),b4aux'length);
    end process;

    Combinational_SumData:process (b1n,b2n_1,b3n_2,b4n_3)begin
        if(rst = '0') then
            sumb12Aux  <= (others=>'0');
            sumb34aux  <= (others=>'0');
        end if;
        sumb12Aux   <= resize((b1n+b2n_1),sumb12Aux'length);
        sumb34aux   <= resize((b3n_2+b4n_3),sumb34aux'length);
    end process;

    Combinational_SumY:process (sumb1n_b2n_1,sumb3n_2_b4n_3)begin
        if(rst ='0') then
            o_aux<=(others =>'0');
        end if;
        o_aux       <= resize((sumb1n_b2n_1+sumb3n_2_b4n_3),o_aux'length);
    end process;

    o_data <= std_logic_vector(o_aux);
end Behavioral;