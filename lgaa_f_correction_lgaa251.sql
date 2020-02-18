create or replace PROCEDURE LGAA_F_CORRECTION_LGAA251(schema_name VARCHAR2, table_name_v_00_jav VARCHAR2, procName VARCHAR2) 
AS 

-- kurzor esetében sajnos nem lehet dinamikus nevet használni:
cur_251 LGAA0_1901_F_J_V00%ROWTYPE;  

sql_statement VARCHAR2(1000);
v_cmd1 VARCHAR2(1000);
cur_ref SYS_REFCURSOR;

v_tev CHAR(4);
v_mho VARCHAR2(2);
v_m003 VARCHAR2(10);
v_aaje VARCHAR2(10);
v_mp77 VARCHAR2(10);
v_sorsz NUMBER(8,0);
v_LGAA251 VARCHAR2(10);
v_LGAA252 VARCHAR2(1);
v_LGAA253 VARCHAR2(10);
v_LGAA254 VARCHAR2(1);
v_LGAA255 VARCHAR2(10);
v_LGAA256 VARCHAR2(1);
v_LGAA257 VARCHAR2(10);
v_LGAA258 VARCHAR2(1);
v_LGAA259 VARCHAR2(10);
v_LGAA260 VARCHAR2(1);

BEGIN

	-- kurzor esetében sajnos nem lehet dinamikus nevet használni:
	--FOR i IN (select TEV, MHO, M003, AAJE, MP77, LGAA251, LGAA252, LGAA253, LGAA254, LGAA255, LGAA256, LGAA257, LGAA258, LGAA259, LGAA260, RSORSZ from LG19.LGAA0_1901_F_J_V00 WHERE LGAA251 IS NULL AND LGAA253 IS NOT NULL) LOOP
	
	-- másik fajta kurzor:
	v_cmd1 := 'SELECT * FROM '|| schema_name ||'.'|| table_name_v_00_jav ||' WHERE LGAA251 IS NULL AND LGAA253 IS NOT NULL';
			
	OPEN cur_ref FOR v_cmd1;
	LOOP
	
		FETCH cur_ref INTO cur_251;
		EXIT WHEN cur_ref%NOTFOUND;
		
		v_tev := cur_251.TEV;
		v_mho := cur_251.MHO;
		v_m003 := cur_251.M003;
		v_aaje := cur_251.AAJE;
		v_mp77 := cur_251.MP77;
		v_sorsz := cur_251.RSORSZ;
		v_LGAA251 := cur_251.LGAA251;
		v_LGAA252 := cur_251.LGAA252;
		v_LGAA253 := cur_251.LGAA253;
		v_LGAA254 := cur_251.LGAA254;
		v_LGAA255 := cur_251.LGAA255;
		v_LGAA256 := cur_251.LGAA256;
		v_LGAA257 := cur_251.LGAA257;
		v_LGAA258 := cur_251.LGAA258;
		v_LGAA259 := cur_251.LGAA259;
		v_LGAA260 := cur_251.LGAA260;
				
		sql_statement := 'UPDATE '|| schema_name ||'.'|| table_name_v_00_jav ||'
		SET LGAA251 = '''|| v_LGAA253 ||'''
		WHERE TEV = '''|| v_tev ||''' AND MHO = '''|| v_mho ||''' AND M003 = '''|| v_m003 ||''' AND AAJE = '''|| v_aaje ||''' AND MP77 = '''|| v_mp77 ||''' AND RSORSZ = '''|| v_sorsz ||''' 
		';
		EXECUTE IMMEDIATE(sql_statement);
		
		sql_statement := 'UPDATE '|| schema_name ||'.'|| table_name_v_00_jav ||'
		SET LGAA253 = '''',
		LGAA254 = ''''
		WHERE TEV = '''|| v_tev ||''' AND MHO = '''|| v_mho ||''' AND M003 = '''|| v_m003 ||''' AND AAJE = '''|| v_aaje ||''' AND MP77 = '''|| v_mp77 ||''' AND RSORSZ = '''|| v_sorsz ||''' 
		';
		EXECUTE IMMEDIATE(sql_statement);		
				
		IF ''|| v_LGAA255 ||'' IS NOT NULL THEN
		
			sql_statement := 'UPDATE '|| schema_name ||'.'|| table_name_v_00_jav ||'
			SET LGAA253 = '''|| v_LGAA255 ||''',
			LGAA254 = '''|| v_LGAA256 ||'''
			WHERE TEV = '''|| v_tev ||''' AND MHO = '''|| v_mho ||''' AND M003 = '''|| v_m003 ||''' AND AAJE = '''|| v_aaje ||''' AND MP77 = '''|| v_mp77 ||''' AND RSORSZ = '''|| v_sorsz ||''' 
			';
			EXECUTE IMMEDIATE(sql_statement);		

			sql_statement := 'UPDATE '|| schema_name ||'.'|| table_name_v_00_jav ||'
			SET LGAA255 = '''',
			LGAA256 = ''''
			WHERE TEV = '''|| v_tev ||''' AND MHO = '''|| v_mho ||''' AND M003 = '''|| v_m003 ||''' AND AAJE = '''|| v_aaje ||''' AND MP77 = '''|| v_mp77 ||''' AND RSORSZ = '''|| v_sorsz ||''' 
			';
			EXECUTE IMMEDIATE(sql_statement);	

		END IF;

		IF ''|| v_LGAA257 ||'' IS NOT NULL THEN
		
			sql_statement := 'UPDATE '|| schema_name ||'.'|| table_name_v_00_jav ||'
			SET LGAA255 = '''|| v_LGAA257 ||''',
			LGAA256 = '''|| v_LGAA258 ||'''
			WHERE TEV = '''|| v_tev ||''' AND MHO = '''|| v_mho ||''' AND M003 = '''|| v_m003 ||''' AND AAJE = '''|| v_aaje ||''' AND MP77 = '''|| v_mp77 ||''' AND RSORSZ = '''|| v_sorsz ||''' 
			';
			EXECUTE IMMEDIATE(sql_statement);			

			sql_statement := 'UPDATE '|| schema_name ||'.'|| table_name_v_00_jav ||'
			SET LGAA257 = '''',
			LGAA258 = ''''
			WHERE TEV = '''|| v_tev ||''' AND MHO = '''|| v_mho ||''' AND M003 = '''|| v_m003 ||''' AND AAJE = '''|| v_aaje ||''' AND MP77 = '''|| v_mp77 ||''' AND RSORSZ = '''|| v_sorsz ||''' 
			';
			EXECUTE IMMEDIATE(sql_statement);				

		END IF;		

		IF ''|| v_LGAA259 ||'' IS NOT NULL THEN

			sql_statement := 'UPDATE '|| schema_name ||'.'|| table_name_v_00_jav ||'
			SET LGAA257 = '''|| v_LGAA259 ||''',
			LGAA258 = '''|| v_LGAA260 ||'''
			WHERE TEV = '''|| v_tev ||''' AND MHO = '''|| v_mho ||''' AND M003 = '''|| v_m003 ||''' AND AAJE = '''|| v_aaje ||''' AND MP77 = '''|| v_mp77 ||''' AND RSORSZ = '''|| v_sorsz ||''' 
			';
			EXECUTE IMMEDIATE(sql_statement);		

			sql_statement := 'UPDATE '|| schema_name ||'.'|| table_name_v_00_jav ||'
			SET LGAA259 = '''',
			LGAA260 = ''''
			WHERE TEV = '''|| v_tev ||''' AND MHO = '''|| v_mho ||''' AND M003 = '''|| v_m003 ||''' AND AAJE = '''|| v_aaje ||''' AND MP77 = '''|| v_mp77 ||''' AND RSORSZ = '''|| v_sorsz ||''' 
			';
			EXECUTE IMMEDIATE(sql_statement);	

		END IF;		
		
	END LOOP;

	commit;
		
-- error case
EXCEPTION

WHEN OTHERS THEN
record_error(procName);
RAISE;
		
END LGAA_F_CORRECTION_LGAA251;