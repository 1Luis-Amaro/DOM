SELECT distinct 'Ativo' "Status GTIN (*)",
       msi.global_attribute10 GTIN,
       'PPG' "Marca",
       '' "Numero do Modelo",
       TRANSLATE(TRANSLATE(SUBSTR(MSI.DESCRIPTION,1,80),'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890—¡…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’ƒÀœ÷‹«Ò·ÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ı‰ÎÔˆ¸Áñ∫™≤∞.-!"''`#$%().:[/]{}®+???ø;ß&¥*<>'
                                                       ,'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-'),CHR(10),' ') "Descricao do Produto (*)",
       '' "Data lancamento mercado",
       substr(FISCAL_CLASSIFICATION.categoria,1,4) || '.' || substr(FISCAL_CLASSIFICATION.categoria,5,2) || '.' || substr(FISCAL_CLASSIFICATION.categoria,7,2) "NCM",
       '',         --"CEST",
       '58000000', --"Segmento Produto (*)",
       '58010000', --"FamÌlia Produto (*)",
       '58010100', --"Classe Produto (*)",
       '99999999', --"Sub Classe Produto (*)",
       ' ',         --"",
       ' ',         --"Agencia Reguladora 1",
       ' ',         --"",
       ' ',         --"AgÍncia Reguladora 2",
       ' ',         --"",
       ' ',         --"AgÍncia Reguladora 3",
       ' ',         --"",
       ' ',         --"AgÍncia Reguladora 4",
       ' ',         --"",
       ' ',         --"AgÍncia Reguladora 5",
       'Brazil',    --"PaÌs/Mercado de Destino (*)",
       'Brazil',    --"PaÌs de Origem (*)",
       ' ',         --"Estado",
       ' ',         --"Altura",
       ' ',         --"Altura - UN Medida",
       ' ',         --"Largura",
       ' ',         --"Largura - UN Medida",
       ' ',         --"Profundidade",
       ' ',         --"Profundidade - UN Medida",
       ' ',         --"Conte˙do LÌquido",
       ' ',
       case 
          when nvl(wci.max_load_quantity,0) > 0 then
               ROUND((nvl(msib.unit_weight,0) / nvl(wci.max_load_quantity,1)) + nvl(msi.unit_weight,0),3)
          else ROUND(nvl(msib.unit_weight,0) + nvl(msi.unit_weight,0),3)
       end            "Peso Bruto (*)",
       'kg',        --"Peso Bruto - UN Medida (*)",
       ROUND(nvl(msi.unit_weight,0),3) "Peso LÌquido",
       'kg',        --"Peso LÌq. - UN Medida",
       '' ,         --Tempo mÌnimo (dias) de vida ˙til do produto apÛs produÁ„o
       '',          --"Compartilha Dados?",
       '',          --"ObservaÁ„o",
       '',          --"Tipo de Produto",
       '',          --"Tipo de Pallet",
       '',          --"Fator de Empilhamento",
       '',          --"Quantidade de Camadas por Pallet",
       '',          --"Quantidade de Itens Comerciais em uma ⁄nica Camada",
       '',          --"Quantidade de Itens Comerciais uma Camada Completa",
       '',          --"Quantidade de Camadas Completas em Item Comercial",
       '',          --"GTIN Inferior",
       '',          --"Quantidade",
       '',          --"AlÌquota de Impostos IPI",
       'LocalWeb',  --"Nome URL 1 (*)",
       'ftp://186.202.69.53/ftp_ppg/' || CASE WHEN CUSTO_OPM.categoria like '%ARQ%' THEN 'GVT/' ELSE 'SUM/' END || msi.segment1 || '.jpg' "URL 1 (*)",
       'Foto',      --"Tipo de URL 1 (*)",
       '',          --"Nome URL 2 (*)",
       '',          --"URL 2 (*)",
       '',          --"Tipo de URL 2 (*)",
       '',          --"Nome URL 3 (*)",
       '',          --"URL 3 (*)",
       '',          --"Tipo de URL 3 (*)",
       '',          --"Item Comercial È um modelo",
       '',          --"Unidade de Medida do Pedido",
       '',          --"MUltiplo Qtd Pedido",
       '',          --"Quantidade MÌnima para Pedido",
       '',          --"Tipo da Embalagem",
       '',          --"Temperatura MÌnima de Armazenamento/manuseio",
       '',          --"Unidade de Medida da Temperatura de Armazenamento/manuseio MÌnima",
       '',          --"Temperatura M·xima de Armazenamento/manuseio",
       '',          --"Unidade de Medida da Temperatura Armazenamento/manuseio M·xima",
       ''  " "         --"Indicador de Mercadorias Perigosas"
  FROM APPS.MTL_SYSTEM_ITEMS_b     MSI,
       apps.mtl_system_items_b_ext msie,
       inv.mtl_system_items_b      msib,
       APPS.MTL_PARAMETERS         MP,
       APPS.MTL_SYSTEM_ITEMS_TL    MST,
       wsh.wsh_container_items     wci,
     /*(SELECT XRF.INVENTORY_ITEM_ID,
               XRF.CROSS_REFERENCE
          FROM APPS.MTL_CROSS_REFERENCES_B XRF
         WHERE XRF.CROSS_REFERENCE_TYPE IN ('DUN14')) DUN,*/
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('Categoria de Custo')) CUSTO_OPM,
        --   
       (SELECT xrf.cross_reference, xrf.inventory_item_id
          FROM APPS.MTL_CROSS_REFERENCES_V XRF
         WHERE xrf.CROSS_REFERENCE_TYPE = 'DUN14') xref,
--
--         WHERE xrf.CROSS_REFERENCE_TYPE = 'DUN14'               AND
--               XRF.inventory_item_id    = MSI.INVENTORY_ITEM_ID AND
--               MSI.ORGANIZATION_ID      = 92) xref,
--
  --         
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO,
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('FISCAL_CLASSIFICATION')) FISCAL_CLASSIFICATION,
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('Compras')) COMPRA
--
 WHERE 1 = 1
   AND wci.load_item_id  (+)    = msi.inventory_item_id
   AND wci.preferred_flag (+)   = 'Y'
   AND wci.master_organization_id (+) in (92,86)  
   AND msiB.organization_id (+)       = wci.master_organization_id
   AND msiB.inventory_item_id (+)     = wci.container_item_id
   AND msi.inventory_item_id    = msie.inventory_item_id(+)
   AND MSI.ORGANIZATION_ID      = MP.ORGANIZATION_ID
   AND MSI.ORGANIZATION_ID      = MST.ORGANIZATION_ID
   AND MSI.INVENTORY_ITEM_ID    = MST.INVENTORY_ITEM_ID
   AND MST.LANGUAGE             = 'PTB'
--   AND MSI.ITEM_TYPE NOT IN('GEQ_SERVICO','SERVICO')
   AND MSI.ORGANIZATION_ID   = CUSTO_OPM.ORGANIZATION_ID(+)
   AND MSI.INVENTORY_ITEM_ID = CUSTO_OPM.INVENTORY_ITEM_ID(+)
   AND MSI.ORGANIZATION_ID   = INVENTARIO.ORGANIZATION_ID(+)
   AND MSI.INVENTORY_ITEM_ID = INVENTARIO.INVENTORY_ITEM_ID(+)
   --AND MSI.ORGANIZATION_ID   = FISCAL_CLASSIFICATION.ORGANIZATION_ID(+)
   AND MSI.INVENTORY_ITEM_ID = FISCAL_CLASSIFICATION.INVENTORY_ITEM_ID(+)
   AND MSI.ORGANIZATION_ID   = COMPRA.ORGANIZATION_ID(+)
   AND MSI.INVENTORY_ITEM_ID = COMPRA.INVENTORY_ITEM_ID(+)
   AND MSI.GLOBAL_ATTRIBUTE10 is not null
   AND LENGTH(MSI.GLOBAL_ATTRIBUTE10) > 5
   AND MSI.GLOBAL_ATTRIBUTE10 NOT LIKE '7891310%'
   and msi.organization_id in (92,86)
   AND MSI.SEGMENT1 NOT LIKE 'WO%'
  -- AND MSI.ITEM_TYPE like 'ACA%'
   AND msi.inventory_item_id = xref.inventory_item_id(+)
--   
--   AND SEGMENT1 LIKE '1000%'
   --AND MSI.ITEM_TYPE NOT IN('RECURSOS_MANUTENCAO', 'GEQ_RECURSOS_MANUTENCAO','VEICULOS_OTM', 'AG', 'AA','GEQ_VEICULOS_OTM','GEQ_SERVICO','SERVICO','PH')
--   AND MP.ORGANIZATION_CODE NOT IN('E01','E02','E03','E04','C01','C02','C03','C04','C05','C06')
--   and MSI.ATTRIBUTE1 IN('5415246700')--,'4502003246')
   --AND MP.ORGANIZATION_CODE IN('057')
--   AND MSI.ATTRIBUTE19 = 'Y'
--   AND COMPRA.CATEGORIA  = '000.057.000.309' --'000.030.000.061'
-- AND CLASSE_GL_OPM.CATEGORIA IN('MERCADORIA REVENDA','PRODUTO ACABADO')
--   AND MP.ORGANIZATION_CODE IN('022','ESP','023','024','025','026','027','028','029','030','031','032')
--   AND MSI.BUYER_ID = 4279
--AND MSI.ATTRIBUTE1 IN('5810120373','7590655024','7590655083','7590655202','8600010029')
  --AND MSI.SEGMENT1 IN('1000000130')
--AND MP.ORGANIZATION_CODE IN('037','038','039','040','041','042','043','044','045','046','047','048','049','050','051','052','053','054','055','056','057','058','059','060','061','062','063','064','065','066','067','068','069','070','071','072','073','074','075','076','077','089','090','091','092','093','094','095','096','001','002','003','004','005','006','007','008','009','081','082','083','084','085','086','087','088')
--AND CLASSE_GL_OPM.CATEGORIA IN('MERCADORIA REVENDA','PRODUTO ACABADO')
--AND MSI.PRIMARY_UOM_CODE <> MSI.ATTRIBUTE18
--AND MSI.ATTRIBUTE1 = '8220002482'--IN()
--AND MSI.INVENTORY_ITEM_ID = 5226615
--AND MP.ORGANIZATION_ID = 814
--  AND MSI.ATTRIBUTE9 LIKE '%.%'
ORDER BY 2,3;