Library ieee;
Use ieee.std_logic_1164.all;
Entity Fto is
 Port(w0,w1,w2,w3 :IN std_logic;
		s				:in std_logic_Vector(1 downto 0);
		f		  :OUT std_logic);
End Fto;

ARCHITECTURE Yee of Fto is
begin
	with s select
		f<=w0 when "00",
			w1 when "01",
			w2 when "10",
			w3 when Others;
end Yee;