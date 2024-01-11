LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

PACKAGE final_package IS
    COMPONENT hex
        port(hex_in: IN STD_LOGIC_VECTOR(0 to 3);
			hex_out: OUT STD_LOGIC_VECTOR(0 to 6)
			);
    END COMPONENT hex;
	 component debounce
		PORT (clock : IN STD_LOGIC;
			  btn : IN STD_LOGIC;
			  btn_debounce : OUT STD_LOGIC);
	end component debounce;
	component p7
		PORT (clk,clear: IN std_logic;
		  divisor,dividend: IN std_logic_vector(7 downto 0);
		  Q:Buffer std_logic_vector(0 to 7) );
	end component p7;
END final_package;