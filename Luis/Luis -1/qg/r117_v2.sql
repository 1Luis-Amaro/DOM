   
   /***** Seleciona apenas itens SEM controle de lote - Saldo Oracle e WMAS *****/
   SELECT 1,
          TRUNC (SYSDATE) AS CREATION_DATE,
          mp.organization_code,
          wmas.codigoproduto,
          '' lotefabricacao,
          wmas.classeproduto,           
          SUM(wmas.qtd_wmas) qtd_wmas,
          SUM (ohq.primary_transaction_quantity) qtd_ebs,
          SUM(wmas.qtd_wmas) - SUM (ohq.primary_transaction_quantity) diferenca
          
     FROM (SELECT lot.codigoestabelecimento,
                  lot.codigoproduto,
                  '' lotefabricacao,
                  seq.classeproduto,           
                  SUM(seq.quantidadeatual + seq.quantidadebloqueado) qtd_wmas
             FROM documentoentrada doc,                                               
                  loteentrada lot,                                                
                  loteentradasequencia seq
            WHERE lot.codigoempresa            = doc.codigoempresa         AND
                  lot.tipodocumento            = doc.tipodocumento         AND
                  lot.seriedocumento           = doc.seriedocumento        AND
                  lot.documentoentrada         = doc.documentoentrada      AND
                  seq.codigoestabelecimento    = lot.codigoestabelecimento AND
                  seq.loteentrada              = lot.loteentrada           AND
                  seq.quantidadebloqueado + seq.quantidadeatual    > 0
                  GROUP BY lot.codigoestabelecimento, lot.codigoproduto, seq.classeproduto) wmas,
                      
          (SELECT organization_id,
                  inventory_item_id,
                  subinventory_code,
                  lot_number,
                  SUM (moq.primary_transaction_quantity) primary_transaction_quantity
             FROM apps.mtl_onhand_quantities_detail moq
            WHERE moq.subinventory_code IN ( SELECT DISTINCT classeproduto sub_inv
                                               FROM loteentradasequencia seq)
            GROUP BY organization_id,
                     inventory_item_id,
                     subinventory_code,
                     lot_number) ohq,
                     
          mtl_system_items_b msi,
          mtl_parameters mp
          
    WHERE mp.attribute7                = wmas.codigoestabelecimento AND
          ohq.organization_id          = mp.organization_id         AND
          ohq.inventory_item_id        = msi.inventory_item_id      AND
          ohq.subinventory_code        = wmas.classeproduto         AND
          ohq.lot_number               is null                      AND
          msi.lot_control_code        != 2                          AND
          msi.segment1                 = wmas.codigoproduto         AND
          msi.organization_id          = mp.organization_id
      
    --  and msi.segment1 = '1037.01' --'ALQ-3902' --'PA-88-8034'    
    --  and doc.codigoestabelecimento = 23
    --  and codigoproduto = '250.01' --'ALQ-3902' --'PA-88-8034'
      
      GROUP BY mp.organization_code,
               wmas.classeproduto,
               wmas.codigoproduto
               
UNION
   /***** Seleciona apenas itens COM controle de lote - Saldo Oracle e WMAS *****/
   SELECT 2, TRUNC (SYSDATE) AS CREATION_DATE,
          mp.organization_code,
          wmas.codigoproduto,
          wmas.lotefabricacao,
          wmas.classeproduto,           
          SUM(wmas.qtd_wmas) qtd_wmas,
          SUM (ohq.primary_transaction_quantity) qtd_ebs,
          SUM(wmas.qtd_wmas) - SUM (ohq.primary_transaction_quantity) diferenca
          
     FROM (SELECT lot.codigoestabelecimento,
                  lot.codigoproduto,
                  seq.lotefabricacao,
                  seq.classeproduto,           
                  SUM(seq.quantidadeatual + seq.quantidadebloqueado) qtd_wmas
             FROM documentoentrada doc,                                               
                  loteentrada lot,                                                
                  loteentradasequencia seq
            WHERE lot.codigoempresa            = doc.codigoempresa         AND
                  lot.tipodocumento            = doc.tipodocumento         AND
                  lot.seriedocumento           = doc.seriedocumento        AND
                  lot.documentoentrada         = doc.documentoentrada      AND
                  seq.codigoestabelecimento    = lot.codigoestabelecimento AND
                  seq.loteentrada              = lot.loteentrada           AND
                  seq.quantidadebloqueado + seq.quantidadeatual    > 0
                  GROUP BY lot.codigoestabelecimento, lot.codigoproduto, seq.classeproduto, seq.lotefabricacao) wmas,
                      
          (SELECT organization_id,
                  inventory_item_id,
                  subinventory_code,
                  lot_number,
                  SUM (moq.primary_transaction_quantity) primary_transaction_quantity
             FROM apps.mtl_onhand_quantities_detail moq
            WHERE moq.subinventory_code IN ( SELECT DISTINCT classeproduto sub_inv
                                               FROM loteentradasequencia seq)
            GROUP BY organization_id,
                     inventory_item_id,
                     subinventory_code,
                     lot_number) ohq,
                     
          mtl_system_items_b msi,
          mtl_parameters mp
          
    WHERE mp.attribute7                = wmas.codigoestabelecimento AND
          ohq.organization_id          = mp.organization_id         AND
          ohq.inventory_item_id        = msi.inventory_item_id      AND
          ohq.subinventory_code        = wmas.classeproduto         AND
          ohq.lot_number               = wmas.lotefabricacao        AND
          msi.lot_control_code         = 2                          AND
          msi.segment1                 = wmas.codigoproduto         AND
          msi.organization_id          = mp.organization_id
      
    
    --  and msi.segment1 = '1037.01' --'ALQ-3902' --'PA-88-8034'    
    --  and doc.codigoestabelecimento = 23
    --  and codigoproduto = '250.01' --'ALQ-3902' --'PA-88-8034'
      
      
      GROUP BY mp.organization_code,
               wmas.classeproduto,
               wmas.codigoproduto,
               wmas.lotefabricacao
               
UNION --PARTE WMAS

   /***** Seleciona apenas itens SEM controle de lote - Saldo WMAS *****/
   SELECT 3, TRUNC (SYSDATE) AS CREATION_DATE,
          mp.organization_code,
          msi.segment1,
          '' lotefabricacao,
          wmas.classeproduto,           
          SUM(wmas.qtd_wmas) qtd_wmas,
          0 qtd_ebs,
          SUM(wmas.qtd_wmas) diferenca
          
     FROM (SELECT mpb.organization_id,
                  msib.inventory_item_id,
                  '' lotefabricacao,
                  seq.classeproduto,           
                  SUM(seq.quantidadeatual + seq.quantidadebloqueado) qtd_wmas
             FROM documentoentrada doc,                                               
                  loteentrada lot,                                                
                  loteentradasequencia seq,
                  mtl_system_items_b msib,
                  mtl_parameters mpb
            WHERE msib.segment1                = lot.codigoproduto          AND
                  msib.organization_id         = mpb.organization_id        AND
                  msib.lot_control_code       != 2                          AND
                  mpb.attribute7               = seq.codigoestabelecimento  AND 
                  lot.codigoempresa            = doc.codigoempresa          AND
                  lot.tipodocumento            = doc.tipodocumento          AND
                  lot.seriedocumento           = doc.seriedocumento         AND
                  lot.documentoentrada         = doc.documentoentrada       AND
                  seq.codigoestabelecimento    = lot.codigoestabelecimento  AND
                  seq.loteentrada              = lot.loteentrada            AND
                  seq.quantidadebloqueado + seq.quantidadeatual    > 0
                  GROUP BY mpb.organization_id, msib.inventory_item_id, seq.classeproduto) wmas,
                      
          (SELECT organization_id,
                  inventory_item_id,
                  subinventory_code,
                  lot_number,
                  SUM (moq.primary_transaction_quantity) primary_transaction_quantity
             FROM apps.mtl_onhand_quantities_detail moq
            WHERE moq.subinventory_code IN ( SELECT DISTINCT classeproduto sub_inv
                                               FROM loteentradasequencia seq)
            GROUP BY organization_id,
                     inventory_item_id,
                     subinventory_code,
                     lot_number) ohq,
         mtl_system_items_b msi,
         mtl_parameters mp
    WHERE ohq.organization_id(+)           = wmas.organization_id   AND
          ohq.inventory_item_id(+)         = wmas.inventory_item_id AND
          ohq.subinventory_code(+)         = wmas.classeproduto     AND
          ohq.lot_number(+)                IS NULL                  AND
          ohq.primary_transaction_quantity IS NULL                  AND
          msi.inventory_item_id            = wmas.inventory_item_id AND
          msi.organization_id              = wmas.organization_id   AND
          mp.organization_id               = wmas.organization_id
          
          
    --  and msi.segment1 = '1037.01' --'ALQ-3902' --'PA-88-8034'          
    --  and doc.codigoestabelecimento = 23
    --  and codigoproduto = '250.01' --'ALQ-3902' --'PA-88-8034'
      
      GROUP BY mp.organization_code,
               msi.segment1,
               wmas.classeproduto
               
UNION
   /***** Seleciona apenas itens COM controle de lote - Saldo Oracle e WMAS *****/
   SELECT 4, TRUNC (SYSDATE) AS CREATION_DATE,
          mp.organization_code,
          msi.segment1,
          wmas.lotefabricacao,
          wmas.classeproduto,           
          SUM(wmas.qtd_wmas) qtd_wmas,
          0 qtd_ebs,
          SUM(wmas.qtd_wmas) diferenca
          
     FROM (SELECT mpb.organization_id,
                  msib.inventory_item_id,
                  seq.lotefabricacao,
                  seq.classeproduto,           
                  SUM(seq.quantidadeatual + seq.quantidadebloqueado) qtd_wmas
             FROM documentoentrada doc,                                               
                  loteentrada lot,                                                
                  loteentradasequencia seq,
                  mtl_system_items_b msib,
                  mtl_parameters mpb
            WHERE msib.segment1                = lot.codigoproduto          AND
                  msib.organization_id         = mpb.organization_id        AND
                  msib.lot_control_code        = 2                          AND
                  mpb.attribute7               = seq.codigoestabelecimento  AND 
                  lot.codigoempresa            = doc.codigoempresa          AND
                  lot.tipodocumento            = doc.tipodocumento          AND
                  lot.seriedocumento           = doc.seriedocumento         AND
                  lot.documentoentrada         = doc.documentoentrada       AND
                  seq.codigoestabelecimento    = lot.codigoestabelecimento  AND
                  seq.loteentrada              = lot.loteentrada            AND
                  seq.quantidadebloqueado + seq.quantidadeatual    > 0
                  GROUP BY mpb.organization_id, msib.inventory_item_id, seq.classeproduto, seq.lotefabricacao) wmas,
                      
          (SELECT organization_id,
                  inventory_item_id,
                  subinventory_code,
                  lot_number,
                  SUM (moq.primary_transaction_quantity) primary_transaction_quantity
             FROM apps.mtl_onhand_quantities_detail moq
            WHERE moq.subinventory_code IN ( SELECT DISTINCT classeproduto sub_inv
                                               FROM loteentradasequencia seq)
            GROUP BY organization_id,
                     inventory_item_id,
                     subinventory_code,
                     lot_number) ohq,
         mtl_system_items_b msi,
         mtl_parameters mp
    WHERE ohq.organization_id(+)           = wmas.organization_id   AND
          ohq.inventory_item_id(+)         = wmas.inventory_item_id AND
          ohq.subinventory_code(+)         = wmas.classeproduto     AND
          ohq.lot_number(+)                = wmas.lotefabricacao    AND
          ohq.primary_transaction_quantity IS NULL                  AND
          msi.inventory_item_id            = wmas.inventory_item_id AND
          msi.organization_id              = wmas.organization_id   AND
          mp.organization_id               = wmas.organization_id
          
          
    --  and msi.segment1 = '1037.01' --'ALQ-3902' --'PA-88-8034'          
    --  and doc.codigoestabelecimento = 23
    --  and codigoproduto = '250.01' --'ALQ-3902' --'PA-88-8034'
      
      GROUP BY mp.organization_code,
               msi.segment1,
               wmas.classeproduto,
               wmas.lotefabricacao
               
UNION

   /***** Seleciona apenas itens SEM controle de lote - Saldo Oracle *****/
   SELECT 5, TRUNC (SYSDATE) AS CREATION_DATE,
          mp.organization_code,
          msi.segment1,
          ohq.lot_number,
          ohq.subinventory_code,           
          0 qtd_wmas,
          SUM(ohq.primary_transaction_quantity) qtd_ebs,
          SUM(ohq.primary_transaction_quantity) * -1 diferenca
          
     FROM (SELECT mpb.organization_id,
                  msib.inventory_item_id,
                  '' lotefabricacao,
                  seq.classeproduto,           
                  SUM(seq.quantidadeatual + seq.quantidadebloqueado) qtd_wmas
             FROM documentoentrada doc,                                               
                  loteentrada lot,                                                
                  loteentradasequencia seq,
                  mtl_system_items_b msib,
                  mtl_parameters mpb
            WHERE msib.segment1                = lot.codigoproduto          AND
                  msib.organization_id         = mpb.organization_id        AND
                  mpb.attribute7               = seq.codigoestabelecimento  AND 
                  lot.codigoempresa            = doc.codigoempresa          AND
                  lot.tipodocumento            = doc.tipodocumento          AND
                  lot.seriedocumento           = doc.seriedocumento         AND
                  lot.documentoentrada         = doc.documentoentrada       AND
                  seq.codigoestabelecimento    = lot.codigoestabelecimento  AND
                  seq.loteentrada              = lot.loteentrada            AND
                  seq.quantidadebloqueado + seq.quantidadeatual    > 0
                  GROUP BY mpb.organization_id, msib.inventory_item_id, seq.classeproduto) wmas,
                      
          (SELECT organization_id,
                  inventory_item_id,
                  subinventory_code,
                  lot_number,
                  SUM (moq.primary_transaction_quantity) primary_transaction_quantity
             FROM apps.mtl_onhand_quantities_detail moq
            WHERE moq.subinventory_code IN ( SELECT DISTINCT classeproduto sub_inv
                                               FROM loteentradasequencia seq)
             
            GROUP BY organization_id,
                     inventory_item_id,
                     subinventory_code,
                     lot_number) ohq,
         mtl_system_items_b msi,
         mtl_parameters mp
         
    WHERE 
          ohq.organization_id              = wmas.organization_id(+)   AND
          ohq.inventory_item_id            = wmas.inventory_item_id(+) AND
          ohq.subinventory_code            = wmas.classeproduto(+)     AND
--          wmas.lotefabricacao              IS NULL                     AND
          wmas.qtd_wmas                    IS NULL                     AND
          ohq.lot_number                   IS NULL                     AND
          msi.inventory_item_id            = ohq.inventory_item_id     AND
          msi.organization_id              = ohq.organization_id       AND
          mp.organization_id               = ohq.organization_id and
          msi.lot_control_code       != 2                          
         
    
    --  and msi.segment1 = '1037.01' --'ALQ-3902' --'PA-88-8034'     
    --  and doc.codigoestabelecimento = 23
    --  and codigoproduto = '250.01' --'ALQ-3902' --'PA-88-8034'
      
      GROUP BY mp.organization_code,
               msi.segment1,
               ohq.subinventory_code,
               ohq.lot_number
               
UNION

   /***** Seleciona apenas itens COM controle de lote - Saldo Oracle *****/
   SELECT 6, TRUNC (SYSDATE) AS CREATION_DATE,
          mp.organization_code,
          msi.segment1,
          ohq.lot_number,
          ohq.subinventory_code,           
          0 qtd_wmas,
          SUM(ohq.primary_transaction_quantity) qtd_ebs,
          SUM(ohq.primary_transaction_quantity) * -1 diferenca
          
     FROM (SELECT mpb.organization_id,
                  msib.inventory_item_id,
                  seq.lotefabricacao,
                  seq.classeproduto,           
                  SUM(seq.quantidadeatual + seq.quantidadebloqueado) qtd_wmas
             FROM documentoentrada doc,                                               
                  loteentrada lot,                                                
                  loteentradasequencia seq,
                  mtl_system_items_b msib,
                  mtl_parameters mpb
            WHERE msib.segment1                = lot.codigoproduto          AND
                  msib.organization_id         = mpb.organization_id        AND
                  mpb.attribute7               = seq.codigoestabelecimento  AND 
                  lot.codigoempresa            = doc.codigoempresa          AND
                  lot.tipodocumento            = doc.tipodocumento          AND
                  lot.seriedocumento           = doc.seriedocumento         AND
                  lot.documentoentrada         = doc.documentoentrada       AND
                  seq.codigoestabelecimento    = lot.codigoestabelecimento  AND
                  seq.loteentrada              = lot.loteentrada            AND
                  seq.quantidadebloqueado + seq.quantidadeatual    > 0
                  GROUP BY mpb.organization_id, msib.inventory_item_id, seq.classeproduto, seq.lotefabricacao) wmas,
                      
          (SELECT organization_id,
                  inventory_item_id,
                  subinventory_code,
                  lot_number,
                  SUM (moq.primary_transaction_quantity) primary_transaction_quantity
             FROM apps.mtl_onhand_quantities_detail moq
            WHERE moq.subinventory_code IN ( SELECT DISTINCT classeproduto sub_inv
                                               FROM loteentradasequencia seq)
            GROUP BY organization_id,
                     inventory_item_id,
                     subinventory_code,
                     lot_number) ohq,
         mtl_system_items_b msi,
         mtl_parameters mp
         
    WHERE 
          ohq.organization_id              = wmas.organization_id(+)   AND
          ohq.inventory_item_id            = wmas.inventory_item_id(+) AND
          ohq.subinventory_code            = wmas.classeproduto(+)     AND
          ohq.lot_number                   = wmas.lotefabricacao(+)    AND
          wmas.qtd_wmas                    IS NULL                     AND
          msi.inventory_item_id            = ohq.inventory_item_id     AND
          msi.organization_id              = ohq.organization_id       AND
          mp.organization_id               = ohq.organization_id       AND
          msi.lot_control_code             = 2                         

         
    
    --  and doc.codigoestabelecimento = 23
    --  and msi.segment1 = '1037.01' --'ALQ-3902' --'PA-88-8034'
      
      GROUP BY mp.organization_code,
               msi.segment1,
               ohq.subinventory_code,
               ohq.lot_number
               
