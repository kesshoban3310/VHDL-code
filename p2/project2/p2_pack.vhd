Library ieee;
Use ieee.std_logic_1164.all;
package p2_pack is 
	component project2
		port(c,x,y:in std_logic;
				s,cout:out std_logic);
	end component project2;
	component hex
		port(z,y,x,w,z1,y1,x1,w1 : IN STD_LOGIC;
            a,b,c,d,e,f,g,a1,b1,c1,d1,e1,f1,g1      : OUT STD_LOGIC);
	end component hex;
end package;