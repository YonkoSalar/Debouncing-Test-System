library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce_test is
 port(
       clk : in std_logic;
       btn : in std_logic_vector(3 downto 0);
       an : out std_logic_vector(3 downto 0);
       sseg : out std_logic_vector(7 downto 0)
   );
end debounce_test;

architecture Behavioral of debounce_test is
signal b_count, d_count : std_logic_vector(7 downto 0);
signal db_level, db_tick_1, db_tick_2, btn_tick, clr: std_logic;

begin


--Debouncing Circuit--
db_unit: entity work.db_fm
port map(
    clk => clk,
    reset => clr,
    sw => btn(1), db =>db_level);


--Edge Detection Circuits--
edge_1: entity work.edge_detector
port map(
        clk => clk,
        reset => clr,
        level => btn(1),
        tick => btn_tick);
        
edge_2: entity work.edge_detector
        port map(
                clk => clk,
                reset => clr,
                level => db_level,
                tick => db_tick_2);

--Two mod-10 Counters--
clr <= btn(0);
mod_m_counter_1 : entity work.mod_m_counter
generic map(
        N => 8, --Number of bits
        M => 10 --mod-10
        )
port map(
    clk => clk,
    reset => clr,
    en => db_tick_2,
    q => d_count);


mod_m_counter_2 : entity work.mod_m_counter
generic map(
        N => 8, --Number of bits
        M => 10 --mod-10
        )
port map(
    clk => clk,
    reset => clr,
    en =>btn_tick,
    q => b_count);
    

--Hex Display time-mutliplexing circuit--
disp_unit : entity work.disp_hex_mux
port map(
    clk => clk,
    reset => clr,
    hex3 => b_count(7 downto 4), hex2 => b_count(3 downto 0),
    hex1 => d_count(7 downto 4), hex0 =>d_count(3 downto 0),
    dp_in => "1011", an => an, sseg => sseg);

end Behavioral;
