----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2022 01:12:07
-- Design Name: 
-- Module Name: register_displacer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_displacer is
    generic(
        N:integer := 4
    );
    port ( clk  : in std_logic;
         rst_n  : in std_logic;
         din    : in std_logic;
         SEL    : in unsigned(1 downto 0);
         D      : in unsigned(N-1 downto 0);
         dout   : out std_logic;
         Q      : out unsigned(N-1 downto 0)
        );
end register_displacer;

architecture Behavioral of register_displacer is
    signal Current_plot, desplazador: unsigned(N-1 downto 0);
begin

    Cambio: process (desplazador , SEL) begin
        Q <= desplazador;
        case SEL is
        when "10" =>
            dout<=desplazador(N-1);
        when others=> 
            dout <= desplazador(0);
        end case;
    end process;
    
    Desplazar: process (clk,rst_n,SEL) begin
    if (rst_n ='0')then
        desplazador <= (others => '0');
    else
        if(rising_edge (clk) )then
            case SEL is
            when "00"   =>
                desplazador <=desplazador;
            when "01"   =>
                desplazador<= din &desplazador(N-1 downto 1);
            when "10"   =>
                desplazador<= desplazador(N-2 downto 0) & din;
            when "11"   =>
                desplazador <= D;
            when others => 
                desplazador <= (others => '0');
            end case;
        end if;
    end if;
    end process;

end Behavioral;
