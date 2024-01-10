Library ieee;
Use ieee.std_logic_1164.all;
ENTITY project2 IS
    port(c,x,y:in std_logic;
			s,cout:out std_logic);
END project2;
 
ARCHITECTURE  func OF project2 IS 
BEGIN
    s<= x xor y xor c;
	 cout <= (x and y) or (c and y) or (c and x);
END func;