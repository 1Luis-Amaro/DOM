select * from apps.mtl_transaction_types;

select mp.organization_code                              "Estabelecimento",
       msi.segment1                                      "Item",
       msi.item_type                                     "Tipo do Item",
       mmt.subinventory_code                             "Subinventario",
       mtt.transaction_type_name                         "Tipo Transacao",
       mmt.primary_quantity                              "Quantidade",
       mmt.transfer_subinventory                         "Subinventario Transferencia",
       to_char(trunc(mmt.transaction_date),'dd/mm/yyyy') "Data Transacao",
       to_char(trunc(mmt.transaction_date),'mm/yyyy') "Período Transacao",
       (select sum(CMPNT_COST) 
          from apps.cm_cmpt_dtl ccd,
               apps.mtl_system_items_b msip
         where ccd.inventory_item_id = msip.inventory_item_id
           AND msip.segment1         = msi.segment1
           AND msip.organization_id  = msi.organization_id
           AND ccd.organization_id   = msi.organization_id
           AND cost_type_id          = '1005'
           AND COST_ANALYSIS_CODE    = 'MT'
           AND period_id         = (SELECT MAX(cstt.period_id)
                                      FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                     WHERE gps.cost_type_id       = cstt.cost_type_id
                                       AND cstt.period_id         = gps.period_id
                                       AND cstt.delete_mark       = '0'
                                       AND cstt.organization_id   = msi.organization_id
                                       AND cstt.inventory_item_id = msi.inventory_item_id
                                       AND cstt.cost_type_id      = '1005'
                                       AND gps.start_date        <= mmt.transaction_date
                                       AND gps.end_date          >= mmt.transaction_date
                                       AND cmpnt_cost       <> 0)) * mmt.primary_quantity  Custo_item
  from apps.mtl_material_transactions mmt,
       apps.mtl_transaction_types     mtt,
       apps.mtl_system_items_b        msi,
       apps.mtl_parameters            mp
 where mtt.transaction_type_id = mmt.transaction_type_id and
       msi.organization_id     = mmt.organization_id     and
       msi.inventory_item_id   = mmt.inventory_item_id   and
       mp.organization_id      = mmt.organization_id     and
       mp.organization_id      = 86 /*182*/                     and
       mmt.transaction_date >= to_date('2022/05/15','yyyy/mm/dd') and
       mmt.transaction_date <  to_date('2023/01/01','yyyy/mm/dd'); and
       mtt.transaction_type_name in ('Physical Inv Adjust','Cycle Count Adjust');
       
       
-- PIN 13/11/2022 - 31/12/2022
-- GVT 15/05/2022 - 31/12/2022
-- SUM 21/08/2022 - 31/12/2022
        
select organization_code, organization_id from apps.mtl_parameters where organization_code =  'PIN';

SELECT * from cidade_ibge;

select * from apps.xxppg_opm_r147;


 and
       subinventory_code in ('MPDIS','FAGVT','TANK','EMB');


Physical Inv Adjust
Cycle Count Adjust