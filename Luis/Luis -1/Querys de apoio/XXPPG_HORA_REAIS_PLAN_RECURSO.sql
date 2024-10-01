/***
XXPPG - OPM - Horas reais e planejadas de Recursos
***/

  SELECT mtp.organization_code org
       , gbh.batch_no
       , flv.meaning status
       , gbsr.resources recurso
       , TO_CHAR (NVL(gbh.batch_close_date,NVL(gbh.actual_cmplt_date,gbh.plan_cmplt_date)), 'mm')   mes_real
       , TO_CHAR (NVL(gbh.batch_close_date,NVL(gbh.actual_cmplt_date,gbh.plan_cmplt_date)), 'yyyy') ano_real
       , SUM (gbsr.plan_rsrc_usage) plan_op
       , SUM (gbsr.actual_rsrc_usage) uso_op
       , gbsr.usage_um udm
       , (SELECT SUM (hrs_plano) hrs
            FROM apps.xxppg_gmf_plano_fabrica_all xgpf
               , apps.cm_cldr_hdr cdh
           WHERE xgpf.organizacion_id = gbh.organization_id
             AND xgpf.anio = cdh.calendar_code
             AND xgpf.recurso = gbsr.resources
             AND TO_CHAR (cdh.start_date, 'yyyy') = TO_CHAR(NVL(gbh.batch_close_date,NVL(gbh.actual_cmplt_date,gbh.plan_cmplt_date)), 'yyyy')  
             )  horas_plano
       , TO_CHAR (NVL(gbh.batch_close_date,NVL(gbh.actual_cmplt_date,gbh.plan_cmplt_date)), 'yyyy')  ano_plano       
    FROM apps.gme_batch_header gbh
       , apps.gme_batch_step_resources gbsr
       , apps.mtl_parameters mtp
       , apps.fnd_lookup_values flv
       , apps.cm_cmpt_mst ccm
   WHERE mtp.organization_id = gbh.organization_id
     AND gbsr.batch_id = gbh.batch_id
     AND gbh.batch_status = flv.lookup_code 
     AND gbsr.cost_cmpntcls_id = ccm.cost_cmpntcls_id
     AND ccm.product_cost_ind = 1
     AND flv.LANGUAGE = userenv('LANG')
     AND flv.lookup_type = 'GME_BATCH_STATUS'
     AND mtp.process_enabled_flag = 'Y'                    --somente OPM, fixo
     AND gbh.batch_type = 0                                           --índice
GROUP BY mtp.organization_code
       , gbh.batch_no
       , TO_CHAR (gbh.batch_close_date, 'mm')
       , gbsr.resources
       , gbsr.usage_um
       , gbh.organization_id       
       , gbh.batch_close_date
       , gbh.actual_cmplt_date
       , gbh.plan_cmplt_date
       , flv.meaning
ORDER BY 6
       , 5
       , 1
       , 2
       , 4;