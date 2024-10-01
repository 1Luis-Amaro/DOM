SELECT distinct 
       fu.user_name
      ,fu.description
      ,fu.start_date start_date_user 
      ,fu.end_date   end_date_user
      ,frt.responsibility_name
      ,fr.end_date End_Date_Resp
      ,furg.start_date start_date_user_resp
      ,furg.end_date end_date_user_resp
      ,fr.responsibility_key
      ,fa.application_short_name
      ,FU.END_DATE
  FROM apps.fnd_user_resp_groups_direct   furg,
       applsys.fnd_user              fu,
       applsys.fnd_responsibility_tl frt,
       applsys.fnd_responsibility    fr,
       applsys.fnd_application_tl    fat,
       applsys.fnd_application       fa
WHERE furg.user_id           = fu.user_id
   AND furg.responsibility_id = frt.responsibility_id
   AND fr.responsibility_id   = frt.responsibility_id
   AND fa.application_id      = fat.application_id
   AND fr.application_id      = fat.application_id
order by fu.description