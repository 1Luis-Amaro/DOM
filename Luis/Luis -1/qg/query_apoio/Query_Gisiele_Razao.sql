SELECT gjb.DESCRIPTION,
       gl.period_name
      ,TRANSLATE(gjb.name,'|','!') ||' '||TRANSLATE(gh.name,'|','!') lote
      ,to_char(gl.effective_date,'DDMMYYYY') data
      ,gl.je_line_num
      ,cc.concatenated_segments
      ,NVL(gl.accounted_cr,0) accounted_cr 
      ,NVL(gl.accounted_dr,0) accounted_dr
      ,NVL(gl.entered_cr,0) entered_cr 
      ,NVL(gl.entered_dr,0) entered_dr
      ,TRANSLATE(gl.description,'|','!')      
     FROM  apps.gl_code_combinations_kfv cc,
           apps.gl_je_headers        gh,
           apps.gl_je_sources        gs,
           apps.gl_je_categories     gc,
           apps.gl_je_lines          gl,
           apps.gl_je_batches        gjb
    WHERE  gl.code_combination_id         = cc.code_combination_id
       AND gh.je_category                 = gc.je_category_name
       AND gh.je_batch_id                 = gjb.je_batch_id
       AND gh.je_source                   = gs.je_source_name
       AND gh.je_header_id                = gl.je_header_id
       --AND gh.actual_flag                 = 'A'
     --  and trunc(gl.effective_date)        < '01-APR-2018'       
       and concatenated_segments LIKE '3545-%-1252-1252%'                       
       --and gh.je_batch_id  IN(248156,248138)
       and gh.currency_code               <> 'STAT'
       and gjb.status = 'P'
       and gh.ledger_id = 2062 -- 2021 (médio) 2062 (STD)
       and gh.period_name = :periodo;
       --and NVL(gl.accounted_cr,0) <> 0
       
       
select DISTINCT(gh.ledger_id) from apps.gl_je_headers        gh;       