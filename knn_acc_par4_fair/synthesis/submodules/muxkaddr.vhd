library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;
use work.common_types.all;

entity MuxKAddr is
	port 
	(  
        AddrA: in std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
        AddrB: in std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0);
        Sel: in std_logic;
        AddrOut: out std_logic_vector(INTEGER(ceil(log2(real(MAX_KSET_SIZE))))-1 downto 0)
    );
end entity MuxKAddr;

architecture Behavioral of MuxKAddr is

	begin
		AddrOut <= AddrA when Sel ='1' else AddrB;
		
end architecture Behavioral;