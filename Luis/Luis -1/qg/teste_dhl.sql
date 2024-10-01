select * /*DISTINCT
                      'UNH+' || '1' || '+DESADV:D:02B:UN'''                  MESSAGE_HEADER
                     ,'BGM+351+' || 'RI-' || a.num_recebimento||'|'||a.nota_fiscal||'+9'''              BEGINNING_MESSAGE
                     ,'DTM+137:' || REPLACE (TO_CHAR (SYSDATE, 'YYYY-MM-DD'), '-', '') || ':102''' DATE_TIME_PERIOD
                     ,'RFF+ACE:' || CASE WHEN SUBSTR(get_loc_rff (a.invoice_type_id, a.entity_id, 'R'),1,10) = 'RFF+ZZZ:DV' THEN 'RID-' ELSE 'RI-' END || a.num_recebimento || ''''        RFF_REFERENCE
                     ,(SELECT    'NAD+SU+1::91++PPG INDL. BRASIL TINTAS E VERNIZES+RODOVIA ANHANGUERA  KM ,106+SUMARE+SP+13180480+BRA'|| ''''
                         FROM HR_ORGANIZATION_UNITS_V hou
                       WHERE hou.organization_id = a.to_organization_id) NAME_ADDRESS
                     , get_loc_rff (a.invoice_type_id, a.entity_id, 'L') LOCATION_IDENTIFICATION
                     ,'TDT+25++++99999:::' || SUBSTR (get_lookup_information ('TDT'), 1, 35) || '''' TRANSPORT_INFORMATION
                     ,'CPS+1''' CONSIG_PACKING_SEQ
                     , a.num_recebimento || '''' DOCUMENT_NUM
                     ,(SELECT 'CNT+2:' || COUNT(*)
                        FROM APPS.XXPPG_BR_INV_DHL_RECPT_WORK
                         WHERE NUM_RI = A.NUM_RECEBIMENTO
                        ) || '''' TOTAL_CONTROL
                     ,'UNT+' || ( SELECT (COUNT(*) * 5) + 11
                                    FROM APPS.XXPPG_BR_INV_DHL_RECPT_WORK XIR,
                                         APPS.XXPPG_BR_INV_DHL_RECPT_LOTS XIRL
                                     WHERE XIR.DHL_WORK_ID = XIRL.DHL_WORK_ID(+)
                                       AND XIR.NUM_RI = A.NUM_RECEBIMENTO
                                    )|| '+' || '1' || '''' MESSAGE_TRAILER*/
             FROM XXPPG_BR_INV_DHL_RECPT_WORK XIR,
                  XXPPG_INV_RECEB_FISICO_DHL_V A
               WHERE --NUM_RECEBIMENTO = p_num_ri
                     XIR.SHIPMENT_LINE_ID = A.SHIPMENT_LINE_ID
                 --AND XIR.STATUS = 'NEW'
                 AND XIR.LINE_TYPE = 'O'
                 and a.num_recebimento in (169646,169645)                 
                 
select rowid, a.* from XXPPG_INV_RECEB_FISICO_DHL_V A  where a.num_recebimento in (169646,169645)  ;            

select rowid, xir.* from XXPPG_BR_INV_DHL_RECPT_WORK XIR where XIR.SHIPMENT_LINE_ID in (1182635,1182634,1182636,1182640,1182639,1182638,1182637)