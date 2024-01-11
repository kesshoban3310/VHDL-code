Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.final_package.all;
ENTITY final_project IS
    PORT(
	 clk,btn : in std_logic;
    IC:in std_logic_vector(7 downto 0);
	 test:in std_logic_vector(0 to 1);
	 data: in std_logic_vector(7 downto 0);
    hazard,in_fetch,in_decode,exe,wb: buffer std_logic;
	 hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7: buffer std_logic_vector(0 to 6)
	 );
END final_project;

ARCHITECTURE func OF final_project IS 
	TYPE regArray is array(0 to 3) OF STD_LOGIC_VECTOR(7 DOWNTO 0); -- register
	TYPE pi_Array IS ARRAY(0 to 3) OF STD_LOGIC_VECTOR(31 DOWNTO 0); -- instruction
	signal reg: regArray:= (others => "00000000");
	signal pi_line: pi_Array := (others => "11110000000000000000000000000000");
	signal rs_data,rt_data:std_logic_vector(7 downto 0);
	signal test_id:integer range 0 to 15;
	signal test_dt: std_logic_vector(7 downto 0):="00000000";
	signal btn_clk:std_logic := '0';
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
	signal data_ans:std_logic_vector(7 downto 0) :="00000000";
	signal rs_ans,rt_ans:std_logic_vector(7 downto 0):="00000000";
	
	
-- forwarding unit (at EXE stage)
	signal for_rs,for_rt: std_logic_vector(0 to 1);
	signal for_rs_da,for_rt_da: std_logic_vector(7 downto 0);	
	

BEGIN 
	stage_de: debounce port map(btn,clk,btn_clk);
	
	process (btn_clk) -- IF stage
		Begin
		if rising_edge(btn_clk) then
			pi_line(0) <= IC & data & "00000000" & "00000000";
			
			if(IC(7 downto 4) /= "1111") then
				in_fetch <= '1';
			else
				in_fetch <= '0';
			END if;
			
		END if;
	end process;
	
	process (btn_clk) --Instrcution Decode
		Begin
		
		if rising_edge(btn_clk) then
		
			pi_line(1) <= pi_line(0);
			
			
			
			if(pi_line(0)(31 downto 28) /= "1111") then
				
--				reg(to_integer(unsigned( pi_line(1)(27 downto 26) )))
--				reg(to_integer(unsigned( pi_line(1)(25 downto 24) )))
				pi_line(1) <= pi_line(0)(31 downto 16) & "00000000" & "00000000";
				
				if(pi_line(0)(31 downto 28) /= "1111" and pi_line(1)(31 downto 28) /= "1111") then
					if(pi_line(1)(27 downto 26) = pi_line(0)(27 downto 26) ) then
					
						hazard<='1';
					elsif(pi_line(1)(27 downto 26) = pi_line(0)(25 downto 24)) then
		
						hazard<='1';
					else
						hazard<='0';
					END if;
				else
					hazard<='0';
				END if;
				
				in_decode <= '1';
			else
				in_decode <= '0';
			END if;
		END if;
	end process;
	
	process (btn_clk,btn) -- EXE stage
		Begin
		if rising_edge(btn_clk) then
			rt_data_exe<= pi_line(1)(7 downto 0);
			data_exe<= pi_line(1)(23 downto 16);
			pi_line(2)(31 downto 16) <= pi_line(1)(31 downto 16);
			if(pi_line(1)(31 downto 28) /= "1111") then
				exe <= '1';
			else
				exe <= '0';
			end if;
		END if;	
			-- forwarding
			
			
		if rising_edge(btn) then	
			if(pi_line(1)(31 downto 28) /= "1111") then
				
				if(pi_line(1)(31 downto 28) = "0000") then
				
					rs_data_exe <=  pi_line(1)(23 downto 16);
					
				elsif(pi_line(1)(31 downto 28) = "0001") then
				
					rs_data_exe <=  reg(to_integer(unsigned( pi_line(1)(25 downto 24) )));
					
				elsif(pi_line(1)(31 downto 28) = "0010") then
				
					rs_data_exe <= reg(to_integer(unsigned( pi_line(1)(27 downto 26) ))) + reg(to_integer(unsigned( pi_line(1)(25 downto 24) )));
					
				elsif(pi_line(1)(31 downto 28) = "0011") then
				
					rs_data_exe <= reg(to_integer(unsigned( pi_line(1)(27 downto 26) ))) - reg(to_integer(unsigned( pi_line(1)(25 downto 24) )));
					
				elsif(pi_line(1)(31 downto 28) = "0100") then
				
					rs_data_exe <= reg(to_integer(unsigned( pi_line(1)(27 downto 26) ))) and reg(to_integer(unsigned( pi_line(1)(25 downto 24) )));
					
				elsif(pi_line(1)(31 downto 28) = "0101") then
				
					rs_data_exe <= reg(to_integer(unsigned( pi_line(1)(27 downto 26) ))) or reg(to_integer(unsigned( pi_line(1)(25 downto 24) )));
					
				elsif(pi_line(1)(31 downto 28) = "0110") then
				
					rs_data_exe <= reg(to_integer(unsigned( pi_line(1)(27 downto 26) ))) nor reg(to_integer(unsigned( pi_line(1)(25 downto 24) )));
					
				elsif(pi_line(1)(31 downto 28) = "0111") then
					if(reg(to_integer(unsigned( pi_line(1)(27 downto 26) ))) < reg(to_integer(unsigned( pi_line(1)(25 downto 24) )))) then
						rs_data_exe <= "00000001";
					else
						rs_data_exe <= "00000000";
					END if;
				END if;
			END if;
		END if;
	end process;
--	
--	
	process (btn_clk) -- WB stage
		Begin
		if rising_edge(btn_clk) then
			pi_line(3) <= pi_line(2);
			
			if( pi_line(2)(31 downto 28) /="1111") then
--				rs_wb <= pi_line(2)(27 downto 26);
--				rs_idx_wb <= to_integer(unsigned( pi_line(2)(27 downto 26) ));
--				rs_data_wb<= rs_data_exe;
				reg(to_integer(unsigned( pi_line(2)(27 downto 26) ))) <= rs_data_exe;
				wb <= '1';
			else
				wb <= '0';
			END if;
		END if;
	end process;
	
	
	test_id <= to_integer(unsigned( test ));
	test_dt <= reg(test_id);
	
-- 31~24 opcode
--	23~16 data
--	15~8 rs_data
--	7~0 rt_data
	
--	stage0: hex port map(data(0) & data(1) & data(2) & data(3),hex0);
--	stage1: hex port map(data(4) & data(5) & data(6) & data(7),hex1);
	stage2: hex port map(pi_line(2)(8) & pi_line(2)(9) & pi_line(2)(10) & pi_line(2)(11),hex2);
	stage3: hex port map(pi_line(2)(12) & pi_line(2)(13) & pi_line(2)(14) & pi_line(2)(15),hex3);
	
	stage4: hex port map(pi_line(2)(0) & pi_line(2)(1) & pi_line(2)(2) & pi_line(2)(3),hex4);
	stage5: hex port map(pi_line(2)(4) & pi_line(2)(5) & pi_line(2)(6) & pi_line(2)(7),hex5);
	
	stage8: hex port map(reg(to_integer(unsigned( pi_line(2)(25 downto 24) )))(0) & reg(to_integer(unsigned( pi_line(2)(25 downto 24) )))(1) & reg(to_integer(unsigned( pi_line(2)(25 downto 24) )))(2) & reg(to_integer(unsigned( pi_line(2)(25 downto 24) )))(3), hex0);
	stage9: hex port map(reg(to_integer(unsigned( pi_line(2)(25 downto 24) )))(4) & reg(to_integer(unsigned( pi_line(2)(25 downto 24) )))(5) & reg(to_integer(unsigned( pi_line(2)(25 downto 24) )))(6) & reg(to_integer(unsigned( pi_line(2)(25 downto 24) )))(7), hex1);
	
	
	stage6: hex port map(test_dt(0) & test_dt(1) & test_dt(2) & test_dt(3), hex6);
	stage7: hex port map(test_dt(4) & test_dt(5) & test_dt(6) & test_dt(7), hex7);
	 
END func;