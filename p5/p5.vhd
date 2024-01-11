Library ieee;
Use ieee.std_logic_1164.all;
ENTITY p5 IS
GENERIC (n: integer :=8); 
    PORT(clk : in std_logic;
			clear: in std_logic;
			load: in std_logic;
			lr_sel: in std_logic;
			di: in std_logic_vector(0 to n-1);
			sdi: in std_logic;
			output:BUFFER STD_LOGIC_VECTOR(0 to n-1));
END p5;
 
ARCHITECTURE  func OF p5 IS 
BEGIN 
	Process
	BEGIN
		WAIT UNTIL clk'EVENT and clk = '1';
		IF clear = '1' then
			clearbits:FOR i in 0 to n-1 loop
				output(i) <= '0';
			END LOOP;
		ELSIF lr_sel = '1' then
			shift:FOR i in 1 to N-1 loop
				output(i) <= output(i-1);
			END LOOP;
			output(0) <= '0';
		ELSIF load='1' then
			output<=di;
		ELSE
			Genbits:FOR i in 1 to N-2 loop
				output(i) <= output(i+1);
			END LOOP;
			output(n-1) <=sdi;
		END IF;
	END PROCESS;
END func;