library ieee;
use ieee.std_logic_1164.all; 
use ieee.math_real.all;
use ieee.numeric_std.all; 
use work.common_types.all;

entity MuxClass is
	port
	(  
        Sel: in std_logic_vector(INTEGER(ceil(log2(real(PARALLELISM))))-1 downto 0);
        ClassIn: in ClassArray(PARALLELISM-1 downto 0);
        ClassOut : out std_logic_vector(CLASS_WIDTH-1 downto 0)
    );
end entity MuxClass;

architecture Behavioral of MuxClass is

	begin
		ClassOut <= ClassIn(to_integer(unsigned(Sel)));
		
end architecture Behavioral;