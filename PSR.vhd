library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PSR is
    Port ( NZVC : in  STD_LOGIC_VECTOR (3 downto 0);
           clk : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Carry : out  STD_LOGIC);
end PSR;

architecture arq_PSR of PSR is

begin
	
	process(Reset, clk, NZVC)
		begin
			if (Reset = '1') then 		
				Carry <= '0';
			elsif (rising_edge(clk)) then
				Carry <= NZVC(0);
				
		end if;
	end process;
				

end arq_PSR;
