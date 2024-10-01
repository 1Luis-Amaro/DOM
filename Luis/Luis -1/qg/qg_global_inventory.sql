select mat_trans.*,
    msib.inventory_item_id,
    org.organization_code,
    mat_trans.TRANSACTION_DATE as document_date,
    trans_typ.transaction_type_name as movement_type,
    trans_typ.description as movement_type_desc,
    case when UPPER(trans_typ.transaction_type_name) like '%RECEIPT%' THEN prha.segment1 ELSE null END as requisition_no, -- Should we use more than names like RECEIPT?
    case when UPPER(trans_typ.transaction_type_name) like '%SHIP%' THEN ooha.order_number ELSE null END as sales_order_number -- Should we use more than names like SHIP?
from
    inv.mtl_material_transactions   mat_trans,
    inv.mtl_transaction_types       trans_typ,
    inv.mtl_transaction_lot_numbers lot_nos,
    inv.mtl_system_items_b          msib,
    apps.org_organization_definitions org,
    (
    select prha.segment1,prla.requisition_line_id 
    from
        po.po_requisition_headers_all prha,
        po.po_requisition_lines_all prla
    where prha.requisition_header_id = prla.requisition_header_id
    ) prha, 
    (
    select ooha.order_number,oola.line_id, ooha.sold_to_org_id 
    from
        ont.oe_order_headers_all ooha,
        ont.oe_order_lines_all oola,
        apps.hr_organization_units hru 
    where ooha.header_id = oola.header_id 
        and hru.organization_id = ooha.org_id
    ) ooha
where 1=1
    and mat_trans.transaction_type_id = trans_typ.transaction_type_id
    and mat_trans.transaction_id      = lot_nos.transaction_id(+) 
    and mat_trans.organization_id     = lot_nos.organization_id(+)
    and mat_trans.inventory_item_id   = lot_nos.inventory_item_id(+)
    and mat_trans.inventory_item_id   = msib.inventory_item_id
    and mat_trans.organization_id     = msib.organization_id
    and mat_trans.organization_id     = org.organization_id
    and prha.requisition_line_id(+)   = mat_trans.source_line_id
    and mat_trans.source_line_id      = ooha.line_id(+)
    and mat_trans.inventory_item_id   = 12461
    and mat_trans.transaction_date   >= sysdate - 250;

select * from inv.mtl_material_transactions   mat_trans where transaction_id = 1493149181;


   (SELECT wdd.source_line_id, wda.delivery_id
      FROM wsh_delivery_assignments  wda,
           wsh_delivery_details      wdd,
           oe_order_lines_all        oola,
           oe_order_headers_all      ooha
           --mtl_material_transactions mmt,
           --mtl_transaction_types     mtt
     WHERE --delivery_id                = l_delivery_id           AND
           oola.line_id               = wdd.sourcE_line_id      AND
           oola.headeR_id             = ooha.header_id          AND
           wda.delivery_detail_id     = wdd.delivery_detail_id) oe;  AND
          -- mmt.transaction_type_id    = mtt.transaction_type_id AND
          -- mmt.trx_source_line_id     = wdd.source_line_id      AND
          -- mmt.trx_source_delivery_id = wda.delivery_id
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
select --mat_trans.*,
    msib.inventory_item_id,
    org.organization_code,
    mat_trans.TRANSACTION_DATE as document_date,
    trans_typ.transaction_type_name as movement_type,
    trans_typ.description as movement_type_desc,
    case when UPPER(trans_typ.transaction_type_name) like '%RECEIPT%' THEN prha.segment1 ELSE null END as requisition_no, -- Should we use more than names like RECEIPT?
    case when UPPER(trans_typ.transaction_type_name) like 'SALES ORDER ISSUE' THEN ooha.order_number ELSE null END as sales_order_number -- Should we use more than names like SHIP?
from
    inv.mtl_material_transactions   mat_trans,
    inv.mtl_transaction_types       trans_typ,
    inv.mtl_transaction_lot_numbers lot_nos,
    inv.mtl_system_items_b          msib,
    apps.org_organization_definitions org,
    (
    select mat_trans.transaction_id, prh.segment1
  from inv.mtl_material_transactions   mat_trans,
       rcv_transactions                rcv,
       apps.po_requisition_lines_all   prla,
       apps.po_requisition_headers_all prh
  where rcv.transaction_id           = mat_trans.SOURCE_LINE_ID AND
        rcv.po_line_location_id      = prla.line_location_id    AND
        prh.requisition_header_id(+) = prla.requisition_header_id
    ) prha, 
   (SELECT ooha.order_number, oola.line_id, ooha.sold_to_org_id, wdd.source_line_id, wda.delivery_id
      FROM wsh_delivery_assignments  wda,
           wsh_delivery_details      wdd,
           oe_order_lines_all        oola,
           oe_order_headers_all      ooha
     WHERE oola.line_id               = wdd.sourcE_line_id      AND
           oola.headeR_id             = ooha.header_id          AND
           wda.delivery_detail_id     = wdd.delivery_detail_id) ooha
where 1=1
    and mat_trans.transaction_type_id    = trans_typ.transaction_type_id
    and mat_trans.transaction_id         = lot_nos.transaction_id(+) 
    and mat_trans.organization_id        = lot_nos.organization_id(+)
    and mat_trans.inventory_item_id      = lot_nos.inventory_item_id(+)
    and mat_trans.inventory_item_id      = msib.inventory_item_id
    and mat_trans.organization_id        = msib.organization_id
    and mat_trans.organization_id        = org.organization_id
    and prha.transaction_id(+)           = mat_trans.transaction_id
    and mat_trans.trx_source_line_id     = ooha.source_line_id (+)
    and mat_trans.trx_source_delivery_id = ooha.delivery_id (+);
    and mat_trans.inventory_item_id      in (12461,4651)
    and mat_trans.transaction_date      >= sysdate - 250;          
          
          
          
    oe
    
select * from inv.mtl_transaction_types       trans_typ where TRANSACTION_TYPE_NAME like '%Int%';

select * from mtl_material_transactions where transaction_type_id = 62 and trunc(transaction_date) = trunc(sysdate - 173);

select * from mtl_material_transactions 
 where --transaction_type_id = 53 and
       organization_id = 182 and 
       trunc(transaction_date) = trunc(sysdate - 173) and inventory_item_id = 1040669;

select sysdate - 173 from dual;

select segment1 from apps.mtl_system_items_b where inventory_item_id = 1275;

select segment1 from po_haders_all;

select * from apps.mtl_onhand_quantities_detail where lot_number like 'SUM000135' and subinventory_code like 'DHQ';


  (SELECT ooha.order_number, oola.line_id, ooha.sold_to_org_id, wdd.source_line_id, wda.delivery_id
      FROM wsh_delivery_assignments  wda,
           wsh_delivery_details      wdd,
           oe_order_lines_all        oola,
           oe_order_headers_all      ooha
     WHERE oola.line_id               = wdd.sourcE_line_id      AND
           oola.headeR_id             = ooha.header_id          AND
           wda.delivery_detail_id     = wdd.delivery_detail_id) ooha
           
           
SELECT transaction_date as data, param.organization_id,
       lot_nos.lot_number              AS batch_number,
       mat_trans.inventory_item_id     AS material_number,
       hca.account_number              AS customer_acc_number,
      (SELECT trans_typ.transaction_type_name 
         from inv.mtl_transaction_types trans_typ
        where mat_trans.transaction_type_id = trans_typ.transaction_type_id) as trans_type
  FROM inv.mtl_material_transactions  mat_trans
       LEFT JOIN inv.mtl_parameters param
           ON mat_trans.organization_id = param.organization_id
       LEFT JOIN (  SELECT transaction_id,
                           inventory_item_id,
                           organization_id,
                           lot_number,
                           status_id,
                           SUM (primary_quantity)         primary_quantity,
                           SUM (transaction_quantity)     transaction_quantity
                      FROM inv.mtl_transaction_lot_numbers
                  GROUP BY transaction_id,
                           inventory_item_id,
                           organization_id,
                           lot_number,
                           status_id) lot_nos
           ON     mat_trans.transaction_id = lot_nos.transaction_id
              AND mat_trans.organization_id = lot_nos.organization_id
              AND mat_trans.inventory_item_id = lot_nos.inventory_item_id
       LEFT JOIN
       (SELECT ooh.order_number, ool.line_id, ooh.sold_to_org_id
          FROM ont.oe_order_headers_all  ooh
               INNER JOIN ont.oe_order_lines_all ool
                   ON ooh.header_id = ool.header_id
               LEFT JOIN apps.hr_organization_units hru
                   ON hru.organization_id = ooh.org_id) ooha
           ON mat_trans.source_line_id = ooha.line_id
       LEFT JOIN ar.hz_cust_accounts hca
           ON hca.cust_account_id = ooha.sold_to_org_id
where mat_trans.inventory_item_id      in (12461,4651)
   and mat_trans.transaction_date      >= sysdate - 250;          
        