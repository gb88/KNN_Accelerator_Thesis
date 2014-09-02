library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use IEEE.std_logic_misc.all;
use ieee.math_real.all;
use work.common_types.all;

entity knnclass is
	port
	(
		Clk: in std_logic;
		Reset: in std_logic;
		EndComp0: in std_logic;
		EndComp1: in std_logic;
		EndTSet0: in std_logic;
		EndTSet1: in std_logic;
		Cl0: in std_logic_vector(CLASS_WIDTH-1 downto 0);
		Cl1: in std_logic_vector(CLASS_WIDTH-1 downto 0);
		Dist0: in std_logic_vector(DISTANCE_WIDTH-1 downto 0);
		Dist1: in std_logic_vector(DISTANCE_WIDTH-1 downto 0);
		Go0: out std_logic;
		Go1: out std_logic;
		Drop0: out std_logic;
		Drop1: out std_logic;
		Overflow0: in std_logic;
		Overflow1: in std_logic;
		DistReset: out std_logic_vector(PARALLELISM-1 downto 0);
		read,
		write,
		chipselect	: in std_logic;
		address		: in std_logic_vector(4 downto 0);
		readdata	: out std_logic_vector(31 downto 0);
		writedata	: in std_logic_vector(31 downto 0)
	);
end knnclass;

architecture Structural of knnclass is

	component ControllerClass is 
		port
		(	
			Clk: in std_logic;
			Reset: in std_logic; 
			KVal: in std_logic_vector(K_WIDTH-1 downto 0);
			StartCl: in std_logic;
			EndTSet: in std_logic;
			EndComp: in std_logic_vector(PARALLELISM-1 downto 0);
			Go: out std_logic_vector(PARALLELISM-1 downto 0);
			DropEn: out std_logic;
			DistReset: out std_logic_vector(PARALLELISM-1 downto 0);
			MuxDistSel: out std_logic_vector(INTEGER(ceil(log2(real(PARALLELISM))))-1 downto 0);
			MuxKRamSel: out std_logic;
			KRamReset: out std_logic;
			KRamWrEn: out std_logic;
			KRamAddr: out std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
			ClKRamAddr: out std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
			VoterReset: out std_logic;
			VoterEn: out std_logic;
			EndClass: out std_logic
		);		
	end component;
	
	component FindMaxDist is 
		port
		(	
			Clk: in std_logic;
			DataIn: in DistArray(MAX_KSET_SIZE-1 downto 0); 
			MaxAddr: out std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
			MaxDist: out std_logic_vector(DISTANCE_WIDTH-1 downto 0)
		);		
	end component;
	
	component MuxKAddr is
		port 
		(  
			AddrA: in std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
			AddrB: in std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
			Sel: in std_logic;
			AddrOut: out std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0)
		);
	end component;
	
	component MuxDist is
		port 
		(  
			Sel: in std_logic_vector(INTEGER(ceil(log2(real(PARALLELISM))))-1 downto 0);
			DistIn: in DistArray(PARALLELISM-1 downto 0);
			DistOut : out std_logic_vector(DISTANCE_WIDTH-1 downto 0)
		);
		end component;
		
	component MuxClass is
		port
		(  
			Sel: in std_logic_vector(INTEGER(ceil(log2(real(PARALLELISM))))-1 downto 0);
			ClassIn: in ClassArray(PARALLELISM-1 downto 0);
			ClassOut : out std_logic_vector(CLASS_WIDTH-1 downto 0)
		);
	end component;
	
	component KRam is
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
	end component;
	
	component DropDist is
		port 
		(  
			Clk: in std_logic;
			DistIn: in DistArray(PARALLELISM-1 downto 0); 
			DistRef: in std_logic_vector(DISTANCE_WIDTH-1 downto 0); 
			DropOut : out std_logic_vector(PARALLELISM-1 downto 0)
		);
	end component;
	
	component Voter is
		port 
		(  
			Clk : in std_logic;
			Reset: in std_logic;
			VoterEn: in std_logic;
			ClIn: in std_logic_vector(CLASS_WIDTH-1 downto 0);
			NVot: out std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE)))) downto 0);
			ClOut: out std_logic_vector(CLASS_WIDTH-1 downto 0)
		);
	end component;
	
	component AvInterface is 
		port
		(	
			clk,
			reset_n,
			read,
			write,
			chipselect	: in std_logic;
			address		: in std_logic_vector(4 downto 0);
			readdata	: out std_logic_vector(31 downto 0);
			writedata	: in std_logic_vector(31 downto 0);
			ClOut 		: in std_logic_vector(CLASS_WIDTH-1 downto 0);
			NVot:		in std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE)))) downto 0);
			StartCl		: out std_logic;
			KVal:		 out std_logic_vector(K_WIDTH-1 downto 0);
			EndClass	: in std_logic;
			DistIn:			in DistArray(MAX_KSET_SIZE-1 downto 0);
			Overflow: 	in std_logic
		);			
	end component; 

	signal MuxDistSelxS: std_logic_vector(INTEGER(ceil(log2(real(PARALLELISM))))-1 downto 0);
	signal MuxKRamSelxS: std_logic;
	signal MaxAddrDistxD:std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
	signal KRamControllerAddrxD: std_logic_vector(3 downto 0); --da mettere k
	signal KRamAddrxD: std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
	signal ClassxD: ClassArray(PARALLELISM-1 downto 0);
	signal KRamClassInxD : std_logic_vector(CLASS_WIDTH-1 downto 0);
	signal KRamRstxRB: std_logic;
	signal KRamWrEnxT: std_logic;
	signal KRamDistInxD: std_logic_vector(DISTANCE_WIDTH-1 downto 0);
	signal KRamClassAddrxD: std_logic_vector(3 downto 0); --da mettere k
	signal VoterClInxD: std_logic_vector(CLASS_WIDTH-1 downto 0);
	signal FindMaxDistDataInxD:DistArray(MAX_KSET_SIZE-1 downto 0);
	signal MaxDistxD: std_logic_vector(DISTANCE_WIDTH-1 downto 0);
	signal DropxT: std_logic_vector(PARALLELISM-1 downto 0);
	signal VoterEnxD: std_logic;
	signal VoterRstxRB: std_logic;
	signal DistInxD: DistArray(PARALLELISM-1 downto 0);
	signal EndCompxD: std_logic_vector(PARALLELISM-1 downto 0);
	signal GoxD: std_logic_vector(PARALLELISM-1 downto 0);
	signal EndTSetxD: std_logic;
	signal DropEnxT: std_logic;
	signal ClOutxD: std_logic_vector(3 downto 0);
	signal NVotxD: std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE)))) downto 0);
	signal StartClxD: std_logic;
	signal KValxD: std_logic_vector(7 downto 0);
	signal EndClassxD: std_logic;
	signal OverflowxD: std_logic;
	
	begin
	
	c0: ControllerClass port map(Clk,Reset,KValxD,StartClxD,EndTSetxD,EndCompxD,GoxD,DropEnxT,DistReset,MuxDistSelxS,MuxKRamSelxS,KRamRstxRB,KRamWrEnxT, KRamControllerAddrxD,KRamClassAddrxD,VoterRstxRB,VoterEnxD,EndClassxD);
	c1: FindMaxDist port map(Clk,FindMaxDistDataInxD,MaxAddrDistxD,MaxDistxD);
	c2: MuxClass port map(MuxDistSelxS, ClassxD, KRamClassInxD);
	c3: MuxKAddr port map(MaxAddrDistxD, KRamControllerAddrxD, MuxKRamSelxS, KRamAddrxD);
	c4: MuxDist port map(MuxDistSelxS,DistInxD,KRamDistInxD);
	c5: KRam port map (Clk, KRamRstxRB, KRamWrEnxT, KRamAddrxD, KRamDistInxD, KRamClassInxD, KRamClassAddrxD, VoterClInxD,FindMaxDistDataInxD );
	c6: DropDist port map(Clk, DistInxD, MaxDistxD, DropxT );
	c7: Voter port map(Clk, VoterRstxRB, VoterEnxD, VoterClInxD, NVotxD, ClOutxD);	
	c8: AvInterface port map(Clk,Reset,read,write,chipselect,address,readdata,writedata,ClOutxD,NVotxD,StartClxD,KValxD,EndClassxD, FindMaxDistDataInxD, OverflowxD);
	
	EndCompxD(0) <= EndComp0;
	EndCompxD(1) <= EndComp1;
	DistInxD(0) <= Dist0;
	DistInxD(1) <= Dist1;
	Go0 <= GoxD(0);
	Go1 <= GoxD(1);
	ClassxD(0) <= Cl0;
	ClassxD(1) <= Cl1;
	Drop0 <= DropxT(0) and DropEnxT;
	Drop1 <= DropxT(1) and DropEnxT;
	EndTSetxD <= EndTSet0 and EndTset1;
	OverflowxD <= Overflow0 or Overflow1;
	
end Structural;