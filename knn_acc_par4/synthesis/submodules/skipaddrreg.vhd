library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity SkipAddrReg is 
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
		SkipAddr0	: out std_logic_vector(15 downto 0);
		SkipAddr1	: out std_logic_vector(15 downto 0);
		SkipAddr2	: out std_logic_vector(15 downto 0);
		SkipAddr3	: out std_logic_vector(15 downto 0)
	);		
end SkipAddrReg; 

architecture Behavioral of SkipAddrReg is 	 

	begin 
		process(clk, reset_n) 
		begin
			if(reset_n='0')then
				readdata <= (others=>'0');
			elsif(rising_edge(clk))then
				readdata <= (others=>'0');
				if(chipselect = '1' and write = '1') then
					case address is
					--only the address 0 is used
						when "00" =>
							SkipAddr0 <= writedata(15 downto 0);
							SkipAddr1 <= writedata(15 downto 0);
							SkipAddr2 <= writedata(15 downto 0);
							SkipAddr3 <= writedata(15 downto 0);
						when others =>
					end case;
				end if;
			end if;
		end process;
	
end Behavioral;