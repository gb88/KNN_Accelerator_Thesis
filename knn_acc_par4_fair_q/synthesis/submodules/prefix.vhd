library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity Prefix is 
	port
	(	
		G2: in std_logic;
		P2: in std_logic;
		G1: in std_logic;
		P1: in std_logic;
		P: out std_logic;
		G: out std_logic		
	);		
end Prefix;

architecture Dataflow of Prefix is 

	begin
		G <= G2 or (G1 and P2);
		P <= P1 and P2;
		
end Dataflow; 