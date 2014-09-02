library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.common_types.all;

package EucDisPkg is

	Component SubDim is
		port(	
			Clk: in std_logic;
			OpA: in std_logic_vector(DIM_WIDTH-1 downto 0); 
			OpB : in std_logic_vector(DIM_WIDTH-1 downto 0);
			SubEn: in std_logic;
			Overflow: out std_logic;
			Result: out std_logic_vector(DIM_WIDTH-1 downto 0)
		);	
	end component;
	
	Component TwoPower is
		port 
		(
			Clk: in std_logic;
			Op		: in std_logic_vector (DIM_WIDTH-1 downto 0);
			Result	: out std_logic_vector (DIM_WIDTH*2-3 downto 0)
		);
	end component;
	
	Component Summation is
		port
		(
			Clk : in  std_logic; 
		    Reset : in  std_logic;   
			En: in std_logic;
			Data: in std_logic_vector(DIM_WIDTH*2-3 downto 0); 
			Overflow: out std_logic;
			AccSum : out std_logic_vector(DISTANCE_WIDTH-1 downto 0)
		); 
	end component; 
	
end EucDisPkg;