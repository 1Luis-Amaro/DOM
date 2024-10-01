select * from DBA_DML_LOCKS
 where name like 'MSC%';
 
 select * from v$sql
 where module = 'MSCFNSCW'
 and upper(sql_text) like '%MSC_%' ;
 
 select sql_text
 from v$session ses, v$sqlarea sql
 where ses.sql_hash_value = sql.hash_value(+) and
 ses.sql_address = sql.address(+) and
 ses.sid= 2782;

