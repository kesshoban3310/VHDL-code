LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY debounce IS
    PORT (
        clock : IN STD_LOGIC;
        btn : IN STD_LOGIC;
        btn_debounce : OUT STD_LOGIC
    );
END debounce;

ARCHITECTURE func OF debounce IS
    CONSTANT counter_ceil : INTEGER := 1000000;
    SIGNAL counter : INTEGER RANGE 0 TO counter_ceil := 0;
    SIGNAL btn_temp : STD_LOGIC:='0';
    SIGNAL btn_current : STD_LOGIC:='0';
BEGIN
    btn_debounce <= not btn_current;
    PROCESS
    BEGIN
        WAIT UNTIL clock'EVENT AND clock = '1';
        IF counter = 0 AND btn_current /= btn THEN
            btn_temp <= btn;
            counter <= 1;
        ELSE
            counter <= counter + 1;
            IF counter = counter_ceil THEN
                counter <= 0;
                btn_current <= btn_temp;
            END IF;
        END IF;
    END PROCESS;
END func;