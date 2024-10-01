
SELECT      mp.organization_code,
            msi.segment1,
            mmt.transaction_type_id ,
            mtt.transaction_type_name,
            gcc.segment3 Prime,
            gcc.segment1 Location,
            gcc.segment2 Minor_Location,
            gcc.segment3 Account,
            gcc.segment4 Sub_Account,
            gcc.segment5 Cost_Centre,
            gcc.segment6 Product_Line,
            gcc.segment7 Inter_Location,
            gc1.concatenated_segments,
            xah.period_name "Period Name",
            xah.accounting_date "Accounting Date",
            gl.currency_code Functional_Currency,
            ROUND (NVL (SUM (accounted_dr), 0) - NVL (SUM (accounted_cr), 0), 2) Functional_Amount,
            xal.currency_code Entered_Currency,
            ROUND (NVL (SUM (entered_dr), 0) - NVL (SUM (entered_cr), 0), 2) Entered_Amount
          --  xal.*
       FROM gmf.gmf_xla_extract_headers gxeh,
            apps.xla_events            xe,
            apps.xla_ae_headers        xah,
            apps.xla_ae_lines          xal,
            apps.mtl_material_transactions mmt,
            apps.gl_code_combinations  gcc,
            apps.gl_code_combinations_kfv gc1,
            apps.gl_ledgers            gl,
            apps.mtl_transaction_types      mtt,
            apps.mtl_system_items_b         msi,
            apps.mtl_parameters             mp
      WHERE     1 = 1                          --gxeh.entity_code= 'INVENTORY'
            AND mp.organization_id        = mmt.organization_id
            AND msi.inventory_item_id     = mmt.inventory_item_id
            AND msi.organization_id       = mmt.organization_id
            AND mtt.transaction_type_id   = mmt.transaction_type_id
         --   AND mmt.transaction_id   IN (2750033127) /*2749866191) -- 2749864494*/
            AND gl.ledger_id              = xah.ledger_id
            AND gl.ledger_id              = gxeh.ledger_id
        --    AND NOT (gl.name LIKE '%STAT%' OR gl.name LIKE '%TEMP%')
            AND gl.ledger_category_code   = 'SECONDARY'
            AND xe.event_id               = gxeh.event_id
            AND xah.event_id              = xe.event_id
            AND xah.application_id        = xe.application_id
            AND xah.ae_header_id          = xal.ae_header_id
            AND xah.application_id        = xal.application_id
            AND xal.ACCOUNTING_CLASS_CODE = 'INVENTORY_VALUATION'
            AND mmt.transaction_id        = gxeh.transaction_id
            AND gc1.code_combination_id   = xal.code_combination_id
            AND gcc.code_combination_id   = xal.code_combination_id
            AND mmt.organization_id = 92 and mmt.transaction_date >= sysdate - 31 AND mmt.SUBINVENTORY_CODE = 'FAB'
    --        AND MMT.inventory_item_id = 6119
          --  and xah.accounting_date <= to_date('2016-12-01','rrrr-mm-dd')
          --  AND gcc.segment3 IN ('1226','1228','1237','1244','1247','1249','1252')
            /*AND EXISTS
                   (SELECT 'X'
                      FROM fnd_flex_values ffv, fnd_flex_value_sets ffvs
                     WHERE     ffv.flex_value_set_id = ffvs.flex_value_set_id
                           AND ffvs.flex_value_set_name =
                                  'XXINV_ARM_INVBAL_ACCOUNT_INCLUSIONS'
                           AND ffv.enabled_flag = 'Y'
                           AND ffv.flex_value = gcc.segment3
                           AND SYSDATE BETWEEN NVL (ffv.start_date_active,
                                                    SYSDATE)
                                           AND NVL (ffv.end_date_active,
                                                    SYSDATE))*/
   GROUP BY gcc.attribute2,
            gcc.segment1,
            gcc.segment2,
            gcc.segment3,
            gcc.segment4,
            gcc.segment5,
            gcc.segment6,
            gcc.segment7,
            gcc.segment8,
            xah.period_name,
            xah.accounting_date,
            gl.currency_code,
            gc1.concatenated_segments,
            xal.currency_code,
            mmt.transaction_type_id,
            mtt.transaction_type_name,
            mp.organization_code,
            msi.segment1
   ORDER BY gcc.segment1, gcc.attribute2, gcc.segment7;

select * from apps.gl_ledgers                 gl;
select * from apps.mtl_material_transactions mmt where organization_id = 92 and transaction_date >= sysdate - 31 AND SUBINVENTORY_CODE = 'FAB';

select * from apps.gl_code_combinations  gcc;

------------ Contabilização do Estoque Michelle Taylor -------------------------
SELECT      mp.organization_code,
            msi.segment1,
            mmt.transaction_type_id ,
            mtt.transaction_type_name,
            gc1.concatenated_segments,
            xah.period_name "Period Name",
            xah.accounting_date "Accounting Date",
            gl.currency_code Functional_Currency,
            xal.currency_code Entered_Currency,
            gxeh.entity_code
       FROM gmf.gmf_xla_extract_headers     gxeh,
            apps.xla_events                 xe,
            apps.xla_ae_headers             xah,
            apps.xla_ae_lines               xal,
            apps.mtl_material_transactions  mmt,
            apps.gl_code_combinations_kfv   gc1,
            apps.gl_ledgers                 gl,
            apps.mtl_transaction_types      mtt,
            apps.mtl_system_items_b         msi,
            apps.mtl_parameters             mp
      WHERE     1 = 1                          --gxeh.entity_code= 'INVENTORY'
            AND mp.organization_id        = mmt.organization_id
            AND msi.inventory_item_id     = mmt.inventory_item_id
            AND msi.organization_id       = mmt.organization_id
            AND mtt.transaction_type_id   = mmt.transaction_type_id
            AND gl.ledger_id              = xah.ledger_id
            AND gl.ledger_id              = gxeh.ledger_id
            AND gl.ledger_category_code   = 'SECONDARY' -- This ledger is related to Standar Costs (USGAP)
            AND xe.event_id               = gxeh.event_id
            AND xah.event_id              = xe.event_id
            AND xah.application_id        = xe.application_id
            AND xah.ae_header_id          = xal.ae_header_id
            AND xah.application_id        = xal.application_id
            AND xal.ACCOUNTING_CLASS_CODE = 'INVENTORY_VALUATION'
            AND mmt.transaction_id        = gxeh.transaction_id
            AND gc1.code_combination_id   = xal.code_combination_id
            AND mmt.transaction_date     >= sysdate - 3 -- Remove the filter by date transaction
            AND ROWNUM < 250
   ORDER BY xah.accounting_date;
   
------------ Contabilização do Estoque Michelle Taylor SIMPLIFICADA ------------------
SELECT      gc1.concatenated_segments,
            xah.period_name "Period Name",
            xah.accounting_date "Accounting Date",
            gl.currency_code Functional_Currency,
            xal.currency_code Entered_Currency,
            gxeh.entity_code
       FROM gmf.gmf_xla_extract_headers     gxeh,
            apps.xla_events                 xe,
            apps.xla_ae_headers             xah,
            apps.xla_ae_lines               xal,
            apps.mtl_material_transactions  mmt,
            apps.gl_code_combinations_kfv   gc1,
            apps.gl_ledgers                 gl
      WHERE     1 = 1
            AND gl.ledger_id              = xah.ledger_id
            AND gl.ledger_id              = gxeh.ledger_id
            AND gl.ledger_category_code   = 'SECONDARY' -- This ledger is related to Standar Costs (USGAP)
            AND xe.event_id               = gxeh.event_id
            AND xah.event_id              = xe.event_id
            AND xah.application_id        = xe.application_id
            AND xah.ae_header_id          = xal.ae_header_id
            AND xah.application_id        = xal.application_id
            AND xal.ACCOUNTING_CLASS_CODE = 'INVENTORY_VALUATION'
            AND mmt.transaction_id        = gxeh.transaction_id
            AND gc1.code_combination_id   = xal.code_combination_id
            AND mmt.transaction_date     >= sysdate - 3 -- Remove the filter by date transaction
   ORDER BY xah.accounting_date;