      select distinct gsf.spec_name, gsf.spec_id,
             msib.segment1,
             msib.item_type,
             gsf.spec_desc,
             gsf.spec_vers,
             gasv.SPEC_VR_ID,
             decode(gasv.spec_type,'I','Inventario','W','WIP','S','Fornecedor') "TIPO SPEC",
             gasv.spec_type,
             gqt.test_class,
             gst.test_display,
             test_method_code,
             test_method_desc,
             gst.target_value_char,
             gst.min_value_char,
             gst.max_value_char,
             gst.min_value_num,
             gst.max_value_num,
             gqt.test_unit,
             gst.print_result_ind
       from apps.gmd_specifications  gsf
           ,apps.gmd_all_spec_vrs    gasv
           ,apps.gmd_spec_tests      gst
           ,apps.GMD_QC_TESTS        gqt
           ,apps.GMD_TEST_METHODS    gtm
           ,apps.mtl_system_items_b   msib
      where  nvl(gasv.end_date,sysdate - 1) < sysdate
        AND (gasv.spec_status = 700 OR
             gasv.spec_status = 900) 
        AND (gsf.spec_status  = 700 OR
             gsf.spec_status  = 900)
       -- AND gasv.spec_vr_id       = gse.original_spec_vr_id
       -- AND gsf.spec_vers = 3
        AND gasv.spec_id          = gsf.spec_id
        AND gst.spec_id           = gsf.spec_id
        AND gqt.test_id           = gst.test_id
        AND gtm.test_method_id    = gqt.test_method_id
        AND msib.inventory_item_id = gsf.inventory_item_id --added by OSS for Call#4036841
        AND msib.organization_id   = 181 --and gsf.spec_name = '300.R0288-BR(AMB)' --92
--        AND msib.segment1          = 'TOBC-070MZ'
      order by 1, 2;

select * from apps.gmd_all_spec_vrs    gasv where spec_id = 73711 order by 2;
select * from apps.mtl_parameters;
select * from apps.gmd_specifications  gsf;
select * from apps.GMD_QC_TESTS        gqt;
select * from apps.GMD_TEST_METHODS;
select * from apps.mtl_system_items_b;

select * from apps.gmd_spec_tests;

select * from qc_text_tbl_vl qtt where qtt.text_code = 74485;

select distinct(spec_status_desc) from gmd_all_spec_vrs    gasv;

/* Formatted on 03/10/2016 13:41:18 (QP5 v5.227.12220.39724) */
  SELECT ROW_ID,
         TEXT_CODE,
         LANG_CODE,
         PARAGRAPH_CODE,
         SUB_PARACODE,
         LINE_NO,
         TEXT,
         CREATION_DATE,
         CREATED_BY,
         LAST_UPDATE_DATE,
         LAST_UPDATED_BY,
         LAST_UPDATE_LOGIN
    FROM QC_TEXT_TBL_VL
   WHERE     text_code = 385202
         AND lang_code = 'US'
         AND paragraph_code = 'DXZZ'
         AND sub_paracode = 0
         AND line_no > 0
ORDER BY line_no
;
