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

ARCHITECTURE  func OF final_project IS 
	TYPE regArray IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(7 DOWNTO 0); -- register
	TYPE In_Array IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(0 to 15); -- instruction
	TYPE pi_Array IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(0 to 31); -- instruction
	signal reg:regArray(0 to 3);
	signal op_array:In_array(0 to 255);
	signal opcode: std_logic_vector(0 to 7);
	signal rs_idx,rt_idx:integer range 0 to 15;
	signal pi_line: IN_array (0 to 3);
	
	signal rs,rt:std_logic_vector(0 to 1);
	signal rs_data,rt_data:std_logic_vector(7 downto 0);
	signal data_v:std_logic_vector(7 downto 0);
	
--	signal forwarding_data:std_logic_vector(7 DOWNTO 0);
--	signal 
--	signal
	
BEGIN 

--	idx<= to_integer(unsigned(data));
--	reg(0) <= std_logic_vector( to_unsigned(idx,8) );
	process (clk) --store code
		Begin
		for i in 0 to 255 loop
			if op_Array(i) = "00000000" then
				op_Array(i) <= IC & data;
				if(op_Array(i)(0 to 3) /= "0000") then
					op_Array(i)(8 to 15) <= "00000000";
				end if;
				exit;
			End IF;
		END loop;
	end process;
	
	
	
	process (clk)--program
		Begin
		for i in 4 to 0 loop
			if i = 3 then --write back
				
				
				opcode <= pi_line(3)(0 to 7);
				data_v <= pi_line(3)(8 to 15);
				rs <= opcode(4) & opcode(5);
				rs_idx <= to_integer(unsigned( rs ));
				rs_data<= pi_line(3)(16 to 23);
				reg(rs_idx) <= rs_data;
				
				
			END if;
			if i = 2 then --execution
				
				
				
				
			END if;
			if i = 1 then --Instrcution Decode
				opcode <= pi_line(1)(0 to 7);
				data_v <= pi_line(1)(8 to 15);
				rs <= opcode(4) & opcode(5);
				rt <= opcode(6) & opcode(7);
				rs_idx <= to_integer(unsigned( rs ));
				rt_idx <= to_integer(unsigned( rt ));
				rs_data<= reg(rs_idx);
				rt_data<= reg(rt_idx);
				pi_line(1) <= opcode + data_v + rs_data + rt_data;
			END if; 
			if i = 0 then -- Instrcution Fetch
				
			END if;
		END loop;
	end process;
	
	process (clk)--pipeline move
		Begin
		
	end process;		
END func;