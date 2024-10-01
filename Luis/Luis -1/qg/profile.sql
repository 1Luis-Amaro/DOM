select b.language resp_lang,
       b.responsibility_name,
       a.profile_option_id ID,
       a.level_value Level_Code,
       e.profile_option_name Profile,
       f.language profile_lang,
       f.user_profile_option_name profile_name,
       decode(a.level_id,10001,'Site'
                        ,10002,'Appl'
                        ,10003,'Resp'
                        ,10004,'User') Nivel,
       decode(a.level_id,10001,'Site'
                        ,10002,c.application_short_name
                        ,10003,b.responsibility_name
                        ,10004,d.user_name) LValue,
       nvl(a.profile_option_value,'Is Null') Value
from apps.fnd_profile_option_values a,
     apps.fnd_responsibility_tl b,
     apps.fnd_application c,
     apps.fnd_user d,
     apps.fnd_profile_options e,
     apps.fnd_profile_options_tl f