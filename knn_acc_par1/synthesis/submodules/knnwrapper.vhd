library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;  
use IEEE.std_logic_misc.all;
use ieee.math_real.all;

entity KnnWrapper is
	port
	(
		Clk: in std_logic;
		Reset: in std_logic;
		EndComp0: in std_logic;
		EndTSet0: in std_logic;
		Cl0: in std_logic_vector(3 downto 0);
		Dist0: in std_logic_vector(15 downto 0); 
		Go0: out std_logic;  
		Drop0: out std_logic; 
		Overflow0: in std_logic;	
		DistReset0: out std_logic;
		read,
		write,
		chipselect	: in std_logic;
		address		: in std_logic_vector(4 downto 0);
		readdata	: out std_logic_vector(31 downto 0);
		writedata	: in std_logic_vector(31 downto 0)
	);
end KnnWrapper;

architecture Structural of KnnWrapper is 

	component knnclass is
	port
	(
		Clk: in std_logic;
		Reset: in std_logic;
		EndComp0: in std_logic;
		EndTSet0: in std_logic;
		Cl0: in std_logic_vector(3 downto 0);
		Dist0: in std_logic_vector(15 downto 0);
		Go0: out std_logic;
		Drop0: out std_logic;
		Overflow0: in std_logic;
		DistReset: out std_logic;
		read,
		write,
		chipselect	: in std_logic;
		address		: in std_logic_vector(4 downto 0);
		readdata	: out std_logic_vector(31 downto 0);
		writedata	: in std_logic_vector(31 downto 0)
	);
	end component;
		
	signal DistResetxD: std_logic;
	
	begin
		c0: knnclass port map(Clk, Reset, EndComp0, EndTSet0, Cl0, Dist0, Go0, Drop0, Overflow0, DistResetxD, read, write, chipselect, address, readdata, writedata);
		
		DistReset0 <= DistResetxD;
		
end Structural;