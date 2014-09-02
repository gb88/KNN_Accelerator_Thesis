library ieee;
use ieee.std_logic_1164.all; 
use work.common_types.all;
use ieee.math_real.all;
use ieee.numeric_std.all; 

entity DropDist is
	port 
	(  
		Clk: in std_logic;
        DistIn: in DistArray(PARALLELISM-1 downto 0); 
        DistRef: in std_logic_vector(DISTANCE_WIDTH-1 downto 0); 
        DropOut : out std_logic_vector(PARALLELISM-1 downto 0)
    );
end entity DropDist;

architecture Structural of DropDist is 

	component CompDist is
		port
		(	
			DistA: in std_logic_vector(DISTANCE_WIDTH-1 downto 0); 
			DistB: in std_logic_vector(DISTANCE_WIDTH-1 downto 0); 
			CompOut : out std_logic		
		);		
	end component;

	signal DropOutxD: std_logic_vector(PARALLELISM-1 downto 0);
	
	begin
	
		DropDistGen:
			for i in 0 to PARALLELISM-1 generate
				CompDistBlk: 
					CompDist port map(DistIn(i), DistRef, DropOutxD(i));
			end generate;
			
		process(Clk)
		begin
			if(rising_edge(clk)) then
				DropOut <= DropOutxD;
			end if;
		end process;
		
end Structural;