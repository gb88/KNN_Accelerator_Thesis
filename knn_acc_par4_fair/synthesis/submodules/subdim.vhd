library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.std_logic_misc.all;
use work.common_types.all;
entity SubDim is 
	port(	
		Clk: in std_logic;
		OpA: in std_logic_vector(DIM_WIDTH-1 downto 0); 
		OpB : in std_logic_vector(DIM_WIDTH-1 downto 0);
		SubEn: in std_logic;
		Overflow: out std_logic;
		Result: out std_logic_vector(DIM_WIDTH-1 downto 0)
	);		
end SubDim;

architecture Behavioral of SubDim is 

	signal ResultxD:std_logic_vector(DIM_WIDTH-1 downto 0);
	signal OverflowxD: std_logic;
	signal OpADelxD: std_logic_vector(DIM_WIDTH-1 downto 0);
	signal OpBDelxD: std_logic_vector(DIM_WIDTH-1 downto 0);
	
	begin 
		process(Clk)
		begin
			if(rising_edge(Clk) and SubEn = '1') then
				OpADelxD <= OpA;
				OpBDelxD <= OpB;
				ResultxD <= std_logic_vector((signed(OpA) - signed(OpB)));	
			end if;
		end process;
		Result <= ResultxD; 
		-- there is overflow only when the signs are different and only if the result has the same sign as the subtrahend 
		Overflow <= (OpADelxD(DIM_WIDTH-1) xor OpBDelxD(DIM_WIDTH-1)) and ((OpBDelxD(DIM_WIDTH-1) xnor ResultxD(DIM_WIDTH-1)));
		
end Behavioral; 

