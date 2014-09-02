library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_types.all;

entity TwoPower is
	port 
	(
		Clk: in std_logic;
		Op		: in std_logic_vector (DIM_WIDTH-1 downto 0);
		Result	: out std_logic_vector (DIM_WIDTH*2-3 downto 0)
	);
end TwoPower;

architecture Behavioral of TwoPower is

	signal MultxD: std_logic_vector(DIM_WIDTH*2-1 downto 0); 
	
	begin
		process(Clk)
		begin
			if (rising_edge(Clk)) then
				MultxD <= std_logic_vector(signed(Op)* signed(Op));
					
			end if;
		end process;
	
	--the sign is lost because is sure that is positive
	Result <= MultxD(DIM_WIDTH*2-3 downto 0);
end Behavioral;
