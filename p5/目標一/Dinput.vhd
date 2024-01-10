Library ieee;
Use ieee.std_logic_1164.all;
Use work.p5_pack.all;
ENTITY Dinput IS
    Port(shift,load,pin,sin :IN std_logic;
		     D:OUT std_logic);
END Dinput;
 
ARCHITECTURE  func OF Dinput IS 
	signal a,b:std_logic;
BEGIN
   a <= sin and shift;
	b <= pin and load;
	D <= a or b;
END func;