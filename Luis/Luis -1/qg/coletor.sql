<!-- #include virtual="/business/login-functions.asp" -->

<%	

Function UpdateOrder(strConn, resource, productionOrder, operation, status, note, successmsg, errormsg)
    dim userId,productionOrderid
    getidUser strConn, userId
    
    sqlquery = "select * from APPS.XXPPG_RESOURCE_BATCH_STEP where RESOURCE_CODE = '" & resource & "' and END_DATE is null"
    if productionOrder = "" then
        productionOrderId = "null"
    else 
        SelectBatchId strConn, productionOrder, productionOrderid, errormsg
    end if 

    if Len(errormsg) = 0 then
        set result = ExecQuerySQL(strConn,sqlquery)
        if result.eof  Then
            strConn.close()
            QueryLookUp = "Select * From APPLSYS.FND_LOOKUP_VALUES Where LOOKUP_TYPE = 'XXPPG_RESOURCE' and LOOKUP_CODE = '" & resource & "'"
            set retLookUp = ExecQuerySQL(strConn,QueryLookUp)
            if retLookUp.eof  Then 
                errormsg = "N&atilde;o encontrado!"
                strConn.close()
            ELSE
                strConn.close()
                insert = "insert into APPS.XXPPG_RESOURCE_BATCH_STEP (RESOURCE_CODE,ORGANIZATION_ID,BATCH_ID,BATCHSTEP_NO,PART,STATUS,START_DATE,START_USER_ID,NOTE) Values ('" & resource & "',92," & productionOrderid & ",'" & operation & "'," & 1 & ", '"& status & "',sysdate," & userid & ",'" & note & "')"
                uppLookup = "Update APPLSYS.FND_LOOKUP_VALUES Set Attribute1 = '" & status & "' Where LOOKUP_TYPE = 'XXPPG_RESOURCE' and LOOKUP_CODE = '" & resource & "'"
                ExecQuerySQL strConn, insert
                strConn.close()
                ExecQuerySQL strConn, uppLookup
                strConn.close()
                successmsg = "Status atualizado com sucesso!"
            end if
        ELSE                             /*-------------------------------------------------------------------------*/
            if result("status") = status and productionOrderid = result("productionOrderid") and note = result("note") THEN
                errormsg = "Mesmo status j&aacute; atualizado!"
                strConn.close()
            else
                upquery = "Update APPS.XXPPG_RESOURCE_BATCH_STEP set END_DATE = Sysdate, END_USER_ID = " & userid & " where RESOURCE_CODE = '" & resource & "' and end_date is null"  
                insert = "insert into APPS.XXPPG_RESOURCE_BATCH_STEP (RESOURCE_CODE,ORGANIZATION_ID,BATCH_ID,BATCHSTEP_NO,PART,STATUS,START_DATE,START_USER_ID,NOTE) Values ('" & resource & "'," & OrganizationID & "," & productionOrderid & ",'" & operation & "'," & 1 & ", '"& status & "',sysdate," & userid & ",'" & note & "')"
                uppLookup = "Update APPLSYS.FND_LOOKUP_VALUES Set Attribute1 = '" & status & "' Where LOOKUP_TYPE = 'XXPPG_RESOURCE' and LOOKUP_CODE = '" & resource & "'"
                
                strConn.close()

                ExecQuerySQL strConn, upquery
                strConn.close()

                ExecQuerySQL strConn, insert
                strConn.close()

                ExecQuerySQL strConn, uppLookup
                strConn.close()

                successmsg = "Status atualizado com sucesso!"
            end if
        end if

        if productionOrder = "null" then
            productionOrder = ""
        end if 
    end if
    
end Function

Function SelectBatchId(strConn,productionOrder, productionOrderid, errormsg)
    queryOrder = "select * from APPS.GME_BATCH_HEADER where BATCH_NO = '" & productionOrder & "' and ORGANIZATION_ID = "& OrganizationID 
    set ret = ExecQuerySQL(strConn,queryOrder)

    if ret.eof Then
        errormsg = "Ordem de produ&ccedil;&atilde;o n&atilde;o encontrado!"
    else
        productionOrderid = ret("BATCH_ID")
    end if
    strConn.close()
end Function

Function SelectResourceStatus(strConn,results)
    queryOrder = "select MEANING from APPLSYS.FND_LOOKUP_VALUES where lookup_type = 'XXPPG_RESOURCE_STATUS' AND LANGUAGE = 'PTB'" 
    set results= ExecQuerySQL(strConn,queryOrder)
end Function

Function SelectCurrentResources(strConn,results, planta, linhaProducao)

Dim strLinhaProducao

if linhaProducao <> "" Then
	strLinhaProducao = "flv.tag = '" & linhaProducao & "' AND "
end If
    queryOrder = "SELECT flv.lookup_code, gbh.batch_no, msi.segment1, msi.description, gmd.plan_qty, flv2.meaning, flv2.attribute5 " & _
                 "FROM APPLSYS.fnd_lookup_values flv, " & _
		 "APPLSYS.fnd_lookup_values flv2, " & _
		 "apps.xxppg_resource_batch_step xr, " & _
		 "apps.gme_batch_header gbh, " & _
		 "gme.gme_material_details gmd, " & _
		 "apps.mtl_system_items_b msi " & _
"WHERE xr.end_date IS NULL AND " & _
"     flv.language = 'PTB' AND " & _
"      flv.lookup_type = 'XXPPG_RESOURCE' AND " & _
"      flv.description = '" & planta & "' AND " & _
strLinhaProducao & _
"      flv2.language = 'PTB' AND " & _
"      flv2.lookup_type = 'XXPPG_RESOURCE_STATUS' AND " & _
"      flv2.meaning = flv.attribute1 AND " & _
"      xr.resource_code(+) = flv.lookup_code AND " & _
"      gbh.batch_id(+) = xr.batch_id AND " & _
"      gmd.batch_id(+) = xr.batch_id AND " & _
"      gmd.line_type(+) = 1 AND " & _
"      gmd.line_no(+) = 1 AND " & _
"      msi.organization_id(+) = gmd.organization_id AND " & _
"      msi.inventory_item_id(+) = gmd.inventory_item_id AND " & _
"      gbh.organization_id(+) = gmd.organization_id AND " & _
"      gbh.organization_id(+) = " & OrganizationID & " order by 1 "


    set results= ExecQuerySQL(strConn,queryOrder)
end Function
%>
