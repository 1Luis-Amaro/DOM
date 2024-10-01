SELECT mp.organization_code "Org"
          , a.segment1
          , a.description "Descricao"
          , b.meaning "Cat"
          , d1.category_concat_segs NCM
          , d1.last_update_date
          , f.user_name
          , f.description
          , b.concatenated_segments "Expense Account"
 FROM apps.mtl_system_items a
         , apps.gl_code_combinations_kfv b
         , apps.mtl_item_categories_v d1
         , apps.fnd_lookup_values_vl b
         , apps.mtl_parameters mp
         , apps.FND_USER f
WHERE b.lookup_type = 'ITEM_TYPE'
     AND a.item_type = b.lookup_code
     AND a.inventory_item_id = d1.inventory_item_id
     AND a.organization_id = d1.organization_id
     AND a.expense_account = b.code_combination_id
     AND a.organization_id = mp.organization_id
     and d1.last_updated_by = f.user_id
     and d1.category_set_name = 'FISCAL_CLASSIFICATION'