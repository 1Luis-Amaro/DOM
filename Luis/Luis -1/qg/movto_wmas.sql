select to_char(DATAPROCESSAMENTO,'yyyy-mm') dt_proc,
       to_char(DATALOG,'yyyy-mm') dt_log,
       doc.CODIGOESTABELECIMENTO,
       integ.tipointegracao,
       doc.tipodocumento,
       --doc.seriedocumento,
       doc.modelodocumento,
       count(to_char(DATALOG,'yyyy-mm'))
  from apps.integracao       integ,
       apps.documento        doc,
       apps.documentodetalhe ddt
 where --integ.estadointegracao  = 2                         AND
      -- ddt.CODIGOEMPRESA       = '1'                       AND
       doc.sequenciaintegracao    = integ.SEQUENCIAINTEGRACAO AND
       ddt.SEQUENCIAINTEGRACAO    = integ.SEQUENCIAINTEGRACAO AND
       ddt.sequenciadocumento (+) = doc.sequenciadocumento    AND
      ((integ.DATAPROCESSAMENTO is not null AND
        integ.DATAPROCESSAMENTO > SYSDATE - 99 AND
        integ.DATAPROCESSAMENTO  < SYSDATE - 7) or
       (integ.DATALOG            > SYSDATE - 99 AND
        integ.DATALOG            < SYSDATE - 7)) 
       group by to_char(DATAPROCESSAMENTO,'yyyy-mm'),
                to_char(DATAlog,'yyyy-mm'),
                integ.tipointegracao,
                doc.tipodocumento,
                doc.CODIGOESTABELECIMENTO,
         --       doc.seriedocumento,
                doc.modelodocumento;

select sysdate - 99 , sysdate - 7 from dual;

select *
  from apps.integracao       integ,
       apps.documento        doc,
       apps.documentodetalhe ddt
 where integ.estadointegracao  = 2    AND
       doc.sequenciaintegracao = integ.SEQUENCIAINTEGRACAO AND
       ddt.CODIGOEMPRESA       = '1'  AND
       ddt.SEQUENCIAINTEGRACAO = integ.SEQUENCIAINTEGRACAO AND
       integ.DATAPROCESSAMENTO is not null;
       group by to_char(DATAPROCESSAMENTO,'yyyy-mm'), integ.tipointegracao;

select * from apps.documentodetalhesequencia   dds
       
select * from apps.documentodetalhe          ddt;

select * from apps.documento          ddt;

select * from apps.integracao      ;