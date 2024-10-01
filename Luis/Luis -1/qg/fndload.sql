strings -a $JL_TOP/reports/US/JLBRRIVB.rdf | grep '$Header'

export NLS_LANG="BRAZILIAN PORTUGUESE_BRAZIL.AL32UTF8"
export NLS_LANG="BRAZILIAN PORTUGUESE_BRAZIL.WE8MSWIN1252"

tkprof lagoea_ora_16045_C005690.trc /home/ocs0092/ora_16045_C005690C005690.txt sys=no record=/home/ocs0092/record_ora_16045_C005690.txt explain=apps/$appspwd
--------------------------
-- FNDLOAD - CONCURRENT --
--------------------------
FNDLOAD apps/$appspwd 0 Y DOWNLOAD $FND_TOP/patch/115/import/afcpprog.lct XXPPG_PO_CUSTO_REPOSICAO_CCR.ldt PROGRAM APPLICATION_SHORT_NAME="XXPPG" CONCURRENT_PROGRAM_NAME="XXPPG_PO_CUSTO_REPOSICAO"
FNDLOAD apps/$appspwd 0 Y DOWNLOAD $FND_TOP/patch/115/import/afcpprog.lct XXPPG_PO_INCONSISTENCIA_CCR.ldt PROGRAM APPLICATION_SHORT_NAME="XXPPG" CONCURRENT_PROGRAM_NAME="XXPPG_PO_INCONSISTENCIA"
--
FNDLOAD apps/$appspwd 0 Y UPLOAD $FND_TOP/patch/115/import/afcpprog.lct $XXPPG_TOP/ldt/XXPPG_PPI_REPORT_PRODUCAO_CCR.ldt - CUSTOM_MODE=FORCE

-------------------
-- FNDLOAD - XDO --
-------------------
FNDLOAD apps/ladoear12d 0 Y DOWNLOAD $XDO_TOP/patch/115/import/xdotmpl.lct XXPPG_INV_REP_PROD_ORDER_XDO.ldt  XDO_DS_DEFINITIONS APPLICATION_SHORT_NAME="XXPPG" DATA_SOURCE_CODE='XXPPG_INV_REP_PROD_ORDER' TMPL_APP_SHORT_NAME="XXPPG" TEMPLATE_CODE="XXPPG_INV_REP_PROD_ORDER_SIMB"
FNDLOAD apps/ladoear12d 0 Y DOWNLOAD $XDO_TOP/patch/115/import/xdotmpl.lct XXPPG_GAP_L001DD_XDO.ldt XDO_DS_DEFINITIONS APPLICATION_SHORT_NAME="XXPPG" DATA_SOURCE_CODE='XXPPG_GAP_L001DD' TMPL_APP_SHORT_NAME="XXPPG" TEMPLATE_CODE="XXPPG_GAP_L001DD"
FNDLOAD apps/ladoear12d 0 Y DOWNLOAD $XDO_TOP/patch/115/import/xdotmpl.lct XXPPG_GAP_L001D_XDO.ldt  XDO_DS_DEFINITIONS APPLICATION_SHORT_NAME="XXPPG" DATA_SOURCE_CODE='XXPPG_GAP_L001D' TMPL_APP_SHORT_NAME="XXPPG" TEMPLATE_CODE="XXPPG_GAP_L001D"

FNDLOAD apps/ladoear12d 0 Y DOWNLOAD $XDO_TOP/patch/115/import/xdotmpl.lct XXPPG_GAP_L001S_XDO.ldt  XDO_DS_DEFINITIONS APPLICATION_SHORT_NAME="XXPPG" DATA_SOURCE_CODE='XXPPG_GAP_L001S' TMPL_APP_SHORT_NAME="XXPPG" TEMPLATE_CODE="XXPPG_GAP_L001S"

FNDLOAD apps/$appspwd 0 Y UPLOAD $XDO_TOP/patch/115/import/xdotmpl.lct $XXPPG_TOP/ldt/XXPPG_TERC_REL_DETALHADO_XDO.ldt - CUSTOM_MODE=FORCE

-----------------------
-- FNDLOAD - Profile --
-----------------------
FNDLOAD apps/$appspwd 0 Y DOWNLOAD $FND_TOP/patch/115/import/afscprof.lct XXPPG_OM_EMAIL_DISTRIBUICAO_RETIRA_PRF.ldt PROFILE FND_PROFILE_OPTION_VALUES PROFILE_NAME="XXPPG_OM_EMAIL_DISTRIBUICAO_RETIRA" APPLICATION_SHORT_NAME="XXPPG"
FNDLOAD apps/$appspwd 0 Y DOWNLOAD $FND_TOP/patch/115/import/afscprof.lct XPPGBR_DIR_FCI_IN_PRF.ldt PROFILE FND_PROFILE_OPTION_VALUES PROFILE_NAME="XPPGBR_DIR_FCI_IN" APPLICATION_SHORT_NAME="XXPPG"
--
FNDLOAD apps/$appspwd 0 Y UPLOAD $FND_TOP/patch/115/import/afscprof.lct XPPGBR_DIR_FCI_OUT_PRF.ldt
FNDLOAD apps/$appspwd 0 Y UPLOAD $FND_TOP/patch/115/import/afscprof.lct XPPGBR_DIR_FCI_IN_PRF.ldt
-----------------------
-- FNDLOAD - Lookups --
-----------------------
FNDLOAD apps/ladoear12d 0 Y DOWNLOAD $FND_TOP/patch/115/import/aflvmlu.lct XXPPG_INKMAKER_CONSU_MATERIAL_LKP.ldt FND_LOOKUP_TYPE APPLICATION_SHORT_NAME ='XXPPG' LOOKUP_TYPE="XXPPG_INKMAKER_CONSU_MATERIAL"
--
FNDLOAD apps/$appspwd 0 Y UPLOAD $FND_TOP/patch/115/import/aflvmlu.lct $XXPPG_TOP/ldt/XXPPG_OM_TRANSACOES_PENDENTES_LKP.ldt - CUSTOM_MODE=FORCE
---------------------
-- FNDLOAD - FORMS --
---------------------
FNDLOAD apps/ladoear12d 0 Y DOWNLOAD $FND_TOP/patch/115/import/afsload.lct XXPPG_CPO_ORDERS_FUNC.ldt FUNCTION FUNCTION_NAME="XXPPG_CPO_ORDERS"
--
FNDLOAD apps/$appspwd 0 Y UPLOAD $FND_TOP/patch/115/import/afsload.lct $XXPPG_TOP/ldt/XXPPGINVTRAN.ldt - WARNING=YES UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE 
--------------------
-- FNDLOAD - MENU --
--------------------
FNDLOAD apps/laroear12r 0 Y DOWNLOAD $FND_TOP/patch/115/import/afsload.lct XXPPG_BR_INV_MNU.ldt       MENU MENU_NAME="XXPPG_BR_INV"
FNDLOAD apps/laroear12r 0 Y DOWNLOAD $FND_TOP/patch/115/import/afsload.lct XXPPG_INV_NAVIGATE_MNU.ldt MENU MENU_NAME="INV_NAVIGATE"
--
FNDLOAD apps/$appspwd 0 Y UPLOAD $FND_TOP/patch/115/import/afsload.lct $XXPPG_TOP/ldt/XXPPG_BR_INV_MNU.ldt
FNDLOAD apps/$appspwd 0 Y UPLOAD $FND_TOP/patch/115/import/afsload.lct $XXPPG_TOP/ldt/XXPPG_INV_NAVIGATE_MNU.ldt
-----------------------------------
-- Fndload Descriptive Flexfield --
-----------------------------------
-------------------------
-- FNDLOAD - Flexfield --
-------------------------
FNDLOAD apps/ladoear12d 0 Y DOWNLOAD $FND_TOP/patch/115/import/afffload.lct FND_COMMON_LOOKUPS_DFF.ldt DESC_FLEX APPLICATION_SHORT_NAME=FND DESCRIPTIVE_FLEXFIELD_NAME='FND_COMMON_LOOKUPS'


--
FNDLOAD apps/$appspwd 0 Y UPLOAD $FND_TOP/patch/115/import/afffload.lct $XXPPG_TOP/ldt/FND_COMMON_LOOKUPS_DF.ldt
-------------------------------------
-- Compiling description flexfield --
-------------------------------------
Compile for Descriptiveflexfields 
fdfcmp <Oracle Username/Password> 0 Y D[escriptive] <appl_short_name> <desc_flex_name> 

--------------
Request Set:--
--------------
FNDLOAD apps/$appspwd 0 Y DOWNLOAD $FND_TOP/patch/115/import/afcprset.lct FNDRSSUB1175.ldt REQ_SET_LINKS REQUEST_SET_NAME="FNDRSSUB1175"
FNDLOAD apps/$appspwd 0 Y UPLOAD $FND_TOP/patch/115/import/afcprset.lct $XXPPG_TOP/ldt/RS_PPGGLGARMGLBAL.ldt

-----------
Value Set--
-----------
$FND_TOP/bin/FNDLOAD apps/ladoear12d 0 Y DOWNLOAD $FND_TOP/patch/115/import/afffload.lct XXPPG_TIPO_RELATORIO_046.ldt VALUE_SET FLEX_VALUE_SET_NAME="XXPPG_TIPO_RELATORIO_046"

$FND_TOP/bin/FNDLOAD apps/apps 0 Y UPLOAD $FND_TOP/patch/115/import/afffload.lct XX_CUSTOM_VS.ldt - WARNING=YES UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE


Link todos FNDLOAD: https://blogs.oracle.com/prajkumar/oracle-fndload-scripts

-------------------------------------------
Create XML Data Definition Visualization
-------------------------------------------

java oracle.apps.xdo.oa.util.XDOLoader UPLOAD -DB_USERNAME apps -DB_PASSWORD $appspwd -JDBC_CONNECTION $AD_APPS_JDBC_URL -LOB_TYPE DATA_TEMPLATE -APPS_SHORT_NAME XXPPG -LOB_CODE XXPPG_TERC_REL_DETALHADO -LANGUAGE en -XDO_FILE_TYPE XML-DATA-TEMPLATE -FILE_NAME $XXPPG_TOP/reports/US/XXPPG_TERC_REL_DETALHADO.xml -CUSTOM_MODE=FORCE

-------------------------------------------
Create XML Templates
-------------------------------------------
java oracle.apps.xdo.oa.util.XDOLoader UPLOAD -DB_USERNAME apps -DB_PASSWORD $appspwd -JDBC_CONNECTION $AD_APPS_JDBC_URL -LOB_TYPE TEMPLATE_SOURCE -APPS_SHORT_NAME XXPPG -LOB_CODE XXPPG_TERC_REL_DETALHADO -LANGUAGE pt -TERRITORY BR -XDO_FILE_TYPE RTF -NLS_LANG PTB -FILE_NAME $XXPPG_TOP/reports/US/XXPPG_TERC_REL_DETALHADO.rtf -CUSTOM_MODE FORCE


Forms Personalization:
---------------------------------
FNDLOAD apps/ladoear12d 0 Y DOWNLOAD $FND_TOP/patch/115/import/affrmcus.lct CLLRILPO_FP.ldt FND_FORM_CUSTOM_RULES form_name=CLLRILPO
FNDLOAD apps/$appspwd 0 Y UPLOAD $FND_TOP/patch/115/import/affrmcus.lct $XXPPG_TOP/ldt/CLLRILPO_FP.ldt