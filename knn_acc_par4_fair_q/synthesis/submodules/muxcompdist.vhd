library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use work.common_types.all;
use ieee.math_real.all;

entity MuxCompDist is 
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
end MuxCompDist;

architecture Structural of MuxCompDist is 

	Component PG is 
		port
		(	
			A: in std_logic;
			B: in std_logic;
			P: out std_logic;
			G: out std_logic		
		);		
	end Component;
	
	Component Prefix is 
		port
		(	
			G2: in std_logic;
			P2: in std_logic;
			G1: in std_logic;
			P1: in std_logic;
			P: out std_logic;
			G: out std_logic		
		);		
	end Component;
	
	signal InternalTreePxD: std_logic_vector(2*(DISTANCE_WIDTH-1) downto 0); 
	signal InternalTreeGxD: std_logic_vector(2*(DISTANCE_WIDTH-1) downto 0); 
	signal DistAxD: std_logic_vector(DISTANCE_WIDTH-1 downto 0); 
	signal CompOutxD: std_logic;
	signal MaxDistxD: std_logic_vector(DISTANCE_WIDTH-1 downto 0); 
	signal AddrMaxxD: std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
	
	begin
		DistAxD <= not(DistA);
		--generation of the first layer with the correct index for the leaf of the tree
		
		GenPGLayer:
			for i in 0 to DISTANCE_WIDTH-1 generate 
				PGGenFH:
					if(i < (2*DISTANCE_WIDTH-2**INTEGER(ceil(log2(real(DISTANCE_WIDTH)))))) generate
					PGBlockFH:
						PG port map(DistAxD(DISTANCE_WIDTH-1-i), DistB(DISTANCE_WIDTH-1-i), InternalTreePxD(2**(INTEGER(ceil(log2(real(DISTANCE_WIDTH)))))-1+i), InternalTreeGxD(2**(INTEGER(ceil(log2(real(DISTANCE_WIDTH)))))-1+i));
					end generate;
				PGGenSH:
					if(i >= (2*DISTANCE_WIDTH-2**INTEGER(ceil(log2(real(DISTANCE_WIDTH)))))) generate	
					PGBlockSH:
						PG port map(DistAxD(DISTANCE_WIDTH-1-i), DistB(DISTANCE_WIDTH-1-i), InternalTreePxD(2**(INTEGER(ceil(log2(real(DISTANCE_WIDTH)))))-1-DISTANCE_WIDTH+i), InternalTreeGxD(2**(INTEGER(ceil(log2(real(DISTANCE_WIDTH)))))-1-DISTANCE_WIDTH+i));
					end generate;
			end generate;
				
		--tree connection
		TreeGenExt:
			for h in 0 to INTEGER(ceil(log2(real(DISTANCE_WIDTH))))-1 generate
				TreeGenInt:
					for i in 0 to (2**h)-1 generate
						NodeGen:
							if((2**h + i) < DISTANCE_WIDTH) generate
								PrefixGen:
									Prefix port map(InternalTreeGxD(2*(2**(h)+(i))-1), InternalTreePxD(2*(2**(h)+(i))-1), InternalTreeGxD(2*(2**(h)+(i))),InternalTreePxD(2*(2**(h)+(i))), InternalTreePxD(2**(h)+(i-1)), InternalTreeGxD(2**(h)+(i-1)));
							end generate;
					end generate;
			end generate;
			
		CompOutxD <= InternalTreePxD(0) nor InternalTreeGxD(0);
		MaxDistxD <= DistA when (CompOutxD = '1') else DistB;
		AddrMaxxD <= AddrA when (CompOutxD = '1') else AddrB;
		
		process(Clk)
		begin
			if rising_edge (Clk) then
				MaxDist <= MaxDistxD;
				AddrMax <= AddrMaxxD;
			end if;
		end process;
		
end Structural; 