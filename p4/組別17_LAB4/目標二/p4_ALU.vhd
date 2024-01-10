Library ieee;
Use ieee.std_logic_1164.all;
Use work.p4_pack.all;
ENTITY p4_ALU IS
    port(A,B,bar:in std_logic;
			ALUctrl:in std_logic_vector(0 to 3);
			carryout:out std_logic;
			overflow,Result: out std_logic);
END p4_ALU;
 
ARCHITECTURE  func OF p4_ALU IS 
	signal s: std_logic_vector(1 downto 0) ;
	signal Abar,Bbar: std_logic;
	signal AdderOut,cout: std_logic;
	signal andOut,OrOut: std_logic;
	signal AbOut,BbOut: std_logic;
BEGIN
   Abar<=not a;
	Bbar<=not b;
	stage0: Tto port map(A,Abar,ALUctrl(3),AbOut);
	stage1: Tto port map(B,Bbar,ALUctrl(2),BbOut);
	
	andOut<=AbOut and BbOut;
	orOut<=AbOut or BbOut;
	
	s(0)<=ALUctrl(0);
	s(1)<=ALUctrl(1);
	
	stage2: oneBitAdder port map(bar,AbOut,BbOut,AdderOut,cout);
	overflow<=cout;
	carryout<=cout;
	stage3: Fto port map(andOut,orOut,AdderOut,AdderOut,s,Result);
END func;