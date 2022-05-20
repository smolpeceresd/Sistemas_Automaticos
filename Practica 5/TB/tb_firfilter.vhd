

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity tb_firfilter is
--  Port ( );
end tb_firfilter;

architecture Structural of tb_firfilter is
    component fir_filter is
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

end component;
constant g_width_tb: integer :=8;
signal clk_tb,rst_tb : std_logic;
signal beta1,beta2,beta3,beta4,i_data : std_logic_vector(g_width_tb -1 downto 0);
signal o_data : std_logic_vector (9 downto 0);
begin

DUT:fir_filter generic map(g_width_tb) port map(clk_tb,rst_tb,beta1,beta2,beta3,beta4,i_data,o_data);

process begin
    rst_tb <='0'; wait for 100ns;
    rst_tb <='1'; wait;
end process;

process begin
    clk_tb <='0'; wait for 50ns;
    clk_tb <='1'; wait for 50ns;
end process;

process begin
-- ESTAN EN COMPLEMENTO A2 -3 1 1 -3
 beta1 <= "11111101"; beta2 <= "00000001"; beta3 <= "00000001";beta4 <= "11111101"; wait;
end process;

process begin
i_data<="00000011";wait;
end process;
end Structural;
