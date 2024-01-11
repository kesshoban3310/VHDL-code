Library ieee;
Use ieee.std_logic_1164.all;
Use work.p4_pack.all;
ENTITY p4 IS
    port(A,B:in std_logic_vector(0 to 6);
			ALUctrl:in std_logic_vector(0 to 3);
			overflow: out std_logic;
			hex1,hex2: out std_logic_vector(0 to 6));
END p4;
ARCHITECTURE  func OF p4 IS 
	signal carryin:std_logic_vector(0 to 7);
	signal dontcare:std_logic_vector(0 to 6);
	signal Result:std_logic_vector(0 to 6);
BEGIN
	ALUstage0:p4_ALU port map(A(0),B(0),ALUctrl(2)and ALUctrl(1),ALUctrl,carryin(1),dontcare(0),Result(0));
	G1 : for i in 1 to 5 generate
		ALUstage1: p4_ALU port map(A(i),B(i),carryin(i),ALUctrl,carryin(i+1),dontcare(i),Result(i));
	end generate;
	ALUstage2:p4_ALU port map(A(6),B(6),carryin(6),ALUctrl,carryin(7),dontcare(6),Result(6));
	overflow <= carryin(7) xor carryin(6) xor Result(6);
	hexstage:hex port map(Result(0),Result(1),Result(2),Result(3),Result(4),Result(5),Result(6),'0',hex1(0),hex1(1),hex1(2),hex1(3),hex1(4),hex1(5),hex1(6),hex2(0),hex2(1),hex2(2),hex2(3),hex2(4),hex2(5),hex2(6));
END func;
