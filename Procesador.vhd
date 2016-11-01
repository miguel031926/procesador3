library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Procesador is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           salida : out  STD_LOGIC_VECTOR (31 downto 0));
end Procesador;

architecture Behavioral of Procesador is

	COMPONENT nPC
	PORT(
		nPC_in : IN std_logic_vector(31 downto 0);
		reset : IN std_logic;
		clk : IN std_logic;          
		nPC_out : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	COMPONENT PC
	PORT(
		PC_in : IN std_logic_vector(31 downto 0);
		reset : IN std_logic;
		clk : IN std_logic;          
		PC_out : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	COMPONENT suma
	PORT(
		op1 : IN std_logic_vector(31 downto 0);
		op2 : IN std_logic_vector(31 downto 0);          
		suma_out : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	COMPONENT IM
	PORT(
		IM_in : IN std_logic_vector(31 downto 0);
		reset : IN std_logic;        
		IM_out : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT CU
	PORT(
		Op : IN std_logic_vector(1 downto 0);
		Op3 : IN std_logic_vector(5 downto 0);
		Aluop : OUT std_logic_vector(5 downto 0)
		);
	END COMPONENT;
	
	COMPONENT RF
	PORT(
		reset : IN std_logic;
		rs1 : IN std_logic_vector(4 downto 0);
		rs2 : IN std_logic_vector(4 downto 0);
		rd : IN std_logic_vector(4 downto 0);
		datawrite : IN std_logic_vector(31 downto 0);          
		CRs1 : OUT std_logic_vector(31 downto 0);
		CRs2 : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	COMPONENT ALU
	PORT(
		carry : IN std_logic;
		in1 : IN std_logic_vector(31 downto 0);
		in2 : IN std_logic_vector(31 downto 0);
		ALUOp : IN std_logic_vector(5 downto 0);
		Result : out  STD_LOGIC_VECTOR (31 downto 0)
		); 
	END COMPONENT;
	
	COMPONENT SEU
	PORT(
		imm : IN std_logic_vector(12 downto 0);          
		SEU_out : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	COMPONENT MUX
	PORT(
		entrada1 : IN std_logic_vector(31 downto 0);
		entrada2 : IN std_logic_vector(31 downto 0);
		i : IN std_logic;          
		MUX_out : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT PSR
	PORT(
		reset : IN std_logic;
		clk : IN std_logic;
		nzvc : IN std_logic_vector(3 downto 0);          
		Carry : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT PSRM
	PORT(
		reset : IN std_logic;
		crs1  : IN std_logic;
		crs2 : IN std_logic;
		Aluresult : IN std_logic_vector(31 downto 0);
		Aluop : IN std_logic_vector(5 downto 0);          
		nzvc : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	signal suma_out, nPC_out, PC_out, IM_out, CRs1, CRs2, ALUResult, SEU_out, MUX_out : std_logic_vector(31 downto 0);
	signal CU_out : std_logic_vector(5 downto 0);
	signal nzvc : std_logic_vector(3 downto 0);
	signal psr_out : std_logic;
	
begin

	Inst_nPC: nPC PORT MAP(
		nPC_in => suma_out,
		reset => reset,
		clk => clk,
		nPC_out => nPC_out
	);
	
	Inst_PC: PC PORT MAP(
		PC_in => nPC_out,
		reset => reset,
		clk => clk,
		PC_out => PC_out 
	);
	
	Inst_suma: suma PORT MAP(
		op1 => x"00000001",
		op2 => nPC_out,
		suma_out => suma_out
	);
	
	Inst_IM: IM PORT MAP(
		IM_in => PC_out,
		reset => reset,
		IM_out => IM_out
	);
	
	Inst_CU: CU PORT MAP(
		Op => IM_out(31 downto 30),
		Op3 => IM_out(24 downto 19),
		Aluop => CU_out
	);
	
	Inst_RF: RF PORT MAP(
		reset => reset,
		rs1 => IM_out(18 downto 14),
		rs2 => IM_out(4 downto 0),
		rd => IM_out(29 downto 25),
		datawrite => ALUResult,
		CRs1 => CRs1,
		CRs2 => CRs2
	);
	
	Inst_SEU: SEU PORT MAP(
		imm => IM_out(12 downto 0),
		SEU_out => SEU_out
	);
	
	Inst_MUX: MUX PORT MAP(
		entrada1 => CRs2,
		entrada2 => SEU_out,
		MUX_out => MUX_out,
		i => IM_out(13) 
	);	
	
	Inst_ALU: ALU PORT MAP(
		carry => psr_out,
		in1 => CRs1,
		in2 => MUX_out,
		ALUOp => CU_out,
		Result => ALUResult
	);
	
	Inst_PSRM: PSRM PORT MAP(
		crs1  => CRs1(31),
		crs2 => MUX_out(31),
		Aluresult => ALUResult,
		Aluop => CU_out,
		reset => reset,
		nzvc => nzvc
	);

	Inst_PSR: PSR PORT MAP(
		reset => reset,
		clk => clk,
		nzvc => nzvc,
		Carry=> psr_out
	);
	
	salida <= ALUResult;

end Behavioral;