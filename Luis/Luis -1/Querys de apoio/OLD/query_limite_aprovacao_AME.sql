SELECT ppf.employee_number "Codigo Funcionario",
       ppf.last_name       "Nome Funcionario",
       paa.ass_attribute11 "PO Req.Compras Produtivas",
       paa.ass_attribute12 "PO Req.Compras Nao Produtivas",
       paa.ass_attribute13 "PO Ordem Compras",
       paa.ass_attribute14 "PO Consultant Contracts",
       paa.ass_attribute15 "AP Prepay Brokers",
       paa.ass_attribute16 "AP Prepay Outros",
       paa.ass_attribute17 "PO Req.Interna Todos",
       paa.ass_attribute18 "AR Credit Notes Nivel",
       ppf.effective_start_date "Data Admissao",
       ppf.effective_end_date   "Data Demissao"    
  FROM per_all_people_f ppf
     , per_all_assignments_f paa
 WHERE ppf.person_id = paa.person_id
