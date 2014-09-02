library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use work.common_types.all;
use ieee.math_real.all;

entity FindMaxCl is 
	port
	(	
		Clk: in std_logic;
		CountClIn: in CountClArray(2**CLASS_WIDTH-1 downto 0);
		ClIn: ClassArray(2**CLASS_WIDTH-1 downto 0);
		MaxCountCl: out std_logic_vector(CLCOUNT_SIZE-1 downto 0);
		MaxCl: out std_logic_vector(CLASS_WIDTH-1 downto 0)
	);		
end FindMaxCl;

architecture Structural of FindMaxCl is 

	Component MuxCompCl is 
	port
	(	
		Clk: in std_logic;
		CountClA: in std_logic_vector(CLCOUNT_SIZE-1 downto 0);
		ClA: in std_logic_vector(CLASS_WIDTH-1 downto 0); 
		CountClB: in std_logic_vector(CLCOUNT_SIZE-1 downto 0);
		ClB: in std_logic_vector(CLASS_WIDTH-1 downto 0); 
		MaxCountCl: out std_logic_vector(CLCOUNT_SIZE-1 downto 0);
		MaxCl: out std_logic_vector(CLASS_WIDTH-1 downto 0)
	);			
	end Component;
	
	type MaxCountClArray is array (2**(CLASS_WIDTH)-2 downto 0) of std_logic_vector(CLCOUNT_SIZE-1 downto 0);
	type MaxClArray is array (2**(CLASS_WIDTH)-2 downto 0) of std_logic_vector(CLASS_WIDTH-1 downto 0);
	signal InternalTreeMaxCount: MaxCountClArray;
	signal InternalTreeMaxCl: MaxClArray;
	
	begin
		--generation of the first layer with the correct index for the leaf of the tree
		GenPGLayer:
			for i in 0 to 2**(CLASS_WIDTH-1)-1 generate
			
				PGGenFH:
					if( i < 2**(CLASS_WIDTH) - 2**(CLASS_WIDTH-1)) generate
						PGBlockFH:
							MuxCompCl port map(Clk, CountClIn(2**CLASS_WIDTH-1-2*i), ClIn(2**CLASS_WIDTH-1-2*i), CountClIn(2**CLASS_WIDTH-1-2*i-1), ClIn(2**CLASS_WIDTH-1-2*i-1), InternalTreeMaxCount(2**(CLASS_WIDTH-1)-1+i), InternalTreeMaxCl(2**(CLASS_WIDTH-1)-1+i));
					end generate;
					
				PGGenSH:
					if( i >= 2**(CLASS_WIDTH) - 2**(CLASS_WIDTH-1)) generate
						PGBlockSH:
							InternalTreeMaxCount(2**(CLASS_WIDTH-1)-1+i) <= CountClIn(2**CLASS_WIDTH-1-i);
							InternalTreeMaxCl(2**(CLASS_WIDTH-1)-1+i) <= ClIn(2**CLASS_WIDTH-1-i);
					end generate;
			end generate;
		--tree connection
		TreeGenExt:
			for h in 0 to INTEGER(ceil(log2(real(2**(CLASS_WIDTH-1)))))-1 generate
				TreeGenInt:
					for i in 0 to (2**h)-1 generate
						NodeGen:
							if((2**h + i) < 2**(CLASS_WIDTH-1)) generate
								PrefixGen:
									MuxCompCl port map(Clk, InternalTreeMaxCount(2*(2**(h)+(i))-1), InternalTreeMaxCl(2*(2**(h)+(i))-1),InternalTreeMaxCount(2*(2**(h)+(i))),InternalTreeMaxCl(2*(2**(h)+(i))), InternalTreeMaxCount(2**(h)+(i-1)),InternalTreeMaxCl(2**(h)+(i-1)));
							end generate;
					end generate;
			end generate;
			
		MaxCountCl <= InternalTreeMaxCount(0);
		MaxCl <= InternalTreeMaxCl(0);
		
end Structural; 

