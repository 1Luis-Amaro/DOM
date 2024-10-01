                 SELECT * --TO_NUMBER(IO.FLEX_FIELD1),
                         -- TO_NUMBER(IO.FLEX_FIELD2),
                        -- DECODE('3127','3127','Drawback Isenção',IO.FLEX_FIELD10)
                --   INTO   v_n_PO_HEADER_ID,
                --          v_n_PO_LINE_ID,
                --          v_s_CFOP_COMP_original
                   FROM   sfwitppg.IS_ITENS_ORDEM IO
                   WHERE  IO.NUM_ORDEM = 50724.82
                   AND    IO.NUM_ITEM  >= 46917;
                
                SELECT TO_NUMBER(IO.FLEX_FIELD1),
                          TO_NUMBER(IO.FLEX_FIELD2),
                          --IO.FLEX_FIELD10
                          --Se for drawback, envia o CFOP Complementar da nota
                          DECODE(r_V_BS_API_NFE_NFC.NF_NATOPE,'3127',v_s_CFOP_COMP,IO.FLEX_FIELD10)
                --   INTO   v_n_PO_HEADER_ID,
                --          v_n_PO_LINE_ID,
                --          v_s_CFOP_COMP_original
                   FROM   sfwitppg.IS_ITENS_ORDEM IO
                   WHERE  IO.NUM_ORDEM = r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_PEDIDO
                   AND    IO.NUM_ITEM  = r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_ITEM_PED;
                   
select * --NF_ITE_PEDIDO, NF_ITE_ITEM_PED
    from   V_BS_API_ITEM_NFE_NFC
    where  NF_ITE_NFID = 11029;                   
    
select *
         --into   r_V_BS_API_NFE_NFC
         from   V_BS_API_NFE_NFC
         where  nf_id = p_n_ID_NOTAFISCAL;   

SELECT NF.CFOP_COMPLEMENTAR
  FROM   BS_NOTA_FISCAL NF
 WHERE  num_nf = 8291;
 
update BS_NOTA_FISCAL NF         
set NF.CFOP_COMPLEMENTAR =  'DRAWBACK_ISENCAO'
 WHERE  num_nf = 8291;
 
 select *
 --into   r_V_BS_API_NFE_NFC
 from   V_BS_API_NFE_NFC
 where  nf_id = 11029;

select * from V_BS_API_NFE_NFC;
 
 SELECT NF.CFOP_COMPLEMENTAR
            INTO   v_s_CFOP_COMP
            FROM   BS_NOTA_FISCAL NF
            WHERE  NF.ID_NOTAFISCAL = r_V_BS_API_NFE_NFC.NF_ID;          
 
 
                   SELECT TO_NUMBER(IO.FLEX_FIELD1),
                          TO_NUMBER(IO.FLEX_FIELD2),
                          --IO.FLEX_FIELD10
                          --Se for drawback, envia o CFOP Complementar da nota
                         DECODE('3127','31271','Drawback Isenção',IO.FLEX_FIELD10)
                --   INTO   v_n_PO_HEADER_ID,
                --          v_n_PO_LINE_ID,
                --          v_s_CFOP_COMP_original
                   FROM   sfwitppg.IS_ITENS_ORDEM IO
                   WHERE  IO.NUM_ORDEM = 50724.82
                   AND    IO.NUM_ITEM  = 46917;
                   
SELECT TO_NUMBER(IO.FLEX_FIELD1),
                          TO_NUMBER(IO.FLEX_FIELD2),
                          DECODE(r_V_BS_API_NFE_NFC.NF_NATOPE,'3127',v_s_CFOP_COMP,IO.FLEX_FIELD10)
                --   INTO   v_n_PO_HEADER_ID,
                --          v_n_PO_LINE_ID,
                --          v_s_CFOP_COMP_original
                   FROM   sfwitppg.IS_ITENS_ORDEM IO
                   WHERE  IO.NUM_ORDEM = 50724.82
                   AND    IO.NUM_ITEM  = 46919;
                   
SELECT TO_NUMBER(IO.FLEX_FIELD1),
                          TO_NUMBER(IO.FLEX_FIELD2),
                          --IO.FLEX_FIELD10
                          --Se for drawback, envia o CFOP Complementar da nota
                          DECODE(r_V_BS_API_NFE_NFC.NF_NATOPE,'3127',v_s_CFOP_COMP,IO.FLEX_FIELD10)
                --   INTO   v_n_PO_HEADER_ID,
                --          v_n_PO_LINE_ID,
                --          v_s_CFOP_COMP_original
                   FROM   sfwitppg.IS_ITENS_ORDEM IO
                   WHERE  IO.NUM_ORDEM = 50724.82
                   AND    IO.NUM_ITEM  = 46920;                                      