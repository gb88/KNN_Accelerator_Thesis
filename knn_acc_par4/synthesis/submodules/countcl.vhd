library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.common_types.all;

entity CountCl is
	port 
	(
		Clk: in std_logic;
		Reset: in std_logic;
		VoterEn: in std_logic;
		En: in std_logic;
		Count: out std_logic_vector(CLCOUNT_SIZE-1 downto 0)
	);
end CountCl;

architecture Behavioral of CountCl is

	signal CountxD: std_logic_vector(CLCOUNT_SIZE-1 downto 0);
	
	begin
		process(Reset,Clk)
		begin
			if(Reset = '0') then
				CountxD <= (others => '0');
			elsif(rising_edge(Clk)) then
				if(En = '1' and VoterEn = '1') then
					CountxD <= std_logic_vector(unsigned(CountxD) + 1);
				end if;
			end if;
		end process;
		Count <= CountxD;

end Behavioral;
