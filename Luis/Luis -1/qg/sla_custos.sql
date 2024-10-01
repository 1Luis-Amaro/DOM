/* Formatted on 10/05/2024 16:15:55 (QP5 v5.396) */
  SELECT ROWID,
         SEGMENT_RULE_DETAIL_ID,
         APPLICATION_ID,
         AMB_CONTEXT_CODE,
         SEGMENT_RULE_CODE,
         SEGMENT_RULE_TYPE_CODE,
         USER_SEQUENCE,
         VALUE_TYPE_CODE,
         VALUE_SOURCE_APPLICATION_ID,
         VALUE_SOURCE_TYPE_CODE,
         VALUE_SOURCE_CODE,
         VALUE_CONSTANT,
         VALUE_CODE_COMBINATION_ID,
         VALUE_MAPPING_SET_CODE,
         VALUE_SEGMENT_RULE_APPL_ID,
         VALUE_SEGMENT_RULE_TYPE_CODE,
         VALUE_SEGMENT_RULE_CODE,
         VALUE_ADR_VERSION_NUM,
         INPUT_SOURCE_APPLICATION_ID,
         INPUT_SOURCE_TYPE_CODE,
         INPUT_SOURCE_CODE,
         VALUE_FLEXFIELD_SEGMENT_CODE,
         CREATION_DATE,
         CREATED_BY,
         LAST_UPDATE_DATE,
         LAST_UPDATE_LOGIN,
         LAST_UPDATED_BY
    FROM apps.xla_seg_rule_details
   WHERE     (APPLICATION_ID = 555)
         AND (AMB_CONTEXT_CODE = 'DEFAULT')
         AND (SEGMENT_RULE_CODE LIKE 'PPGBR_PRODUCTLINE')
         AND (SEGMENT_RULE_TYPE_CODE = 'C')
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
 WHERE XS.SEGMENT_RULE_CODE = 'PPGBR_PRODUCTLINE' AND
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