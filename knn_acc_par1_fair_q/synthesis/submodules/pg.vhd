library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity PG is 
	port
	(	
		A: in std_logic;
		B: in std_logic;
		P: out std_logic;
		G: out std_logic		
	);		
end PG;

architecture Dataflow of PG is 

	begin
		G <= A and B;
		P <= A xor B;
		
end Dataflow; 