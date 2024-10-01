/**
XXPPG - Cálculo de Taxas - Associações de Contas
**/
SELECT gl.name
     , god.organization_code
     , xgdd.tipo_custo
     , 'DIRETOS'
     , xgdd.recurso
     , xgdd.ccdesc_desde
     , xgdd.ccdesc_hasta
     , xgdd.rateio
  FROM xxppg.xxppg_gmf_despesa_direta_all xgdd
     , apps.gmf_organization_definitions god
     , apps.gl_ledgers gl
 WHERE god.organization_id = xgdd.organizacion_id
   AND gl.ledger_id = xgdd.ledger_id
UNION ALL
SELECT gl.name
     , god.organization_code
     , xgbi.tipo_custo
     , 'INDIRETOS'
     , xgbi.codigo_base
     , xgbi.ccdesc_desde
     , xgbi.ccdesc_hasta
     , xgbi.base_rateio
  FROM xxppg.xxppg_gmf_base_indireta_all xgbi
     , apps.gmf_organization_definitions god
     , apps.gl_ledgers gl
 WHERE xgbi.organizacion_id = god.organization_id
   AND xgbi.ledger_id = gl.ledger_id
ORDER BY 1
       , 2
       , 3
       , 4
       , 5
       , 6;