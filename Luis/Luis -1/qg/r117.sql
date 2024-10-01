   
   /***** Seleciona apenas itens SEM controle de lote - Saldo Oracle e WMAS *****/
   select TRUNC (SYSDATE) AS CREATION_DATE,
          mp.organization_code,
          lot.codigoproduto,
          '' lotefabricacao,
          seq.classeproduto,           
         -- seq.datavencimento,
          sum(seq.quantidadeatual + seq.quantidadebloqueado) qtd_wmas,
          SUM (ohq.primary_transaction_quantity) qtd_ebs,
          sum(seq.quantidadeatual + seq.quantidadebloqueado) - SUM (ohq.primary_transaction_quantity) diferenca
     from documentoentrada doc,                                               
          loteentrada lot,                                                
          loteentradasequencia seq,
          mtl_system_items_b msi,
          mtl_parameters mp,
         (SELECT organization_id,
                 inventory_item_id,
                 subinventory_code,
                 lot_number,
                 SUM (moq.primary_transaction_quantity) primary_transaction_quantity
            FROM apps.mtl_onhand_quantities_detail moq
           GROUP BY organization_id,
                    inventory_item_id,
                    subinventory_code,
                    lot_number) ohq
                                           
    WHERE mp.attribute7                = lot.codigoestabelecimento AND
          ohq.organization_id          = mp.organization_id        AND
          ohq.inventory_item_id        = msi.inventory_item_id     AND
          ohq.subinventory_code        = seq.classeproduto         AND
          ohq.lot_number               is null                     AND
          msi.lot_control_code        != 2                         AND
          msi.segment1                 = lot.codigoproduto         AND
          msi.organization_id          = mp.organization_id        AND
          lot.codigoempresa            = doc.codigoempresa         AND
          lot.tipodocumento            = doc.tipodocumento         AND
          lot.seriedocumento           = doc.seriedocumento        AND
          lot.documentoentrada         = doc.documentoentrada      AND
          seq.codigoestabelecimento    = lot.codigoestabelecimento AND
          seq.loteentrada              = lot.loteentrada           AND
          seq.quantidadebloqueado + seq.quantidadeatual    > 0
      
    --  and doc.codigoestabelecimento = 23
    --  and codigoproduto = '250.01' --'ALQ-3902' --'PA-88-8034'
      
      GROUP BY mp.organization_code,
               seq.classeproduto,
               lot.codigoproduto
               
UNION
   /***** Seleciona apenas itens COM controle de lote - Saldo Oracle e WMAS *****/   
   SELECT TRUNC (SYSDATE) AS CREATION_DATE,
          mp.organization_code,
          lot.codigoproduto,
          seq.lotefabricacao,
          seq.classeproduto,           
          SUM(seq.quantidadeatual + seq.quantidadebloqueado) qtd_wmas,
          SUM (ohq.primary_transaction_quantity) qtd_ebs,
          sum(seq.quantidadeatual + seq.quantidadebloqueado) - SUM (ohq.primary_transaction_quantity) diferenca
     FROM documentoentrada doc,                                               
          loteentrada lot,                                                
          loteentradasequencia seq,
          mtl_system_items_b msi,
          mtl_parameters mp,
         (SELECT organization_id,
                 inventory_item_id,
                 subinventory_code,
                 lot_number,
                 SUM (moq.primary_transaction_quantity) primary_transaction_quantity
            FROM apps.mtl_onhand_quantities_detail moq
           GROUP BY organization_id,
                    inventory_item_id,
                    subinventory_code,
                    lot_number) ohq
                                           
    WHERE mp.attribute7                = lot.codigoestabelecimento AND
          ohq.organization_id          = mp.organization_id        AND
          ohq.inventory_item_id        = msi.inventory_item_id     AND
          ohq.subinventory_code        = seq.classeproduto         AND
          ohq.lot_number               = seq.lotefabricacao        AND
          msi.lot_control_code         = 2                         AND
          msi.segment1                 = lot.codigoproduto         AND
          msi.organization_id          = mp.organization_id        AND
          lot.codigoempresa            = doc.codigoempresa         AND
          lot.tipodocumento            = doc.tipodocumento         AND
          lot.seriedocumento           = doc.seriedocumento        AND
          lot.documentoentrada         = doc.documentoentrada      AND
          seq.codigoestabelecimento    = lot.codigoestabelecimento AND
          seq.loteentrada              = lot.loteentrada           AND
          seq.quantidadebloqueado + seq.quantidadeatual    > 0
      
    --  and doc.codigoestabelecimento = 23
    --  and codigoproduto = '250.01' --'ALQ-3902' --'PA-88-8034'
      
      group by mp.organization_code,
               seq.classeproduto,
               lot.codigoproduto,
               seq.lotefabricacao
               
UNION ALL
   /***** Seleciona apenas itens SEM controle de lote - Saldo WMAS *****/
   SELECT TRUNC (SYSDATE) AS CREATION_DATE,
          mp.organization_code,
          lot.codigoproduto,
          seq.lotefabricacao,
          seq.classeproduto,           
          SUM(seq.quantidadeatual + seq.quantidadebloqueado),
          0,
          0
     FROM documentoentrada doc,                                               
          loteentrada lot,                                                
          loteentradasequencia seq, 
          mtl_parameters mp,
          mtl_system_items_b msi
                                          
    WHERE msi.inventory_item_id NOT IN (SELECT moq.inventory_item_id 
                                          FROM apps.mtl_onhand_quantities_detail moq
                                         WHERE moq.organization_id          = mp.organization_id
                                           AND moq.inventory_item_id        = msi.inventory_item_id
                                           AND moq.subinventory_code        = seq.classeproduto
                                           AND moq.lot_number               IS NULL) AND
          mp.attribute7             = lot.codigoestabelecimento  AND
          msi.lot_control_code     != 2                          AND          
          msi.segment1              = lot.codigoproduto          AND
          msi.organization_id       = mp.organization_id         AND
          mp.attribute7             = lot.codigoestabelecimento  AND
          lot.codigoempresa         = doc.codigoempresa          AND
          lot.tipodocumento         = doc.tipodocumento          AND
          lot.seriedocumento        = doc.seriedocumento         AND
          lot.documentoentrada      = doc.documentoentrada       AND
          seq.codigoestabelecimento = lot.codigoestabelecimento  AND
          seq.loteentrada           = lot.loteentrada            AND
          seq.quantidadebloqueado + seq.quantidadeatual    > 0
      
    --  and doc.codigoestabelecimento = 23      
      
     -- and codigoproduto = '250.01' --'ALQ-3902' --'PA-88-8034'
      
      GROUP BY mp.organization_code,
               seq.classeproduto,
               lot.codigoproduto,
               seq.lotefabricacao
               
UNION
               
   /***** Seleciona apenas itens COM controle de lote - Saldo WMAS *****/
   SELECT TRUNC (SYSDATE) AS CREATION_DATE,
          mp.organization_code,
          lot.codigoproduto,
          seq.lotefabricacao,
          seq.classeproduto,           
          SUM(seq.quantidadeatual + seq.quantidadebloqueado),
          0,
          0
     FROM documentoentrada doc,                                               
          loteentrada lot,                                                
          loteentradasequencia seq, 
          mtl_parameters mp,
          mtl_system_items_b msi
                                          
    WHERE msi.inventory_item_id NOT IN (SELECT moq.inventory_item_id 
                                          FROM apps.mtl_onhand_quantities_detail moq
                                         WHERE moq.organization_id          = mp.organization_id
                                           AND moq.inventory_item_id        = msi.inventory_item_id
                                           AND moq.subinventory_code        = seq.classeproduto
                                           AND moq.lot_number               = seq.lotefabricacao) AND
          mp.attribute7             = lot.codigoestabelecimento  AND
          msi.lot_control_code      = 2                          AND          
          msi.segment1              = lot.codigoproduto          AND
          msi.organization_id       = mp.organization_id         AND
          mp.attribute7             = lot.codigoestabelecimento  AND
          lot.codigoempresa         = doc.codigoempresa          AND
          lot.tipodocumento         = doc.tipodocumento          AND
          lot.seriedocumento        = doc.seriedocumento         AND
          lot.documentoentrada      = doc.documentoentrada       AND
          seq.codigoestabelecimento = lot.codigoestabelecimento  AND
          seq.loteentrada           = lot.loteentrada            AND
          seq.quantidadebloqueado + seq.quantidadeatual    > 0
      
    --  and doc.codigoestabelecimento = 23      
      
     -- and codigoproduto = '250.01' --'ALQ-3902' --'PA-88-8034'
      
      GROUP BY mp.organization_code,
               seq.classeproduto,
               lot.codigoproduto,
               seq.lotefabricacao
               
UNION ALL
   /***** Seleciona apenas itens SEM controle de lote - Saldo ORACLE *****/ 
   SELECT TRUNC (SYSDATE) AS CREATION_DATE,
          mp.organization_code,
          msi.segment1,
          moq.lot_number,
          moq.subinventory_code SUBINVENTARIO,
          0 CANTIDAD,
          SUM (moq.primary_transaction_quantity) TRANSACTION_QUANTITY,
          SUM (moq.primary_transaction_quantity) DIFERENCIA
     FROM mtl_system_items_b msi,
          apps.mtl_onhand_quantities_detail moq,
          mtl_parameters mp
         
    WHERE NOT EXISTS (SELECT 'x'
                        FROM documentoentrada doc,
                             loteentrada lot,
                             loteentradasequencia seq                                           
                       WHERE lot.codigoempresa              = doc.codigoempresa          AND
                             seq.codigoestabelecimento      = mp.attribute7              AND
                             lot.codigoproduto              = msi.segment1               AND
                             seq.quantidadeatual + seq.quantidadebloqueado > 0           AND
                             seq.classeproduto              = moq.subinventory_code      AND
                             lot.tipodocumento              = doc.tipodocumento          AND
                             lot.seriedocumento             = doc.seriedocumento         AND
                             lot.documentoentrada           = doc.documentoentrada       AND
                             seq.codigoestabelecimento      = lot.codigoestabelecimento  AND
                             seq.loteentrada                = lot.loteentrada            AND
                             seq.quantidadebloqueado + seq.quantidadeatual    > 0) AND
          msi.lot_control_code  != 2                                               AND
          msi.organization_id    = moq.organization_id                             AND
          msi.inventory_item_id  = moq.inventory_item_id                           AND
          moq.subinventory_code IN ( SELECT DISTINCT classeproduto sub_inv
                                       FROM loteentradasequencia seq)              AND
          mp.attribute7         IS NOT NULL                                        AND   
          mp.organization_id    = moq.organization_id  
--          msi.segment1 = '250.01' and
   --       moq.organization_id   = 86                    --P_ORG_ID                                

                                        
GROUP BY mp.organization_code,
         msi.segment1,
         moq.lot_number,
         moq.subinventory_code
                  
UNION         
   /***** Seleciona apenas itens COM controle de lote - Saldo ORACLE *****/ 
   SELECT TRUNC (SYSDATE) AS CREATION_DATE,
          mp.organization_code,
          msi.segment1,
          moq.lot_number,
          moq.subinventory_code SUBINVENTARIO,
          0 CANTIDAD,
          SUM (moq.primary_transaction_quantity) TRANSACTION_QUANTITY,
          SUM (moq.primary_transaction_quantity) DIFERENCIA
     FROM mtl_system_items_b msi,
          apps.mtl_onhand_quantities_detail moq,
          mtl_parameters mp
         
    WHERE NOT EXISTS (SELECT 'x'
                        FROM documentoentrada doc,
                             loteentrada lot,
                             loteentradasequencia seq                                           
                       WHERE lot.codigoempresa              = doc.codigoempresa          AND
                             seq.codigoestabelecimento      = mp.attribute7              AND
                             lot.codigoproduto              = msi.segment1               AND
                             seq.classeproduto              = moq.subinventory_code      AND
                             seq.lotefabricacao             = moq.lot_number             AND
                             lot.tipodocumento              = doc.tipodocumento          AND
                             lot.seriedocumento             = doc.seriedocumento         AND
                             lot.documentoentrada           = doc.documentoentrada       AND
                             seq.codigoestabelecimento      = lot.codigoestabelecimento  AND
                             seq.loteentrada                = lot.loteentrada            AND
                             seq.quantidadebloqueado + seq.quantidadeatual    > 0) AND
          msi.lot_control_code   = 2                                               AND
          msi.organization_id    = moq.organization_id                             AND
          msi.inventory_item_id  = moq.inventory_item_id                           AND
          moq.subinventory_code IN ( SELECT DISTINCT classeproduto sub_inv
                                       FROM loteentradasequencia seq)              AND
          mp.attribute7         IS NOT NULL                                        AND   
          mp.organization_id    = moq.organization_id  
--          msi.segment1 = '250.01' and
   --       moq.organization_id   = 86                    --P_ORG_ID                                

                                        
GROUP BY mp.organization_code,
         msi.segment1,
         moq.lot_number,
         moq.subinventory_code
         
order by 1,2,3         ;
