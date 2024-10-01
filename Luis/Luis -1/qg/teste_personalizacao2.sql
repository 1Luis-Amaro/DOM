declare
lc_printer_name varchar (200);
BEGIN
   lc_printer_name := 'teste';
end;
     
 /*       BEGIN
          SELECT printer_name
          INTO   lc_printer_name
          FROM   fnd_concurrent_programs_vl
          WHERE  concurrent_program_name = 'XXPPG_1077_COLOR_LAB_LABEL';
        EXCEPTION
          WHEN OTHERS THEN
            lc_printer_name := NULL;
        END;
        --
        BEGIN
          SELECT default_value
          INTO   v_argument
          FROM   fnd_descr_flex_col_usage_vl
          WHERE  application_id = 20003
          AND    descriptive_flexfield_name =
                 '$SRS$.XXPPG_1077_COLOR_LAB_LABEL'
          AND    end_user_column_name = 'p_directory_temp';
        EXCEPTION
          WHEN OTHERS THEN
            v_argument := 'XXPPG_BR_REPORTS_OUT';
        END;
        --
        lc_boolean := fnd_submit.set_print_options(printer => lc_printer_name
                                                  ,style   => NULL
                                                  ,copies  => 1);
        --Add printer
        lc_boolean1 := fnd_request.add_printer(printer => lc_printer_name
                                              ,copies  => 1);
        ---                                         

        l_sub_conc := apps.fnd_request.submit_request('XXPPG'
                                                     ,'XXPPG_1077_COLOR_LAB_LABEL'
                                                     ,'XXPPG 1077 - Color Lab Label Print'
                                                     ,SYSDATE
                                                     ,FALSE
                                                      --      ,NULL
                                                     ,v_argument --'APPLOUT'
                                                     ,v_argument --'XXPPG_BR_REPORTS_OUT'
                                                     ,:xxppg_batch_cq_cor.batch_id
                                                     ,NULL
                                                     ,'|');
        COMMIT;
        BEGIN
          message('Request ID: ' || l_sub_conc ||
                  ' Submetido Para Impressao de Etiqueta');
          message('Request ID: ' || l_sub_conc);
        END;*/
      END;