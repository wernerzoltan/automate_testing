create or replace PROCEDURE LGAA_F_CORRECTION_SZULIDO(schema_name VARCHAR2, table_name_v_00_jav VARCHAR2, procName VARCHAR2) 
AS 

-- kurzor esetében sajnos nem lehet dinamikus nevet használni:
cur_szulido LGAA0_1901_F_J_V00%ROWTYPE;      

sql_statement VARCHAR2(1000);
v_cmd1 VARCHAR2(1000);
cur_ref SYS_REFCURSOR;

v_tev CHAR(4);
v_mho VARCHAR2(2);
v_m003 VARCHAR2(10);
v_aaje VARCHAR2(10);
v_mp77 VARCHAR2(10);
v_sorsz NUMBER(8,0);

BEGIN
	
	-- kurzor esetében sajnos nem lehet dinamikus nevet használni az alábbi módon:
	--FOR i IN (SELECT TEV, MHO, M003, AAJE, MP77, RSORSZ, SZULIDO FROM LG19.LGAA0_1901_F_J_V00 WHERE SZULIDO IS NULL) LOOP

	-- másik fajta kurzor:
	v_cmd1 := 'SELECT * FROM '|| schema_name ||'.'|| table_name_v_00_jav ||' WHERE SZULIDO IS NULL';
	
	OPEN cur_ref FOR v_cmd1;
	LOOP
	
		FETCH cur_ref INTO cur_szulido;
		EXIT WHEN cur_ref%NOTFOUND;
		
		v_tev := cur_szulido.TEV;
		v_mho := cur_szulido.MHO;
		v_m003 := cur_szulido.M003;
		v_aaje := cur_szulido.AAJE;
		v_mp77 := cur_szulido.MP77;
		v_sorsz := cur_szulido.RSORSZ;
		
		sql_statement := 'UPDATE '|| schema_name ||'.'|| table_name_v_00_jav ||'
		SET SZULIDO = (SELECT (to_date(''1867-01-01'', ''YYYY-MM-DD'') + (SELECT SUBSTR(AAJE, 2, 5) FROM '|| schema_name ||'.'|| table_name_v_00_jav ||' WHERE TEV = '''|| v_tev ||''' AND MHO = '''|| v_mho ||''' AND M003 = '''|| v_m003||''' AND AAJE = '''|| v_aaje ||''' AND MP77 = '''|| v_mp77 ||''' AND RSORSZ = '|| v_sorsz ||' AND SZULIDO IS NULL)) as new_date FROM dual)			
		WHERE TEV = '''|| v_tev ||''' AND MHO = '''|| v_mho ||''' AND M003 = '''|| v_m003 ||''' AND AAJE = '''|| v_aaje ||''' AND MP77 = '''|| v_mp77 ||''' AND RSORSZ = '|| v_sorsz ||' AND SZULIDO IS NULL';
		EXECUTE IMMEDIATE(sql_statement);
	
	END LOOP;
	
	commit;

-- error case
EXCEPTION

WHEN OTHERS THEN
record_error(procName);
RAISE;
		
END LGAA_F_CORRECTION_SZULIDO;