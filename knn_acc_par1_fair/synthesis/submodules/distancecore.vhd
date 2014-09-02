library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;  
use ieee.math_real.all;

entity distancecore is  
	port
	(	 
		Clk,
		reset_n			: in std_logic;
		waitrequest 	: in std_logic;
		chipselect		: out std_logic;
		read			: out std_logic;
		write			: out std_logic;
		address			: out std_logic_vector(15 downto 0);
		readdata		: in std_logic_vector(31 downto 0);
		writedata		: out std_logic_vector(31 downto 0);
		waitrequest1	: in std_logic;
		chipselect1		: out std_logic;
		read1			: out std_logic; 
		write1			: out std_logic;
		address1		: out std_logic_vector(15 downto 0);
		readdata1		: in std_logic_vector(31 downto 0);
		writedata1		: out std_logic_vector(31 downto 0);
		reset			: in std_logic;
		QAddress		: in std_logic_vector(15 downto 0);
		SkipAddr		: in std_logic_vector(15 downto 0);
		NDim			: in std_logic_vector(15 downto 0);
		NTr				: in std_logic_vector(15 downto 0);
		Full			: in std_logic;
		EndTSetIn		: in std_logic;
		Go				: in std_logic;
		Drop			: in std_logic;
		EndComp			: out std_logic;
		Empty 			: out std_logic;
		EndTSetOut		: out std_logic;
		Cl				: out std_logic_vector(3 downto 0);
		Dist			: out std_logic_vector(15 downto 0);
		Overflow		: out std_logic
	);		
end distancecore;

architecture Structural of distancecore is 

	component CustomReader is 
	port
	(	
		Clk,
		reset_n			: in std_logic;
		waitrequest 	: in std_logic;
		chipselect		: out std_logic;
		read			: out std_logic; 
		write			: out std_logic;
		address			: out std_logic_vector(15 downto 0);
		readdata		: in std_logic_vector(31 downto 0);
		writedata		: out std_logic_vector(31 downto 0);
		waitrequest1 	: in std_logic;
		chipselect1		: out std_logic;
		read1			: out std_logic; 
		write1			: out std_logic;
		address1		: out std_logic_vector(15 downto 0);
		readdata1		: in std_logic_vector(31 downto 0);
		writedata1		: out std_logic_vector(31 downto 0);
		reset 			: in std_logic;
		QAddress		: in std_logic_vector(15 downto 0);
		SkipAddr		: in std_logic_vector(15 downto 0);
		NDim			: in std_logic_vector(15 downto 0);
		NTr				: in std_logic_vector(15 downto 0);
		Full			: in std_logic;
		EndTSetIn		: in std_logic;
		Go				: in std_logic;
		Drop			: in std_logic;
		EndComp			: out std_logic;
		Empty 			: out std_logic;
		EndTSetOut		: out std_logic;
		SumEn			: out std_logic;
		SubEn			: out std_logic;
		SumReset		: out std_logic;
		Cl				: out std_logic_vector(3 downto 0);
		Q				: out std_logic_vector(9 downto 0);
		T				: out std_logic_vector(9 downto 0)
	);		
	end component;
	
	component EucDis is
	port 
	(
		Clk : in std_logic;
		Reset : in std_logic;
		DimT : in std_logic_vector(9 downto 0);
		DimQ : in std_logic_vector(9 downto 0);
		SumEn: in std_logic;
		SubEn: in std_logic;
		SumReset: in std_logic;
		Overflow: out std_logic;
		Dist: out std_logic_vector(15 downto 0)
	);
	end component;
	
	component OverflowLatch is 
	port
	(	
		Clk     : 	in std_logic;
		Reset   :	in std_logic;
		Overflow: 	in std_logic; 
		LatchOut:	out std_logic
	);		
	end component;
	
	signal QxD: std_logic_vector(9 downto 0);
	signal TxD: std_logic_vector(9 downto 0);
	signal OverflowxD: std_logic;
	signal SumEnxD: std_logic;
	signal SumResetxD: std_logic;
	signal SubEnxD: std_logic;
	
	begin
	
		c_0: CustomReader port map(clk, reset_n, waitrequest, chipselect, read, write, address, readdata, writedata, waitrequest1, chipselect1, read1, write1, address1, readdata1, writedata1, Reset, QAddress, SkipAddr, NDim, NTr, Full, EndTSetIn, Go, Drop, EndComp,Empty, EndTSetOut, SumEnxD, SubEnxD, SumResetxD, Cl, QxD, TxD);
		c_1: EucDis port map(Clk, Reset, TxD, QxD, SumEnxD, SubEnxD, SumResetxD, OverflowxD, Dist);
		c_2: OverflowLatch port map(Clk, Reset, OverflowxD, Overflow);
		
end Structural;