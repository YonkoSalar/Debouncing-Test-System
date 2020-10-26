----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2020 12:29:55
-- Design Name: 
-- Module Name: edge_detector - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity edge_detector is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           level : in STD_LOGIC;
           tick : out STD_LOGIC);
end edge_detector;

architecture Behavioral of edge_detector is
    type state_type is (zero, one);
    signal state_reg, state_next : state_type;
begin
    -- State Register --
    process(clk, reset)
        begin
            if(reset = '1') then
                state_reg <= zero;
             elsif (clk'event and clk='1') then
                state_reg <= state_next;
             end if;
     end process;
     
     -- Next State/output logic --
     process(state_reg, level)
     begin
        state_next <= state_reg;
        tick <= '0';
        case state_reg is
            when zero =>
                if level = '1' then
                    state_next <= one;
                    tick <= '1';
                end if;
            when one =>
                if level = '0' then
                    state_next <= zero;
                end if;
        end case;
      end process;

end Behavioral;
