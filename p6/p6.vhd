Library ieee;
Use ieee.std_logic_1164.all;
ENTITY p6 IS
	PORT(clk : in std_logic;
	w: in std_logic;
	r: in std_logic;
	output:out STD_LOGIC_VECTOR(0 to 2));
END p6;

ARCHITECTURE  func OF p6 IS 
	TYPE State_Type is (A,B,C,D,E,F);
   signal s: State_Type;
BEGIN 
		 Process
		 BEGIN
			  WAIT UNTIL clk'EVENT and clk = '1';
			  if r = '0' then
					if s = A then
						 if w = '1' then 
							  s <= B;
						 else
							  s <= A;
						 end if;
					end if;
					if s = B then
						 if w = '1' then 
							  s <= D;
						 else
							  s <= C;
						 end if;
					end if;
					if s = D or s = C then
						 s <= E;
					end if;
					if s = E then
						 if w = '1' then 
							  s <= F;
						 else
							  s <= B;
						 end if;
					end if;
			  else
					s <= A;
			  end if;
		 END PROCESS;
		 PROCESS (s)
		 BEGIN
			if s = A then
				output<= "000";
			END if;
			if s = B then
				output<= "001";
			END if;
			if s = C then
				output<="010";
			END if;
			if s = D then
				output<="011";
			END if;
			if s = E then
				output<="100";
			END if;
			if s = F then
				output<="101";
			END if;
		END PROCESS;
END func;