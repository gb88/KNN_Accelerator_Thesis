library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity BaseQAddr is 
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
		QAddress0:			out std_logic_vector(15 downto 0);
		QAddress1:			out std_logic_vector(15 downto 0)
	);		
	
end BaseQAddr; 
architecture Structural of BaseQAddr is 	 
begin 
	process(clk, reset_n) 
	begin
		if(reset_n='0')then
			readdata<=(others=>'0');
		elsif(rising_edge(clk))then
			readdata<=(others=>'0');
			if(chipselect='1')then
				if(write='1')then
					case address is
						when "00" =>
							QAddress0 <= writedata(15 downto 0);
							QAddress1 <= writedata(15 downto 0);
						when others =>
					end case;
				end if;
			end if;
		end if;
end process;
end structural;