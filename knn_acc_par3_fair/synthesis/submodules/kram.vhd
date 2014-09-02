library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;
use work.common_types.all;

entity KRam is
	port
	(  
        Clk : in std_logic;
        Reset: in std_logic;
        WrEn: in std_logic;
        WrAddr: in std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
        DistIn: in std_logic_vector(DISTANCE_WIDTH-1 downto 0);
        ClIn: in std_logic_vector(CLASS_WIDTH-1 downto 0);
        ClAddr: in std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
        ClOut: out std_logic_vector(CLASS_WIDTH-1 downto 0);
        DistanceOut: out DistArray(MAX_KSET_SIZE-1 downto 0)
    );
end entity KRam;

architecture Behavioral of KRam is

	signal DistRamxD : DistArray (0 to MAX_KSET_SIZE-1);
	signal ClRamxD : ClassArray(0 to MAX_KSET_SIZE-1);
	
	begin
	
		process(Clk,WrEn,Reset)
		begin
			
			if rising_edge(Clk) then
				if Reset = '0' then
					for i in 0 to MAX_KSET_SIZE-1 loop
						DistRamxD(i) <= (others =>'0');
						ClRamxD(i) <= (others =>'0');
					end loop;
				end if;
				if WrEn = '1' then
					DistRamxD(to_integer(unsigned(WrAddr))) <= DistIn;
					ClRamxD(to_integer(unsigned(WrAddr))) <= ClIn;
				end if;
				ClOut <= ClRamxD(to_integer(unsigned(ClAddr)));	
				--this loop is needed otherwise will not work
				for i in 0 to MAX_KSET_SIZE-1 loop
					DistanceOut(i) <= DistRamxD(i);
				end loop;			
			end if; 
		end process;
		
end architecture Behavioral;
