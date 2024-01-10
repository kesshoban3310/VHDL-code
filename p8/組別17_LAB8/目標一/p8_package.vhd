LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

PACKAGE p8_package IS
    COMPONENT hex
        port(hex_in: IN STD_LOGIC_VECTOR(0 to 3);
			hex_out: OUT STD_LOGIC_VECTOR(0 to 6)
			);
    END COMPONENT hex;
END p8_package;