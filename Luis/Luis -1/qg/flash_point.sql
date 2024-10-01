select * from xxppg.xxgmd_technical_parameters_stg;

select * from XXGMD_GPS_SBTITN_TAB_DET;

SELECT --NFLASHPT,
       --SFLASHPTSCALE,
       --SORGANIZATIONCODE,
       --SMFGCODE,
       lf.*
  FROM xxppg.tblLegacyFormula LF order by 3; where SMFGCODE = 'D800';
  
select * from dba_objects where object_name like '%LEGACY%' and object_type = 'TABLE';

select * from apps.FM_FORM_MST   fm;

select msi.segment1 ITEM,
       fm.formula_no FORMULA,
       fm.formula_vers VERSION,
       fm.formula_status,
       msi.inventory_item_status_code,
       inventario.segment2 BU,
      -- mgl.SORGANIZATIONCODE ORG,
       (select mgl.NFLASHPT 
          from xxppg.MPI_GPSI_LEGACYFORMULA mgl
         where mgl.nformulaid = fm.formula_id and
               mgl.TIMESTAMP = (select max(mgl2.TIMESTAMP)
                                  from xxppg.MPI_GPSI_LEGACYFORMULA mgl2
                                 where mgl2.nformulaid = fm.formula_id)) FLASH_POINT,
       pun.un_number,
       phc.hazard_class,
       mp.organization_code,
      -- MAX(mgl.TIMESTAMP),
      (select msip.segment1
         from apps.FM_FORM_MST   fm1,
              apps.FM_MATL_DTL   fmd1,
              apps.FM_MATL_DTL   fmp,
              apps.mtl_system_items_b msip
        where fmd1.inventory_item_id = msi.inventory_item_id     and
              fmd1.line_type         = -1                        and
              fm1.formula_id         = fmd1.formula_id           and
              fmp.formula_id         = fm1.formula_id            and
              fmp.line_type          = 1                         and
              msip.inventory_item_id = fmp.inventory_item_id     and
              msip.organization_id   = fm1.owner_organization_id and
              msip.item_type         = 'ACA'                     and
              rownum = 1) Acabado
  from --xxppg.MPI_GPSI_LEGACYFORMULA mgl,
       apps.FM_FORM_MST        fm,
       apps.FM_MATL_DTL        fmd,
       apps.po_un_numbers      pun,
       apps.po_hazard_classes  phc,
       apps.mtl_system_items_b msi,
       apps.mtl_parameters     mp,
       (SELECT MIC.INVENTORY_ITEM_ID,
               mic.segment2,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO
 WHERE msi.un_number_id             = pun.un_number_id          and
       msi.inventory_item_id        = fmd.inventory_item_id     and
       msi.organization_id          = fm.owner_organization_id  and
       mp.organization_id           = msi.organization_id       and
       phc.hazard_class_id          = pun.hazard_class_id       and
       inventario.organization_id   = msi.organization_id       and
       inventario.inventory_item_id = msi.inventory_item_id     and
--       fm.formula_id                = mgl.nformulaid            and
       fmd.formula_id               = fm.formula_id             and
       fmd.line_type                = 1                         and 
       exists(select mgl.nformulaid 
                from xxppg.MPI_GPSI_LEGACYFORMULA mgl
               where mgl.nformulaid = fm.formula_id);
and fm.formula_no = 'C565-6121.INT';                
                
                

 and
       group by  msi.segment1,
                 fm.formula_no,
                   fm.formula_vers,
                   fm.formula_status,
                   inventario.segment2,
                   mgl.SORGANIZATIONCODE,
                   mgl.NFLASHPT,
                   pun.un_number,
                   phc.hazard_class,
                   msi.inventory_item_status_code,
                   msi.inventory_item_id;


select distinct * from xxppg.MPI_GPSI_LEGACYFORMULA mgl where mgl.SMFGCODE = 'D800';'C565-6121.INT';


select distinct(msi.segment1)
  from apps.FM_FORM_MST   fm,
       apps.FM_MATL_DTL   fmd,
       apps.FM_MATL_DTL   fmp,
       apps.mtl_system_items_b msip
  where fmd.inventory_item_id = msi.inventory_item_id    and
        fmd.line_type         = -1                       and
        fm.formula_id         = fmd.formula_id           and
        fmp.formula_id        = fm.formula_id            and
        fmp.line_type         = 1                        and
        msi.inventory_item_id = fmp.inventory_item_id    and
        msi.organization_id   = fm.owner_organization_id and
        msi.item_type         = 'ACA'                    and
        rownum = 1
        order by 1 ;


select * from MSD_DEM_LEGACY_SETUP_PARAMS;
select * from TBLLEGACYCOMPOSITION;
select * from TBLLEGACYFORMULA;
select * from TBLLEGACYFORMULASALESCODEXREF;
select * from TBLLEGACYPRODUCTDESCRIPTIONS;
select * from TBLLEGACYTDGSALESCODE;
select * from MPI_GPSI_LEGACYORDERPLI;
select * from MPI_GPSI_LEGACYFORMSCODEXREF;
select * from MPI_GPSI_LEGACYPRODDESCTEMP;
select * from MPI_GPSI_LEGACYTDGSALESCODE;
select * from MPI_GPSI_LEGACYFORMULA;
select * from MPI_GPSI_LEGACYCOMPOSITION;
select * from MPI_GPSI_LEGACYORDERSLI;
select * from MPI_GPSI_LEGACYORDERSHIPPED;
select * from MPI_GPSI_LEGACYORDERPLACED;
select * from MPI_GPSI_LEGACYCUSTOMERADDRESS;
select * from MPI_GPSI_LEGACYCUSTOMERINFO;




select msi.segment1 ITEM,
       fm.formula_no FORMULA,
       fm.formula_vers VERSION,
       fm.formula_status,
       inventario.segment2 BU,
       mgl.SORGANIZATIONCODE ORG,
       mgl.NFLASHPT FLASH_POINT,
       pun.un_number,
       phc.hazard_class,
       msi.inventory_item_status_code,
      (select msi.segment1
         from apps.FM_FORM_MST   fm1,
              apps.FM_MATL_DTL   fmd1,
              apps.FM_MATL_DTL   fmp,
              apps.mtl_system_items_b msip
        where fmd1.inventory_item_id = msi.inventory_item_id     and
              fmd1.line_type         = -1                        and
              fm1.formula_id         = fmd1.formula_id           and
              fmp.formula_id         = fm1.formula_id            and
              fmp.line_type          = 1                         and
              msip.inventory_item_id = fmp.inventory_item_id     and
              msip.organization_id   = fm1.owner_organization_id and
              msip.item_type         = 'ACA'                     and
              rownum = 1) Acabado
  from xxppg.MPI_GPSI_LEGACYFORMULA mgl,
       apps.FM_FORM_MST   fm,
       apps.FM_MATL_DTL   fmd,
       apps.po_un_numbers pun,
       apps.po_hazard_classes phc,
       apps.mtl_system_items_b msi,
       (SELECT MIC.INVENTORY_ITEM_ID,
               mic.segment2,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO
 WHERE msi.un_number_id             = pun.un_number_id          and
       msi.inventory_item_id        = fmd.inventory_item_id     and
       msi.organization_id          = fm.owner_organization_id  and
       phc.hazard_class_id          = pun.hazard_class_id       and
       inventario.organization_id   = msi.organization_id       and
       inventario.inventory_item_id = msi.inventory_item_id     and
       fm.formula_id                = mgl.nformulaid            and
       fmd.formula_id               = fm.formula_id             and
       fmd.line_type                = 1                         and 
       mgl.SMFGCODE                 = 'C565-6121.INT';