LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.ALL;

ENTITY p7 IS
    PORT (
        clk,clear: IN std_logic;
		  divisor,dividend: IN std_logic_vector(7 downto 0);
		  Q:out std_logic_vector(7 downto 0) 
    );
END p7;

ARCHITECTURE func OF p7 IS
		TYPE State_Type is (A,B,C,D,E,F);
		signal remain:std_logic_vector(15 downto 0) ;
		signal count:integer range 0 to 15;
		signal l,r:integer range 0 to 2048;
		signal div:std_logic_vector(15 downto 0) ;
		signal quo:std_logic_vector(7 downto 0);
		signal s: State_Type:=A;
		signal Re:std_logic_vector(0 to 7);
BEGIN
	Process(clk)
		BEGIN
			  if rising_edge(clk) then
				  if clear = '0' then
						  if s = A then
								remain<= "00000000" & dividend ;
								 div<= divisor & "00000000";
								 count <= 0;
								s <= B;
						  elsif s = B then
								if remain < div then
									s <= D;
								else
									remain <= remain - div;
									s <= C;
									
								END if;
						  elsif s = C then
								stage0: for i in 0 to 6 loop
									quo(i+1) <= quo(i);
								END loop;
								quo(0) <= '1';
								s <= E;
						  elsif s = D  then
								 stage1: for i in 0 to 6 loop
									quo(i+1) <= quo(i);
								END loop;
								quo(0) <= '0';
								s <= E;
						  elsif s = E then
								stage2: for i in 1 to 15 loop
									div(i-1) <= div(i);
								END loop;
								div(15) <= '0';
								count <= count + 1;
								if count < 8 then
									s <= B;
								else 
									s <= F;
								END if;
						  elsif s = F then
								s <= A;
								Q <= quo;
						  end if;
				  else
						remain<= "0000000000000000";
						quo <= "00000000";
						div <= "0000000000000000";
						count <= 0;
						s <= A;
						
				  end if;
				end if;
		END PROCESS;
	  Re <= remain(0) & remain(1) & remain(2) & remain(3) & remain(4) & remain(5) & remain(6) & remain(7);
END func;