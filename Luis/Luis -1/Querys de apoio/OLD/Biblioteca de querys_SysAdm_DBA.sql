*******************************
    Biblioteca de querys
*******************************

**********************************
		Cancelar concurrentes 
**********************************

-- Cancelar concurrentes ( APPS es necesario ) 

select count(*) from fnd_concurrent_processes

COUNT(*)
----------
729

create table fnd_concurrent_processes_bkp as select * from fnd_concurrent_processes;

select * from fnd_concurrent_processes 
where trunc(PROCESS_START_DATE) = '16-JAN-2007'


delete APPLSYS.fnd_concurrent_processes 
where CONCURRENT_PROCESS_ID=481012


select * from fnd_concurrent_processes 
where CONCURRENT_PROCESS_ID=481012

commit;

 
select status_code,phase_code from fnd_concurrent_requests where REQUEST_ID=4682363

S P
- -
R R

update fnd_concurrent_requests set phase_code='C',status_code='X' where REQUEST_ID=4682363;

 
select status_code,phase_code from fnd_concurrent_requests where REQUEST_ID=4460963;

S P
- -
X C


Commit complete.




**********************************
		Organizations ID 
**********************************

SELECT 
	   HROU.ORGANIZATION_ID
	--   ,HROU.LOCATION_ID
	   ,HROU.NAME
	   ,XTRI.FULL_NAME
	--   ,HROU.INTERNAL_ADDRESS_LINE
	   ,HROU.ATTRIBUTE20
FROM 
	  HR.HR_ALL_ORGANIZATION_UNITS HROU
	 ,XTR_PARTY_INFO XTRI 
WHERE 
	  HROU.ORGANIZATION_ID = LEGAL_ENTITY_ID
--WHERE ORGANIZATION_ID like '86'
--WHERE NAME like '%ALSE_DIA%'
ORDER BY ORGANIZATION_ID;



**********************************************************
		Usuarios & Responsabilidades 
*********************************************************

-- Original  de usuarios .....

SELECT 
   ROWID, USER_ID, USER_NAME, LAST_UPDATE_DATE, 
   LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, 
   LAST_UPDATE_LOGIN, ENCRYPTED_FOUNDATION_PASSWORD, ENCRYPTED_USER_PASSWORD, 
   SESSION_NUMBER, START_DATE, END_DATE, 
   DESCRIPTION, LAST_LOGON_DATE, PASSWORD_DATE, 
   PASSWORD_ACCESSES_LEFT, PASSWORD_LIFESPAN_ACCESSES, PASSWORD_LIFESPAN_DAYS, 
   EMPLOYEE_ID, EMAIL_ADDRESS, FAX, 
   CUSTOMER_ID, SUPPLIER_ID, WEB_PASSWORD, 
   USER_GUID, GCN_CODE_COMBINATION_ID, PERSON_PARTY_ID
FROM APPLSYS.FND_USER Tbl
where user_name like '%XOCHITL.SALAZAR%'



-- Usuarios APPS match con empleados RH 

select 
 u.user_id Usuario_Id
,u.user_name   Cuenta
,u.description Descripcion
,u.email_address email_usuario
,u.employee_id Empleado_Id
,p.full_name Empleado
,p.EMAIL_ADDRESS email_empleado
from apps.fnd_user u
    ,per_all_people_f p
where u.employee_id = p.person_id(+)
order by empleado



-- Usuarios sin asignacion de empleados 

select 
 u.user_id Usuario_Id
,u.user_name   Cuenta
,u.description Descripcion
,u.email_address email_usuario
,u.employee_id Empleado_Id
from apps.fnd_user u
where u.employee_id is null



 
-- Usuario y responsabilidades 
select 
 u.user_name   "Cuenta"
,u.description "Descripcion"
,u.EMAIL_ADDRESS
,U.start_date "Inicia"
,U.end_date   "Termina"
,p.EMAIL_ADDRESS "email_empleado"
,R.RESPONSIBILITY_NAME "Responsabilidad"
--,Ur.description "Desc_Resp"
,Ur.start_date "Inicia"
,Ur.end_date   "Termina"
,decode(Ur.END_DATE,NULL,'SI',decode(trunc(sysdate)-trunc(nvl(Ur.END_DATE,sysdate)),0,'SI','NO')) "Habilitada"
from 
  apps.FND_RESPONSIBILITY_VL r
, apps.fnd_user u
, per_all_people_f p
--, fnd_user_resp_groups Ur    --ANTES 
, FND_USER_RESP_GROUPS_ALL Ur  --DESPIES  solo con APPS 
where u.user_name like '%%'
--where u.description like '%INIGUEZ%'
--where Ur.description like '%ALSE_CXP_DIA_AUXILIAR_A%'
and decode(U.END_DATE,NULL,'SI','NO') like 'SI'
and u.employee_id = p.person_id(+)
and Ur.user_id = u.user_id
and UR.RESPONSIBILITY_ID = R.RESPONSIBILITY_ID
AND (R.RESPONSIBILITY_NAME like '%ALSE_IP%'
or R.RESPONSIBILITY_NAME like '%ALSE_PO%')
--AND Ur.DESCRIPTION like 'ALSE_IEXP_%_SUPERUSUARIO_ROCC%'
--and Ur.start_date > to_date('28-JUN-2005 00:52','DD-MON-YYYY HH24:MI')
and decode(Ur.END_DATE,NULL,'SI',decode(trunc(sysdate)-trunc(nvl(Ur.END_DATE,sysdate)),0,'SI','NO')) like 'SI' 
--order by user_name
order by u.user_name,R.RESPONSIBILITY_NAME




-- Usuario con Securing Attributes 
select 
 u.user_name   "Cuenta"
,u.description "Descripcion"
,u.EMAIL_ADDRESS
,U.start_date "Inicia"
,U.end_date   "Termina"
,usav.ATTRIBUTE_CODE
from 
  apps.fnd_user u
, AK_WEB_USER_SEC_ATTR_VALUES  usav
where u.user_name like '%LORENA.MARTINEZ%'
and u.user_id = usav.WEB_USER_ID



-- Indica usuarios que han sido desactivados 

SELECT 
   USER_NAME
   ,DESCRIPTION
   ,START_DATE 
   ,END_DATE
   , EMPLOYEE_ID
   ,EMAIL_ADDRESS
   ,LAST_UPDATE_DATE 
FROM APPLSYS.FND_USER Tbl
where END_DATE is not NULL



-- Busca empleado por usuarios y/o descripcion 

SELECT 
   USER_NAME, DESCRIPTION,
   START_DATE, END_DATE, 
    EMPLOYEE_ID, EMAIL_ADDRESS, LAST_UPDATE_DATE 
FROM APPLSYS.FND_USER Tbl
--where user_name like '%GABRIELA.MARQUEZ%'
where description like '%LORENA%'
--AND END_DATE IS NULL




-- Centro de costos por empleado 

select 
        distinct CC.segment1||'.'||CC.segment2||'.'||CC.segment3||'.'||CC.segment4
        ||'.'||CC.segment5||'.'||CC.segment6||'.'||CC.segment7 "CUENTA CONTABLE"
	   ,CC.segment3 "CENTRO DE COSTO"
	   ,H.EMPLOYEE_NUMBER
	   ,H.FIRST_NAME 
	   ,H.LAST_NAME
	   ,H.FULL_NAME	 "FULL_PEOPLE_NAME"
	   ,POS.NAME "POSITION_NAME"
	   ,H2.FULL_NAME "FULL_SUPERVISOR_NAME"
FROM 
	 per_all_people_f H
	,per_all_people_f H2
    ,PER_ALL_ASSIGNMENTS_F A
	,GL_CODE_COMBINATIONS CC
	,HR_ALL_POSITIONS_F	POS
where H.FULL_NAME like '%FRIEDA%'
AND H.PERSON_ID = A.PERSON_ID
AND A.SUPERVISOR_ID = H2.PERSON_ID
AND A.DEFAULT_CODE_COMB_ID = CC.CODE_COMBINATION_ID
AND POS.POSITION_ID = A.POSITION_ID
--AND A.EFFECTIVE_START_DATE = (SELECT MAX(A2.EFFECTIVE_START_DATE) FROM PER_ALL_ASSIGNMENTS_F A2 WHERE A2.PERSON_ID = A.PERSON_ID)
AND TRUNC(H.EFFECTIVE_END_DATE) = '31-DEC-4712'
AND TRUNC(H2.EFFECTIVE_END_DATE) = '31-DEC-4712'
AND TRUNC(A.EFFECTIVE_END_DATE) = '31-DEC-4712'
order by H.FULL_NAME





*****************************
	 Responsabilidades
****************************

-- Ver Responsabilidades .....

select to_char(b.responsibility_id) id, b.responsibility_name responsabilidad 
from apps.fnd_responsibility_vl b 
where b.responsibility_name LIKE '&reponsabilidad'


select to_char(b.responsibility_id) id, b.responsibility_name responsabilidad 
from apps.fnd_responsibility_vl b 
where b.responsibility_name LIKE '%ALSEA%'



select r.responsibility_id Id
,r.responsibility_name Nombre
,r.responsibility_key  Key
,r.description Descripcion
,a.application_short_name Aplicacion
,m.menu_name Menu
,g.description Grupo
,ab.APPLICATION_SHORT_NAME Grupo_Aplicacion
,rg.REQUEST_GROUP_NAME
,ac.APPLICATION_SHORT_NAME Request_Aplicacion
,decode(r.end_date,NULL,'SI','NO') Habilitada
,r.VERSION ID_TYPE
,decode(r.VERSION,'4','Applications','W','Self Service','M','Mobile') Available_From
from apps.FND_RESPONSIBILITY_VL r
,apps.fnd_menus m
,apps.fnd_application a
,apps.fnd_data_groups g
,apps.fnd_application ab
,apps.fnd_application ac
,fnd_request_groups rg
WHERE r.responsibility_name like '%ALSE_CXP%DIA%'
and m.menu_id = r.menu_id
and a.application_id = r.application_id
and r.DATA_GROUP_ID = g.data_group_id(+)
and r.DATA_GROUP_APPLICATION_ID = ab.APPLICATION_ID(+)
and r.REQUEST_GROUP_ID = rg.REQUEST_GROUP_ID(+)
and r.GROUP_APPLICATION_ID = rg.APPLICATION_ID(+)
and r.GROUP_APPLICATION_ID = ac.APPLICATION_ID(+)
--and decode(r.end_date,NULL,'SI','NO') like 'SI'
order by r.responsibility_name



select 
 r.responsibility_id 	"Id"
,r.responsibility_name 	"RESPONSIBILITY NAME"
,avl.APPLICATION_NAME 	"APPLICATION"
,r.responsibility_key  	"RESPONSIBILITY KEY"
,r.description 			"DESCRIPTION"
,mvl.menu_name 			"MENU"
,mvl.USER_MENU_NAME		"USER_MENU"
,dg.data_group_name		"DATA GROUP NAME"
,avl.APPLICATION_NAME   "DATA GROUP APPLICATION"
,rg.REQUEST_GROUP_NAME  "REQUEST_GROUP_NAME"
,avl.APPLICATION_NAME   "REQUEST GROUP APPLICATION"
,decode(r.end_date,NULL,'SI','NO') Habilitada
,r.VERSION ID_TYPE
,decode(r.VERSION,'4','Applications','W','Self Service','M','Mobile') "AVAILABLE FROM"
from 
 apps.FND_RESPONSIBILITY_VL r
,apps.FND_MENUS_VL mvl
,apps.fnd_data_groups dg
,apps.fnd_request_groups rg
,apps.FND_APPLICATION_VL avl
WHERE 
r.responsibility_name like '%ALSE_CXP%DIA%'
--avl.APPLICATION_NAME like 'Oracle Ge%'
and r.menu_id = mvl.menu_id
and r.application_id = avl.application_id
and r.DATA_GROUP_ID = dg.data_group_id(+)
and r.DATA_GROUP_APPLICATION_ID = avl.application_id
and r.REQUEST_GROUP_ID = rg.REQUEST_GROUP_ID(+)
and r.GROUP_APPLICATION_ID = rg.APPLICATION_ID(+)
and r.GROUP_APPLICATION_ID = avl.application_id
and decode(r.end_date,NULL,'SI','NO') like 'SI'
order by r.responsibility_name



 

-- Ver Funcion y Menu de Responsabilidades .....


select r.responsibility_name,
	   rr.rule_type,
	   (case  rr.rule_type 
	   		  when 'M' then (select user_menu_name from apps.fnd_menus_vl where ACTION_ID=MENU_ID)
			  when 'F' then (select user_function_name from apps.fnd_form_functions_vl where ACTION_ID=FUNCTION_ID)
	   end ) excepcion
from fnd_resp_functions rr
	 ,apps.FND_RESPONSIBILITY_VL r
where r.responsibility_id = rr.responsibility_id
and R.responsIbility_name= 'ALSE_PO_ODP_CONSULTA'
order by 2,3




-- indica las Funcion y/o Menu que no estan estan como exluidas para una Responsabilidades .....

Nota: es importante ejecutar el primer query para saber cual es el MENU_ID,
el cual sera substituido en el segundo query en el ACTION_ID

select fmv.user_menu_name, fmv.* from apps.fnd_menus_vl fmv
where user_menu_name like '%Customer SubMenu%'



SELECT   
    rp.responsibility_name, rp.responsibility_id, u.user_name   "Cuenta"
    FROM apps.fnd_responsibility_vl rp,
  	     apps.FND_USER_RESP_GROUPS_ALL Ur,
		 apps.fnd_user u
   WHERE (   rp.responsibility_name LIKE 'ALSE_CXC%'
          OR rp.responsibility_name LIKE 'ALSE_CUENTASXCOBRAR%'
          OR rp.responsibility_name LIKE 'ALSE_AR%'
         )
	 and Ur.user_id = u.user_id
     and Ur.RESPONSIBILITY_ID = rp.RESPONSIBILITY_ID
	 and u.end_date is null
	 and Ur.END_DATE is null
     AND NOT EXISTS 
            (SELECT 1
              --r.responsibility_name,
               -- r.responsibility_id,
              --rr.rule_type,
              -- (case  rr.rule_type
              --       when 'M' then (select user_menu_name from apps.fnd_menus_vl where rr.ACTION_ID=MENU_ID)
              --       when 'F' then (select user_function_name from apps.fnd_form_functions_vl where rr.ACTION_ID=FUNCTION_ID)
              --  end ) excepcion
            FROM   fnd_resp_functions rr, apps.fnd_responsibility_vl r
             WHERE r.responsibility_id = rr.responsibility_id
               AND (   r.responsibility_name LIKE 'ALSE_CXC%'
                    OR r.responsibility_name LIKE 'ALSE_CUENTASXCOBRAR%'
                    OR r.responsibility_name LIKE 'ALSE_AR%'
              )
               AND rr.action_id IN (67722, 72275)
               AND r.responsibility_id = rp.responsibility_id)
	
ORDER BY 1



---
--- Responsabilidades VS Profiles
---
select lpad(fpo.profile_option_name,55) pon 
, lpad(fpot.user_profile_option_name,55) upon 
, fpot.description d 
, lpad(fpo.start_date_active,15) sda 
, lpad(fpo.end_date_active,15) eda 
, lpad(fpo.creation_date,15) cd 
, lpad(fu.user_name,20) cb 
, 'Site' lo 
, 'SITE' lov 
, fpov.profile_option_value pov 
from FND_PROFILE_OPTIONS_TL fpot 
, FND_PROFILE_OPTIONS fpo 
, FND_PROFILE_OPTION_VALUES fpov 
, FND_USER fu 
where 
--fpot.user_profile_option_name  in ('GL Set of Books Name','HR:User Type', 'MO: Operating Unit') 
--and 
fpot.profile_option_name = fpo.profile_option_name 
and fpo.application_id = fpov.application_id	   	  --------------- 
and fpo.profile_option_id = fpov.profile_option_id 
and fpo.created_by = fu.user_id 
and fpot.language = Userenv('Lang') 
and fpov.level_id = 10001 /* Site Level */ 
union all 
select lpad(fpo.profile_option_name,55) pon 
, lpad(fpot.user_profile_option_name,55) upon 
, fpot.description d 
, lpad(fpo.start_date_active,15) sda 
, lpad(fpo.end_date_active,15) eda 
, lpad(fpo.creation_date,15) cd 
, lpad(fu.user_name,20) cb 
, 'Apps' lo 
, fa.application_name lov 
, fpov.profile_option_value pov 
from FND_PROFILE_OPTIONS_TL fpot 
, FND_PROFILE_OPTIONS fpo 
, FND_PROFILE_OPTION_VALUES fpov 
, FND_USER fu 
, FND_APPLICATION_TL fa 
where 
--fpot.user_profile_option_name  in ('GL Set of Books Name','HR:User Type', 'MO: Operating Unit') 
--and 
fpot.profile_option_name = fpo.profile_option_name 
and fpo.profile_option_id = fpov.profile_option_id 
and fpo.created_by = fu.user_id 
and fpot.language = Userenv('Lang') 
and fpov.level_id = 10002 /* Application Level */ 
and fpov.level_value = fa.application_id 	   	   	  ----------------------
union all 
select lpad(fpo.profile_option_name,55) pon 
, lpad(fpot.user_profile_option_name,55) upon 
, fpot.description d 
, lpad(fpo.start_date_active,15) sda 
, lpad(fpo.end_date_active,15) eda 
, lpad(fpo.creation_date,15) cd 
, lpad(fu.user_name,20) cb 
, 'Resp' lo 
, frt.responsibility_name lov 
, fpov.profile_option_value pov 
from FND_PROFILE_OPTIONS_TL fpot 
, FND_PROFILE_OPTIONS fpo 
, FND_PROFILE_OPTION_VALUES fpov 
, FND_USER fu 
, FND_RESPONSIBILITY_TL frt 
where frt.responsibility_name like '%ALSE_IEXP_%_SUPERUSUARIO%'
--fpot.user_profile_option_name  in ('GL Set of Books Name','HR:User Type', 'MO: Operating Unit')
and 
fpot.profile_option_name = fpo.profile_option_name 
and fpo.profile_option_id = fpov.profile_option_id 
and fpo.created_by = fu.user_id 
and frt.language = Userenv('Lang') 
and fpot.language = Userenv('Lang') 
and fpov.level_id = 10003 /* Responsibility Level */ 
and fpov.level_value = frt.responsibility_id 
and fpov.level_value_application_id = frt.application_id 
union all 
select lpad(fpo.profile_option_name,55) pon 
, lpad(fpot.user_profile_option_name,55) upon 
, fpot.description d 
, lpad(fpo.start_date_active,15) sda 
, lpad(fpo.end_date_active,15) eda 
, lpad(fpo.creation_date,15) cd 
, lpad(fu.user_name,20) cb 
, 'User' lo 
, fu2.user_name lov 
, fpov.profile_option_value pov 
from FND_PROFILE_OPTIONS_TL fpot 
, FND_PROFILE_OPTIONS fpo 
, FND_PROFILE_OPTION_VALUES fpov 
, FND_USER fu 
, FND_USER fu2 
where 
--fpot.user_profile_option_name in ('GL Set of Books Name','HR:User Type', 'MO: Operating Unit') 
--and 
fpot.profile_option_name = fpo.profile_option_name 
and fpo.profile_option_id = fpov.profile_option_id 
and fpo.created_by = fu.user_id 
and fpov.level_id = 10004 /* User Level */ 
and fpov.level_value = fu2.user_id 
and fpot.language = Userenv('Lang') 
order by upon, lo, lov 






 
 
 ___________________________________________________________________________________________
 ___________________________________________________________________________________________
 
 
 
 
 -- Show the User name in DB 

SELECT * from dba_users where username like 'XXL%'
/

-- Verifica los valores dentro de V$PARAMETER 

select name, value
from v$parameter
where name like 'max_dump_%'

Nota: 
	  Parametros utiles: (control_files / local_listener / user_dump_dest / db_name / trace_enabled)

Ejemplo:
      
	  select name, value from V$PARAMETER where name = 'user_dump_dest'   -- Ruta del direcotrio udump 


----------
Ejemplos
----------

show parameter spfile 

select name, value 
from v$spparameter
where name = 'processes';

select name, value 
from v$spparameter
where name = 'db_cache_size';


alter system set processes = 250 scope=spfile;

alter system set db_cache_size = 134217728 scope=spfile;

alter system set java_pool_size = 469762048 scope=spfile;

alter system set large_pool_size = 67108864 scope=spfile;

alter system set shared_pool_size = 469762048 scope=spfile;





-- Indica cual es el seteo del procedre 

select TEXT
from dba_source
where NAME LIKE upper ('trace_setting')
/


select *
from dba_source
where owner LIKE upper ('ap')
/

--ALSE_BE_FONDEO

select text 
from dba_source
where name = 'HR_JOB_SWI'
and line = 2

TEXT
--------------------------------------------------------------------------------
* $Header: hrjobswi.pkh 115.3 2002/12/05 17:47:08 ndorai noship $ */
* $Header: hrjobswi.pkb 115.3 2002/12/05 17:47:17 ndorai noship $ */


	  
	  
-- Ver el lenguage base 

select language_code, nls_language, nls_territory, installed_flag
from fnd_languages
where installed_flag = 'B'
or installed_flag = 'I'
order by 1
/


-- Ver instancia a la cual estamos conectados

select *
from V$DATABASE

select instance_name from v$instance;


-- Version de la base de datos 

select * from V$VERSION


--> Indica si el Multi-Org esta activado ( $AD_TOP/sql => adutconf.sql ) 

set head off
select decode(multi_org_flag,'N','No','Y','Yes','No') "MultiOrg Activado"
from fnd_product_groups
set head on  
/


--> Indica la version de Financial, MultiOrg, MultiLenguage, MultiMoneda & SID  

select RELEASE_NAME 
, MULTI_ORG_FLAG
, MULTI_LINGUAL_FLAG
, MULTI_CURRENCY_FLAG
, APPLICATIONS_SYSTEM_NAME
from fnd_product_groups







*******************
 Objetos invalidos
*******************

select count(*)
from   dba_objects
where  status = 'INVALID'
/


SELECT 
substr(OWNER,1,10)Owner, 
substr(OBJECT_TYPE,1,15) Object_Type, 
substr(Object_Name,1,30) Object_Name, 
count(*) Count
FROM DBA_OBJECTS
WHERE status='INVALID'
GROUP BY object_Name, owner, object_type
ORDER By Object_type, Object_name, Owner
/


'''''''''''''''''''''''''''''''''''''''

select 'alter package ' || object_name || ' compile body;'
from   user_objects
where  status = 'INVALID'
and    object_type = 'PACKAGE BODY'


Ejemplo:
SQL> alter package <package_name> compile; (package specification)
SQL> alter package <package_name> compile body; (package body)

SQL> alter package pejobapi.pkh compile; 
SQL> alter package pejobapi.pkb compile body;



'''''''''''''''''''''''''''''''''''''''


***********
 parches
***********

select *
from ad_bugs
where bug_number Like '%3300123%'

--where creation_date > to_date('01-JUL-2005 00:52','DD-MON-YYYY HH24:MI')
where trunc(creation_date) between ('01-FEB-2006') AND ('22-FEB-2006')
order by creation_date



select * from ad_bugs where bug_number='&1';


select *
from ad_applied_patches
where patch_name like '3300123'

--where creation_date > to_date('01-JUL-2005 00:52','DD-MON-YYYY HH24:MI')
where trunc(creation_date) between ('01-FEB-2006') AND ('22-FEB-2006')
order by creation_date
	  
	  
	  
	  
**************
 TRACE 
**************
	  
-- Cambia el parametro a ilimitado para generar trace completos, correr con system/manager

ALTER SYSTEM SET MAX_DUMP_FILE_SIZE = 'unlimited'

ALTER SYSTEM SET MAX_DUMP_FILE_SIZE = 10240

ALTER SYSTEM SET MAX_DUMP_FILE_SIZE = 20971520  (20MB)


MAX_DUMP_FILE_SIZE = { size | 'unlimited'} [deferred] 



-- Cambia la ruta de salida del udump 

alter system set user_dump_dest='/export/home/oracle/tmp/udump'

alter system set user_dump_dest='/admin/oracle/prod1/udump'



-- Para ver cual es el # de trace que se esta generando 

Select *
from v$process
where addr in (select paddr from v$session where module= 'RAXTRX')
/


-- Indica la ruta del direcotrio udump 

Nota: Ver valores para V$PARAMETER (seecccion general)





*****************************
 Concurrent Program Manager
*****************************

-- Query para ver los concurrent manager de algun proceso 

select
at.application_name "APPS NAME",
a.request_id, 
a.parent_request_id,
a.request_date,
a.actual_start_date,
a.actual_completion_date,
b.user_concurrent_program_name,
TO_NUMBER(round(greatest(a.actual_completion_date - a.actual_start_date,0)*24*60, 2)) "Duration (min)",
a.argument_text,
a.phase_code,
a.status_code,
u.user_name,
outfile_name,
logfile_name
from 
	 fnd_application_tl at,
	 fnd_concurrent_requests a,
     fnd_concurrent_programs_tl b,
	 apps.fnd_user u
where 1=1
--AND    b.user_concurrent_program_name like '%Gather Schema Statistics'
and a.requested_by = u.user_id
and a.request_id = '3773496' 
--and a.request_id in (4560562,4560135,4560012) 
--and a.actual_start_date > to_date('31-OCT-2006 00:00','DD-MON-YYYY HH24:MI')  --EJEM2 ('11-SEP-2002','DD-MON-YYYY') 
--and a.concurrent_program_id in (33044,32353,32766) 
--and actual_completion_date < to_date('07-FEB-2003 00:52','DD-MON-YYYY HH24:MI') 
and a.concurrent_program_id = b.concurrent_program_id
and b.application_id = at.application_id 
--and a.parent_REQUEST_ID = -1 
--and a.argument_text like '%99%'
--and a.status_code like 'C'
--and a.phase_code like 'C'	
--and a.actual_completion_date is null 
--and TO_NUMBER(round(greatest(a.actual_completion_date - a.actual_start_date,0)*24*60, 2)) > 1
--and user_name= 'JAIME.VELEZ' 
and b.language = 'US'
and at.language = 'US'
--AND u.user_name <> 'BOL-SETUP'
order by 4 desc
/


-- parametros 
asc  Acendente
desc Desendente

Autoinvoice	  	       			(RAXTRX)
Process Lockboxes	   		    (ARLPLB)
Order Import	       			(OEOIMP)
Update Standard Costs  			(CMCICU)
Receiving Transactions Register (RCVTXRTR)
General Ledger Transfer Program (ARGLTP)
Aging - 7 Buckets Report 		(ARXAGM) 
AR Reconciliation Report 		(ARXRECON)
Journal Entries Report			(ARRGTA)
Transaction Register			(ARRXINVR)
Unapplied Receipts Register		(ARXCOA2)




NOTE:
Sometimes the signal 11s show in the logs However, the log report (what you actually see as the log file) 
often gets terminated (abended) before completing when UNIX abends the Apps process.
The following script will reveal these 'hidden' errors (often signal 11 errors).


SELECT request_id, cancel_or_hold, completion_code, 
       completion_text, phase_code, status_code 
FROM fnd_concurrent_requests 
WHERE request_id IN ('1429985','1429988')
	
	; (substitute in your request IDs)


	
-- Indica el nombre del programa concurrente de usuario y/o program programa concurrente 

select a.user_concurrent_program_name, b.CONCURRENT_PROGRAM_NAME
from fnd_concurrent_programs_tl a,
     FND_CONCURRENT_PROGRAMS b
where a.CONCURRENT_PROGRAM_ID = b.CONCURRENT_PROGRAM_ID
and a.APPLICATION_ID = b.APPLICATION_ID
--and b.CONCURRENT_PROGRAM_NAME = 'ARXCOA2' --'ARRGTA' 
and a.user_concurrent_program_name like 'Tran% Reg%'  
/



-- Indica cual es el program_id de un CONCURRENT_PROGRAM 

select *
from FND_CONCURRENT_PROGRAMS
where CONCURRENT_PROGRAM_NAME = 'OEOIMP'
--where concurrent_program_id = 20428	 
/	



-- AR AUTOINVOICE - Despliega el numero de lineas, duracion y lineas por min. asi como facturas del un 
-- concurrent_program_id en particular o del request id 
select
     b.request_id, 
     b.actual_start_date,
     --to_char(b.actual_start_date,'dd-mm-yy hh24:mi:ss'),
     c.num_de_linhas,
     TO_NUMBER(round(greatest(b.actual_completion_date - b.actual_start_date,0)*24*60, 2)) "Duration (min)",
     round(greatest(c.num_de_linhas/
     TO_NUMBER(round(greatest(b.actual_completion_date - b.actual_start_date,0)*24*60, 2)))) "Trasactions/Min",
     b.argument_text
from
     (select a.request_id request_id,
	 count(1) num_de_linhas
     from apps.ra_customer_trx_all a
     -- from ra_customer_trx_lines_all a
     group by a.request_id) c,
     -- rgarbari.sess_concurrent_req b
	 fnd_concurrent_requests b
where
     --b.request_id like '4560012' and
     --b.concurrent_program_id = 20428 and
     c.request_id = b.request_id and
     b.phase_code = 'C' and
     b.status_code = 'C' and
     --b.actual_start_date > to_date('10-NOV-2002 00:00','DD-MON-YYYY HH24:MI') and
     b.argument_text like '%FC%'
     order by 1 desc
/



*****************
 Analize Table 
*****************

-- Indica cual fue la ultima fecha en que fue analizada la tabla o modulo  

select owner, substr(table_name,1,30) "TABLE", num_rows, last_analyzed
from sys.dba_tables
--where table_name like 'OE_ORDER_LINES_ELISA' 
where table_name in (
 'RA_CUST_TRX_LINE_GL_DIST_ALL' 
,'RA_CUSTOMER_TRX_ALL' 	
,'RA_CUSTOMERS'  
,'RA_CUST_TRX_TYPES_ALL' 
,'GL_PERIOD_STATUSES' 
,'RA_BATCHES_ALL' 
,'GL_SETS_OF_BOOKS' 
,'GL_PERIODS' 
)
--where owner = 'GL'
/




*******************
 Table
*******************

--  Busqueda de una tabla */

select table_name
from all_tables
where table_name like '%APPLIE%PATCH%'
--where table_name like '%INTERFACE%'



-- Indica el numero de bloques de una tabla 

select blocks
from sys.dba_tables
where owner = 'AR'
and table_name = 'AR_PAYMENTS_INTERFACE_ALL'
/


-- Ver los diferentes OBJECT_TYPE  que se tienen de una TABLA  

select *
from tab
where tname like '%PER_JOB%'
/

select *
from all_objects
where object_name like '%PER_JOB%'
/

-- Indica que tabla esta bloqueada 

select distinct
a.sid,
a.serial#,
a.osuser,
a.username,
a.status,
b.owner,
b.name,
b.blocking_others,
to_char(a.logon_time,'MM/DD/YYYY HH24:MI:SS') logon_time, 
a.action,
a.command,
a.module
from v$session a, dba_dml_locks b
where a.sid=b.session_id
--and b.name like 'XTR%' 
-- and b.owner like 'XTR'
order by logon_time desc;
/


-- Indica todas aquellas tablas que tienen un campo de ' ORG_ID '  

select OWNER,TABLE_NAME,COLUMN_NAME
from all_tab_columns
where COLUMN_NAME like '%ORG_ID%'







*****************************
	objetos con locked...
****************************


-- This is the SQL to find the lock on the table 

SELECT a.object_id, a.session_id, b.object_name
       ,b.OWNER,b.CREATED, b.LAST_DDL_TIME --b.TIMESTAMP
FROM 
  v$locked_object a
, dba_objects b
WHERE a.object_id = b.object_id
and b.OWNER like 'ONT%'
--and b.object_name like 'AP%'
 
OBJECT_ID	SESSION_ID	OBJECT_NAME			   		CREATED					    LAST_DDL_TIME	             TIMESTAMP
27400		393			AP_ACCOUNTING_EVENTS_ALL	14/05/2000 06:34:24 p.m.	25/06/2005 11:22:31 p.m.	2003-06-25:15:25:07
27477		393			AP_PAYMENT_SCHEDULES_ALL	14/05/2000 06:34:28 p.m.	25/06/2005 11:22:33 p.m.	2004-06-17:23:08:43
27657		393			AP_CHECKS_ALL				14/05/2000 06:34:38 p.m.	25/06/2005 11:22:32 p.m.	2003-06-25:15:25:08
27918		393			AP_INVOICES_ALL				14/05/2000 06:35:27 p.m.	25/06/2005 11:22:32 p.m.	2002-10-26:05:39:16
27956		393			AP_CHECK_STOCKS_ALL			14/05/2000 06:35:29 p.m.	25/06/2005 11:22:32 p.m.	2002-10-25:15:51:42
27918		413			AP_INVOICES_ALL				14/05/2000 06:35:27 p.m.	25/06/2005 11:22:32 p.m.	2002-10-26:05:39:16
27918		445			AP_INVOICES_ALL				14/05/2000 06:35:27 p.m.	25/06/2005 11:22:32 p.m.	2002-10-26:05:39:16
 
27657		846			AP_CHECKS_ALL				14/05/2000 06:34:38 p.m.	25/06/2005 11:22:32 p.m.
 

-- This is the SQL to find the  SID	 &  SERIAL# 

SELECT sid, serial# from v$session 
WHERE sid = 836 --983--838 --734 --846;

SID	 SERIAL#
--- -------
836	 50431

-- This is the SQL to  kill session

alter system kill session 'SID' & 'SERIAL#'
 
alter system kill session '836,50431';


 commit








*********************
 Valores de Perfiles 
*********************


-- Muestra los parametros de un profile  

select 
	   fpo.profile_option_name "OProfile"
	   ,upo.user_profile_option_name "UProfile"
	   ,fpov.profile_option_value "Value"
	   ,fpov.level_id "level_id"
	   ,fpov.level_value "level_value"
	   ,fpov.profile_option_id "profile_option_id"
	   ,decode(fpov.level_id,10001,
       	       'SITE',10002,
               'APPLICATION',10003,
               'RESPONSIBILITY',10004,'USER')"LEVEL"
	   ,fa.application_short_name App
	   ,fr.responsibility_name "Responsibility"
	   ,fu.user_name "USER"
	   --upo.last_update_date
from 
	 apps.fnd_profile_option_values fpov,
	 apps.fnd_profile_options fpo, 
	 apps.fnd_application fa, 
	 apps.fnd_responsibility_vl fr,
	 apps.fnd_user fu,
	 apps.fnd_profile_options_tl upo
where fpo.profile_option_id=fpov.profile_option_id
and fa.application_id(+)=fpov.level_value
and fr.application_id(+)=fpov.level_value_application_id
and fr.responsibility_id(+)=fpov.level_value
and fu.user_id(+)=fpov.level_value
and upo.language = 'US'
and fpo.profile_option_name=upo.profile_option_name
--and fpo.profile_option_name like '%FND_INIT_SQL%' --'ONT_DEBUG_LEVEL'   	  	 		 	 	   	  --- combinar 
--and fpov.profile_option_value like '%sun480%' 													  --- combinar 
--and upo.user_profile_option_name like '%ICX: Lan%'												  	  --- combinar 
and decode(fpov.level_id,10001,'SITE',10002,'APPLICATION',10003,'RESPONSIBILITY',10004,'USER')='SITE' --- combinar 
order by 1,4
/



Ejemplo Profile con problema 
-----------------------------
FND_INIT_SQL = begin hz_hr_data_policy_pkg.initialize_hz_hr_clause; end;



-- Modifica el parametro de un profile 

Update fnd_profile_option_values
set    fnd_profile_option_values = NULL
where  profile_option_id = 3156
and    level_id = 10001
and    level_value = 0
/

rollback

-- Muestra los parametros de un profile # 2  
Select
      val.level_id,
      val.level_value,
      val.profile_option_id,
      val.profile_option_value
from  fnd_profile_options opt,
      fnd_profile_option_values val
Where opt.profile_option_name = 'BIS_SQL_TRACE'
and   opt.profile_option_id = val.profile_option_id
/






*******************
 Productos
*******************

--> Product Installation Status, Version Info and Patch Level 

select decode(nvl(a.APPLICATION_short_name,'Not Found'),
              'SQLAP','AP','SQLGL','GL','OFA','FA',
              'Not Found','id '||to_char(fpi.application_id),
              a.APPLICATION_short_name) "APPS"
		,decode(nvl(o.ORACLE_username,'Not Found'),
              'Not Found','id '||to_char(fpi.oracle_id),
              o.ORACLE_username) "ONAME"
		,decode(fpi.status,'I','Installed','S','Shared',
               'N','Inactive',fpi.status) "STATUS"
        ,fpi.application_id "APPS ID"
		,fpi.product_version "PROD_VERSION"
        ,nvl(fpi.patch_level,'-- Not Available --') "PATCHSET"
        ,to_char(fpi.last_update_date,'dd-Mon-RRRR') "UPDATE DATE"
		,at.application_name "APPS NAME"
from
	  fnd_oracle_userid o 
     ,fnd_application a
	 ,fnd_product_installations fpi
	 ,fnd_application_tl at
Where fpi.application_id = a.application_id(+)
and fpi.oracle_id = o.oracle_id(+)
and at.application_id = a.application_id
and at.language = 'US'
--and fpi.application_id in (select application_id from fnd_application where application_short_name like '%GL%')
--and fpi.application_id in (select application_id from fnd_application where application_short_name in ('AR'))    -- solo el cambio en  el segundo select in ('CSC')) 
--and fpi.application_id = 697 
--and at.application_name like '%Ser%'
order by 1,2
/      



Resultado   
------------   
APPS	ONAME	STATUS		APPS ID		PROD_VERSION  PATCHSET	   UPDATE DATE	APPS NAME
-----   -----   --------    --------	-----------   ----------   -----------	----------
CSC		CSC		Installed	511			11.5.0		  11i.CSC.P	   26-Jun-2003	Customer Care
AD		APPLSYS	Shared		50			11.5.0		  11i.AD.H	   26-Jun-2003	Applications DBA









**********************************
 Tablespace, datafile, Indices
**********************************


-- Show All Datafiles For Tablespace And Oracle Stuff 	

select * 
from dba_data_files 
where tablespace_name like 'GL%'
order by tablespace_name, file_name 


-- Indica la ruta de los archivos *.dbf 	

select name 
from v$datafile 
where rownum=1



-- Muestra los indices de una tabla & la columna asociada a dicho indice 

select a.owner
,decode(a.index_type,'NORMAL',decode(a.uniqueness,'UNIQUE','SI','NO'),'B') uniqueness
,a.index_name indice
,a.ini_trans
,b.column_position sec
,b.column_name columna
from all_indexes a
    ,all_ind_columns b
where a.index_name = b.index_name
and b.table_name = b.table_name
and a.owner = b.index_owner
and a.table_owner = b.table_owner
and a.table_name = 'GL_INTERFACE'  --upper('&tabla')
order by a.owner, b.index_name, b.column_position
/


-- Show All Indexes

select owner, index_name, table_type, tablespace_name 
from dba_indexes
--where owner <> 'SYSTEM' 
where  owner = 'GL'
--and index_name like 'GL_INTERFACE_N1'
and owner <> 'DBSNMP' 
and owner <> 'ORDSYS' 
and owner <> 'OUTLN' 
and owner <> 'SYS' 
and owner <> 'SYSTEM' 
order by owner, index_name, tablespace_name


-- Indica el indice que se esta utilizando 

select object_name, object_id
from dba_objects
where object_id = 173437
/



-- Indica el maximo de extents de un segmento de TABLESPACE 

select tablespace_name tbs
,segment_name segmento
,extents
,decode(max_extents,2147483645,'UNLIMITED',max_extents) max_extents
,next_extent
,bytes
,blocks
from dba_segments
--where owner not in ('SYS','SYSTEM')
where segment_name like 'AR_JOURNAL_INTERIM%'
--where tablespace_name like 'ABM%'
order by tablespace_name, segment_name, segment_type, bytes desc
/



-- Indica el numero total, libre y % de un TABLESPACE 

SELECT a.tablespace_name TS,     
  SUM(a.tots) Tot_Size,     
  SUM(a.sumb) Tot_Free,       
  SUM(a.sumb)*100/SUM(a.tots) Pct     
FROM   
  (SELECT tablespace_name, 0 tots, SUM(bytes) sumb     
   FROM dba_free_space a   
   GROUP BY tablespace_name     
   UNION     
   SELECT tablespace_name, SUM(bytes) tots, 0     
   FROM dba_data_files     
   GROUP BY tablespace_name
   ) a       
GROUP BY a.tablespace_name;



Resultado
-----------
TS	 TOT_SIZE	TOT_FREE	 PCT
---  ---------  ----------	 ---------------
GLD	 122716160	2949120		 2.40320427236315
GLX	 71598080	655360		 0.915331807780321




***********
 Trigger
***********


--To enable all triggers defined for a specific table you can use the following 
--ALTER TABLE statement with the ENABLE ALL TRIGGERS option as : 

ALTER TABLE inventory ENABLE ALL TRIGGERS;


--To enable  a specific triggers you can use the following 
--ALTER TABLE statement with the ENABLE option as : 

ALTER TRIGGER <trigger_name> ENABLE;



-- Indica por modulo cuantos triggers estan Habilitados o Desabilitados 

select owner, table_owner, base_object_type, status, count(*) 
from dba_triggers 
--where status = 'ENABLED'
where status = 'DISABLED'
group by owner, table_owner, base_object_type, status


select count(*) 
from dba_triggers 
where status = 'DISABLED'

select count(*) 
from dba_triggers 
where status = 'ENABLED'



-- Indica si un TRIGGER en especifico esta Habilitado o Desabilitado 

SELECT trigger_name, table_owner, table_name, status
FROM dba_triggers
--WHERE STATUS = 'DISABLED'
WHERE STATUS = 'ENABLED'
AND trigger_name like '%OVN'


select trigger_name, trigger_type, triggering_event, status
from all_triggers 
where table_name = 'PER_ORG_STRUCTURE_VERSIONS'
--where trigger_name = 'XXLG_CONTACT_STAGING_TRG'


-- Obtiene le Comando de Alter de los trigegers que estan Desabilitados  

SELECT 'ALTER TRIGGER ' || owner || '.' || trigger_name || ' ENABLE ; ' 
FROM dba_triggers
WHERE STATUS = 'DISABLED'
AND trigger_name like '%OVN'



select per_organization_structures_s.nextval 
from dual




********************
 Directory_path 
********************

--> Modifica el valor del directory_path 

SELECT directory_path
FROM   all_directories

  /interface/infalsei/PALSEI/incoming
  /interface/infalsei/PALSEI/outgoing

Modificar el Path : replace or update
--------------------------------------
CREATE OR REPLACE DIRECTORY INCOMING as '/interface/infalsei/DALSEI/incoming';

CREATE OR REPLACE DIRECTORY OUTGOING as '/interface/infalsei/DALSEI/outgoing';

CREATE OR REPLACE DIRECTORY ALSE_P_EPPP_DIR as '/dalsei/applcsf/out/DALSEI_auohsalse03/';






**************************************
*-- Especificos de Modulos o Proceso  
**************************************


--dice cual son los que tienen mas archivos en tablas de wf 

select a.display_name, a.name, c.count
from  (select b.item_type, count(1) count
       from wf_items b
       where b.end_date is not null
       group by item_type) c,
      wf_item_types_tl a
where c.item_type = a.name
and a.language = 'US'
/



--> modifica el valor del global_attribute1 ( AR ) 

update ra_customer_trx_all 
set global_attribute1 = NULL
where global_attribute1 ='S' 
and customer_trx_id in 
(
'926619','926622','926620','926625','926623','926621',
.
.
.
'919702','919703','919704','919705','919706','919707'
)
and org_id = 85

Solución:
	Solicitud realizada.







************************************************************************
 Busqueda de Table, Indexes, Sequences, Packages, Procedures, Triggers
************************************************************************

Table
---------

	desc xxlg_street
	
	
Indexes
---------

	select 'EXISTS' from all_indexes where index_name = 'XXLG_ALIASES_FK1_I'

	select * from all_indexes where owner = 'AP'


Sequences
----------

	select 'EXISTS' from all_sequences where sequence_name = 'XXLG_PURPOSE_RESP_ID_SEQ';

	select * from all_sequences where sequence_owner like '%GL%'
		

Packages
----------

	desc xxlg_load_addresses_pk

	desc xxlg_update_sr_pk

	
Procedures
-----------

	desc populate_audit

	desc xxlg_initialize

	
	
Triggers
---------

	select 'EXISTS' from all_triggers where trigger_name = 'XXLG_CONTACT_STAGING_TRG'



	
********************************************************************************************************************
********************************************************************************************************************




********************************************************************************************************************
********************************************************************************************************************












 
	 
	 	 

 
 
 
 




