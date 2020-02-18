create or replace PROCEDURE record_error(PRC VARCHAR2) AUTHID DEFINER  AS 

   PRAGMA AUTONOMOUS_TRANSACTION;
   l_mesg  VARCHAR2(32767) := SQLERRM;

BEGIN

	EXECUTE IMMEDIATE' INSERT INTO logging (created_on, info, proc_name, message, backtrace)
	VALUES (TO_CHAR(CURRENT_TIMESTAMP, ''YYYY.MM.DD HH24:MI:SS.FF''), ''ERROR'', '''|| PRC ||''', '''|| l_mesg ||''', sys.DBMS_UTILITY.format_error_backtrace)';


   COMMIT;
END;