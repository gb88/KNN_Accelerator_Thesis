library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use work.common_types.all;
entity Summation is 
	port
	(
			Clk : in  std_logic; 
		    Reset : in  std_logic; 
			En: in std_logic;
			Data: in std_logic_vector(DIM_WIDTH*2-3 downto 0); 
			Overflow: out std_logic;
			AccSum : out std_logic_vector(DISTANCE_WIDTH-1 downto 0)
	); 
end Summation; 

architecture Behavioral of Summation is 

	signal AccumulatorxD: std_logic_vector(DIM_WIDTH*2-1 downto 0); 
		begin 
			process (Clk, Reset) 
				begin 
					if(Reset = '0')then 
						AccumulatorxD <= (Others => '0'); 
					elsif(rising_edge(Clk))then
						if(En = '1')then
							AccumulatorxD <= AccumulatorxD + Data;
						end if;   
					end if;
			end process; 
			
	Overflow <= AccumulatorxD(DIM_WIDTH*2-1);
	--only the most significant bit is taken, the msb is discarded because should be at 0 if no overflow occurs
    AccSum <= AccumulatorxD(DIM_WIDTH*2-2 downto DIM_WIDTH*2-2-DISTANCE_WIDTH+1); 
	
end Behavioral; 