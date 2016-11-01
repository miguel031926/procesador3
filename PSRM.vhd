library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PSRM is
    Port ( crs1 : in  STD_LOGIC;
           crs2 : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Aluop : in  STD_LOGIC_VECTOR (5 downto 0);
           Aluresult : in  STD_LOGIC_VECTOR (31 downto 0);
           NZVC : out  STD_LOGIC_VECTOR (3 downto 0));
end PSRM;

architecture Behavioral of PSRM is

begin
	process (Reset, Aluop, ALuresult, crs1, crs2)
		begin
			if Reset = '1' then 
				NZVC <= "0000";
			
			else	
				--Logicas
				if Aluop = "001000" or Aluop = "001001" or Aluop = "001010" or ALuop = "001011" or Aluop = "001100" or ALuop = "001101" then 
					NZVC(3) <= Aluresult(31);
					if Aluresult = "00000000000000000000000000000000" then 
						NZVC(2) <= '1';
					else
						NZVC(2) <= '0';
					end if;
					NZVC(1) <= '0';
					NZVC(0) <= '0';
				end if;
				
			
				--Aritmeticas
				
				
				--Add
				if ALuop = "001110" or Aluop = "010000" then
					NZVC(3) <= Aluresult(31);
					if Aluresult = "00000000000000000000000000000000" then 
						NZVC(2) <= '1';
					else
						NZVC(2) <= '0';
					end if;
					NZVC(1) <= (crs1 and crs2 and (not ALuresult(31))) or ((not crs1) and (not crs2) and Aluresult(31));
					NZVC(0) <= (crs1 and crs2) or ((not ALuresult(31)) and (crs1 or crs2));
				end if;
						
						--Sub
				if ALuop = "010001" or Aluop = "010011" then
					NZVC(3) <= Aluresult(31);
					if Aluresult = "00000000000000000000000000000000" then 
						NZVC(2) <= '1';
					else
						NZVC(2) <= '0';
					end if;
					NZVC(1) <= (crs1 and (not crs2) and (not ALuresult(31))) or ((not crs1) and crs2 and Aluresult(31));
					NZVC(0) <= ((not crs1) and crs2) or (ALuresult(31) and ((not crs1) or crs2));
				end if;
				
			end if;
	end process;
						
			
end Behavioral;
