SELECT pp.last_name,
       pa.effective_start_date,
       pa.effective_end_date,
       pa.d_supervisor_id,
       pa.ass_attribute11 PO_REQ_COMPRAS_PRODUTIVAS,
       pa.ass_attribute12 PO_REQ_COMPRAS_NAO_PRODUTIVAS,
       pa.ass_attribute13 PO_ORDEM_COMPRAS,
       pa.ass_attribute19 PO_ACORDO_DE_COMPRAS,
       pa.ass_attribute14 PO_OC_CONSULTANT_CONTRACTS,
       pa.ass_attribute15 AP_PREPAY_BROKERS,
       pa.ass_attribute16 AP_PREPAY_OUTROS,
       pa.ass_attribute17 PO_RE_INTERNA_TODOS
 FROM apps.PER_ASSIGNMENTS_V7 pa,
      apps.PER_PEOPLE_V7 pp
 WHERE pp.person_id = pa.person_id AND
       pa.ass_attribute_category = 'APROVACOES';
