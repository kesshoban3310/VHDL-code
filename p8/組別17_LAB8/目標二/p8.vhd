Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.ALL;
Use ieee.std_logic_unsigned.all;
use work.p8_package.all;
ENTITY p8 IS
    PORT(
	 clk : in std_logic;
    IC:in std_logic_vector(0 to 7);
	 data: in std_logic_vector(7 downto 0);
    output:out STD_LOGIC_VECTOR(0 to 2);
	 hex0,hex1,hex2,hex3,hex4,hex5: buffer std_logic_vector(0 to 6)
	 );
END p8;

ARCHITECTURE  func OF p8 IS 
	signal r0,r1,r2,r3:std_logic_vector(7 downto 0);
	signal rs_data,rt_data,rs_bus,rs_result:std_logic_vector(7 downto 0);
	signal rs,rt:std_logic_vector(1 downto 0);
	signal opcode:std_logic_vector(3 downto 0);
	signal led0,led1,led2,led3:std_logic_vector(0 to 3);
	signal remain:std_logic_vector(15 downto 0) ;
	signal div:std_logic_vector(15 downto 0) ;
	signal quo:std_logic_vector(0 to 7) ;
	TYPE State_Type is (A,B,C);
	signal s: State_Type;
	TYPE div_Type is (D,E,F,G,H,I);
	signal div_s: div_Type;
	signal count:integer range 0 to 15;
BEGIN 
	opcode <= IC(0) &	IC(1) & IC(2) & IC(3);
	rs <= IC(4)&IC(5);
	rt <= IC(6)&IC(7);

	stage1: hex port map(data(4) & data(5) & data(6) & data(7),hex1);
	stage2: hex port map(data(0) & data(1) & data(2) & data(3),hex0);
	
	
	Process
		BEGIN
			WAIT UNTIL clk'EVENT and clk = '1';
				if s=A then
					if rs = "00" then
						rs_data<=r0;
					END if;
					if rs = "01" then
						rs_data<=r1;
					END if;
					if rs = "10" then
						rs_data<=r2;
					END if;
					if rs = "11" then
						rs_data<=r3;
					END if;
					
					if rt = "00" then
						rt_data<=r0;
					END if;
					if rt = "01" then
						rt_data<=r1;
					END if;
					if rt = "10" then
						rt_data<=r2;
					END if;
					if rt = "11" then
						rt_data<=r3;
					END if;
					if(opcode = "1000") then
						div_s<=D;
					END if;
					s <= B;
				END if;
				if s=B then
					if(opcode = "0000") then
						rs_data <= data;
						s <= C;
					END if;
					if(opcode = "0001") then
						rs_data <= rt_data;
						s <= C;
					END if;
					if(opcode = "0010") then
						rs_data <= rs_data + rt_data;
						s <= C;
					END if;
					if(opcode = "0011") then
						rs_data <= rs_data and rt_data;
						s <= C;
					END if;
					if(opcode = "0101") then
						rs_data <= rs_data - rt_data;
						s <= C;
					END if;
					if(opcode = "1001") then
						rs_data <= rt_data - rs_data;
						s <= C;
					END if;
					if(opcode = "1000") then
						if div_s = D then
							remain<= "00000000" & rs_data;
							div<= rt_data & "00000000";
							count <= 0;
							div_s <= E;
						END if;
						if div_s = E then
							if remain < div then
								div_s <= G;
							else
								remain <= remain - div;
								div_s <= F;
							END if;
						END if;
						if div_s = F then
							stage0: for i in 0 to 6 loop
								quo(i+1) <= quo(i);
							END loop;
							quo(0) <= '1';
							div_s <= H;
						END if;
						if div_s = G then
							stage1: for i in 0 to 6 loop
								quo(i+1) <= quo(i);
							END loop;
							quo(0) <= '0';
							div_s <= H;
						END if;
						if div_s = H then
							stage2: for i in 1 to 15 loop
								div(i-1) <= div(i);
							END loop;
							div(15) <= '0';
							count <= count + 1;
							if count < 8 then
								div_s <= E;
							else 
								div_s <= I;
							END if;
						END if;
						if div_s = I then
							rs_data <= quo(7) & quo(6) & quo(5) & quo(4) & quo(3) & quo(2) & quo(1) & quo(0);
							s <= C;
						END if;
					END if;
					if(opcode = "0100") then
						if(rs_data<rt_data) then
							rs_data	<= "00000001";
						ELse
							rs_data  <= "00000000";
						END if;
						s <= C;
					END if;
				END if;
				if s=C then
					if rs = "00" then
						r0 <= rs_data;
					END if;
					if rs = "01" then
						r1 <= rs_data;
					END if;
					if rs = "10" then
						r2 <= rs_data;
					END if;
					if rs = "11" then
						r3 <= rs_data;
					END if;
					s <= A;
					div_s <= D;
				END if;
	END PROCESS;
	
	
	WITH rs SELECT
			led3 <= r0(7 downto 4) WHEN "00",
					  r1(7 downto 4) WHEN "01",
					  r2(7 downto 4) WHEN "10",
					  r3(7 downto 4) WHEN OTHERS;
	WITH rs SELECT
			led2 <= r0(3 downto 0) WHEN "00",
			        r1(3 downto 0) WHEN "01",
			        r2(3 downto 0) WHEN "10",
					  r3(3 downto 0) WHEN OTHERS;
	WITH rt SELECT
			led1 <= r0(7 downto 4) WHEN "00",
			        r1(7 downto 4) WHEN "01",
			        r2(7 downto 4) WHEN "10",
					  r3(7 downto 4) WHEN OTHERS;
	WITH rt SELECT
			led0 <= r0(3 downto 0) WHEN "00",
			        r1(3 downto 0) WHEN "01",
			        r2(3 downto 0) WHEN "10",
					  r3(3 downto 0) WHEN OTHERS;
					  
	stage3: hex port map(led3(3) & led3(2) & led3(1) & led3(0),hex5);
	stage4: hex port map(led2(3) & led2(2) & led2(1) & led2(0),hex4);
	stage5: hex port map(led1(3) & led1(2) & led1(1) & led1(0),hex3);
	stage6: hex port map(led0(3) & led0(2) & led0(1) & led0(0),hex2);	
			
END func;