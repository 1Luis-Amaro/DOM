select papf.employee_number ppgid
     , papf.employee_number matricula
     , papf.full_name nome
     , gcc.concatenated_segments combinacao_contabil
     , papf.attribute_category valor_contexto
     , papf.attribute1 permite_criar_rateio
from apps.per_all_people_f papf
   , apps.per_all_assignments_f paaf
   , apps.gl_code_combinations_kfv gcc
where 1 = 1
and papf.effective_end_date > sysdate
and papf.person_type_id = 6
and papf.person_id = paaf.person_id
and paaf.effective_end_date > sysdate
and paaf.default_code_comb_id = gcc.code_combination_id
order by papf.full_name