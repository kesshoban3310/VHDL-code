Library ieee;
Use ieee.std_logic_1164.all;
Entity TtO is
 Port(w0,w1,s :IN std_logic;
		f		  :OUT std_logic);
End Tto;

ARCHITECTURE Func of Tto is
begin
	f<=w0 when s<='0' ELSE w1;
end Func;