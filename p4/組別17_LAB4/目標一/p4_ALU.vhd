Library ieee;
Use ieee.std_logic_1164.all;
ENTITY ALU IS
    port(A,B,less,carryin :in std_logic;
            opcode:in std_logic_vector(0 to 3);
            result,set,carryout :out std_logic);
END ALU;
 
ARCHITECTURE  func OF ALU IS 
 
BEGIN
   
END func;