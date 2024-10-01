CREATE OR REPLACE PACKAGE BODY APPS.XXPPG_INV_OPER_PREACTOR_PKG
IS
  /*------------------------------------------------------------------------------*\
   |   Author     : Carlos Rodriguez                                              |
   |   Created    : 20/05/2014 9:00:00 a.m.                                       |
   |   Purpose    : Programa principal que genera un archivo csv con todos los    |
   |                equipos registrados en Oracle para enviar a Preactor          |
   |   Modify by  :                                                               |
   |   Date       :                                                               |
   |   Description:                                                               |
  \*------------------------------------------------------------------------------*/
PROCEDURE main_env_equipo (p_error_code   IN OUT VARCHAR2
                          ,p_error_desc   IN OUT VARCHAR2)
IS
  l_archivo       UTL_FILE.file_type;
  l_directorio    varchar2(1000);
  l_nm_archivo    varchar2(25);
  l_lin_detalle   varchar2(250);
  l_exist_reg     number := 0;
  l_status_flag   boolean;
  e_error_profile exception;
  e_sin_datos     exception;

BEGIN

    FOR reg IN (SELECT resources, assigned_qty
                  FROM CR_RSRC_DTL
                 WHERE schedule_ind = 1
                   AND inactive_ind = 0
                ORDER BY resources)
    LOOP
      l_exist_reg := l_exist_reg + 1;
      IF l_exist_reg = 1 THEN
          -- Crea nombre de archivo
          l_nm_archivo := 'resourcesin.csv';

    BEGIN
        select val.profile_option_value
          into l_directorio
          from fnd_profile_options opt
              ,fnd_profile_option_values val
        where  opt.profile_option_name = 'XPPGBR_PREACTOR_DIR_OUT'
          and  opt.profile_option_id   = val.profile_option_id
          and  val.level_value         = 0;
    EXCEPTION
        WHEN OTHERS THEN
          raise e_error_profile;
    END;
          -- Crea archivo
          l_archivo := UTL_FILE.fopen (l_directorio, l_nm_archivo, 'W');
          -- Cabecera (Fixo)
           UTL_FILE.put_line (l_archivo,'Code;Name;Finite or Infinite');
      END IF; --IF l_exist_reg = 1 THEN

      FOR reg_qty IN 1..reg.assigned_qty LOOP
          l_lin_detalle := reg.resources||' '||reg_qty||';'||reg.resources||';FINITO';
          UTL_FILE.put_line (l_archivo,l_lin_detalle);
      END LOOP; --reg_qty

    END LOOP; -- reg
     -- Cierra el archivo
    IF UTL_FILE.is_open(l_archivo) THEN
       UTL_FILE.fflush (l_archivo);
       UTL_FILE.fclose (l_archivo);
    END IF;

    IF l_exist_reg = 0 THEN
       raise e_sin_datos;
    END IF;

    p_error_desc := 'O arquivo '||l_nm_archivo||' foi criado no local '||l_directorio;

    fnd_file.put_line(fnd_file.output,'+---------------------------------------------------------------------------+');
    fnd_file.put_line(fnd_file.output,'O arquivo '||l_nm_archivo||' foi criado no local '||l_directorio);
    fnd_file.put_line(fnd_file.output,'+---------------------------------------------------------------------------+');

 EXCEPTION
   WHEN e_error_profile THEN
        p_error_desc := 'Erro encontrado na pesquisa o profile XPPGBR_PREACTOR_DIR_OUT';
        fnd_file.put_line(fnd_file.log,'Erro encontrado na pesquisa o profile XPPGBR_PREACTOR_DIR_OUT');
        l_status_flag := fnd_concurrent.set_completion_status('ERROR','Erro encontrado na pesquisa o profile XPPGBR_PREACTOR_DIR_OUT');
        COMMIT;
   WHEN e_sin_datos THEN
        p_error_desc := 'Sem Entrada De Equipamentos para processamento';
        fnd_file.put_line(fnd_file.log,'Sem Entrada De Equipamentos para processamento');
        l_status_flag := fnd_concurrent.set_completion_status('WARNING','Sem Entrada De Equipamentos para processamento');
        COMMIT;
   WHEN OTHERS THEN
        p_error_desc := SQLERRM;
        fnd_file.put_line(fnd_file.log,p_error_desc);
        l_status_flag := fnd_concurrent.set_completion_status('ERROR',p_error_desc);
        COMMIT;
  END main_env_equipo;

 /*------------------------------------------------------------------------------*\
   |   Author     : Carlos Rodriguez                                              |
   |   Created    : 20/05/2014 9:00:00 a.m.                                       |
   |   Purpose    : Programa principal que genera un archivo csv con todos los    |
   |                grupos de equipos registrados en Oracle para enviar a Preactor|
   |   Modify by  :                                                               |
   |   Date       :                                                               |
   |   Description:                                                               |
  \*------------------------------------------------------------------------------*/
PROCEDURE main_grupo_equip (p_error_code   IN OUT VARCHAR2
                           ,p_error_desc   IN OUT VARCHAR2)
IS
  l_archivo       UTL_FILE.file_type;
  l_directorio    varchar2(1000);
  l_nm_archivo    varchar2(25);
  l_lin_detalle   varchar2(250);
  l_exist_reg     number := 0;
  l_status_flag   boolean;
  e_error_profile exception;
  e_sin_datos     exception;

BEGIN

    FOR reg IN (SELECT resources
                  FROM CR_RSRC_DTL
                 WHERE schedule_ind = 1
                   AND inactive_ind = 0
                ORDER BY resources)
    LOOP
      l_exist_reg := l_exist_reg + 1;
      IF l_exist_reg = 1 THEN
          -- Crea nombre de archivo
          l_nm_archivo := 'resourcesgroup.csv';

    BEGIN
        select val.profile_option_value
          into l_directorio
          from fnd_profile_options opt
              ,fnd_profile_option_values val
        where  opt.profile_option_name = 'XPPGBR_PREACTOR_DIR_OUT'
          and  opt.profile_option_id   = val.profile_option_id
          and  val.level_value         = 0;
    EXCEPTION
        WHEN OTHERS THEN
          raise e_error_profile;
    END;
          -- Crea archivo
          l_archivo := UTL_FILE.fopen (l_directorio, l_nm_archivo, 'W');
          -- Cabecera (Fixo)
           UTL_FILE.put_line (l_archivo,'WORKCENTER;DESCRICAO');
      END IF; --IF l_exist_reg = 1 THEN

        l_lin_detalle := reg.resources||';'||reg.resources;
        UTL_FILE.put_line (l_archivo,l_lin_detalle);

    END LOOP; -- reg
     -- Cierra el archivo
    IF UTL_FILE.is_open(l_archivo) THEN
       UTL_FILE.fflush (l_archivo);
       UTL_FILE.fclose (l_archivo);
    END IF;

    IF l_exist_reg = 0 THEN
       raise e_sin_datos;
    END IF;

    p_error_desc := 'O arquivo '||l_nm_archivo||' foi criado no local '||l_directorio;

    fnd_file.put_line(fnd_file.output,'+---------------------------------------------------------------------------+');
    fnd_file.put_line(fnd_file.output,'O arquivo '||l_nm_archivo||' foi criado no local '||l_directorio);
    fnd_file.put_line(fnd_file.output,'+---------------------------------------------------------------------------+');

 EXCEPTION
   WHEN e_error_profile THEN
        p_error_desc := 'Erro encontrado na pesquisa o profile XPPGBR_PREACTOR_DIR_OUT';
        fnd_file.put_line(fnd_file.log,'Erro encontrado na pesquisa o profile XPPGBR_PREACTOR_DIR_OUT');
        l_status_flag := fnd_concurrent.set_completion_status('ERROR','Erro encontrado na pesquisa o profile XPPGBR_PREACTOR_DIR_OUT');
        COMMIT;
   WHEN e_sin_datos THEN
        p_error_desc := 'Sem Entrada de Grupos de Equipamentos para processamento';
        fnd_file.put_line(fnd_file.log,'Sem Entrada de Grupos de Equipamentos para processamento');
        l_status_flag := fnd_concurrent.set_completion_status('WARNING','Sem Entrada de Grupos de Equipamentos para processamento');
        COMMIT;
   WHEN OTHERS THEN
        p_error_desc := SQLERRM;
        fnd_file.put_line(fnd_file.log,p_error_desc);
        l_status_flag := fnd_concurrent.set_completion_status('ERROR',p_error_desc);
        COMMIT;
  END main_grupo_equip;

  /*------------------------------------------------------------------------------*\
   |   Author     : Carlos Rodriguez                                              |
   |   Created    : 20/05/2014 9:00:00 a.m.                                       |
   |   Purpose    : Programa principal que genera un archivo csv con todos los    |
   |                recursos x grupo de recursos registrados en Oracle para       |
   |                enviar a Preactor                                             |
   |   Modify by  :                                                               |
   |   Date       :                                                               |
   |   Description:                                                               |
  \*------------------------------------------------------------------------------*/
PROCEDURE main_grupo_recurso (p_error_code   IN OUT VARCHAR2
                             ,p_error_desc   IN OUT VARCHAR2)
IS
  l_archivo       UTL_FILE.file_type;
  l_directorio    varchar2(1000);
  l_nm_archivo    varchar2(50);
  l_lin_detalle   varchar2(250);
  l_exist_reg     number := 0;
  l_status_flag   boolean;
  e_error_profile exception;
  e_sin_datos     exception;

BEGIN

    FOR reg IN (SELECT resources, assigned_qty
                  FROM CR_RSRC_DTL
                 WHERE schedule_ind = 1
                   AND inactive_ind = 0
                ORDER BY resources)
    LOOP
      l_exist_reg := l_exist_reg + 1;
      IF l_exist_reg = 1 THEN
          -- Crea nombre de archivo
          l_nm_archivo := 'resourcesbyresourcesgroup.csv';

    BEGIN
        select val.profile_option_value
          into l_directorio
          from fnd_profile_options opt
              ,fnd_profile_option_values val
        where  opt.profile_option_name = 'XPPGBR_PREACTOR_DIR_OUT'
          and  opt.profile_option_id   = val.profile_option_id
          and  val.level_value         = 0;
    EXCEPTION
        WHEN OTHERS THEN
          raise e_error_profile;
    END;
          -- Crea archivo
          l_archivo := UTL_FILE.fopen (l_directorio, l_nm_archivo, 'W');
          -- Cabecera (Fixo)
           UTL_FILE.put_line (l_archivo,'GRUPO DE RECURSOS;RECURSOS VALIDOS');
      END IF; --IF l_exist_reg = 1 THEN

      FOR reg_qty IN 1..reg.assigned_qty LOOP
          l_lin_detalle := reg.resources||';'||reg.resources||' '||reg_qty;
          UTL_FILE.put_line (l_archivo,l_lin_detalle);
      END LOOP; --reg_qty

    END LOOP; -- reg
     -- Cierra el archivo
    IF UTL_FILE.is_open(l_archivo) THEN
       UTL_FILE.fflush (l_archivo);
       UTL_FILE.fclose (l_archivo);
    END IF;

    IF l_exist_reg = 0 THEN
       raise e_sin_datos;
    END IF;

    p_error_desc := 'O arquivo '||l_nm_archivo||' foi criado no local '||l_directorio;

    fnd_file.put_line(fnd_file.output,'+---------------------------------------------------------------------------+');
    fnd_file.put_line(fnd_file.output,'O arquivo '||l_nm_archivo||' foi criado no local '||l_directorio);
    fnd_file.put_line(fnd_file.output,'+---------------------------------------------------------------------------+');

 EXCEPTION
   WHEN e_error_profile THEN
        p_error_desc := 'Erro encontrado na pesquisa o profile XPPGBR_PREACTOR_DIR_OUT';
        fnd_file.put_line(fnd_file.log,'Erro encontrado na pesquisa o profile XPPGBR_PREACTOR_DIR_OUT');
        l_status_flag := fnd_concurrent.set_completion_status('ERROR','Erro encontrado na pesquisa o profile XPPGBR_PREACTOR_DIR_OUT');
        COMMIT;
   WHEN e_sin_datos THEN
        p_error_desc := 'Sem Entrada De Recursos x Grupo de Recursos para processamento';
        fnd_file.put_line(fnd_file.log,'Sem Entrada De Recursos x Grupo de Recursos para processamento');
        l_status_flag := fnd_concurrent.set_completion_status('WARNING','Sem Entrada De Recursos x Grupo de Recursos para processamento');
        COMMIT;
   WHEN OTHERS THEN
        p_error_desc := SQLERRM;
        fnd_file.put_line(fnd_file.log,p_error_desc);
        l_status_flag := fnd_concurrent.set_completion_status('ERROR',p_error_desc);
        COMMIT;
  END main_grupo_recurso;

 /*------------------------------------------------------------------------------*\
   |   Author     : Carlos Rodriguez                                              |
   |   Created    : 17/06/2014 9:00:00 a.m.                                       |
   |   Purpose    : Programa principal que genera un archivo csv con todas las    |
   |                ordernes de compra con saldo abierto y los saldos en almacen  |
   |   Modify by  :                                                               |
   |   Date       :                                                               |
   |   Description:                                                               |
  \*------------------------------------------------------------------------------*/
PROCEDURE main_oc_saldos (p_error_code        IN OUT VARCHAR2
                         ,p_error_desc        IN OUT VARCHAR2
                         ,p_organization_code IN     VARCHAR2)
IS
  l_archivo       UTL_FILE.file_type;
  l_directorio    varchar2(1000);
  l_nm_archivo    varchar2(25);
  l_lin_detalle   varchar2(250);
  l_exist_reg     number := 0;
  l_status_flag   boolean;
  l_order_no      number := 0;
  e_error_profile exception;
  e_sin_datos     exception;

BEGIN

    FOR reg IN (SELECT  hea.segment1||'-'||lin.line_num ORDER_NO
                        ,mtl.segment1                           PART_NO
                        ,mtl.description                        DESCRIPTION
                        ,(nvl(lin.quantity,0) - nvl(loc.quantity_received,0) - nvl(loc.quantity_billed,0) - nvl(loc.quantity_cancelled,0)) QUANTITY
                        ,to_char(loc.promised_date,'YYYYMMDD')  DUE_DATE
                  FROM  po_headers_all         hea
                       ,po_lines_all           lin
                       ,po_line_locations_all  loc
                       ,mtl_system_items_b     mtl
                       ,mtl_parameters         par
                 WHERE  hea.po_header_id      = lin.po_header_id
                   AND  hea.cancel_flag      is null
                   AND  lin.cancel_flag      is null
                   AND  lin.item_id           = mtl.inventory_item_id
                   AND  mtl.organization_id   = par.organization_id
                   AND  par.organization_code = p_organization_code
                   AND  loc.po_header_id      = lin.po_header_id
                   AND  loc.po_line_id        = lin.po_line_id
                   AND  loc.cancel_flag      is null
                   AND  (nvl(lin.quantity,0) - nvl(loc.quantity_received,0) - nvl(loc.quantity_billed,0) - nvl(loc.quantity_cancelled,0)) > 0
                ORDER BY hea.segment1, lin.line_num)
    LOOP
      l_exist_reg := l_exist_reg + 1;
      IF l_exist_reg = 1 THEN
            -- Crea nombre de archivo
            l_nm_archivo := 'supply.csv';

            BEGIN
                select val.profile_option_value
                  into l_directorio
                  from fnd_profile_options opt
                      ,fnd_profile_option_values val
                where  opt.profile_option_name = 'XPPGBR_PREACTOR_DIR_OUT'
                  and  opt.profile_option_id   = val.profile_option_id
                  and  val.level_value         = 0;
            EXCEPTION
                WHEN OTHERS THEN
                  raise e_error_profile;
            END;
            -- Crea archivo
            l_archivo := UTL_FILE.fopen (l_directorio, l_nm_archivo, 'W');
            -- Cabecera (Fixo)
            UTL_FILE.put_line (l_archivo,'ORDER NO.;PART NO.;DESCRIPTION;QUANTITY;DUE DATE ;PRIORITY;ORDER TYPE');
      END IF; --IF l_exist_reg = 1 THEN

      l_lin_detalle := reg.ORDER_NO||';'||
                       reg.PART_NO||';'||
                       reg.DESCRIPTION||';'||
                       reg.QUANTITY||';'||
                       reg.DUE_DATE||';'||
                       NULL||';'||
                       'ORDEM DE COMPRA';

      UTL_FILE.put_line (l_archivo,l_lin_detalle);
    END LOOP; -- reg

    FOR reg2 in (SELECT  ite.segment1        PART_NO
                        ,ite.description     DESCRIPTION
                        ,(sum(han.transaction_quantity) - sum(nvl(res.reservation_quantity,0))) QUANTITY
                  FROM  mtl_onhand_quantities han
                       ,mtl_system_items_b    ite
                       ,mtl_reservations      res
                       ,mtl_parameters        par
                 WHERE han.organization_id   = ite.organization_id
                   AND han.inventory_item_id = ite.inventory_item_id
                   AND han.organization_id   = res.organization_id (+)
                   AND han.inventory_item_id = res.inventory_item_id (+)
                   AND han.transaction_quantity > 0
                   AND han.organization_id   = par.organization_id
                   AND par.organization_code = p_organization_code
                   GROUP BY ite.segment1
                        ,ite.description
                   ORDER BY ite.segment1
                )
    LOOP

      IF l_exist_reg = 0 THEN
            -- Crea nombre de archivo
            l_nm_archivo := 'supply.csv';

            BEGIN
                select val.profile_option_value
                  into l_directorio
                  from fnd_profile_options opt
                      ,fnd_profile_option_values val
                where  opt.profile_option_name = 'XPPGBR_PREACTOR_DIR_OUT'
                  and  opt.profile_option_id   = val.profile_option_id
                  and  val.level_value         = 0;
            EXCEPTION
                WHEN OTHERS THEN
                  raise e_error_profile;
            END;
            -- Crea archivo
            l_archivo := UTL_FILE.fopen (l_directorio, l_nm_archivo, 'W');
            -- Cabecera (Fixo)
            UTL_FILE.put_line (l_archivo,'ORDER NO.;PART NO.;DESCRIPTION;QUANTITY;DUE DATE ;PRIORITY;ORDER TYPE');
      END IF; --IF l_exist_reg = 1 THEN

      l_exist_reg   := l_exist_reg + 1;
      l_order_no    := l_order_no + 1;
      l_lin_detalle := l_order_no||';'||
                       reg2.PART_NO||';'||
                       reg2.DESCRIPTION||';'||
                       reg2.QUANTITY||';'||
                       TO_CHAR(SYSDATE,'YYYYMMDD')||';'||
                       NULL||';'||
                       'Estoque';

      UTL_FILE.put_line (l_archivo,l_lin_detalle);
    END LOOP;
     -- Cierra el archivo
    IF UTL_FILE.is_open(l_archivo) THEN
       UTL_FILE.fflush (l_archivo);
       UTL_FILE.fclose (l_archivo);
    END IF;

    IF l_exist_reg = 0 THEN
       raise e_sin_datos;
    END IF;

    p_error_desc := 'O arquivo '||l_nm_archivo||' foi criado no local '||l_directorio;

    fnd_file.put_line(fnd_file.output,'+---------------------------------------------------------------------------+');
    fnd_file.put_line(fnd_file.output,'O arquivo '||l_nm_archivo||' foi criado no local '||l_directorio);
    fnd_file.put_line(fnd_file.output,'+---------------------------------------------------------------------------+');

 EXCEPTION
   WHEN e_error_profile THEN
        p_error_desc := 'Erro encontrado na pesquisa o profile XPPGBR_PREACTOR_DIR_OUT';
        fnd_file.put_line(fnd_file.log,'Erro encontrado na pesquisa o profile XPPGBR_PREACTOR_DIR_OUT');
        l_status_flag := fnd_concurrent.set_completion_status('ERROR','Erro encontrado na pesquisa o profile XPPGBR_PREACTOR_DIR_OUT');
        COMMIT;
   WHEN e_sin_datos THEN
        p_error_desc := 'Sem Ordens de Compra e Saldos de Estoque para processamento';
        fnd_file.put_line(fnd_file.log,'Sem Ordens de Compra e Saldos de Estoque para processamento');
        l_status_flag := fnd_concurrent.set_completion_status('WARNING','Sem Ordens de Compra e Saldos de Estoque para processamento');
        COMMIT;
   WHEN OTHERS THEN
        p_error_desc := SQLERRM;
        fnd_file.put_line(fnd_file.log,p_error_desc);
        l_status_flag := fnd_concurrent.set_completion_status('ERROR',p_error_desc);
        COMMIT;
  END main_oc_saldos;


 /*------------------------------------------------------------------------------*\
   |   Author     : Carlos Rodriguez                                              |
   |   Created    : 25/06/2014 9:00:00 a.m.                                       |
   |   Purpose    : Programa principal que genera un archivo csv con todas las    |
   |                BOM de Ordenes de Produccion                                  |
   |   Modify by  :                                                               |
   |   Date       :                                                               |
   |   Description:                                                               |
  \*------------------------------------------------------------------------------*/
PROCEDURE main_bom_op (p_error_code        IN OUT VARCHAR2
                      ,p_error_desc        IN OUT VARCHAR2
                      ,p_organization_code IN     VARCHAR2)
IS

  l_archivo       UTL_FILE.file_type;
  l_directorio    varchar2(1000);
  l_nm_archivo    varchar2(25);
  l_lin_detalle   varchar2(250);
  l_exist_reg     number := 0;
  l_status_flag   boolean;
  e_error_profile exception;
  e_sin_datos     exception;

BEGIN

    FOR reg IN (SELECT   gbh.batch_no         ordem
        ,frd.routingstep_no   operacao
        ,msi.segment1         componente
        ,decode(gbh.batch_status,'1',md.plan_qty,DECODE(gbh.batch_status,'2',md.wip_plan_qty,0))quantidade
        ,'0'
    FROM fm_rout_hdr frh
       , fm_rout_dtl frd
       , gmd_operations_b gob
       , gmd_operation_activities goa
       , gmd_recipes grr
       , gme_batch_header gbh
       , gmd_recipe_step_materials grs
       , gmd_recipe_validity_rules grv
       , gme_material_details md
       , fm_matl_dtl          fmd
       , mtl_system_items_b   msi
       , gme_material_details mdp
       , mtl_system_items_b   msip
       ,mtl_parameters        mp
   WHERE 1 = 1
     AND frh.routing_id         = frd.routing_id
     AND gob.oprn_id            = frd.oprn_id
     AND goa.oprn_id            = gob.oprn_id
     AND grr.recipe_id          = grs.recipe_id
     AND frh.routing_id         = grr.routing_id
     AND grs.routingstep_id     = frd.routingstep_id
     AND gbh.routing_id         = frh.routing_id
     AND grv.recipe_validity_rule_id = gbh.recipe_validity_rule_id
     AND grr.recipe_id          = grv.recipe_id
     AND fmd.formula_id         = grr.formula_id
     AND grs.formulaline_id     = fmd.formulaline_id
     AND msi.inventory_item_id  = fmd.inventory_item_id
     AND msi.organization_id    = fmd.organization_id
     AND md.batch_id            = gbh.batch_id
     AND md.formulaline_id      = fmd.formulaline_id
     AND mdp.batch_id           = gbh.batch_id
     AND mdp.line_type          = 1
     AND msip.inventory_item_id = mdp.inventory_item_id
     AND msip.organization_id   = mdp.organization_id
     AND xxppg_inv_oper_preactor_pkg.get_category_segment(msip.inventory_item_id,msip.organization_id) <> 'ACA'
     AND mp.organization_code  = p_organization_code--SUM
     AND gbh.organization_id   = mp.organization_id      
ORDER BY frd.routingstep_no)
    LOOP
      l_exist_reg := l_exist_reg + 1;
      IF l_exist_reg = 1 THEN
            -- Crea nombre de archivo
            l_nm_archivo := 'bomdata.csv';

            BEGIN
                select val.profile_option_value
                  into l_directorio
                  from fnd_profile_options opt
                      ,fnd_profile_option_values val
                where  opt.profile_option_name = 'XPPGBR_PREACTOR_DIR_OUT'
                  and  opt.profile_option_id   = val.profile_option_id
                  and  val.level_value         = 0;
            EXCEPTION
                WHEN OTHERS THEN
                  raise e_error_profile;
            END;
            -- Crea archivo
            l_archivo := UTL_FILE.fopen (l_directorio, l_nm_archivo, 'W');
            -- Cabecera (Fixo)
            UTL_FILE.put_line (l_archivo,'ORDEM;OPERACAO;COMPONENTE;QUANTIDADE;IGNORAR FALTAS');
      END IF; --IF l_exist_reg = 1 THEN

      l_lin_detalle := reg.ordem||';'||
                       reg.operacao||';'||
                       reg.componente||';'||
                       reg.quantidade||';'||
                       '0';

      UTL_FILE.put_line (l_archivo,l_lin_detalle);
    END LOOP; -- reg

    IF UTL_FILE.is_open(l_archivo) THEN
       UTL_FILE.fflush (l_archivo);
       UTL_FILE.fclose (l_archivo);
    END IF;

    IF l_exist_reg = 0 THEN
       raise e_sin_datos;
    END IF;

    p_error_desc := 'O arquivo '||l_nm_archivo||' foi criado no local '||l_directorio;

    fnd_file.put_line(fnd_file.output,'+---------------------------------------------------------------------------+');
    fnd_file.put_line(fnd_file.output,'O arquivo '||l_nm_archivo||' foi criado no local '||l_directorio);
    fnd_file.put_line(fnd_file.output,'+---------------------------------------------------------------------------+');

 EXCEPTION
   WHEN e_error_profile THEN
        p_error_desc := 'Erro encontrado na pesquisa o profile XPPGBR_PREACTOR_DIR_OUT';
        fnd_file.put_line(fnd_file.log,'Erro encontrado na pesquisa o profile XPPGBR_PREACTOR_DIR_OUT');
        l_status_flag := fnd_concurrent.set_completion_status('ERROR','Erro encontrado na pesquisa o profile XPPGBR_PREACTOR_DIR_OUT');
        COMMIT;
   WHEN e_sin_datos THEN
        p_error_desc := 'Sem BOM da Ordem De Produ? para processamento';
        fnd_file.put_line(fnd_file.log,'Sem BOM da Ordem De Produ? para processamento');
        l_status_flag := fnd_concurrent.set_completion_status('WARNING','Sem BOM da Ordem De Produ? para processamento');
        COMMIT;
   WHEN OTHERS THEN
        p_error_desc := SQLERRM;
        fnd_file.put_line(fnd_file.log,p_error_desc);
        l_status_flag := fnd_concurrent.set_completion_status('ERROR',p_error_desc);
        COMMIT;
  END main_bom_op;
  
FUNCTION get_category_segment( P_INVENTORY_ITEM_ID  IN NUMBER
                                ,P_ORGANIZATION_ID    IN NUMBER)
       RETURN VARCHAR2 AS
CURSOR c_category ( PX_INVENTORY_ITEM_ID  IN NUMBER
                   ,PX_ORGANIZATION_ID    IN NUMBER) IS
    SELECT  mc1.segment1
    FROM mtl_item_categories mic1
       , mtl_categories mc1
       , mtl_system_items_b msib1
       , mtl_category_sets mcs1
    WHERE 1 = 1
     AND  mic1.inventory_item_id = PX_INVENTORY_ITEM_ID
     AND mic1.organization_id    = PX_ORGANIZATION_ID
     AND msib1.organization_id = mic1.organization_id
     AND msib1.inventory_item_id = mic1.inventory_item_id
     AND mc1.category_id = mic1.category_id
     AND mcs1.category_set_id   = 1--'Inventory' --en Inventory puedo ver si es acabado o intermediario
     AND mcs1.category_set_id   = mic1.category_set_id
     AND MC1.segment1 IN ( 'ACA', 'INT','SEMI');
 l_category   VARCHAR2(20):='ACA';
 lMessage     VARCHAR2(4000):=null;
BEGIN
  OPEN c_category (P_INVENTORY_ITEM_ID, P_ORGANIZATION_ID);
  FETCH c_category INTO l_category;
  CLOSE c_category;
  RETURN l_category;
EXCEPTION
   WHEN OTHERS THEN
      lMessage := fnd_message.get;
      xx_debug_pk.debug(lMessage);
      RETURN 'ERROR';
END;

 END XXPPG_INV_OPER_PREACTOR_PKG;
/
