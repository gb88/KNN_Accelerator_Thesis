library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity FullReg is 
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
		Full		: out std_logic
	);		
	
end FullReg; 

architecture Behavioral of FullReg is 	 

	signal FullxD: std_logic;
	
	begin 
		process(clk, reset_n) 
		begin
			if(reset_n = '0')then
				readdata <= (others => '0');
			elsif(rising_edge(clk))then
				readdata <= (others => '0');
				if(chipselect='1' and write = '1')then
					case address is
						--only address 0 is used
						when "00" =>
							FullxD <= writedata(0);
						when others =>
					end case;
				end if;
			end if;
	end process;
	
	Full<= FullxD;
	
end Behavioral;