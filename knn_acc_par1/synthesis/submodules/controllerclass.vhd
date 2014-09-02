library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use IEEE.std_logic_misc.all;
use ieee.math_real.all;
use work.common_types.all;
entity ControllerClass is 
	port(	
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
end ControllerClass;

architecture Behavioral of ControllerClass is 

	type StateType is (InitState, UpdateMaxState, CheckEndCompState, StoreDistState, VoterState, MaxClassState, ClassState);
	signal NextStatexT : StateType; 
	signal MuxDistSelxD: std_logic_vector(INTEGER(ceil(log2(real(PARALLELISM))))-1 downto 0);
	signal KRamAddrxD: std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
	signal ClKRamAddrxD: std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE)))) downto 0);
	signal KValxD: std_logic_vector(K_WIDTH-1 downto 0);
	signal KCountxD: std_logic_vector(K_WIDTH-1 downto 0);
	signal EndCompxD: std_logic_vector( PARALLELISM-1 downto 0);
	signal CounterUpdMaxT: std_logic_vector(INTEGER(ceil(log2(real(6 + INTEGER(ceil(log2(real(MAX_KSET_SIZE)))))))) downto 0);
	
	begin
		process(Clk, Reset, StartCl) 
		begin 
			
			if (Reset='0' or StartCl='0')  then 
				CounterUpdMaxT <= (Others => '0');
				Go <= (Others => '0');
				DropEn <='0';
				DistReset <= (Others => '0');
				MuxDistSelxD <= (Others => '0');
				MuxKRamSel <= '0';
				KRamReset <= '0';
				KRamWrEn <= '0';
				KRamAddrxD <= (Others => '1');
				ClKRamAddrxD <= (Others => '0');
				VoterReset <= '0';
				VoterEn <= '0';
				EndClass <=	'0';
				KCountxD <= (Others => '0');
				NextStatexT<= InitState; 
			elsif rising_edge(clk) then
				NextStatexT <= InitState;
				case NextStatexT is
					when InitState => 
						CounterUpdMaxT <= (Others => '0');
						Go <= (Others => '0');
						DropEn <='0';
						DistReset <= (Others => '0');
						MuxDistSelxD <= (Others => '0');
						MuxKRamSel <= '0';
						KRamReset <= '0';
						KRamWrEn <= '0';
						KRamAddrxD <= (Others => '1');
						ClKRamAddrxD <= (Others => '0');
						VoterReset <= '0';
						VoterEn <= '0';
						EndClass <=	'0';
						KCountxD <= (Others => '0');
						KValxD <= KVal;
						if(StartCl = '1') then
							NextStatexT <= CheckEndCompState;
						else
							NextStatexT <= InitState;
						end if;
					when CheckEndCompState =>
						CounterUpdMaxT <= (Others => '0');
						Go <= (Others => '0');
						DistReset <= (Others => '1');
						KRamReset <= '1';
						KRamWrEn <= '0';
						ClKRamAddrxD <= (Others => '0');
						VoterReset <= '0';
						VoterEn <= '0';
						EndClass <=	'0';				
						if(EndTSet='1') then
							NextStatexT <= VoterState;
							VoterReset <= '1';
							--VoterEn <= '1';
						elsif(to_integer(unsigned(EndCompxD)) /= 0) then
							NextStatexT <= StoreDistState;
							KRamAddrxD <= std_logic_vector(unsigned(KRamAddrxD)+1);
						else
							NextStatexT <= CheckEndCompState;	
						end if;
						if(unsigned(KCountxD) < unsigned(KValxD)) then 
							MuxKRamSel <= '0';
							DropEn <='0';
						else 
							DropEn <='1';
							MuxKRamSel <= '1';
						end if;
						for i in 0 to PARALLELISM-1 loop
							if(EndCompxD(i)='1') then
								MuxDistSelxD <= std_logic_vector(to_unsigned(i,INTEGER(ceil(log2(real(PARALLELISM))))));
							end if;
						end loop;
					when StoreDistState =>
						CounterUpdMaxT <= (Others => '0');
						DistReset <= (Others => '1');
						KRamReset <= '1';
						KRamWrEn <= '1';
						VoterReset <= '0';
						VoterEn <= '0';
						EndClass <=	'0';
						NextStatexT <= UpdateMaxState;
						if(unsigned(KCountxD)<unsigned(KValxD)) then
							KCountxD <= std_logic_vector(unsigned(KCountxD)+1);	
						end if;
						if(unsigned(KCountxD)+1>=unsigned(KValxD)) then
							DropEn <='1';
						else
							DropEn <='0';
						end if;
						Go(to_integer(unsigned(MuxDistSelxD)))<='1';
					when UpdateMaxState =>
						DistReset <= (Others => '1');
						KRamReset <= '1';
						KRamWrEn <= '0';
						VoterReset <= '0';
						VoterEn <= '0';
						EndClass <=	'0';
						if(unsigned(CounterUpdMaxT) < 6 + INTEGER(ceil(log2(real(MAX_KSET_SIZE))))) then
							NextStatexT <= UpdateMaxState;
							CounterUpdMaxT <= std_logic_vector(unsigned(CounterUpdMaxT) + 1);
						else
							
							NextStatexT <= CheckEndCompState;
						end if;	
						Go <= (Others => '0');
					when VoterState =>	
						CounterUpdMaxT <= (Others => '0');
						DistReset <= (Others => '1');
						KRamReset <= '1';
						KRamWrEn <= '0';
						VoterReset <= '1';
						VoterEn <= '1';
						EndClass <=	'0';
						if(unsigned(ClKRamAddrxD)<unsigned(KValxD)) then 
							NextStatexT <= VoterState;
							ClKRamAddrxD <= std_logic_vector(unsigned(ClKRamAddrxD)+1);
						else
							NextStatexT <= MaxClassState;
							EndClass <=	'0';
							VoterEn <= '0';
						end if;
					when MaxClassState =>
						DistReset <= (Others => '1'); 
						KRamReset <= '1'; 
						KRamWrEn <= '0';
						VoterReset <= '1';
						VoterEn <= '0';
						EndClass <=	'0'; 
						ClKRamAddrxD <= (Others => '0');
						DropEn <='0';
						Go <= (Others => '0');
						KRamAddrxD <= (Others => '1');
						KCountxD <= (Others => '0');
						MuxDistSelxD <= (Others => '0');
						if(unsigned(CounterUpdMaxT) < 1 + INTEGER(ceil(log2(real(MAX_KSET_SIZE))))) then
							NextStatexT <= MaxClassState;
							CounterUpdMaxT <= std_logic_vector(unsigned(CounterUpdMaxT) + 1);
						else
							NextStatexT <= ClassState;
						end if;	
					when ClassState =>
						CounterUpdMaxT <= (Others => '0');
						DistReset <= (Others => '1'); 
						KRamReset <= '1'; 
						KRamWrEn <= '0';
						VoterReset <= '1';
						VoterEn <= '0';
						EndClass <=	'1'; 
						if(StartCl='0') then
							NextStatexT <= InitState;
							MuxKRamSel <= '0';
						else
							NextStatexT <= ClassState;
						end if;
						ClKRamAddrxD <= (Others => '0');
						DropEn <='0';
						Go <= (Others => '0');
						KRamAddrxD <= (Others => '1');
						KCountxD <= (Others => '0');
						MuxDistSelxD <= (Others => '0');
					when others =>
					end case;	
			end if; 
		end process; 		
			
		EndCompxD <= EndComp;
		MuxDistSel <= MuxDistSelxD;
		KRamAddr <= KRamAddrxD;
		ClKRamAddr <= ClKRamAddrxD(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
		
end Behavioral; 