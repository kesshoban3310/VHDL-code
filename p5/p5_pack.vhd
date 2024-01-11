Library ieee;
Use ieee.std_logic_1164.all;
package p5_pack is 
	component Dff
		Port(D,resetn,clk:IN std_logic;
			Q:out std_logic);
	end component Dff;
	component Dinput
		Port(shift,load,pin,sin :IN std_logic;
		     D:OUT std_logic);
	end component Dinput;
end package;