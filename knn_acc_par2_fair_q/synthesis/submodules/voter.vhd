library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;
use work.common_types.all;

entity Voter is
	port 
	(  
		Clk : in std_logic;
		Reset: in std_logic;
		VoterEn: in std_logic;
		ClIn: in std_logic_vector(CLASS_WIDTH-1 downto 0);
		NVot: out std_logic_vector(CLCOUNT_SIZE-1 downto 0);
		ClOut: out std_logic_vector(CLASS_WIDTH-1 downto 0)
	);
end entity Voter;

Architecture Structural of Voter is

	signal CountEnxT: std_logic_vector(2**CLASS_WIDTH-1 downto 0);
	signal CountOutxD: CountClArray(2**CLASS_WIDTH-1 downto 0);
	signal ClxD: ClassArray(2**CLASS_WIDTH-1 downto 0);
	
	Component DecCl is
		port 
		(  
			ClIn: in std_logic_vector(CLASS_WIDTH-1 downto 0);
			DecOut : out std_logic_vector(2**CLASS_WIDTH-1 downto 0)
		);
	end Component;
	
	Component CountCl is
		port 
		(
			Clk: in std_logic;
			Reset: in std_logic;
			VoterEn: in std_logic;
			En: in std_logic;
			Count: out std_logic_vector(CLCOUNT_SIZE-1 downto 0)
		);
	end Component;
	
	Component FindMaxCl is 
		port
		(	
			Clk: in std_logic;
			CountClIn: in CountClArray(2**CLASS_WIDTH-1 downto 0);
			ClIn: ClassArray(2**CLASS_WIDTH-1 downto 0);
			MaxCountCl: out std_logic_vector(CLCOUNT_SIZE-1 downto 0);
			MaxCl: out std_logic_vector(CLASS_WIDTH-1 downto 0)
		);	
	end Component;
	
	begin
		DecClBlk:
			DecCl port map(ClIn, CountEnxT);
			
		CountGen:
			for i in 0 to 2**CLASS_WIDTH-1 generate
				CountClBlk: 
					CountCl	port map(Clk, Reset, VoterEn, CountEnxT(i), CountOutxD(i));
					ClxD(i) <= std_logic_vector(to_unsigned(i,CLASS_WIDTH));
			end generate;
			
		FindMaxClBlk:
			FindMaxCl port map(Clk, CountOutxD, ClxD, NVot, ClOut );
			
end Structural;