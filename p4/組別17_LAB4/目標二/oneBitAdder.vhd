Library ieee;
Use ieee.std_logic_1164.all;
ENTITY oneBitAdder IS
    port(c,x,y:in std_logic;
			s,cout:out std_logic);
END oneBitAdder;
 
ARCHITECTURE  func OF oneBitAdder IS 
BEGIN
    s<= x xor y xor c;
	 cout <= (x and y) or (c and y) or (c and x);
END func;