   select doc.estadodocumento
         ,doc.codigoempresa
         ,doc.tipodocumento
         ,doc.seriedocumento
         ,doc.documentoentrada
         ,seq.quantidadeatual
         ,lot.codigoestabelecimento
         ,lot.loteentrada
         ,lot.codigoproduto
         ,seq.lotefabricacao
         ,seq.classeproduto
         ,seq.loteentradasequencia
         ,seq.codigoua
         ,seq.datavencimento
     from apps.documentoentrada doc
         ,apps.loteentrada lot
         ,apps.loteentradasequencia seq
    where lot.codigoempresa         = doc.codigoempresa
      and lot.tipodocumento         = doc.tipodocumento
      and lot.seriedocumento        = doc.seriedocumento
      and lot.documentoentrada      = doc.documentoentrada
      and seq.codigoestabelecimento = lot.codigoestabelecimento
      and seq.loteentrada           = lot.loteentrada
      and seq.quantidadeatual       > 0 ;