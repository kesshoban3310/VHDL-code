Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--USE ieee.std_logic_arith.ALL;
use work.final_package.all;
ENTITY final_project IS
    PORT(
	 clk : in std_logic;
    IC:in std_logic_vector(0 to 7);
	 data: in std_logic_vector(7 downto 0);
    hazard,in_fetch,in_decode,exe,wb: buffer std_logic;
	 hex0,hex1,hex2,hex3,hex4,hex5: buffer std_logic_vector(0 to 6)
	 );
END final_project;

ARCHITECTURE  func OF final_project IS 
	TYPE regArray IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(7 DOWNTO 0); -- register
	TYPE pi_Array IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(0 to 31); -- instruction
	signal reg:regArray(0 to 3);
	signal opcode: std_logic_vector(0 to 7);
	signal rs_idx,rt_idx:integer range 0 to 15;
	signal pi_line: pi_array (0 to 3);
	signal rs,rt:std_logic_vector(0 to 1);
	signal rs_data,rt_data:std_logic_vector(7 downto 0);
	signal data_v:std_logic_vector(7 downto 0);
-- output unit
	signal data_ans:std_logic_vector(0 to 7);
	signal rs_ans,rt_ans:std_logic_vector(0 to 7);
	
	
-- forwarding unit	
	signal for_rs,for_rt: std_logic_vector(0 to 1);
	signal for_rs_da,for_rt_da: std_logic_vector(7 downto 0);	
	
--	signal forwarding_data:std_logic_vector(7 DOWNTO 0);
--	signal 
--	signal
	
BEGIN 

	process --program
		Begin
		WAIT UNTIL clk'EVENT and clk = '1';
		
		for_rs <= pi_line(3)(4 to 5);
		for_rt <= pi_line(3)(6 to 7);
		
		for_rs_da <= pi_line(3)(16 to 23);
		for_rt_da <= pi_line(3)(24 to 31);
		
		stage1: for i in 3 to 0 loop
			if i = 3 then --write back
				opcode <= pi_line(3)(0 to 7);
				if(opcode(0 to 3 ) /="1111") then
					data_v <= pi_line(3)(8 to 15);
					rs <= opcode(4) & opcode(5);
					rs_idx <= to_integer(unsigned( rs ));
					rs_data<= pi_line(3)(16 to 23);
					reg(rs_idx) <= rs_data;
					rs_ans <= rs_data;
					rt_ans <= pi_line(3)(24 to 31);
					data_ans <= data_v;
					wb <= '1';
				else
					wb <= '0';
				END if;
				
			END if;
			if i = 2 then --execution
				opcode <= pi_line(2)(0 to 7);
				data_v <= pi_line(2)(8 to 15);
				if(opcode(0 to 3 ) /="1111") then
					rs_data<= pi_line(2)(16 to 23);
					rt_data<= pi_line(2)(24 to 31);
					if(opcode(0 to 3 ) = "0000") then
						rs_data <=  data_v;
					END if;
					if(opcode(0 to 3 ) = "0001") then
						rs_data <=  rt_data;
					END if;
					if(opcode(0 to 3 ) = "0010") then
						rs_data <= rs_data+rt_data;
					END if;
					if(opcode(0 to 3 ) = "0011") then
						rs_data <= rs_data-rt_data;
					END if;
					if(opcode(0 to 3 ) = "0100") then
						rs_data <= rs_data and rt_data;
					END if;
					if(opcode(0 to 3 ) = "0101") then
						rs_data <= rs_data or rt_data;
					END if;
					if(opcode(0 to 3 ) = "0110") then
						rs_data <= rs_data nor rt_data;
					END if;
					if(opcode(0 to 3 ) = "0111") then
						if(rs_data < rt_data) then
							rs_data <= "00000001";
						else
							rs_data <= "00000000";
						END if;
					END if;
					exe <= '1';
				else
					exe <= '0';
				END if;
				
			END if;
			if i = 1 then --Instrcution Decode
				opcode <= pi_line(1)(0 to 7);
				if(opcode(0 to 3 ) /="1111") then
					data_v <= pi_line(1)(8 to 15);
					rs <= opcode(4) & opcode(5);
					rt <= opcode(6) & opcode(7);
					rs_idx <= to_integer(unsigned( rs ));
					rt_idx <= to_integer(unsigned( rt ));
					rs_data<= reg(rs_idx);
					rt_data<= reg(rt_idx);
					pi_line(1) <= opcode & data_v & rs_data & rt_data;
					in_decode <= '1';
				else
					in_decode <= '0';
				END if;
			END if; 
			if i = 0 then -- Instrcution Fetch
				pi_line(0) <= IC & data & "00000000" & "00000000";
				in_fetch <= '1';
			END if;
		END loop;
	end process;
	
	process  --pipeline move
		Begin
			WAIT UNTIL clk'EVENT and clk = '1';
			stage2: for i in 2 to 0 loop
				pi_line(i+1) <= pi_line(i);
			END loop;
			pi_line(0) <= "11111111111111111111111111111111";
	end process;	
	
	
	stage0: hex port map(data_ans(4 to 7),hex0);
	stage1: hex port map(data_ans(0 to 3),hex1);
	stage2: hex port map(rs_ans(4 to 7),hex2);
	stage3: hex port map(rs_ans(0 to 3),hex3);
	stage4: hex port map(rt_ans(4 to 7),hex4);
	stage5: hex port map(rt_ans(0 to 3),hex5);
END func;