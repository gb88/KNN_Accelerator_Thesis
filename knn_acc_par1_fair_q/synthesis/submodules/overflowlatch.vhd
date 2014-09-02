library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.std_logic_misc.all;
use work.common_types.all;

entity OverflowLatch is 
	port
	(	
		Clk     : 	in std_logic;
		Reset   :	in std_logic;
		Overflow: 	in std_logic; 
		LatchOut:	out std_logic
	);		
end OverflowLatch;

architecture Behavioral of OverflowLatch is 

	signal LatchxD:std_logic;
	
	begin 
		process(Clk, Reset, Overflow)
		begin
			if Reset = '0' then
				LatchxD <= '0';
			elsif(rising_edge(Clk) and Overflow = '1') then
				LatchxD <= '1';
			end if;
		end process;
		LatchOut <= LatchxD; 
		
end Behavioral; 