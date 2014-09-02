library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;
use work.common_types.all;

entity DecCl is
	port 
	(  
        ClIn: in std_logic_vector(CLASS_WIDTH-1 downto 0);
        DecOut : out std_logic_vector(2**CLASS_WIDTH-1 downto 0)
    );
end entity DecCl;

architecture Behavioral of DecCl is

	signal DecOutxD: std_logic_vector(2**CLASS_WIDTH-1 downto 0);
	begin
		process(ClIn, DecOutxD)
		begin
			for i in 0 to 2**CLASS_WIDTH-1 loop
				if(to_integer(unsigned(ClIn)) = i) then
					DecOutxD(i) <= '1';
				else 
					DecOutxD(i) <= '0';
				end if;
			end loop;
			DecOut <= DecOutxD;
		end process;
	
end architecture Behavioral;