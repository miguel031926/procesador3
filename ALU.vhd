library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port ( Aluop : in  STD_LOGIC_VECTOR (5 downto 0);
           In1 : in  STD_LOGIC_VECTOR (31 downto 0);
           In2 : in  STD_LOGIC_VECTOR (31 downto 0);
			  Carry : in STD_LOGIC; 
           Result : out  STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));
end ALU;

architecture arq_ALU of ALU is

begin
	process(In1,In2,Aluop)
		begin
			case Aluop is
				when "000000" => Result <= In1 + In2;
				when "000001" => Result <= In1 - In2;
				when "000010" => Result <= In1 and In2;
				when "000011" => Result <= In1 or In2;
				when "000100" => Result <= In1 xor In2;
				when "000101" => Result <= In1 xnor In2;
				when "000110" => Result <= In1 nand In2;
				when "000111" => Result <= In1 nor In2;
				when "001000" => Result <= In1 and In2; --Andcc
				when "001001" => Result <= In1 nand In2; --Nandcc
				when "001010" => Result <= In1 or In2; --Orcc
				when "001011" => Result <= In1 nor In2; --Norcc
				when "001100" => Result <= In1 xor In2; --Xorcc
				when "001101" => Result <= In1 xnor In2; -- Xnorcc
				when "001110" => Result <= In1 + In2; --Addc
				when "001111" => Result <= In1 + In2 + Carry; --Addx
				when "010000" => Result <= In1 + In2 + Carry; --Addxcc
				when "010001" => Result <= In1 - In2; --Subcc
				when "010010" => Result <= In1 - In2 - Carry; --Subx
				when "010011" => Result <= In1 - In2 - Carry; --Subxcc
				when others => Result <= "00000000000000000000000000000000";
			end case;
	end process;

end arq_ALU;