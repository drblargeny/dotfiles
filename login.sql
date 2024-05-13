-- Use gvim
define _editor='gvim.bat -f'

-- enable DBMS_OUTPUT, use unlimited buffer, wrap lines
set serveroutput on size unlimited format wrapped

-- trim blanks in columns
set trimout on
set trimspool on

-- Set the bytes displayed for LONG and CLOB
set long 500

-- Set the width of a line
set linesize 140

-- Set the number of lines on a page (i.e. how often column headers appear)
set pagesize 1000

-- Set width of the explain plan
column plan_plus_exp format a80

-- Setup a more-useful prompt
--column global_name new_value gname
set termout off
define gname=idle
column global_name new_value gname
SELECT LOWER(USER) || '@' || SUBSTR(global_name, 1, DECODE(dot, 0, LENGTH(global_name), dot - 1))
         global_name
FROM   (SELECT global_name, INSTR(global_name, '.') dot FROM global_name);
set sqlprompt '&gname> '
set termout on

-- Enable auto-trace/explain-plan
set autotrace on
--set autotrace traceonly

-- Show timing stats
set timing on

-- Set default editor file name
set editfile sqlplus.sql
