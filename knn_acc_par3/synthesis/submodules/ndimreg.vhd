library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity NDimReg is 
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
		NDim0		: out std_logic_vector(7 downto 0);
		NDim1		: out std_logic_vector(7 downto 0);
		NDim2		: out std_logic_vector(7 downto 0);
		NDim3		: out std_logic_vector(7 downto 0)
	);			
end NDimReg; 

architecture Behavioral of NDimReg is 
	 
	begin 
		process(clk, reset_n) 
		begin
			if(reset_n = '0')then
				readdata <= (others => '0');
			elsif(rising_edge(clk))then
				readdata <= (others => '0');
				if(chipselect = '1' and write = '1') then
						--only address 0 is used
						case address is
							when "00" =>
								NDim0 <= writedata(7 downto 0);
								NDim1 <= writedata(7 downto 0);
								NDim2 <= writedata(7 downto 0);
								NDim3 <= writedata(7 downto 0);
							when others =>
						end case;
				end if;
			end if;
	end process;
	
end Behavioral;