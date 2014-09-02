library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;
use ieee.std_logic_misc.all;
use work.common_types.all;

entity FindMaxDist is 
	port
	(	
		Clk: in std_logic;
		DataIn: in DistArray(MAX_KSET_SIZE-1 downto 0); 
		MaxAddr: out std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
		MaxDist: out std_logic_vector(DISTANCE_WIDTH-1 downto 0)
	);		
end FindMaxDist;

architecture Structural of FindMaxDist is 

	Component MuxCompDist is 
		port
		(	
			Clk: in std_logic;
			DistA: in std_logic_vector(DISTANCE_WIDTH-1 downto 0); 
			AddrA: in std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
			DistB: in std_logic_vector(DISTANCE_WIDTH-1 downto 0); 
			AddrB: in std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
			MaxDist: out std_logic_vector(DISTANCE_WIDTH-1 downto 0); 
			AddrMax: out std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0)
		);		
	end Component;
	
	type MaxDistArray is array (2**(INTEGER(ceil(log2(real(MAX_KSET_SIZE)))))-2 downto 0) of std_logic_vector(DISTANCE_WIDTH-1 downto 0);
	signal InternalTreeMaxDist: MaxDistArray;
	type MaxAddrArray is array (2**(INTEGER(ceil(log2(real(MAX_KSET_SIZE)))))-2 downto 0) of std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
	signal InternalTreeMaxAddr: MaxAddrArray;
	signal DataInxD: DistArray(MAX_KSET_SIZE-1 downto 0);
	
	begin
		--generation of the first layer with the correct index for the leaf of the tree
		GenPGLayer:
			for i in 0 to 2**(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1)-1 generate
				PGGenFH:
					if(i < (MAX_KSET_SIZE-2**(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1))) generate
						PGBlockFH:
							MuxCompDist port map(Clk,DataInxD(MAX_KSET_SIZE-1-2*i), std_logic_vector(to_unsigned(MAX_KSET_SIZE-1-2*i,(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))))), DataInxD(MAX_KSET_SIZE-2-2*i), std_logic_vector(to_unsigned((MAX_KSET_SIZE-2-2*i),(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))))), InternalTreeMaxDist(2**(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1)-1+i), InternalTreeMaxAddr(2**(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1)-1+i));
					end generate;
				PGGenSH:
					if(i >= (MAX_KSET_SIZE-2**(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1))) generate
						PGBlockSH:
						InternalTreeMaxDist(2**(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1)-1+i) <= DataInxD(2**(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1)-1-i);
						InternalTreeMaxAddr(2**(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1)-1+i) <= std_logic_vector(to_unsigned(2**(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1)-1-i,(INTEGER(ceil(log2(real(MAX_KSET_SIZE)))))));
					end generate;
			end generate;
			
		--tree construction
		TreeGenExt:
			for h in 0 to INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-2 generate
				TreeGenInt:
					for i in 0 to (2**h)-1 generate
						NodeGen:
							if((2**h + i) < 2**(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1)) generate
								PrefixGen:
									MuxCompDist port map(Clk,InternalTreeMaxDist(2*(2**(h)+(i))-1), InternalTreeMaxAddr(2*(2**(h)+(i))-1),InternalTreeMaxDist(2*(2**(h)+(i))),InternalTreeMaxAddr(2*(2**(h)+(i))), InternalTreeMaxDist(2**(h)+(i-1)),InternalTreeMaxAddr(2**(h)+(i-1)));
							end generate;
					end generate;
			end generate;
		MaxAddr <= InternalTreeMaxAddr(0);
		MaxDist <= InternalTreeMaxDist(0);
		
		process (Clk)
		begin
			if rising_edge(Clk) then
				DataInxD <= DataIn;
			end if;
		end process;
end Structural; 
