DROP VIEW APPS.BATCH_TRACKER_BATCHES;

/* Formatted on 28/05/2019 08:57:41 (QP5 v5.294) */
CREATE OR REPLACE FORCE VIEW APPS.BATCH_TRACKER_BATCHES
(
   ITEM,
   ITEM_DESCRIPTION,
   INVENTORY_CLASS,
   PLANNING_CLASS,
   PLANT,
   BATCH_NUMBER,
   BATCH_STATUS,
   PLANNED_QUANTITY_UOM1,
   UOM1,
   PLANNED_QUANTITY_KG,
   PLANNED_START_DATE,
   PLANNED_COMPLETION_DATE,
   REQUIRED_COMPLETION_DATE,
   ITEM_TYPE,
   BATCH_NOTES,
   TECH_GROUP_DESCRIPTION,
   TECH_SUB_GROUP_DESCRIPTION,
   FIXED_LEAD_TIME,
   FILLING_INDICATOR
)
   BEQUEATH DEFINER
AS
   SELECT MSIB.SEGMENT1                          ITEM,
          MSIB.DESCRIPTION                       ITEM_DESCRIPTION,
          'MTS'                                  INVENTORY_CLASS,
          (SELECT (SELECT SEGMENT1
                     FROM INV.MTL_CATEGORIES_B MCB
                    WHERE MIC.CATEGORY_ID = MCB.CATEGORY_ID)
             FROM APPS.MTL_ITEM_CATEGORIES MIC
            WHERE     1 = 1
                  AND MIC.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID
                  AND MIC.ORGANIZATION_ID = MSIB.ORGANIZATION_ID
                  AND (MIC.CATEGORY_ID IN
                          (SELECT MCB.CATEGORY_ID
                             FROM APPS.MTL_CATEGORIES_B MCB
                            WHERE     1 = 1
                                  AND MCB.STRUCTURE_ID =
                                         (SELECT MCS_B.STRUCTURE_ID
                                            FROM APPS.MTL_CATEGORY_SETS_B
                                                 MCS_B
                                           WHERE     1 = 1
                                                 AND MCS_B.CATEGORY_SET_ID =
                                                        (SELECT MCATS.CATEGORY_SET_ID
                                                           FROM MTL_CATEGORY_SETS
                                                                MCATS,
                                                                MTL_CATEGORIES
                                                                MCAT
                                                          WHERE     1 = 1
                                                                AND MCATS.CATEGORY_SET_NAME =
                                                                       'PPG_PLANNING_CLASS'
                                                                AND MCAT.CATEGORY_ID =
                                                                       MCATS.DEFAULT_CATEGORY_ID)))))
                                                 PLANNING_CLASS,
          MP.ORGANIZATION_CODE                   PLANT,
          GBH.BATCH_NO                           BATCH_NUMBER,
          -- DECODE (GBH.BATCH_STATUS, 1, 'Pending')
          DECODE (GBH.BATCH_STATUS,
                  1, 'Pending',
                  2, 'WIP',
                  -1, 'Cancelled')               BATCH_STATUS,
          APPS.INV_CONVERT.INV_UM_CONVERT (
             ITEM_ID         => MSIB.INVENTORY_ITEM_ID,
             PRECISION       => NULL,
             FROM_QUANTITY   => ROUND (GMD.PLAN_QTY, 2),
             FROM_UNIT       => GMD.DTL_UM,
             TO_UNIT         => MSIB.PRIMARY_UOM_CODE,
             FROM_NAME       => NULL,
             TO_NAME         => NULL)
             PLANNED_QUANTITY_UOM1,
          MSIB.PRIMARY_UOM_CODE                  UOM1,
          APPS.INV_CONVERT.INV_UM_CONVERT (
             ITEM_ID         => MSIB.INVENTORY_ITEM_ID,
             PRECISION       => NULL,
             FROM_QUANTITY   => ROUND (GMD.PLAN_QTY, 2),
             FROM_UNIT       => GMD.DTL_UM,
             TO_UNIT         => 'kg',
             FROM_NAME       => NULL,
             TO_NAME         => NULL)
                                                 PLANNED_QUANTITY_KG,
          GBH.PLAN_START_DATE                    PLANNED_START_DATE,
          GBH.PLAN_CMPLT_DATE                    PLANNED_COMPLETION_DATE,
          GBH.DUE_DATE                           REQUIRED_COMPLETION_DATE,
          DECODE (MSIB.ITEM_TYPE,
                  'INT', 'Intermediate',
                  'SEMI', 'Bulk',
                  'ACA', 'Finished Good',
                  'ACARV', 'Finished Good')      ITEM_TYPE,
          ''                                     BATCH_NOTES, -- 4 - Solvent borne product
          (SELECT (SELECT SEGMENT1
                          || ' - '
                          || SUBSTR (MTL.DESCRIPTION,
                                     1,
                                     INSTR (MTL.DESCRIPTION, '/') - 1)
                     FROM INV.MTL_CATEGORIES_B MCB, INV.MTL_CATEGORIES_TL MTL
                    WHERE MIC.CATEGORY_ID = MCB.CATEGORY_ID AND
                          MTL.CATEGORY_ID = MCB.CATEGORY_ID AND
                          MTL.LANGUAGE = 'US')
             FROM APPS.MTL_ITEM_CATEGORIES MIC
            WHERE 1 = 1 AND
                  MIC.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID AND
                  MIC.ORGANIZATION_ID = 82 AND
                 (MIC.CATEGORY_ID IN 
                         (SELECT MCB.CATEGORY_ID
                            FROM APPS.MTL_CATEGORIES_B MCB
                            WHERE 1 = 1 AND
                                  MCB.STRUCTURE_ID =
                                     (SELECT MCS_B.STRUCTURE_ID
                                        FROM APPS.MTL_CATEGORY_SETS_B MCS_B
                                       WHERE 1 = 1 AND
                                             MCS_B.CATEGORY_SET_ID = 
                                                 (SELECT MCATS.CATEGORY_SET_ID
                                                    FROM MTL_CATEGORY_SETS MCATS,
                                                         MTL_CATEGORIES    MCAT
                                                   WHERE 1 = 1                                                AND
                                                         MCATS.CATEGORY_SET_NAME = 'PPG_TECH_GROUP_SUB_GROUP' AND
                                                         MCAT.CATEGORY_ID        = MCATS.DEFAULT_CATEGORY_ID)))))
                                                TECH_GROUP_DESCRIPTION,                         -- C - Clear
          (SELECT (SELECT segment2
                          || ' - '
                          || SUBSTR (MTL.DESCRIPTION,
                                     INSTR (MTL.DESCRIPTION, '/') + 1)
                     FROM INV.MTL_CATEGORIES_B MCB, INV.MTL_CATEGORIES_TL MTL
                    WHERE MIC.CATEGORY_ID = MCB.CATEGORY_ID AND
                          MTL.CATEGORY_ID = MCB.CATEGORY_ID AND
                          MTL.LANGUAGE = 'US')
             FROM APPS.MTL_ITEM_CATEGORIES MIC
            WHERE 1 = 1 AND
                  MIC.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID AND
                  MIC.ORGANIZATION_ID   = 82                     AND
                 (MIC.CATEGORY_ID IN
                          (SELECT MCB.CATEGORY_ID
                             FROM APPS.MTL_CATEGORIES_B MCB
                            WHERE 1 = 1 AND
                                 MCB.STRUCTURE_ID =
                                         (SELECT MCS_B.STRUCTURE_ID
                                            FROM APPS.MTL_CATEGORY_SETS_B MCS_B
                                           WHERE 1 = 1 AND
                                                 MCS_B.CATEGORY_SET_ID =
                                                        (SELECT MCATS.CATEGORY_SET_ID
                                                           FROM MTL_CATEGORY_SETS MCATS,
                                                                MTL_CATEGORIES    MCAT
                                                          WHERE 1 = 1 AND
                                                                MCATS.CATEGORY_SET_NAME = 'PPG_TECH_GROUP_SUB_GROUP' AND
                                                                MCAT.CATEGORY_ID        = MCATS.DEFAULT_CATEGORY_ID)))))
                                                TECH_SUB_GROUP_DESCRIPTION,
          ROUND(MSIB.FIXED_LEAD_TIME,5)         FIXED_LEAD_TIME,
          DECODE (FM.FORMULA_TYPE, 1, 'Y', 'N') FILLING_INDICATOR
     FROM APPS.MTL_SYSTEM_ITEMS_B  MSIB,
          APPS.GME_BATCH_HEADER    GBH,
          GME.GME_MATERIAL_DETAILS GMD,
          APPS.MTL_PARAMETERS      MP,
          APPS.GMD_ROUTINGS_B      GRB,
          APPS.FM_FORM_MST         FM
    WHERE 1 = 1                                                  AND
          MP.ORGANIZATION_ID    = MSIB.ORGANIZATION_ID           AND
          GBH.ORGANIZATION_ID   = MSIB.ORGANIZATION_ID           AND
          GRB.ROUTING_ID        = GBH.ROUTING_ID                 AND
          GBH.BATCH_TYPE        = 0                              AND
          ((GBH.BATCH_STATUS IN (1, 2)) OR
           (GBH.BATCH_STATUS = -1 AND
            TRUNC (GBH.LAST_UPDATE_DATE) > TRUNC (SYSDATE - 7))) AND
          GMD.BATCH_ID          = GBH.BATCH_ID                   AND
          GMD.LINE_TYPE         = 1                              AND
          GMD.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID         AND
          GMD.ORGANIZATION_ID   = MSIB.ORGANIZATION_ID           AND
          GBH.FORMULA_ID        = FM.FORMULA_ID                  AND
          GBH.organization_id   = 92    -- Envia apenas Sumare
;

GRANT SELECT ON APPS.BATCH_TRACKER_BATCHES TO readprivs_role;
GRANT SELECT ON APPS.BATCH_TRACKER_BATCHES TO BATCH_TRACKER_USER;
