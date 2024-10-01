
50890 - Semi
51943 - Acabado

SELECT * 
 FROM gme_batch_header 
 WHERE batch_no = 50890 and organization_id = 86; 


 SELECT distinct m.segment1, m.inventory_item_id , d.* 
 FROM gme_material_details d, mtl_system_items m 
 WHERE d.batch_id = 827138 
 AND d.inventory_item_id = m.inventory_item_id; 

 select * from gme_batch_step_resources 
 where batch_id = 827138; 

 SELECT t.* 
 FROM gme_batch_header h, mtl_material_transactions t 
 WHERE h.batch_id = 827138 
 AND h.batch_id = t.transaction_source_id 
 AND t.transaction_source_type_id = 5; 


 SELECT * FROM gme_transaction_pairs 
 WHERE batch_id = 827138 

 SELECT t.* 
 FROM gme_batch_header h, gme_resource_txns t 
 WHERE h.batch_id = 827138 
 AND h.batch_id = t.doc_id 
 AND t.doc_type = 'PROD'; 

 Select * from gmf_xla_extract_headers 
 where source_document_id = 827138 
 and txn_source = 'PM'; 

 Select * from gmf_xla_extract_lines 
 where header_id IN 
 ( Select header_id from 
 gmf_xla_extract_headers where source_document_id = 827138 
 and txn_source = 'PM'); 

---------------------------

50890 - Semi
51943 - Acabado

SELECT * 
 FROM gme_batch_header 
 WHERE batch_no = 51943 and organization_id = 86; 


 SELECT distinct m.segment1, m.inventory_item_id , d.* 
 FROM gme_material_details d, mtl_system_items m 
 WHERE d.batch_id = 853100 
 AND d.inventory_item_id = m.inventory_item_id; 

 select * from gme_batch_step_resources 
 where batch_id = 853100; 

 SELECT t.* 
 FROM gme_batch_header h, mtl_material_transactions t 
 WHERE h.batch_id = 853100 
 AND h.batch_id = t.transaction_source_id 
 AND t.transaction_source_type_id = 5; 


 SELECT * FROM gme_transaction_pairs 
 WHERE batch_id = 853100 

 SELECT t.* 
 FROM gme_batch_header h, gme_resource_txns t 
 WHERE h.batch_id = 853100 
 AND h.batch_id = t.doc_id 
 AND t.doc_type = 'PROD'; 

 Select * from gmf_xla_extract_headers 
 where source_document_id = 853100 
 and txn_source = 'PM'; 

 Select * from gmf_xla_extract_lines 
 where header_id IN 
 ( Select header_id from 
 gmf_xla_extract_headers where source_document_id = 853100 
 and txn_source = 'PM'); 
