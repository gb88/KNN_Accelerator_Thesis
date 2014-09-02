library ieee;
use ieee.std_logic_1164.all; 
use ieee.math_real.all;

package common_types is

	constant DISTANCE_WIDTH : integer := 16;
	constant CLASS_WIDTH : integer := 4;
	constant INT_WIDTH : integer:= 4;
	constant DEC_WIDTH: integer:= 6;
	constant DIM_WIDTH: integer:= INT_WIDTH+DEC_WIDTH;
	constant PARALLELISM : integer := 3;
	constant MAX_KSET_SIZE: integer:= 16;
	constant K_WIDTH: integer := 8;
	constant CLCOUNT_SIZE: integer := INTEGER(ceil(log2(real(MAX_KSET_SIZE))))+1;
	
	type ClassArray is array(integer range <>) of std_logic_vector(CLASS_WIDTH-1 downto 0); 
	type KAddrArray is array(integer range <>) of std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
	type CountClArray is array(integer range <>) of std_logic_vector(CLCOUNT_SIZE-1 downto 0);
	type DistArray is array(integer range <>) of std_logic_vector(DISTANCE_WIDTH-1 downto 0); 
	
end package;