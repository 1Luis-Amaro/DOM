select * from cll_f189_invoice_types      cfit where description like '%COMPL%' order by 2;

SELECT fnd_profile.value('XPPGBR_TIPO_NF_FRETE') FROM DUAL;

SELECT fnd_profile.value('XXPPG_TIPO_NF_COMPL_IMP') FROM DUAL;


select distinct invoice_type_code "Tipo NF Frete", description "Description"
--into :visible_option_value,
--:profile_option_value
from cll_f189_invoice_types
where trunc(nvl(inactive_date, sysdate-1)) < trunc(sysdate)  and description like 'PAGAMENTO%'
order by 1


COLUMN="\"Tipo NF Frete\"(15), \"Description\"(60)"