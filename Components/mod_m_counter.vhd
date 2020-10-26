
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mod_m_counter is
    generic(
        N: integer := 8; --Number of bits
        M: integer := 10 --mod-M
        );
    port(
        clk, reset: in std_logic;
        en : in std_logic;
        max_tick: out std_logic;
        q: out std_logic_vector (N-1 downto 0)
        );
        
end mod_m_counter;

architecture Behavioral of mod_m_counter is
signal r_reg, r_next : unsigned(N-1 downto 0);

begin
------------ sequential part-----
	process (reset, clk)
		begin
			if (reset = '1') then
				r_reg <= (others =>'0');
			elsif (rising_edge(clk)) then --(clk'event and clk = '1') 
				if (en = '1') then 
					r_reg <= r_next;
				end if; -- en 
			end if; -- rst
		end process;
------------- next state logic --
---- input: r_reg
---- outout: r_next
	r_next <= (others => '0') when r_reg = M-1 else
			   r_reg +1;
			   
			   
-------------- output logic -----
----- r_reg and external input signal

   q <= std_logic_vector(r_reg);
   max_tick <= '1' when r_reg = M-1 else
               '0';
end Behavioral;
