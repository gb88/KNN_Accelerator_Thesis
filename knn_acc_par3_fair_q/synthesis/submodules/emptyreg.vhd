library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity EmptyReg is 
	port
	(	
		clk,
		reset_n,
		read,
		write,
		chipselect	: in std_logic;
		address		: in std_logic_vector(1 downto 0);
		readdata	: out std_logic_vector(31 downto 0);
		writedata	: in std_logic_vector(31 downto 0);
		Empty		: in std_logic
	);		
	
end EmptyReg; 

architecture Behavioral of EmptyReg is 	
 
	begin 
		process(clk, reset_n) 
		begin
			if(reset_n='0')then
				readdata <= (others => '0');
			elsif(rising_edge(clk))then
				if(chipselect = '1' and read = '1' )then
					case address is
						when "00" =>
							readdata(31 downto 1) <= (others=>'0');
							readdata(0) <= Empty;
						when others =>
					end case;
				end if;
			end if;
		end process;
		
end Behavioral;