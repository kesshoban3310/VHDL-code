Library ieee;
Use ieee.std_logic_1164.all;
ENTITY hex IS
	port(hex_in: IN STD_LOGIC_VECTOR(0 to 3);
			hex_out: OUT STD_LOGIC_VECTOR(0 to 6)
			);
end hex;
 
ARCHITECTURE  func OF hex IS 
BEGIN
	 hex_out(0)<= (not hex_in(3) and not hex_in(2) and not hex_in(1) and hex_in(0)) or (hex_in(3) and not hex_in(2) and hex_in(1) and hex_in(0)) or (hex_in(2) and not hex_in(1) and not hex_in(0)) or (hex_in(3) and hex_in(2) and not hex_in(1));
    hex_out(1)<= (hex_in(3) and hex_in(2) and not hex_in(1) and not hex_in(0)) or (not hex_in(3) and hex_in(2) and not hex_in(1) and hex_in(0)) or (hex_in(3) and hex_in(1) and hex_in(0)) or (hex_in(3) and hex_in(2) and hex_in(1)) or (hex_in(2) and hex_in(1) and not hex_in(0));
    hex_out(2)<= (not hex_in(3) and not hex_in(2) and hex_in(1) and not hex_in(0)) or (hex_in(3) and hex_in(2) and not hex_in(0)) or (hex_in(3) and hex_in(2) and hex_in(1));
    hex_out(3)<= (not hex_in(2) and not hex_in(1) and hex_in(0)) or (not hex_in(3) and hex_in(2) and not hex_in(1) and not hex_in(0)) or (hex_in(2) and hex_in(1) and hex_in(0)) or (hex_in(3) and not hex_in(2) and hex_in(1) and not hex_in(0));
    hex_out(4)<= (not hex_in(3) and hex_in(0)) or (not hex_in(3) and hex_in(2) and not hex_in(1)) or (not hex_in(2) and not hex_in(1) and hex_in(0));
    hex_out(5)<= (not hex_in(3) and not hex_in(2) and hex_in(0)) or (not hex_in(3) and not hex_in(2) and hex_in(1)) or (not hex_in(3) and hex_in(1) and hex_in(0)) or (hex_in(3) and hex_in(2) and not hex_in(1));
    hex_out(6)<= (not hex_in(3) and not hex_in(2) and not hex_in(1)) or (not hex_in(3) and hex_in(2) and hex_in(1) and hex_in(0));
END func;