library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity register_displaced_tb is
    --  Port ( );
end register_displaced_tb;

architecture Structural of register_displaced_tb is

    component register_displacer is
        generic(
            N:integer := 4
        );
        port (
            clk    : in std_logic;
            rst_n  : in std_logic;
            din    : in std_logic;
            SEL    : in unsigned(1 downto 0);
            D      : in unsigned(N-1 downto 0);
            dout   : out std_logic;
            Q      : out unsigned(N-1 downto 0)
        );
    end component;

    constant N_tb :integer:= integer (4);
    signal clk_tb,rst_n_tb,din_tb,dout_tb:std_logic;
    signal SEL_tb : unsigned (1 downto 0);
    signal D_tb,Q_tb : unsigned (N_tb-1 downto 0);

begin

    DUT: register_displacer
        generic map ( N => N_tb)
        port map(
            clk  => clk_tb,
            rst_n  => rst_n_tb,
            din    => din_tb,
            SEL    => SEL_tb,
            D      => D_tb,
            dout   => dout_tb,
            Q      => Q_tb
        );


    process begin
        rst_n_tb <='0'; wait for 50ns;
        rst_n_tb <= '1' ;wait;
    end process;

    process begin
        clk_tb <= '0'; wait for 50ns;
        clk_tb <= '1'; wait for 50ns;
    end process;

    process begin
        SEL_tb <= "00"; wait for 100ns;
        SEL_tb <= "01"; wait for 15000ns;
        SEL_tb <= "10"; wait for 15000ns;
        SEL_tb <= "11"; wait for 10000ns;
        SEL_tb <= "00"; wait;
    end process;

    process begin
        din_tb <= '1'; wait for 1500ns;
        din_tb <= '0'; wait for 1200ns;
    end process;

    process begin
        D_tb<="0101";wait;
    end process;
end Structural;
