select mtp.organization_code,
decode(gmb.batch_status, -1, 'CANCELADA', 1, 'PENDENTE', 4 , 'FECHADA', 3 , 'CONCLUIDA', 2, 'WIP', -3 ,'ORDEM PLANEJADA FIRME CONVERTIDA')STATUS_OP,
gmb.batch_no NRO_OP,
msib.segment1 PRODUTO,
fmm.formula_no FORMULA,
fmm.formula_vers VERSAO_FORMULA, 
fmm.formula_desc1 DESCRICAO_FORMULA,
gmb.plan_start_date DATA_INICIO_PLANEJADA,
gmb.actual_start_date DATA_INICIO_REAL,
gmb.actual_cmplt_date DATA_TERMINO_REAL,
gmb.batch_close_date DATA_FECHAMENTO_OP
from apps.gme_batch_header gmb, apps.mtl_system_items_b msib, apps.mtl_parameters mtp, apps.fm_form_mst fmm, apps.fm_matl_dtl fmd
where  gmb.organization_id = mtp.organization_id
and msib.organization_id = fmd.organization_id
and msib.inventory_item_id = fmd.inventory_item_id
and fmm.formula_id = fmd.formula_id
and gmb.formula_id = fmm.formula_id
and fmd.line_type = 1  --produto acabado
order by status_op


