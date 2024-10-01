/* Formatted on 10/05/2024 16:15:55 (QP5 v5.396) */
  SELECT ROWID,
         xsr.SEGMENT_RULE_DETAIL_ID,
         xsr.APPLICATION_ID,
         xsr.AMB_CONTEXT_CODE,
         xsr.SEGMENT_RULE_CODE,
         xsr.SEGMENT_RULE_TYPE_CODE,
         xsr.USER_SEQUENCE,
         xsr.VALUE_TYPE_CODE,
         xsr.VALUE_SOURCE_APPLICATION_ID,
         xsr.VALUE_SOURCE_TYPE_CODE,
         xsr.VALUE_SOURCE_CODE,
         xsr.VALUE_CONSTANT,
         xsr.VALUE_CODE_COMBINATION_ID,
         xsr.VALUE_MAPPING_SET_CODE,
         xsr.VALUE_SEGMENT_RULE_APPL_ID,
         xsr.VALUE_SEGMENT_RULE_TYPE_CODE,
         xsr.VALUE_SEGMENT_RULE_CODE,
         xsr.VALUE_ADR_VERSION_NUM,
         xsr.INPUT_SOURCE_APPLICATION_ID,
         xsr.INPUT_SOURCE_TYPE_CODE,
         xsr.INPUT_SOURCE_CODE,
         xsr.VALUE_FLEXFIELD_SEGMENT_CODE,
         xsr.CREATION_DATE,
         xsr.CREATED_BY,
         xsr.LAST_UPDATE_DATE,
         xsr.LAST_UPDATE_LOGIN,
         xsr.LAST_UPDATED_BY
    FROM apps.xla_seg_rule_details xsr
   WHERE     (xsr.APPLICATION_ID = 555)
         AND (xsr.AMB_CONTEXT_CODE = 'DEFAULT')
         AND (xsr.SEGMENT_RULE_CODE LIKE 'PPGBR_PRODUCTLINE')
         AND (xsr.SEGMENT_RULE_TYPE_CODE = 'C')
ORDER BY user_sequence;


select xs.segment_rule_code,
       xs.user_sequence,
       xs.value_constant,
       xc.user_sequence,
       xc.bracket_left_code,
       xc.bracket_right_code,
       xc.value_type_code,
       xc.source_code,
       xc.value_constant,
       xc.line_operator_code,
       xc.logical_operator_code
       
  from apps.xla_seg_rule_details XS,
       APPS.xla_conditions       XC
 WHERE XS.SEGMENT_RULE_CODE = 'PPGUS_PRODUCTLINE' AND
       xc.segment_rule_detail_id = xs.segment_rule_detail_id
       ORDER BY XS.USER_SEQUENCE, xc.USER_SEQUENCE;
       
SELECT * 
  FROM APPS.xla_conditions XC;       

select *
  from apps.xla_seg_rules_fvl
 where application_name = 'Process Manufacturing Financials' AND
       segment_rule_code like '%LINE%' ; 


select *
  from apps.xla_seg_rules_B
 WHERE SEGMENT_RULE_CODE = 'PPGBR_PRODUCTLINE';
 
 where application_name = 'Process Manufacturing Financials' AND
       segment_rule_code like '%LINE%' ; 

apps.xla_seg_rule_details;

--------- Verificar Contas da Renault não existentes na VW --------
select gc.segment1 || '-' || 
       gc.segment2 || '-' ||
       gc.segment3 || '-' ||
       gc.segment4 || '-' ||
       gc.segment5 || '-' ||
       gc.segment6 || '-' ||
       gc.segment7 "Conta Renault",
       gc.attribute2,
       xam.METHOD_NAME  "Actual Allocation Method",
       xamv.METHOD_NAME "Budget Allocation Method",
       (select gc2.segment1 || '-' || 
               gc2.segment2 || '-' ||
               gc2.segment3 || '-' ||
               gc2.segment4 || '-' ||
               gc2.segment5 || '-' ||
               gc2.segment6 || '-' ||
               gc2.segment7 "Conta VW"
          from apps.gl_code_combinations_v gc2
        where  gc2.segment1 = gc.segment1 AND
               gc2.segment2 = '51105'     AND
               gc2.segment3 = gc.segment3 AND
               gc2.segment4 = gc.segment4 AND
               gc2.segment5 = gc.segment5 AND
               gc2.segment6 = (CASE when gc.segment6 = 1491 then '1501'
                                    when gc.segment6 = 1819 then '1833'
                                    else gc.segment6
                               END) AND
               gc2.segment7 = gc.segment7) "Conta_VW"
  from apps.gl_code_combinations_v gc,
       apps.xxgl_allocation_methods_v xam,
       apps.xxgl_allocation_methods_v xamv
 where gc.segment1    = '3545'        AND
       gc.segment2    = '51102'       AND
       xam.method_id  = gc.attribute3 AND
       xamv.method_id = gc.attribute4;
       
select * from apps.xxgl_allocation_methods_v xam;       

select gc.segment1 || '-' || 
       gc.segment2 || '-' ||
       gc.segment3 || '-' ||
       gc.segment4 || '-' ||
       gc.segment5 || '-' ||
       gc.segment6 || '-' ||
       gc.segment7 "Conta Renault",
       gc.attribute2,
       xam.METHOD_NAME  "Actual Allocation Method",
       xamv.METHOD_NAME "Budget Allocation Method",
       (select gc2.segment1 || '-' || 
               gc2.segment2 || '-' ||
               gc2.segment3 || '-' ||
               gc2.segment4 || '-' ||
               gc2.segment5 || '-' ||
               gc2.segment6 || '-' ||
               gc2.segment7 "Conta VW"
          from apps.gl_code_combinations_v gc2
        where  gc2.segment1 = gc.segment1 AND
               gc2.segment2 = '51105'     AND
               gc2.segment3 = gc.segment3 AND
               gc2.segment4 = gc.segment4 AND
               gc2.segment5 = gc.segment5 AND
               gc2.segment6 = (CASE when gc.segment6 = 1491 then '1501'
                                    when gc.segment6 = 1819 then '1833'
                                    else gc.segment6
                               END) AND
               gc2.segment7 = gc.segment7) "Conta_VW",
--               
               gc.segment1 || '-' ||
               '51105'     || '-' ||
               gc.segment3 || '-' ||
               gc.segment4 || '-' ||
               gc.segment5 || '-' ||
               (CASE when gc.segment6 = 1491 then '1501'
                                    when gc.segment6 = 1819 then '1833'
                                    else gc.segment6
                               END)  || '-' ||
               gc.segment7  "Conta Criar"
  from apps.gl_code_combinations_v gc,
       apps.xxgl_allocation_methods_v xam,
       apps.xxgl_allocation_methods_v xamv
 where gc.segment1       = '3545'        AND
       gc.segment2       = '51102'       AND
       xam.method_id(+)  = gc.attribute3 AND
       xamv.method_id(+) = gc.attribute4;   