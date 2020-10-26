----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2020 11:27:25
-- Design Name: 
-- Module Name: disp_hex_mux - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity disp_hex_mux is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           hex3, hex2, hex1, hex0 : in STD_LOGIC_VECTOR (3 downto 0);
           dp_in: in std_logic_vector(3 downto 0);
           an: out std_logic_vector(3 downto 0);
           sseg : out std_logic_vector(7 downto 0)
           
           );
end disp_hex_mux;

architecture Behavioral of disp_hex_mux is
constant N: integer := 18;
signal q_reg, q_next: unsigned (N-1 downto 0);
signal sel: std_logic_vector(1 downto 0);
signal hex : std_logic_vector(3 downto 0);
signal dp: std_logic;

begin
-- Register --
process(clk, reset)
begin
    if reset = '1' then
        q_reg <= (others => '0');
    elsif (rising_edge(clk)) then
        q_reg <= q_next;
    end if;
    
end process;

-- Next-state logic for the counter --
q_next <= q_reg + 1;

-- 2 MSBs of counter to control 4-to-1 multiplexing
sel <= std_logic_vector(q_reg(N-1 downto N-2));
process(sel, hex0, hex1, hex2, hex3, dp_in)
begin
    case sel is
        when "00" =>
            an <= "1110";
            hex <= hex0;
            dp <= dp_in(0);
        when "01" =>
            an <= "1101";
            hex <= hex1;
            dp <= dp_in(1);
        when "10" =>
            an <= "1011";
            hex <= hex2;
            dp <= dp_in(2);
        when others =>
            an <= "0111";
            hex <= hex3;
            dp <= dp_in(3);
        end case;
end process;

-- Hex-to-7-segment led decoding
with hex select
    sseg(6 downto 0) <=
        "0000001" when "0000", -- 00
        "1001111" when "0001", -- 01
        "0010010" when "0010", -- 02
        "0000110" when "0011", -- 03
        "1001100" when "0100", -- 04
        "0100100" when "0101",-- 05
        "0100000" when "0110", -- 06
        "0001111" when "0111",-- 07
        "0000000" when "1000", -- 08
        "0000100" when "1001", -- 09
        "0001000" when "1010", -- A
        "1100000" when "1011", -- B
        "0110001" when "1100",-- C
        "1000010" when "1101", -- D
        "0110000" when "1110", -- E
        "0111000" when others;

    sseg(7) <= dp;

end Behavioral;
