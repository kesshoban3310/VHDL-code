Library ieee;
Use ieee.std_logic_1164.all;
Use work.p2_pack.all;
ENTITY p2 IS
    port(x,y:in std_logic_vector(0 to 7);
			h: out std_logic_vector(0 to 6);
			h2: out std_logic_vector(0 to 6);
			overflow: out std_logic);
END p2;
ARCHITECTURE  func OF p2 IS 
	signal s: std_logic_vector(0 to 7) ;
	signal c: std_logic_vector(0 to 7) ;
	signal cout:std_logic;
BEGIN
	stage0: project2 port map(c(0),x(0),y(0),s(0),c(1));
	stage1: project2 port map(c(1),x(1),y(1),s(1),c(2));
	stage2: project2 port map(c(2),x(2),y(2),s(2),c(3));
	stage3: project2 port map(c(3),x(3),y(3),s(3),c(4));
	stage4: project2 port map(c(4),x(4),y(4),s(4),c(5));
	stage5: project2 port map(c(5),x(5),y(5),s(5),c(6));
	stage6: project2 port map(c(6),x(6),y(6),s(6),c(7));
	stage7: project2 port map(c(7),x(7),y(7),s(7),cout);
	overflow <= cout AND cout;
	stage8: hex port map(s(0),s(1),s(2),s(3),s(4),s(5),s(6),s(7),h(0),h(1),h(2),h(3),h(4),h(5),h(6),h2(0),h2(1),h2(2),h2(3),h2(4),h2(5),h2(6));
END func;
