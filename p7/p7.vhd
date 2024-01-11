LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.ALL;
USE work.p7_package.ALL;

ENTITY p7 IS
    PORT (
        clk,clear: IN std_logic;
		  divisor,dividend: IN std_logic_vector(7 downto 0);
		  Re:Buffer std_logic_vector(0 to 7);
		  Q:Buffer std_logic_vector(0 to 7);
		  hex0,hex1,hex2,hex3,hex4,hex5:OUT std_logic_vector(0 to 6);
		  the_end: OUT std_logic;
		  the_nege: OUT std_logic
    );
END p7;

ARCHITECTURE func OF p7 IS
		TYPE State_Type is (A,B,C,D,E,F);
		signal remain:std_logic_vector(15 downto 0) ;
		signal count:integer range 0 to 15;
		signal l,r:integer range 0 to 2048;
		signal div:std_logic_vector(15 downto 0) ;
		signal quo:std_logic_vector(0 to 7) ;
		signal s: State_Type:=A;
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
									the_nege <= '0';
								else
									remain <= remain - div;
									s <= C;
									the_nege <= '1';
								END if;
						  elsif s = C then
								stage0: for i in 0 to 6 loop
									quo(i+1) <= quo(i);
								END loop;
								quo(0) <= '1';
								s <= E;
								the_nege <= '0';
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
								the_end <= '1';
						  end if;
				  else
						remain<= "0000000000000000";
						quo <= "00000000";
						div <= "0000000000000000";
						count <= 0;
						s <= A;
						the_end <= '0';
						the_nege <= '0';
				  end if;
				end if;
		END PROCESS;
	  Q <= quo;
	  Re <= remain(0) & remain(1) & remain(2) & remain(3) & remain(4) & remain(5) & remain(6) & remain(7);
	  stage0: hex port map (Re(4) & Re(5) & Re(6) & Re(7),hex3);
	  stage1: hex port map (Re(0) & Re(1) & Re(2) & Re(3),hex2);
	  stage2: hex port map (Q(4) & Q(5) & Q(6) & Q(7),hex1);
	  stage3: hex port map (Q(0) & Q(1) & Q(2) & Q(3),hex0);
	  stage4: hex port map (div(4) & div(5) & div(6) & div(7),hex5);
	  stage5: hex port map (div(0) & div(1) & div(2) & div(3),hex4);
END func;