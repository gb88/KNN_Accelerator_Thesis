library ieee;
use ieee.std_logic_1164.all; 
use ieee.math_real.all;
use ieee.numeric_std.all; 
use ieee.std_logic_misc.all;
use work.common_types.all;

entity MuxDist is
	port 
	(  
        Sel: in std_logic_vector(INTEGER(ceil(log2(real(PARALLELISM))))-1 downto 0);
        DistIn: in DistArray(PARALLELISM-1 downto 0);
        DistOut : out std_logic_vector(DISTANCE_WIDTH-1 downto 0)
    );
end entity MuxDist;

architecture Behavioral of MuxDist is

	begin
		DistOut <= DistIn(to_integer(unsigned(Sel)));
		
end architecture Behavioral;