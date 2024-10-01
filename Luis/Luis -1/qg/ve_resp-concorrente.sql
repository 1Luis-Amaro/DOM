SELECT cpt.user_concurrent_program_name "Concurrent Program Name",
       DECODE (rgu.request_unit_type,
               'P', 'Program',
               'S', 'Set',
               rgu.request_unit_type)
          "Unit Type",
       cp.concurrent_program_name "Concurrent Program Short Name",
       rg.application_id "Application ID",
       rg.request_group_name "Request Group Name",
       fat.application_name "Application Name",
       fa.application_short_name "Application Short Name",
       fa.basepath "Basepath",
       cp.output_print_style,
       frv.*
  FROM apps.fnd_request_groups rg,
       apps.fnd_request_group_units rgu,
       apps.fnd_concurrent_programs cp,
       apps.fnd_concurrent_programs_tl cpt,
       apps.fnd_application fa,
       apps.fnd_application_tl fat,
       apps.fnd_responsibility_vl frv
 WHERE rg.request_group_id = rgu.request_group_id
   AND rgu.request_unit_id = cp.concurrent_program_id
   AND cp.concurrent_program_id = cpt.concurrent_program_id
   AND rg.application_id = fat.application_id
   AND fa.application_id = fat.application_id
   and frv.application_id = fat.application_id
   and frv.request_group_id = rg.request_group_id
   AND cpt.language = USERENV ('LANG')
   AND fat.language = USERENV ('LANG')
   AND cp.concurrent_program_name like 'XXPPG%';
   
select * from apps.fnd_application
 where application_id = 20065;
