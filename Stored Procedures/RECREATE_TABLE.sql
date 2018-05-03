create or replace 
PROCEDURE        "RECREATE_TABLE" AUTHID CURRENT_USER IS

v_Cursor	NUMBER;
v_createstring	VARCHAR2(300);
v_dropstring	VARCHAR2(100);
v_numrows	INTEGER;

BEGIN

v_cursor := DBMS_SQL.OPEN_CURSOR;

v_dropstring := 'DROP TABLE cpg_oragems_log';

  BEGIN
	DBMS_SQL.PARSE(v_cursor,v_dropstring,DBMS_SQL.V7);

  EXCEPTION
	WHEN OTHERS THEN
		IF SQLCODE != -942 THEN
			RAISE;
		END IF;

  END;

v_createstring := 'create table cpg_oragems_log (ERROR_CODE 		NUMBER,
						ERROR_MSG		VARCHAR2(200),
						ERROR_TXT		VARCHAR2(200),
						DATE_ADDED		DATE)';

DBMS_SQL.PARSE(v_cursor,v_createstring,DBMS_SQL.V7);
v_numrows := DBMS_SQL.EXECUTE(v_cursor);
DBMS_SQL.CLOSE_CURSOR(v_cursor);



v_cursor := DBMS_SQL.OPEN_CURSOR;

v_dropstring := 'DROP TABLE cpg_skf_po_err_log';

  BEGIN
	DBMS_SQL.PARSE(v_cursor,v_dropstring,DBMS_SQL.V7);

  EXCEPTION
	WHEN OTHERS THEN
		IF SQLCODE != -942 THEN
			RAISE;
		END IF;

  END;

v_createstring := 'create table cpg_skf_po_err_log(ERROR_CODE 		NUMBER,
						ERROR_MSG		VARCHAR2(200),
						ERROR_TXT		VARCHAR2(200),
						DATE_ADDED		DATE)';

DBMS_SQL.PARSE(v_cursor,v_createstring,DBMS_SQL.V7);
v_numrows := DBMS_SQL.EXECUTE(v_cursor);
DBMS_SQL.CLOSE_CURSOR(v_cursor);


EXCEPTION
  WHEN OTHERS THEN
	DBMS_SQL.CLOSE_CURSOR(v_cursor);
	RAISE;


END RECREATE_TABLE;

 