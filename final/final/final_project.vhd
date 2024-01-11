Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
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

ARCHITECTURE func OF final_project IS 
	TYPE regArray is array(0 to 3) OF STD_LOGIC_VECTOR(7 DOWNTO 0); -- register
	TYPE pi_Array IS ARRAY(0 to 3) OF STD_LOGIC_VECTOR(0 to 31); -- instruction
	signal reg: regArray;
	signal pi_line: pi_Array;
	signal rs_data,rt_data:std_logic_vector(7 downto 0);
	
	
	
-- IF unit
	signal opcode: std_logic_vector(0 to 7);
	signal data_v: std_logic_vector(7 downto 0);

-- ID unit
	signal rs_idx_id,rt_idx_id:integer range 0 to 15;
	signal rs_data_id,rt_data_id:std_logic_vector(7 downto 0);
	signal rs_id,rt_id:std_logic_vector(0 to 1);
-- EXE unit
	signal rs_idx_exe,rt_idx_exe:integer range 0 to 15;
	signal rs_data_exe,rt_data_exe:std_logic_vector(7 downto 0);
	signal rs_exe,rt_exe:std_logic_vector(0 to 1);
	signal data_exe:std_logic_vector(7 downto 0);
-- WB unit	
	signal rs_idx_wb,rt_idx_wb:integer range 0 to 15;
	signal rs_data_wb,rt_data_wb:std_logic_vector(7 downto 0);
	signal rs_wb,rt_wb:std_logic_vector(0 to 1);
	signal data_wb:std_logic_vector(7 downto 0);


-- output unit (at EXE stage)
	signal data_ans:std_logic_vector(0 to 7);
	signal rs_ans,rt_ans:std_logic_vector(0 to 7);
	
	
-- forwarding unit (at EXE stage)
	signal for_rs,for_rt: std_logic_vector(0 to 1);
	signal for_rs_da,for_rt_da: std_logic_vector(7 downto 0);	
	

BEGIN 
	process (clk) -- WB stage
		Begin
		if rising_edge(clk) then
			pi_line(3) <= pi_line(2);
			if( pi_line(3)(0 to 3) /="1111") then
				rs_wb <= pi_line(3)(4 to 5);
				rs_idx_wb <= to_integer(unsigned( rs_wb ));
				rs_data_wb<= pi_line(3)(16 to 23);
				reg(rs_idx_wb) <= rs_data_wb;
				wb <= '1';
			else
				wb <= '0';
			END if;
		END if;
	end process;
	
	process (clk) -- EXE stage
		Begin
		if rising_edge(clk) then
			pi_line(2) <= pi_line(1);
			if(pi_line(2)(0 to 3 ) /="1111") then
				rs_data_exe<= pi_line(2)(16 to 23);
				rt_data_exe<= pi_line(2)(24 to 31);
				data_exe<= pi_line(2)(8 to 15);
				if(pi_line(2)(0 to 3 ) = "0000") then
					rs_data_exe <=  data_exe;
				END if;
				if(pi_line(2)(0 to 3 ) = "0001") then
					rs_data_exe <=  rt_data_exe;
				END if;
				if(pi_line(2)(0 to 3 ) = "0010") then
					rs_data_exe <= rs_data_exe+rt_data_exe;
				END if;
				if(pi_line(2)(0 to 3 ) = "0011") then
					rs_data_exe <= rs_data_exe-rt_data_exe;
				END if;
				if(pi_line(2)(0 to 3 ) = "0100") then
					rs_data_exe <= rs_data_exe and rt_data_exe;
				END if;
				if(pi_line(2)(0 to 3 ) = "0101") then
					rs_data_exe <= rs_data_exe or rt_data_exe;
				END if;
				if(pi_line(2)(0 to 3 ) = "0110") then
					rs_data_exe <= rs_data_exe nor rt_data_exe;
				END if;
				if(pi_line(2)(0 to 3 ) = "0111") then
					if(rs_data_exe < rt_data_exe) then
						rs_data_exe <= "00000001";
					else
						rs_data_exe <= "00000000";
					END if;
				END if;
				exe <= '1';
				pi_line(2) <= pi_line(2)(0 to 7) & pi_line(2)(8 to 15) & rs_data_exe & rt_data_exe;
				rs_ans <= rs_data_exe;
				rt_ans <= rt_data_exe;
				data_ans <= pi_line(2)(8 to 15);
			else
				exe <= '0';
			END if;
		END if;
	end process;
	
	process (clk) --Instrcution Decode
		Begin
		if rising_edge(clk) then
			pi_line(1) <= pi_line(0);
			if(pi_line(1)(0 to 3 ) /="1111") then
				rs_id <= pi_line(1)(4 to 5);
				rt_id <= pi_line(1)(6 to 7);
				rs_idx_id <= to_integer(unsigned( rs_id ));
				rt_idx_id <= to_integer(unsigned( rt_id ));
				rs_data_id<= reg(rs_idx_id);
				rt_data_id<= reg(rt_idx_id);
				pi_line(1) <= pi_line(1)(0 to 15) & rs_data_id & rt_data_id;
				in_decode <= '1';
			else
				in_decode <= '0';
			END if;
		END if;
	end process;
	
	process (clk) -- IF stage
		Begin
		if rising_edge(clk) then
			opcode <= IC;
			data_v <= data;
			pi_line(0) <= opcode & data_v & "00000000" & "00000000";
			in_fetch <= '1';
		END if;
	end process;
	
	
	stage0: hex port map(data_ans(4 to 7),hex0);
	stage1: hex port map(data_ans(0 to 3),hex1);
	stage2: hex port map(rs_ans(4 to 7),hex2);
	stage3: hex port map(rs_ans(0 to 3),hex3);
	stage4: hex port map(rt_ans(4 to 7),hex4);
	stage5: hex port map(rt_ans(0 to 3),hex5);
END func;