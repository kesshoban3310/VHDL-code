Library ieee;
Use ieee.std_logic_1164.all;
package p4_pack is 
	component Tto
		Port(w0,w1,s :IN std_logic;
		f		  :OUT std_logic);
	end component Tto;
	component Fto
		Port(w0,w1,w2,w3 :IN std_logic;
		s				:in std_logic_Vector(1 downto 0);
		f		  :OUT std_logic);
	end component Fto;
	component oneBitAdder
    port(c,x,y:in std_logic;
			s,cout:out std_logic);
	end component oneBitAdder;
	component hex
		port(z,y,x,w,z1,y1,x1,w1 : IN STD_LOGIC;
            a,b,c,d,e,f,g,a1,b1,c1,d1,e1,f1,g1      : OUT STD_LOGIC);
	end component hex;
end package;