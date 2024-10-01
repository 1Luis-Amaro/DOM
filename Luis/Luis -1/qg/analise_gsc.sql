SELECT * FROM apps.global_sc_open_order_data;
SELECT * FROM apps.global_sc_invoice_data;
SELECT * FROM apps.global_sc_purchase_order_data;
SELECT location_code, sbu, item_no,lot_no inv_category_regional ,hist_3month_usage_in_kg   FROM apps.global_sc_inventory_data where item_no like 'PT-62%';
SELECT * FROM apps.GLOBAL_SC_MASTER_LOAD;

select * from apps.xxinv_global_sc_inv_data_temp;

SELECT COUNT(DATE_FOR_EXTRACT_COMPILATION) FROM apps.global_sc_open_order_data;
SELECT COUNT(DATE_FOR_EXTRACT_COMPILATION) FROM apps.global_sc_invoice_data;
SELECT COUNT(DATE_FOR_EXTRACT_COMPILATION) FROM apps.global_sc_purchase_order_data;
SELECT COUNT(DATE_FOR_EXTRACT_COMPILATION) FROM apps.global_sc_inventory_data;
SELECT * FROM apps.GLOBAL_SC_MASTER_LOAD;

select inventory_item_id from apps.mtl_system_items_b where segment1 = '25110.50';

SELECT LOCATION_CODE
       ,WHSE_CODE
       ,WHSE_NAME
       ,SBU
       ,ITEM_NO
       ,ITEM_DESC
       ,LEAD_TIME_IN_DAYS
       ,QTY_ORDERED_IN_KG
       ,QTY_ORDERED_IN_L
       ,QTY_ORDERED_IN_UNITS
       ,PURCHASE_ORDER_NUMBER
       ,TO_CHAR(PO_DELIVERY_DATE,'RRRR-MM-DD') || 'T00:00:00'     PO_DELIVERY_DATE
       ,TO_CHAR(PO_LINE_CREATED_DATE,'RRRR-MM-DD') || 'T00:00:00' PO_LINE_CREATED_DATE
       ,EXTRACT_DATA_SOURCE
       ,TO_CHAR(DATE_FOR_EXTRACT_COMPILATION,'RRRR-MM-DD') || 'T00:00:00' DATE_FOR_EXTRACT_COMPILATION
       ,PROCESSED_FLAG
       ,TO_CHAR(CREATION_DATE,'RRRR-MM-DD') || 'T00:00:00' CREATION_DATE
       ,CREATED_BY
       ,TO_CHAR(LAST_UPDATE_DATE,'RRRR-MM-DD') || 'T00:00:00'  LAST_UPDATE_DATE
       ,LAST_UPDATED_BY
       ,CURRENCY_CODE
       ,SUBSBU
       ,PRICE_PER_LITER
       ,PRICE_PER_KG
       ,PRICE_PER_UNIT
       ,VENDOR_NAME
      FROM global_sc_purchase_order_data;
      
/* Formatted on 14/05/2015 18:21:58 (QP5 v5.227.12220.39724) */
SELECT LOCATION_CODE,
       WHSE_CODE,
       WHSE_NAME,
       SBU,
       ITEM_NO,
       ITEM_DESC,
       LEAD_TIME_IN_DAYS,
       INVENTORY_STATUS_REGIONAL,
       ONHAND_IN_KG,
       ONHAND_IN_L,
       ONHAND_IN_UNITS,
       STORAGE_ADDRESS,
       LOT_NO,
       TO_CHAR(LOT_CREATION_DATE,'RRRR-MM-DD') || 'T00:00:00' LOT_CREATION_DATE,
       TO_CHAR(LOT_EXPIRE_DATE,'RRRR-MM-DD')   || 'T00:00:00' LOT_EXPIRE_DATE,
       STD_COST_PER_KG,
       STD_COST_PER_L,
       STD_COST_PER_UNIT,
       COST_CURRENCY,
       INV_CATEGORY_REGIONAL,
       INV_CATEGORY_REGIONAL_DESC,
       MTO_MTS_REGIONAL,
       CONSIGNMENT_INDICATOR,
       TOTAL_IN_PROCESS_QTY_IN_KG,
       TOTAL_IN_PROCESS_QTY_IN_L,
       TOTAL_IN_PROCESS_QTY_IN_UNITS,
       SAFETY_STOCK_IN_KG,
       SAFETY_STOCK_IN_L,
       SAFETY_STOCK_IN_UNITS,
       MTD_CONS_SALES_IN_KG,
       MTD_CONS_SALES_IN_L,
       MTD_CONS_SALES_IN_UNITS,
       MTD_RECEIPTS_IN_KG,
       MTD_RECEIPTS_IN_L,
       MTD_RECEIPTS_IN_UNITS,
       FCST_3MONTH_USAGE_IN_KG,
       FCST_3MONTH_USAGE_IN_L,
       FCST_3MONTH_USAGE_IN_UNITS,
       HIST_3MONTH_USAGE_IN_KG,
       HIST_3MONTH_USAGE_IN_L,
       HIST_3MONTH_USAGE_IN_UNITS,
       CONSUM_SALES_90_DAYS_IN_KG,
       CONSUM_SALES_90_DAYS_IN_L,
       CONSUM_SALES_90_DAYS_IN_UNITS,
       EXTRACT_DATA_SOURCE,
       TO_CHAR(DATE_FOR_EXTRACT_COMPILATION,'RRRR-MM-DD') || 'T00:00:00' DATE_FOR_EXTRACT_COMPILATION,
       PROCESSED_FLAG,
       TO_CHAR(CREATION_DATE,'RRRR-MM-DD') || 'T00:00:00' CREATION_DATE,
       CREATED_BY,
       TO_CHAR(LAST_UPDATE_DATE,'RRRR-MM-DD') || 'T00:00:00' LAST_UPDATE_DATE,
       LAST_UPDATED_BY,
       SUBSBU
  FROM apps.global_sc_inventory_data where inv_category_regional = 'RM' AND sbu = 'INDUSTRIAL'; --/*WHSE_CODE = 'FA01' AND*/ item_no = 'CR681';0      
  
select distinct(SBU) from apps.global_sc_inventory_data; where inv_category_regional = 'RM'; --AND sbu = 'INDUSTRIAL';  
  
  select plan_qty,original_qty from apps.gme_material_details where plan_qty <> original_qty;
  
  select * from gme_batch_header bth where BATCH_STATUS = 2;
  
  select * from mtl_material_transactions; 