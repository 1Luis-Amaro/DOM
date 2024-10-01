select   gli.status
        ,gll.name
        ,NVL(glj.user_je_source_name, gli.user_je_source_name) ORIGEM
        ,trunc(gli.accounting_date) DATA_CONTABIL
        ,gli.period_name
        ,gli.currency_code 
        ,entered_cr
        ,entered_dr
        ,gcc.concatenated_segments
from apps.gl_interface gli
     ,apps.gl_ledgers gll
     ,apps.gl_je_sources glj
     ,apps.gl_code_combinations_kfv gcc
where 1 = 1
and gli.ledger_id = gll.ledger_id (+)
and gli.code_combination_id = gcc.code_combination_id (+)
and gli.user_je_source_name = glj.user_je_source_name (+)
and gli.status not in ('NEW', 'P')