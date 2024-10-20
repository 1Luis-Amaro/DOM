   SELECT xsrd.segment_rule_code
        , decode( lag(xsrd.segment_rule_detail_id, 1) over (ORDER BY xsrd.segment_rule_code, xsrd.user_sequence), xsrd.segment_rule_detail_id, NULL, 
                  '*IR'
                ) IR
                
        , decode( lag(xsrd.segment_rule_detail_id, 1) over (ORDER BY xsrd.segment_rule_code, xsrd.user_sequence), xsrd.segment_rule_detail_id, NULL, 
                  xsrd.user_sequence
                ) rule_user_sequence

        , decode( lag(xsrd.segment_rule_detail_id, 1) over (ORDER BY xsrd.segment_rule_code, xsrd.user_sequence), xsrd.segment_rule_detail_id, NULL, 
                  'TAB'
                ) tab1

        , decode( lag(xsrd.segment_rule_detail_id, 1) over (ORDER BY xsrd.segment_rule_code, xsrd.user_sequence), xsrd.segment_rule_detail_id, NULL,
                  ( SELECT '\'||flv.meaning
                      FROM apps.fnd_lookup_values flv
                     WHERE flv.lookup_type = 'XLA_SEG_VALUE_TYPE'
                       AND flv.lookup_code = xsrd.value_type_code
                       AND flv.LANGUAGE = userenv('lang')          )
                ) rule_value_type_code

        , decode( lag(xsrd.segment_rule_detail_id, 1) over (ORDER BY xsrd.segment_rule_code, xsrd.user_sequence), xsrd.segment_rule_detail_id, NULL, 
                  'TAB'
                ) tab2
                
        , decode( lag(xsrd.segment_rule_detail_id, 1) over (ORDER BY xsrd.segment_rule_code, xsrd.user_sequence), xsrd.segment_rule_detail_id, NULL, 
                  xsrd.value_constant
                ) rule_value_constant

        , decode( lag(xsrd.segment_rule_detail_id, 1) over (ORDER BY xsrd.segment_rule_code, xsrd.user_sequence), xsrd.segment_rule_detail_id, NULL, 
                  '*AO'
                ) AO_IR
        , xc.user_sequence condition_user_sequence
        , 'TAB' tab3
        , ( SELECT '\'||flv.meaning
              FROM apps.fnd_lookup_values flv
             WHERE flv.lookup_type = 'XLA_BRACKET_LEFT'
               AND flv.lookup_code = xc.bracket_left_code
               AND flv.LANGUAGE = userenv('lang')          ) bracket_left_code
        , 'TAB' tab4
        , ( SELECT xs.name
              FROM apps.xla_sources_vl xs
             WHERE xs.application_id IN ( 555, 602 )
               AND xs.source_code = xc.source_code        ) source_name
        , 'TAB' tab5
        , ( SELECT fifs.segment_name
              FROM apps.fnd_id_flex_segments fifs
             WHERE fifs.id_flex_code = 'GL#'
               AND fifs.application_column_name = xc.flexfield_segment_code ) flexfield_segment_code
               
        , DECODE( ( SELECT fifs.segment_name
                      FROM apps.fnd_id_flex_segments fifs
                     WHERE fifs.id_flex_code = 'GL#'
                       AND fifs.application_column_name = xc.flexfield_segment_code ), NULL, NULL, 'TAB') tab6
        , ( SELECT flv.meaning
              FROM apps.fnd_lookup_values flv
             WHERE flv.lookup_type = 'XLA_LINE_OPERATOR_TYPE'
               AND flv.lookup_code = xc.line_operator_code
               AND flv.LANGUAGE = userenv('lang')          ) line_operator_code
        , decode (( SELECT flv.meaning
                      FROM apps.fnd_lookup_values flv
                     WHERE flv.lookup_type = 'XLA_SEG_VALUE_TYPE'
                       AND flv.lookup_code = xc.value_type_code
                       AND flv.LANGUAGE = userenv('lang')), NULL, NULL, 'TAB') tab7
        , ( SELECT flv.meaning
              FROM apps.fnd_lookup_values flv
             WHERE flv.lookup_type = 'XLA_SEG_VALUE_TYPE'
               AND flv.lookup_code = xc.value_type_code
               AND flv.LANGUAGE = userenv('lang')          ) value_type_code
        , decode (( SELECT flv.meaning
                      FROM apps.fnd_lookup_values flv
                     WHERE flv.lookup_type = 'XLA_SEG_VALUE_TYPE'
                       AND flv.lookup_code = xc.value_type_code
                       AND flv.LANGUAGE = userenv('lang')), NULL, NULL, 'TAB') tab8
        , decode(xc.source_code, 'AR_TRX_TYPE_ID'      , ( SELECT rctt.name||' ('||haou.name||')'
                                                             FROM apps.ra_cust_trx_types_all  rctt
                                                                , apps.hr_all_organization_units haou
                                                            WHERE rctt.cust_trx_type_id = xc.value_constant
                                                              AND haou.organization_id = rctt.org_id )
                               , 'COST_CAT_CATEGORY_ID', ( SELECT mc.concatenated_segments
                                                             FROM apps.mtl_categories_kfv mc
                                                            WHERE category_id = xc.value_constant ) 
                               , 'COST_CMPNTCLS_ID'    , ( SELECT ccm.cost_cmpntcls_code
                                                             FROM apps.cm_cmpt_mst ccm
                                                            WHERE ccm.cost_cmpntcls_id = xc.value_constant )
                               , 'ORDER_TYPE'          , ( SELECT ottt.name
                                                             FROM apps.oe_transaction_types_tl ottt
                                                            WHERE transaction_type_id = xc.value_constant
                                                              AND ottt.language = userenv('LANG')          ) 
                               , 'ORGANIZATION_ID'     , ( SELECT mp.organization_code
                                                             FROM apps.mtl_parameters mp
                                                            WHERE mp.organization_id = xc.value_constant )
                               , 'PROCESS_EXECUTION_ENABLED_FLAG'
                                                       , (SELECT flv.meaning
                                                            FROM apps.fnd_lookup_values flv
                                                           WHERE flv.lookup_type = 'GME_YES_NO'
                                                             AND flv.LANGUAGE = userenv('lang')
                                                             AND flv.lookup_code = xc.value_constant )
                               , 'TRANSACTION_TYPE_ID' , (SELECT mtt.transaction_type_name
                                                            FROM apps.mtl_transaction_types mtt
                                                           WHERE mtt.transaction_type_id = xc.value_constant ) 
                               , 'XLA_LEGAL_ENTITY_ID' , ( SELECT xep.name
                                                             FROM apps.xle_entity_profiles xep
                                                            WHERE xep.legal_entity_id = xc.value_constant )  
                               , xc.value_constant
                ) condition_value_constant
        , 'TAB' tab9
        , ( SELECT '\'||flv.meaning
              FROM apps.fnd_lookup_values flv
             WHERE flv.lookup_type = 'XLA_BRACKET_RIGHT'
               AND flv.lookup_code = xc.bracket_right_code
               AND flv.LANGUAGE = userenv('lang')          ) bracket_right_code
        , 'TAB' tab10
        , ( SELECT '\'||flv.meaning
              FROM apps.fnd_lookup_values flv
             WHERE flv.lookup_type = 'XLA_LOGICAL_OPERATOR_TYPE'
               AND flv.lookup_code = xc.logical_operator_code
               AND flv.LANGUAGE = userenv('lang')          ) logical_operator_code
        , 'TAB' tab11
        , decode( lead(xsrd.segment_rule_detail_id, 1) over (ORDER BY xsrd.segment_rule_code, xsrd.user_sequence), xsrd.segment_rule_detail_id, NULL, 
                  '*SAVE' 
                ) save_form
        , decode( lead(xsrd.segment_rule_detail_id, 1) over (ORDER BY xsrd.segment_rule_code, xsrd.user_sequence), xsrd.segment_rule_detail_id, NULL, 
                  '\^{F4}' 
                ) close_form
        , decode( lead(xsrd.segment_rule_code, 1) over (ORDER BY xsrd.segment_rule_code, xsrd.user_sequence), xsrd.segment_rule_code, NULL, 
                  '*PB'
                ) PB
     FROM apps.xla_conditions        xc
        , apps.xla_seg_rule_details  xsrd
    WHERE xc.segment_rule_detail_id (+) = xsrd.segment_rule_detail_id
      AND xsrd.value_constant IS NOT NULL 
    AND xsrd.application_id = 555
      AND xsrd.segment_rule_type_code = 'C'
 ORDER BY xsrd.segment_rule_code
        , xsrd.user_sequence
        , xc.user_sequence;