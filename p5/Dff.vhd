Library ieee;
Use ieee.std_logic_1164.all;
ENTITY Dff is
	Port(D,resetn,clk:IN std_logic;
			Q:out std_logic);
end Dff;
ARCHITECTURE  func OF Dff IS 
BEGIN
   PROCESS(resetn,clk)
	BEGIN
		if resetn = '0' THEN
			Q<='0';
		ELSIF clk'EVENT AND Clk = '1' THEN
			Q<=D;
		END IF;
	END PROCESS;
END func;