select * from apps.qa_plan_collection_triggers_v qc , apps.qa_plan_transactions_v qt 
 where --qc.low_value = 'KHJ-2929-RES' and
       qt.plan_transaction_id = qc.plan_transaction_id
       and LOW_VALUE = 'LC-55-3939';

select inventory_item_id from apps.mtl_system_items_b where segment1 = 'LC-55-3939';

--select * from apps.QA_SL_CRITERIA_ASSOCIATION_V;
select * from apps.QA_SKIPLOT_ASSOCIATION QSLA;
select * from apps.QA_SKIPLOT_PROCESSES QSLP;

SELECT * from apps.qa_plan_transactions_v where plan_transaction_id = 16100;
select * from apps.QA_PLANS_V; 

QA_SL_CRITERIA_ASSOCIATION_V


select *
  from apps.qa_plan_collection_triggers_v qc,
       apps.qa_plan_transactions_v qt,
       apps.QA_PLANS_V             qp
 where COLLECTION_TRIGGER_DESCRIPTION = 'Item'       and
       low_value                      = 'LC-55-3939' and
       qp.plan_id                     = qt.plan_id   and
       qt.plan_transaction_id         = qc.plan_transaction_id; and organization_id = 182;

select * from apps.QA_SL_SP_RCV_CRITERIA_V where organization_id = 92 AND ITEM = 'LC-55-3939';
select * from apps.qa_plan_transactions_v qt;


select qc.PLAN_NAME,
       qc.TRANSACTION_DESCRIPTION,
       qc.COLLECTION_TRIGGER_DESCRIPTION,
       qc.DATATYPE,
       qc.DECIMAL_PRECISION,
       qc.OPERATOR,
       qc.OPERATOR_MEANING,
       qc.LOW_VALUE,
       qc.LOW_VALUE_ID,
       qc.HIGH_VALUE,
       qc.HIGH_VALUE_ID,
       qt.PLAN_DESCRIPTION,
       qt.MANDATORY_COLLECTION_FLAG,
       qt.MANDATORY_MEANING,
       qt.ENABLED_FLAG,
       qt.ENABLED_MEANING
  from apps.qa_plan_collection_triggers_v qc,
       apps.qa_plan_transactions_v        qt 
 where qt.plan_transaction_id = qc.plan_transaction_id;


select qc.PLAN_NAME                      "PLANO",
       qc.TRANSACTION_DESCRIPTION        "DESCR TRANSACAO",
       qc.COLLECTION_TRIGGER_DESCRIPTION "TIPO COLETA",
       qc.OPERATOR_MEANING "OPERADOR",
       qc.LOW_VALUE "DADO INFERIOR",
       qc.HIGH_VALUE "DADO SUPERIOR",
       qt.PLAN_DESCRIPTION "DESCRICAO PLANO",
       qt.MANDATORY_MEANING "MANDATORIO",
       qt.ENABLED_MEANING "ATIVO"
  from apps.qa_plan_collection_triggers_v qc,
       apps.qa_plan_transactions_v        qt 
 where --qc.collection_trigger_description = Parameter1
       --qc.low_value                      = Parameter2 and
       qt.plan_transaction_id = qc.plan_transaction_id and qt.PLAN_DESCRIPTION like '%PIN';
       
select * from apps.asl;       




---------------------------
SELECT * FROM apps.QA_ACTIONS;
SELECT * FROM apps.QA_ACTION_LOG; --
SELECT * FROM apps.QA_CAR_TYPES;
SELECT * FROM apps.QA_CHARS;
SELECT * FROM apps.QA_CHAR_ACTIONS;
SELECT * FROM apps.QA_CHAR_ACTION_OUTPUTS;
SELECT * FROM apps.QA_CHAR_ACTION_TRIGGERS;
SELECT * FROM apps.QA_CHAR_VALUE_LOOKUPS;
SELECT * FROM apps.QA_CONTROL_LIMITS;
SELECT * FROM apps.QA_CRITERIA;
SELECT * FROM apps.QA_CRITERIA_HEADERS;
SELECT * FROM apps.QA_INTERFACE_ERRORS;
SELECT * FROM apps.QA_PLANS; -- Plano de Coleta
SELECT * FROM apps.QA_PLAN_CHARS;
SELECT * FROM apps.QA_PLAN_CHAR_ACTIONS;
SELECT * FROM apps.QA_PLAN_CHAR_ACTION_OUTPUTS;
SELECT * FROM apps.QA_PLAN_CHAR_ACTION_TRIGGERS;
SELECT * FROM apps.QA_PLAN_CHAR_VALUE_LOOKUPS;
SELECT * FROM apps.QA_PLAN_COLLECTION_TRIGGERS;
SELECT * FROM apps.QA_PLAN_TRANSACTIONS;
SELECT * FROM apps.QA_RESULTS where item_id = 1629775; --
SELECT * FROM apps.QA_RESULTS_INTERFACE;
SELECT * FROM apps.QA_SPECS;
SELECT * FROM apps.QA_SPEC_CHARS;
SELECT * FROM apps.QA_TXN_COLLECTION_TRIGGERS;
SELECT * FROM apps.QA_IN_LISTS;
SELECT * FROM apps.QA_CHART_DATA;
SELECT * FROM apps.QA_CHART_CONSTANTS;
SELECT * FROM apps.QA_RESULTS_UPDATE_HISTORY;
SELECT * FROM apps.QA_BIS_RESULTS;
SELECT * FROM apps.QA_BIS_UPDATE_HISTORY;
SELECT * FROM apps.QA_MQA_LOT_SERIAL_TEMP;
SELECT * FROM apps.QA_BUG1339720_METHOD;
SELECT * FROM apps.QA_BUG1339720_TEMP;
SELECT * FROM apps.QA_SKIPLOT_PROCESSES; --
SELECT * FROM apps.QA_SL_SP_RCV_CRITERIA where item_id = 1629775; --
SELECT * FROM apps.QA_SKIPLOT_ASSOCIATION where criteria_id = 417148; --
SELECT * FROM apps.QA_SKIPLOT_PROCESS_PLANS;
SELECT * FROM apps.QA_SKIPLOT_PROCESS_PLAN_RULES;
SELECT * FROM apps.QA_SKIPLOT_PLAN_STATES where criteria_id = 417148; --
SELECT * FROM apps.QA_SKIPLOT_STATE_HISTORY where criteria_id = 417148; --
SELECT * FROM apps.QA_SKIPLOT_RCV_RESULTS where criteria_id = 417148; --
SELECT * FROM apps.QA_SKIPLOT_LOT_PLANS;
SELECT * FROM apps.QA_SKIPLOT_LOG;
SELECT * FROM apps.QA_SAMPLING_INSP_LEVEL;
SELECT * FROM apps.QA_SAMPLING_PLANS;
SELECT * FROM apps.QA_SAMPLING_ASSOCIATION;
SELECT * FROM apps.QA_SAMPLING_CUSTOM_RULES;
SELECT * FROM apps.QA_SAMPLING_STD_RULES;
SELECT * FROM apps.QA_GRANTED_PRIVILEGES;
SELECT * FROM apps.QA_INSP_COLLECTIONS_TEMP;
SELECT * FROM apps.QA_INSP_PLANS_TEMP;
SELECT * FROM apps.QA_PC_PLAN_RELATIONSHIP;
SELECT * FROM apps.QA_PC_ELEMENT_RELATIONSHIP;
SELECT * FROM apps.QA_PC_CRITERIA;
SELECT * FROM apps.QA_PC_RESULTS_RELATIONSHIP;
SELECT * FROM apps.QA_AHL_MR_DUMMY;
SELECT * FROM apps.QA_CSI_ITEM_INSTANCES_DUMMY;
SELECT * FROM apps.QA_INSP_COLLECTIONS_DTL_TEMP;
SELECT * FROM apps.QA_RCV_LOT_SER_TEMP;
SELECT * FROM apps.QA_SEQ_AUDIT_HISTORY;
SELECT * FROM apps.QA_PERFORMANCE_TEMP;
SELECT * FROM apps.QA_CHAR_INDEXES;
SELECT * FROM apps.QA_CHART_HEADERS;
SELECT * FROM apps.QA_CHART_GENERIC;
SELECT * FROM apps.QA_CHART_CONTROL;
SELECT * FROM apps.QA_DEVICE_INFO;
SELECT * FROM apps.QA_DEVICE_DATA_VALUES;
