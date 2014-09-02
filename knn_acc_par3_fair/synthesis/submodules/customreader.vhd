library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all; 
use ieee.math_real.all;
use work.common_types.all;
 
entity CustomReader is 
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
		Cl				: out std_logic_vector(CLASS_WIDTH-1 downto 0);
		Q				: out std_logic_vector(DIM_WIDTH-1 downto 0);
		T				: out std_logic_vector(DIM_WIDTH-1 downto 0)
	);		
end CustomReader;

architecture Behavioral of CustomReader is 

	type StateType is (NEWADDR, READMEM ,WAITFULL, SENDDIST, WAITRESET, ASKFULL);
	type ReqType is (read_req, no_req);
	signal request: ReqType;
	signal NextStatexT: StateType; 
	signal NDimCount: std_logic_vector(15 downto 0);
	signal NTrCount: std_logic_vector(15 downto 0);
	signal DataInPipexD: std_logic;
	signal SumEnPipexD: std_logic; 
	signal AddressxD: std_logic_vector(15 downto 0);
	signal Address1xD: std_logic_vector(15 downto 0);
	signal NDimxD: std_logic_vector(15 downto 0);
	signal CurrAddrxD: std_logic_vector(15 downto 0);
	signal PosCountxD: std_logic_vector(2 downto 0);
	
	begin
		process(clk, reset_n, reset)
		begin
			write <= '0';
			write1 <= '0';
			if(reset_n='0' or reset = '0')then
				read <= '0';
				read1 <='0';
				DataInPipexD <= '0';
				SubEn <= '0';
				NDimCount <= (others=>'0');
				NTrCount	<= (others=>'0');
				AddressxD <= (others=>'0');
				Address1xD <= QAddress;
				Empty <= '1';
				EndComp <='0';
				EndTSetOut <='0';
				PosCountxD <= (others=>'0');
				request <= no_req;
				NextStatexT <= WAITFULL;
			elsif(rising_edge(clk))then
				NextStatexT <= WAITFULL;
				case NextStatexT is
					when WAITFULL =>
						DataInPipexD <= '0';
						SubEn <= '0';
						request <= no_req;
						Address1xD <= Address1xD;
						EndTSetOut <='0';
						Empty <= '1';
						EndComp <='0';
						if Full = '1' then
							NTrCount	<= (others=>'0');
							AddressxD <= (others=>'0');
							NextStatexT <= NEWADDR;
						else
							NextStatexT <= WAITFULL;
						end if;
					when NEWADDR =>
						read  <= '0';
						read1 <= '0';
						request <= no_req;
						Address1xD <= Address1xD;
						EndTSetOut <= '0';
						EndComp <= '0';
						SumReset <= '0';
						Empty <= '0';
						DataInPipexD <= '0';
						SubEn <= '0';
						NDimCount <= (others => '0');
						PosCountxD <= (others => '0');
						if(waitrequest = '1' or waitrequest1 = '1')then
							NextStatexT <= NEWADDR;
							DataInPipexD <= '0';
							SubEn <= '0';
							if(waitrequest = '1' and request = read_req) then
								read <='1';
								request <= read_req;
							end if;
							if(waitrequest1='1' and request = read_req) then
								read1 <='1';
								request <= read_req;
							end if;
						else
							address <= AddressxD;
							address1 <= Address1xD;
							CurrAddrxD <= AddressxD;
							AddressxD <= std_logic_vector(unsigned(AddressxD) + 4);
							Address1xD <= std_logic_vector(unsigned(Address1xD) + 4);
							NextStatexT <= READMEM;
							request <= read_req;
							read <= '1';
							read1 <= '1';
						end if;
					when READMEM =>
						read  <= '0';
						read1 <= '0';
						DataInPipexD <= '0';
						SubEn <= '0';
						Empty <= '0';
						Address1xD <= Address1xD;
						EndTSetOut <= '0';
						EndComp <='0';
						if(Drop ='1') then
							SumReset <= '0';
							if (NTrCount < NTr) then
								NextStatexT <= NEWADDR;
								Address1xD <= QAddress;
								AddressxD <= std_logic_vector(unsigned(CurrAddrxD) + unsigned(SkipAddr));
							elsif(NTrCount >= NTr) then
								NextStatexT <= ASKFULL;
								Address1xD <= QAddress;
								Empty <= '1';
								if(EndTSetIn = '1')then
									EndTSetOut <= EndTSetIn;
									NextStatexT <= WAITRESET;
								end if;
							end if;
						else
							if(unsigned(NDimCount) = 0) then
								SumReset <= '0';
							else
								SumReset <='1';
							end if;
							if(unsigned(NDimCount) < unsigned(NDimxD) + 1) then
								if(waitrequest = '1' or waitrequest1 = '1')then
									NextStatexT <= READMEM;
									DataInPipexD <= '0';
									SubEn <= '0';
									if(waitrequest='1' and request = read_req) then
										read <='1';
										request <= read_req;
									end if;
									if(waitrequest1='1' and request = read_req) then
										read1 <='1';
										request <= read_req;
									end if;
								else
									if(unsigned(NDimCount) = 0) then
										PosCountxD <= (others => '0');
										Cl <= readdata(CLASS_WIDTH-1  downto 0);
										NDimCount <= std_logic_vector(unsigned(NDimCount) + 1);
										NTrCount <= std_logic_vector(unsigned(NTrCount) + 1);
										address <= AddressxD;
										read <='1';
										request <= read_req;
										AddressxD <= std_logic_vector(unsigned(AddressxD)+ 4);
										NextStatexT <= READMEM;
									else
										DataInPipexD <= '1';
										SubEn <= '1';
										NextStatexT <= READMEM;
										if(unsigned(PosCountxD) = 0) then
											request <= no_req;
											T <= readdata(9 downto 0);
											Q <= readdata1(9 downto 0);
											NDimCount <= std_logic_vector(unsigned(NDimCount) + 1);
											PosCountxD <= std_logic_vector(unsigned(PosCountxD) + 1);	
										elsif(unsigned(PosCountxD) = 1) then
											request <= no_req;
											T <= readdata(19 downto 10);
											Q <= readdata1(19 downto 10);
											PosCountxD <= std_logic_vector(unsigned(PosCountxD) + 1);
											NDimCount <= std_logic_vector(unsigned(NDimCount) + 1);
										elsif(unsigned(PosCountxD) = 2) then
											T <= readdata(29 downto 20);
											Q <= readdata1(29 downto 20);
											NDimCount <= std_logic_vector(unsigned(NDimCount) + 1);
											PosCountxD <= (others=>'0');
											address <= AddressxD;
											address1 <= Address1xD;
											AddressxD <= std_logic_vector(unsigned(AddressxD) + 4);
											Address1xD <= std_logic_vector(unsigned(Address1xD) + 4);
											read <= '1';
											read1 <= '1';
											request <= read_req;
											NextStatexT <= READMEM;
										end if;								
									end if;
								end if;
							elsif(unsigned(NDimCount) < unsigned(NDimxD) + 5) then 
								request <= no_req;
								DataInPipexD <= '0';
								SubEn <= '0';
								PosCountxD <= (others=>'0');
								NDimCount <= std_logic_vector(unsigned(NDimCount)+ 1);
								NextStatexT <= READMEM;
							else
								request <= no_req;
								NDimCount <= (others=>'0');
								EndComp <='1';
								NextStatexT <= SENDDIST;
							end if;
						end if;
					when SENDDIST =>
						read <= '0';
						read1 <= '0';
						EndComp <= '1';
						DataInPipexD <= '0';
						SubEn <= '0';
						Empty <= '0';
						request <= no_req;
						EndTSetOut <= '0';
						SumReset <= '1';
						Address1xD <= QAddress;
						AddressxD <= std_logic_vector(unsigned(CurrAddrxD) + unsigned(SkipAddr));
						PosCountxD <= (others => '0');
						if(Drop ='1') then
							EndComp <='0';
							SumReset <= '0';
							if (NTrCount < NTr) then
								NextStatexT <= NEWADDR;
							elsif(NTrCount >= NTr) then
								NextStatexT <= ASKFULL;
								Empty <= '1';
								if(EndTSetIn = '1')then
									EndTSetOut <= EndTSetIn;
									NextStatexT <= WAITRESET;
								end if;
							end if;
						else
							if (Go = '1' and NTrCount < NTr) then
								NextStatexT <= NEWADDR;
								SumReset <= '0';
							elsif(Go = '1' and NTrCount >= NTr) then
								NextStatexT <= ASKFULL;
								Empty <= '1';
								SumReset <= '0';
								if(EndTSetIn = '1')then
									EndTSetOut <= EndTSetIn;
									NextStatexT <= WAITRESET;
								end if;
							else
								NextStatexT <= SENDDIST;
							end if;
						end if;
					when WAITRESET =>
						read <='0';
						read1 <='0';
						DataInPipexD <= '0';
						SubEn <= '0';
						request <= no_req;
						NTrCount <= (others=>'0');
						Address1xD <= QAddress;
						PosCountxD <= (others=>'0');
						Empty <= '1';
						SumReset <= '0';
						EndComp <='0';
						if(EndTSetIn = '1')then
							EndTSetOut <= EndTSetIn;
						end if;
						NextStatexT <= WAITRESET;
					when ASKFULL =>
						DataInPipexD <= '0';
						SubEn <= '0';
						request <= no_req;
						read <='0';
						read1 <='0';
						NTrCount <= (others=>'0');
						Address1xD <= QAddress;
						AddressxD <= (others=>'0');
						PosCountxD <= (others=>'0');
						SumReset <= '0';
						Empty <= '1';
						EndComp <='0';
						if(EndTSetIn = '1')then
							EndTSetOut <= EndTSetIn;
							NextStatexT <= WAITRESET;
						end if;
						if(Full = '0') then
							NextStatexT <= WAITFULL;
						else
							NextStatexT <= ASKFULL;
						end if;
					when others =>
				end case;
			end if;
		end process;
		--process for the eucdist pipeline enable
		process(clk)
		begin
			if(rising_edge(clk)) then
				if(unsigned(NDimCount) = 0) then
					SumEnPipexD <= '0';
					SumEn <= '0';
				else
					SumEnPipexD <= DataInPipexD;
					SumEn <= SumEnPipexD;
				end if;		
			end if;
		end process;
		
		NDimxD<=NDim;
	
end Behavioral;