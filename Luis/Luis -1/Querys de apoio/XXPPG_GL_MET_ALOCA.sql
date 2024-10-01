    select a.method_name,
           a.AB_INDICATOR,
           a.location, 
           a.description, 
           b.start_period, 
           b.end_period, 
           b.description descricao, 
           b.line_type, 
           c.line_num, 
           c.amount_type, 
           c.amount, 
           d.prodline_name
      from apps.xxgl_allocation_methods a,
           apps.xxgl_alloc_method_sequences b,
           apps.xxgl_allocation_method_lines c,
           apps.xxgl_product_lines d
     where a.method_id = b.method_id
       and c.method_id = b.method_id 
       and c.sequence_num = b.sequence_num
       and c.prodline_id = d.prodline_id