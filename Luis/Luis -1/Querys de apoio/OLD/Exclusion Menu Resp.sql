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





AR_CUSTOMERS_GUI
Customer SubMenu

ALSE_CXC%
ALSE_CUENTASXCOBRAR%
ALSE_AR%
		
	
	
	
select r.responsibility_name,
       r.responsibility_id
from apps.FND_RESPONSIBILITY_VL r
where (R.responsIbility_name like 'ALSE_CXC%' 
	   or R.responsIbility_name like 'ALSE_CUENTASXCOBRAR%'
	   or R.responsIbility_name like 'ALSE_AR%' )

		


select distinct r.responsibility_name,
       r.responsibility_id,
	   rr.rule_type,
	   (case  rr.rule_type 
	  		  when 'M' then (select user_menu_name from apps.fnd_menus_vl where rr.ACTION_ID=MENU_ID)
			  when 'F' then (select user_function_name from apps.fnd_form_functions_vl where rr.ACTION_ID=FUNCTION_ID)
	   end ) excepcion
from fnd_resp_functions rr
	 ,apps.FND_RESPONSIBILITY_VL r
where r.responsibility_id = rr.responsibility_id
and (R.responsIbility_name like 'ALSE_CXC%' 
	 or R.responsIbility_name like 'ALSE_CUENTASXCOBRAR%'
	 or R.responsIbility_name like 'ALSE_AR%' )
and  rr.ACTION_ID in ( 67722,72275 )
order by 1,2




select fmv.user_menu_name, fmv.* from apps.fnd_menus_vl fmv
where user_menu_name like '%Customer SubMenu%'



=====================


/* Formatted on 2007/01/16 17:52 (Formatter Plus v4.8.7) */
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




		