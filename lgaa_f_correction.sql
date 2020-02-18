create or replace PROCEDURE LGAA_F_CORRECTION(to_write NUMBER, v_00 NUMBER, v_01 NUMBER) 
AS 

no_out_table EXCEPTION;
procName VARCHAR2(30);

sql_statement VARCHAR2(1000);
v NUMERIC;
schema_name VARCHAR2(10);
table_name_v_00 VARCHAR2(50);
table_name_v_00_jav VARCHAR2(50);
table_name_v_01 VARCHAR2(50);

BEGIN

schema_name := 'LG19';
table_name_v_00 := 'LGAA0_1901_F_V00';
table_name_v_00_jav := 'LGAA0_1901_F_J_V00';
table_name_v_01 := 'LGAA0_1901_F_V01';

INSERT INTO LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', 'START', '', '');

-- USER OUTPUT
IF to_write = 1 THEN
	DBMS_OUTPUT.PUT_LINE('Javított tábla felülírása bekapcsolva + LOG táblába írás');
	
	INSERT INTO LOGGING (created_on, info, proc_name, message, backtrace)
	VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', 'START', 'Javított tábla felülírása', '');
	
ELSIF to_write != 1 THEN
	DBMS_OUTPUT.PUT_LINE('Csak LOG táblába írás');
	
	INSERT INTO LOGGING (created_on, info, proc_name, message, backtrace)
	VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', 'START', 'Csak LOG táblába írás', '');
	
END IF;

-- V00 tábla vizsgálata
IF v_00 = 1 THEN

DBMS_OUTPUT.PUT_LINE('v00 tábla vizsgálata bekapcsolva');
	
INSERT INTO LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', 'START', 'v00 tábla vizsgálata bekapcsolva', '');

-- V00_JAVITOTT tábla megvan?
SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = ''|| table_name_v_00_jav ||'';

IF v = 0 THEN
	
	RAISE no_out_table;
			
END IF; 


-- SZULIDO mezők vizsgálata
-- SZULIDO < DATE(TEV,MHO,01)




-- SZULIDO = DATE(AAJE)
procName := 'SZULIDO IS NULL';

sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| table_name_v_00_jav ||' WHERE SZULIDO IS NULL';
EXECUTE IMMEDIATE sql_statement INTO v;

IF v = 0 THEN

	DBMS_OUTPUT.PUT_LINE('SZULIDO mező értékei megfelelőek');

ELSE 

	DBMS_OUTPUT.PUT_LINE('SZULIDO mező esetében eltérés van '|| v ||' rekord esetében');
	INSERT INTO LOGGING (created_on, info, proc_name, message, backtrace)
	VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', ''|| v ||' rekord esetében eltérés', '');
	
	IF to_write = 1 THEN
	
		LGAA_F_CORRECTION_SZULIDO(''|| schema_name ||'', ''|| table_name_v_00_jav ||'', ''|| procName ||'');
		
		-- futást követő vizsgálat
		sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| table_name_v_00_jav ||' WHERE SZULIDO IS NULL';
		EXECUTE IMMEDIATE sql_statement INTO v;
		
		IF v = 0 THEN

			INSERT INTO LOGGING (created_on, info, proc_name, message, backtrace)
			VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'SZULIDO mező feldolgozása megfelelően lefutott', '');
		
		ELSE 
		
			INSERT INTO LOGGING (created_on, info, proc_name, message, backtrace)
			VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'ERROR', ''|| procName ||'', 'SZULIDO mező feldolgozása: '|| v ||' rekordnál nem történt javítás', '');
			DBMS_OUTPUT.PUT_LINE('ERROR: SZULIDO mező feldolgozása');		
				
		END IF;		

	END IF;

END IF;




-- LGAA251-LGAA260 mezők vizsgálata
-- ha az LGAA251 üres, de LGAA253 nem üres, akkor át kell rendezni a mezőket

procName := 'LGAA251-LGAA260';

sql_statement := 'SELECT COUNT(*) FROM (SELECT * FROM '|| schema_name ||'.'|| table_name_v_00_jav ||' WHERE 
LGAA251 IS NULL AND 
LGAA253 IS NOT NULL)';

EXECUTE IMMEDIATE sql_statement INTO v;

IF v = 0 THEN

	DBMS_OUTPUT.PUT_LINE('LGAA251 mezők értékei megfelelőek');
	
ELSE 

	DBMS_OUTPUT.PUT_LINE('LGAA251 mezők esetében eltérés van '|| v ||' rekord esetében');
	INSERT INTO LOGGING (created_on, info, proc_name, message, backtrace)
	VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', ''|| v ||' rekord esetében eltérés', '');
	
	IF to_write = 1 THEN
	
		LGAA_F_CORRECTION_LGAA251(''|| schema_name ||'', ''|| table_name_v_00_jav ||'', ''|| procName ||'');
			
	END IF;
	
	-- futást követő vizsgálat
	sql_statement := 'SELECT COUNT(*) FROM (SELECT * FROM '|| schema_name ||'.'|| table_name_v_00_jav ||' WHERE 
	LGAA251 IS NULL AND 
	LGAA253 IS NOT NULL)';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
	IF v = 0 THEN

		INSERT INTO LOGGING (created_on, info, proc_name, message, backtrace)
		VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'LGAA251 mezők feldolgozása megfelelően lefutott', '');
	
	ELSE 
	
		INSERT INTO LOGGING (created_on, info, proc_name, message, backtrace)
		VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'ERROR', ''|| procName ||'', 'LGAA251 mezők feldolgozása: '|| v ||' rekordnál nem történt javítás', '');
		DBMS_OUTPUT.PUT_LINE('ERROR: LGAA251 mezők feldolgozása');		
	
	
	END IF;

END IF;

-- LGAA251-LGAA260 mezők vizsgálata <--




END IF;


-- V01 tábla vizsgálata
IF v_01 = 1 THEN

DBMS_OUTPUT.PUT_LINE('v01 tábla vizsgálata bekapcsolva');

INSERT INTO LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', 'START', 'v01 tábla vizsgálata bekapcsolva', '');


-- Egyszerűsített foglalkoztatottak vizsgálata
-- LGAA507 és LGAA509 negatív értékek vizsgálata

procName := 'LGAA507 negatív';

sql_statement := 'select count(*) from (
select * from '|| schema_name ||'.'|| table_name_v_01 ||'
where LGAA509 < 0 OR LGAA507 < 0)';

EXECUTE IMMEDIATE sql_statement INTO v;

IF v = 0 THEN

	DBMS_OUTPUT.PUT_LINE('LGAA507, LGAA509 mezők megfelelőek');

ELSE 

	INSERT INTO LOGGING (created_on, info, proc_name, message, backtrace)
	VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'ERROR', ''|| procName ||'', 'LGAA507, LGAA509 mező '|| v ||' esetben hibás', '');
	DBMS_OUTPUT.PUT_LINE('ERROR: LGAA507, LGAA509 mező '|| v ||' esetben hibás');	

END IF;

-- LGAA507 van, de LGAA509 üres

procName := 'LGAA509 üres';

sql_statement := 'select count(*) from '|| schema_name ||'.'|| table_name_v_01 ||'
where LGAA509 IS NULL AND LGAA507 IS NOT NULL';

EXECUTE IMMEDIATE sql_statement INTO v;

IF v = 0 THEN

	DBMS_OUTPUT.PUT_LINE('LGAA507, LGAA509 mezők megfelelőek');

ELSE 

	INSERT INTO LOGGING (created_on, info, proc_name, message, backtrace)
	VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'ERROR', ''|| procName ||'', 'LGAA507, LGAA509 mező '|| v ||' esetben hibás', '');
	DBMS_OUTPUT.PUT_LINE('ERROR: LGAA507, LGAA509 mező '|| v ||' esetben hibás');	

END IF;




END IF;


INSERT INTO LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', 'END', '', '');

-- error case
EXCEPTION

WHEN no_out_table THEN
	DBMS_OUTPUT.PUT_LINE(''|| table_name_v_00_jav ||' tábla nem létezik az adatbázisban, kérlek, hogy a további futtatáshoz hozd létre');

WHEN OTHERS THEN
record_error(procName);
RAISE;
	
END LGAA_F_CORRECTION;