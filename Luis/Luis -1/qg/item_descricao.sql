select segment1, organization_id, description
  from apps.mtl_system_items_b
 where item_type in ('ACA','ACARV','MP');
 
select organization_id, organization_code from apps.mtl_parameters;
 
select msi.organization_id,
       mp.organization_code,
       msi.item_type,
       msi.segment1,
       TRANSLATE(TRANSLATE(SUBSTR(MSI.DESCRIPTION,1,180),'|ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890ֱֹֽׁ׃ÚְָּׂÙֲÊ־װÛֳױִֻֿײÜַסביםףתאטלעשגךמפûדץהכןצüח–÷×²°.-!"''`#$%().:[/]{}¨+???¿;§&´*<>'
                                                        ,' ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-'),CHR(10),' ') "Descricao",
       TRANSLATE(TRANSLATE(msit.description,'|ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890ֱֹֽׁ׃ÚְָּׂÙֲÊ־װÛֳױִֻֿײÜַסביםףתאטלעשגךמפûדץהכןצüח–÷×²°.-!"''`#$%().:[/]{}¨+???¿;§&´*<>'
                                           ,' ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-'),CHR(10),' ')  descricao,
       TRANSLATE(TRANSLATE(msit.long_description,'|ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890ֱֹֽׁ׃ÚְָּׂÙֲÊ־װÛֳױִֻֿײÜַסביםףתאטלעשגךמפûדץהכןצüח–÷×²°.-!"''`#$%().:[/]{}¨+???¿;§&´*<>'
                                                ,' ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-'),CHR(10),' ')  descricao,
       msit.language,
       inventario.categoria,
       msi.inventory_item_status_code
  from apps.mtl_system_items_b  msi,
       apps.mtl_system_items_tl msit,
       apps.mtl_parameters      mp,
      (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO       
 where mp.organization_id     = msi.organization_id              and
       msit.inventory_item_id = msi.inventory_item_id            and
       msit.organization_id   = msi.organization_id              and
       msi.organization_id    = 87                               AND --ITM
       msit.language          = 'PTB' AND
       msi.item_type in ('ACA','ACARV','MP','INT')          and
       MSI.ORGANIZATION_ID       = INVENTARIO.ORGANIZATION_ID(+) AND
       MSI.INVENTORY_ITEM_ID     = INVENTARIO.INVENTORY_ITEM_ID(+);
       -- AND
     -- (INVENTARIO.CATEGORIA LIKE '%ACA%' or
     --  INVENTARIO.CATEGORIA LIKE '%MP%' or
     --  INVENTARIO.CATEGORIA LIKE '%INT%')  ;
        
        select msit.description from apps.mtl_system_items_b msi, apps.mtl_system_items_tl msit
         where msit.inventory_item_id = msi.inventory_item_id and
               msit.organization_id   = msi.organization_id   and 
               segment1 = '19A0408286';
               
               
----- Compara descriחדo sem caracteres especiais -----

select msi.organization_id,
       msi.item_type,
       msi.segment1,
       MSI.DESCRIPTION,
       TRANSLATE(TRANSLATE(SUBSTR(MSI.DESCRIPTION,1,180),'|ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890ֱֹֽׁ׃ÚְָּׂÙֲÊ־װÛֳױִֻֿײÜַסביםףתאטלעשגךמפûדץהכןצüח–÷×²°.-!"''`#$%().:[/]{}¨+???¿;§&´*<>'
                                                        ,' ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-'),CHR(10),' ') "Descricao"
  from apps.mtl_system_items_b  msi
 where msi.organization_id    = 87                  AND
       msi.item_type in ('ACA','ACARV','MP','INT')  AND
       MSI.DESCRIPTION <>
       TRANSLATE(TRANSLATE(SUBSTR(MSI.DESCRIPTION,1,180),'|ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890ֱֹֽׁ׃ÚְָּׂÙֲÊ־װÛֳױִֻֿײÜַסביםףתאטלעשגךמפûדץהכןצüח–÷×²°!"''`${}¨???¿;§´*<>'
                                                        ,' ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-'),CHR(10),' ') 
                      
----- Compara descriחדo sem caracteres especiais -----