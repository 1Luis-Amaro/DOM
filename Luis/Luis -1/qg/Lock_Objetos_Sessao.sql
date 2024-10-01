/* Formatted on 10/11/2015 08:36:24 (QP5 v5.267.14150.38573) */
SELECT * --loc.session_id, dba.object_name
  FROM v$locked_object loc, dba_objects dba
 WHERE     loc.session_id IN (SELECT l.sid
                                FROM v$lock l, v$lock a
                               WHERE     l.id1 = a.id1
                                     AND l.block = 1
                                     AND a.request <> 0)
       AND loc.object_id = dba.object_id;

  SELECT  SUBSTR (b.owner, 1, 8) owner,
         b.object_type object_type,
         SUBSTR (b.object_name, 1, 18) object_name,
         DECODE (a.locked_mode,
                 0, 'None',
                 1, 'Null',
                 2, 'Row-S',
                 3, 'Row-X',
                 4, 'Share',
                 5, 'S/Row-X',
                 6, 'Exclusive')
            locked_mode,
         a.oracle_username username,
         a.os_user_name osuser,
         TO_CHAR(c.logon_time, 'YYYY/MM/DD HH24:MI:SS') logon_time,
         c.action,
         a.session_id sid,
         c.SERIAL#,
         'alter system kill session '''|| a.session_id||','||c.SERIAL#||''';' 
    FROM v$locked_object a, dba_objects b, v$session c
   WHERE a.object_id = b.object_id AND a.session_id = c.sid
--    and b.object_name like 'PO_%'   
ORDER BY c.action,b.owner, b.object_type, b.object_name;

--alter system kill session '769,691';

/**** Verifica a query que está sendo executada por determinado programa ****/
select *
  from v$session ses 
 where sql_exec_start is not null
 order by sql_exec_start desc;

select sql_text, ses.client_identifier
  from v$session ses, v$sqlarea sql
 where ses.sql_hash_value = sql.hash_value(+) and
       ses.sql_address = sql.address(+) and
       ses.sid in (1483);
/****************************************************************************/
SELECT *
FROM V$SESSION
ORDER BY logon_time DESC;
 
SELECT SUBSTR(c.username,1,10) ora
      ,c.status
      ,d.sql_text
      ,d.piece
      ,c.sid
      --,c.*
FROM /*all_objects a
    ,v$LOCK b
    ,*/v$sqltext d
    ,v$SESSION c
WHERE c.sql_address = d.address
/*AND a.object_type = 'TABLE'
AND b.id1 = a.object_id
AND c.sid = b.sid
AND c.username IS NOT NULL*/
AND c.sid IN (859, 167)
ORDER BY 1, 2, d.piece
