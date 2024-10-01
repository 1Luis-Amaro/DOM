select MSI.SEGMENT1,
       xp.ATTRIBUTE24 nome_designer_lata,
       xp.ATTRIBUTE25 nome_designer_caixa,
       xp.ATTRIBUTE26 nome_designer_tambor
  from apps.XXPPG_PRINTER_MESSAGES xp,
       APPS.MTL_SYSTEM_ITEMS_b msi
 where xp.message_type = 'INFORMACAO_ADICIONAL_ITEM' and
       msi.inventory_item_id = xp.message_item_id and
       msi.organization_id = 92;
       
select * from apps.XXPPG_PRINTER_MESSAGES xp       