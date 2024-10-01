CREATE OR REPLACE PACKAGE BODY SFWITPPG.PKG_R12_DBL_EXP_INSERT IS

   PROCEDURE EBS_AP_INVOICES_INTERFACE(p_r_SFWBR_AP_INVO_INTER SFWBR_AP_INVO_INTER%ROWTYPE) is
   BEGIN
      INSERT INTO SFWBR_AP_INVO_INTER (INVOICE_ID,
                                       INVOICE_NUM,
                                       INVOICE_TYPE_LOOKUP_CODE,
                                       INVOICE_DATE,
                                       PO_NUMBER,
                                       VENDOR_ID,
                                       VENDOR_NUM,
                                       VENDOR_NAME,
                                       VENDOR_SITE_ID,
                                       VENDOR_SITE_CODE,
                                       INVOICE_AMOUNT,
                                       INVOICE_CURRENCY_CODE,
                                       EXCHANGE_RATE,
                                       EXCHANGE_RATE_TYPE,
                                       EXCHANGE_DATE,
                                       TERMS_ID,
                                       TERMS_NAME,
                                       DESCRIPTION,
                                       AWT_GROUP_ID,
                                       AWT_GROUP_NAME,
                                       LAST_UPDATE_DATE,
                                       LAST_UPDATED_BY,
                                       LAST_UPDATE_LOGIN,
                                       CREATION_DATE,
                                       CREATED_BY,
                                       ATTRIBUTE_CATEGORY,
                                       ATTRIBUTE1,
                                       ATTRIBUTE2,
                                       ATTRIBUTE3,
                                       ATTRIBUTE4,
                                       ATTRIBUTE5,
                                       ATTRIBUTE6,
                                       ATTRIBUTE7,
                                       ATTRIBUTE8,
                                       ATTRIBUTE9,
                                       ATTRIBUTE10,
                                       ATTRIBUTE11,
                                       ATTRIBUTE12,
                                       ATTRIBUTE13,
                                       ATTRIBUTE14,
                                       ATTRIBUTE15,
                                       GLOBAL_ATTRIBUTE_CATEGORY,
                                       GLOBAL_ATTRIBUTE1,
                                       GLOBAL_ATTRIBUTE2,
                                       GLOBAL_ATTRIBUTE3,
                                       GLOBAL_ATTRIBUTE4,
                                       GLOBAL_ATTRIBUTE5,
                                       GLOBAL_ATTRIBUTE6,
                                       GLOBAL_ATTRIBUTE7,
                                       GLOBAL_ATTRIBUTE8,
                                       GLOBAL_ATTRIBUTE9,
                                       GLOBAL_ATTRIBUTE10,
                                       GLOBAL_ATTRIBUTE11,
                                       GLOBAL_ATTRIBUTE12,
                                       GLOBAL_ATTRIBUTE13,
                                       GLOBAL_ATTRIBUTE14,
                                       GLOBAL_ATTRIBUTE15,
                                       GLOBAL_ATTRIBUTE16,
                                       GLOBAL_ATTRIBUTE17,
                                       GLOBAL_ATTRIBUTE18,
                                       GLOBAL_ATTRIBUTE19,
                                       GLOBAL_ATTRIBUTE20,
                                       STATUS,
                                       SOURCE,
                                       GROUP_ID,
                                       REQUEST_ID,
                                       PAYMENT_CROSS_RATE_TYPE,
                                       PAYMENT_CROSS_RATE_DATE,
                                       PAYMENT_CROSS_RATE,
                                       PAYMENT_CURRENCY_CODE,
                                       WORKFLOW_FLAG,
                                       DOC_CATEGORY_CODE,
                                       VOUCHER_NUM,
                                       PAYMENT_METHOD_LOOKUP_CODE,
                                       PAY_GROUP_LOOKUP_CODE,
                                       GOODS_RECEIVED_DATE,
                                       INVOICE_RECEIVED_DATE,
                                       GL_DATE,
                                       ACCTS_PAY_CODE_COMBINATION_ID,
                                       USSGL_TRANSACTION_CODE,
                                       EXCLUSIVE_PAYMENT_FLAG,
                                       ORG_ID,
                                       AMOUNT_APPLICABLE_TO_DISCOUNT,
                                       PREPAY_NUM,
                                       PREPAY_DIST_NUM,
                                       PREPAY_APPLY_AMOUNT,
                                       PREPAY_GL_DATE,
                                       INVOICE_INCLUDES_PREPAY_FLAG,
                                       NO_XRATE_BASE_AMOUNT,
                                       VENDOR_EMAIL_ADDRESS,
                                       TERMS_DATE,
                                       REQUESTER_ID,
                                       SHIP_TO_LOCATION,
                                       EXTERNAL_DOC_REF)
      VALUES                          (p_r_SFWBR_AP_INVO_INTER.INVOICE_ID,
                                       p_r_SFWBR_AP_INVO_INTER.INVOICE_NUM,
                                       p_r_SFWBR_AP_INVO_INTER.INVOICE_TYPE_LOOKUP_CODE,
                                       p_r_SFWBR_AP_INVO_INTER.INVOICE_DATE,
                                       p_r_SFWBR_AP_INVO_INTER.PO_NUMBER,
                                       p_r_SFWBR_AP_INVO_INTER.VENDOR_ID,
                                       p_r_SFWBR_AP_INVO_INTER.VENDOR_NUM,
                                       p_r_SFWBR_AP_INVO_INTER.VENDOR_NAME,
                                       p_r_SFWBR_AP_INVO_INTER.VENDOR_SITE_ID,
                                       p_r_SFWBR_AP_INVO_INTER.VENDOR_SITE_CODE,
                                       p_r_SFWBR_AP_INVO_INTER.INVOICE_AMOUNT,
                                       p_r_SFWBR_AP_INVO_INTER.INVOICE_CURRENCY_CODE,
                                       p_r_SFWBR_AP_INVO_INTER.EXCHANGE_RATE,
                                       p_r_SFWBR_AP_INVO_INTER.EXCHANGE_RATE_TYPE,
                                       p_r_SFWBR_AP_INVO_INTER.EXCHANGE_DATE,
                                       p_r_SFWBR_AP_INVO_INTER.TERMS_ID,
                                       p_r_SFWBR_AP_INVO_INTER.TERMS_NAME,
                                       p_r_SFWBR_AP_INVO_INTER.DESCRIPTION,
                                       p_r_SFWBR_AP_INVO_INTER.AWT_GROUP_ID,
                                       p_r_SFWBR_AP_INVO_INTER.AWT_GROUP_NAME,
                                       p_r_SFWBR_AP_INVO_INTER.LAST_UPDATE_DATE,
                                       p_r_SFWBR_AP_INVO_INTER.LAST_UPDATED_BY,
                                       p_r_SFWBR_AP_INVO_INTER.LAST_UPDATE_LOGIN,
                                       p_r_SFWBR_AP_INVO_INTER.CREATION_DATE,
                                       p_r_SFWBR_AP_INVO_INTER.CREATED_BY,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE_CATEGORY,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE1,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE2,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE3,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE4,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE5,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE6,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE7,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE8,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE9,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE10,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE11,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE12,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE13,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE14,
                                       p_r_SFWBR_AP_INVO_INTER.ATTRIBUTE15,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE_CATEGORY,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE1,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE2,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE3,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE4,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE5,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE6,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE7,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE8,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE9,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE10,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE11,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE12,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE13,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE14,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE15,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE16,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE17,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE18,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE19,
                                       p_r_SFWBR_AP_INVO_INTER.GLOBAL_ATTRIBUTE20,
                                       p_r_SFWBR_AP_INVO_INTER.STATUS,
                                       p_r_SFWBR_AP_INVO_INTER.SOURCE,
                                       p_r_SFWBR_AP_INVO_INTER.GROUP_ID,
                                       p_r_SFWBR_AP_INVO_INTER.REQUEST_ID,
                                       p_r_SFWBR_AP_INVO_INTER.PAYMENT_CROSS_RATE_TYPE,
                                       p_r_SFWBR_AP_INVO_INTER.PAYMENT_CROSS_RATE_DATE,
                                       p_r_SFWBR_AP_INVO_INTER.PAYMENT_CROSS_RATE,
                                       p_r_SFWBR_AP_INVO_INTER.PAYMENT_CURRENCY_CODE,
                                       p_r_SFWBR_AP_INVO_INTER.WORKFLOW_FLAG,
                                       p_r_SFWBR_AP_INVO_INTER.DOC_CATEGORY_CODE,
                                       p_r_SFWBR_AP_INVO_INTER.VOUCHER_NUM,
                                       p_r_SFWBR_AP_INVO_INTER.PAYMENT_METHOD_LOOKUP_CODE,
                                       p_r_SFWBR_AP_INVO_INTER.PAY_GROUP_LOOKUP_CODE,
                                       p_r_SFWBR_AP_INVO_INTER.GOODS_RECEIVED_DATE,
                                       p_r_SFWBR_AP_INVO_INTER.INVOICE_RECEIVED_DATE,
                                       p_r_SFWBR_AP_INVO_INTER.GL_DATE,
                                       p_r_SFWBR_AP_INVO_INTER.ACCTS_PAY_CODE_COMBINATION_ID,
                                       p_r_SFWBR_AP_INVO_INTER.USSGL_TRANSACTION_CODE,
                                       p_r_SFWBR_AP_INVO_INTER.EXCLUSIVE_PAYMENT_FLAG,
                                       p_r_SFWBR_AP_INVO_INTER.ORG_ID,
                                       p_r_SFWBR_AP_INVO_INTER.AMOUNT_APPLICABLE_TO_DISCOUNT,
                                       p_r_SFWBR_AP_INVO_INTER.PREPAY_NUM,
                                       p_r_SFWBR_AP_INVO_INTER.PREPAY_DIST_NUM,
                                       p_r_SFWBR_AP_INVO_INTER.PREPAY_APPLY_AMOUNT,
                                       p_r_SFWBR_AP_INVO_INTER.PREPAY_GL_DATE,
                                       p_r_SFWBR_AP_INVO_INTER.INVOICE_INCLUDES_PREPAY_FLAG,
                                       p_r_SFWBR_AP_INVO_INTER.NO_XRATE_BASE_AMOUNT,
                                       p_r_SFWBR_AP_INVO_INTER.VENDOR_EMAIL_ADDRESS,
                                       p_r_SFWBR_AP_INVO_INTER.TERMS_DATE,
                                       p_r_SFWBR_AP_INVO_INTER.REQUESTER_ID,
                                       p_r_SFWBR_AP_INVO_INTER.SHIP_TO_LOCATION,
                                       p_r_SFWBR_AP_INVO_INTER.EXTERNAL_DOC_REF);
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000,'Erro ao inserir na tabela SFWBR_AP_INVO_INTER. ' || sqlerrm);
   END EBS_AP_INVOICES_INTERFACE;
   --
   PROCEDURE EBS_AP_INVOICE_LINES_INTERFACE(p_r_SFWBR_AP_INVOICE_LINES_INT SFWBR_AP_INVO_LINES_INTER%ROWTYPE) is
   BEGIN
      INSERT INTO SFWBR_AP_INVO_LINES_INTER (LAST_UPDATE_DATE,
                                             LAST_UPDATE_LOGIN,
                                             CREATED_BY,
                                             CREATION_DATE,
                                             ATTRIBUTE_CATEGORY,
                                             ATTRIBUTE1,
                                             ATTRIBUTE2,
                                             ATTRIBUTE3,
                                             ATTRIBUTE4,
                                             ATTRIBUTE5,
                                             ATTRIBUTE6,
                                             ATTRIBUTE7,
                                             ATTRIBUTE8,
                                             ATTRIBUTE9,
                                             ATTRIBUTE10,
                                             ATTRIBUTE11,
                                             ATTRIBUTE12,
                                             ATTRIBUTE13,
                                             ATTRIBUTE14,
                                             ATTRIBUTE15,
                                             GLOBAL_ATTRIBUTE_CATEGORY,
                                             GLOBAL_ATTRIBUTE1,
                                             GLOBAL_ATTRIBUTE2,
                                             GLOBAL_ATTRIBUTE3,
                                             GLOBAL_ATTRIBUTE4,
                                             GLOBAL_ATTRIBUTE5,
                                             GLOBAL_ATTRIBUTE6,
                                             GLOBAL_ATTRIBUTE7,
                                             GLOBAL_ATTRIBUTE8,
                                             GLOBAL_ATTRIBUTE9,
                                             GLOBAL_ATTRIBUTE10,
                                             GLOBAL_ATTRIBUTE11,
                                             GLOBAL_ATTRIBUTE12,
                                             GLOBAL_ATTRIBUTE13,
                                             GLOBAL_ATTRIBUTE14,
                                             GLOBAL_ATTRIBUTE15,
                                             GLOBAL_ATTRIBUTE16,
                                             GLOBAL_ATTRIBUTE17,
                                             GLOBAL_ATTRIBUTE18,
                                             GLOBAL_ATTRIBUTE19,
                                             GLOBAL_ATTRIBUTE20,
                                             PO_RELEASE_ID,
                                             RELEASE_NUM,
                                             ACCOUNT_SEGMENT,
                                             BALANCING_SEGMENT,
                                             COST_CENTER_SEGMENT,
                                             PROJECT_ID,
                                             TASK_ID,
                                             EXPENDITURE_TYPE,
                                             EXPENDITURE_ITEM_DATE,
                                             EXPENDITURE_ORGANIZATION_ID,
                                             PROJECT_ACCOUNTING_CONTEXT,
                                             PA_ADDITION_FLAG,
                                             PA_QUANTITY,
                                             USSGL_TRANSACTION_CODE,
                                             STAT_AMOUNT,
                                             TYPE_1099,
                                             INCOME_TAX_REGION,
                                             ASSETS_TRACKING_FLAG,
                                             PRICE_CORRECTION_FLAG,
                                             ORG_ID,
                                             RECEIPT_NUMBER,
                                             RECEIPT_LINE_NUMBER,
                                             MATCH_OPTION,
                                             PACKING_SLIP,
                                             RCV_TRANSACTION_ID,
                                             PA_CC_AR_INVOICE_ID,
                                             PA_CC_AR_INVOICE_LINE_NUM,
                                             REFERENCE_1,
                                             REFERENCE_2,
                                             PA_CC_PROCESSED_CODE,
                                             TAX_RECOVERY_RATE,
                                             TAX_RECOVERY_OVERRIDE_FLAG,
                                             TAX_RECOVERABLE_FLAG,
                                             TAX_CODE_OVERRIDE_FLAG,
                                             TAX_CODE_ID,
                                             CREDIT_CARD_TRX_ID,
                                             AWARD_ID,
                                             VENDOR_ITEM_NUM,
                                             TAXABLE_FLAG,
                                             PRICE_CORRECT_INV_NUM,
                                             EXTERNAL_DOC_LINE_REF,
                                             INVOICE_ID,
                                             INVOICE_LINE_ID,
                                             LINE_NUMBER,
                                             LINE_TYPE_LOOKUP_CODE,
                                             LINE_GROUP_NUMBER,
                                             AMOUNT,
                                             ACCOUNTING_DATE,
                                             DESCRIPTION,
                                             AMOUNT_INCLUDES_TAX_FLAG,
                                             PRORATE_ACROSS_FLAG,
                                             TAX_CODE,
                                             FINAL_MATCH_FLAG,
                                             PO_HEADER_ID,
                                             PO_NUMBER,
                                             PO_LINE_ID,
                                             PO_LINE_NUMBER,
                                             PO_LINE_LOCATION_ID,
                                             PO_SHIPMENT_NUM,
                                             PO_DISTRIBUTION_ID,
                                             PO_DISTRIBUTION_NUM,
                                             PO_UNIT_OF_MEASURE,
                                             INVENTORY_ITEM_ID,
                                             ITEM_DESCRIPTION,
                                             QUANTITY_INVOICED,
                                             SHIP_TO_LOCATION_CODE,
                                             UNIT_PRICE,
                                             DISTRIBUTION_SET_ID,
                                             DISTRIBUTION_SET_NAME,
                                             DIST_CODE_CONCATENATED,
                                             DIST_CODE_COMBINATION_ID,
                                             AWT_GROUP_ID,
                                             AWT_GROUP_NAME,
                                             LAST_UPDATED_BY)
      VALUES                                (p_r_SFWBR_AP_INVOICE_LINES_INT.LAST_UPDATE_DATE,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.LAST_UPDATE_LOGIN,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.CREATED_BY,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.CREATION_DATE,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE_CATEGORY,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE1,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE2,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE3,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE4,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE5,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE6,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE7,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE8,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE9,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE10,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE11,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE12,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE13,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE14,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ATTRIBUTE15,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE_CATEGORY,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE1,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE2,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE3,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE4,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE5,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE6,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE7,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE8,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE9,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE10,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE11,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE12,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE13,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE14,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE15,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE16,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE17,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE18,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE19,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE20,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PO_RELEASE_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.RELEASE_NUM,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ACCOUNT_SEGMENT,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.BALANCING_SEGMENT,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.COST_CENTER_SEGMENT,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PROJECT_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.TASK_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.EXPENDITURE_TYPE,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.EXPENDITURE_ITEM_DATE,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.EXPENDITURE_ORGANIZATION_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PROJECT_ACCOUNTING_CONTEXT,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PA_ADDITION_FLAG,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PA_QUANTITY,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.USSGL_TRANSACTION_CODE,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.STAT_AMOUNT,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.TYPE_1099,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.INCOME_TAX_REGION,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ASSETS_TRACKING_FLAG,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PRICE_CORRECTION_FLAG,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ORG_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.RECEIPT_NUMBER,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.RECEIPT_LINE_NUMBER,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.MATCH_OPTION,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PACKING_SLIP,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.RCV_TRANSACTION_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PA_CC_AR_INVOICE_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PA_CC_AR_INVOICE_LINE_NUM,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.REFERENCE_1,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.REFERENCE_2,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PA_CC_PROCESSED_CODE,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.TAX_RECOVERY_RATE,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.TAX_RECOVERY_OVERRIDE_FLAG,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.TAX_RECOVERABLE_FLAG,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.TAX_CODE_OVERRIDE_FLAG,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.TAX_CODE_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.CREDIT_CARD_TRX_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.AWARD_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.VENDOR_ITEM_NUM,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.TAXABLE_FLAG,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PRICE_CORRECT_INV_NUM,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.EXTERNAL_DOC_LINE_REF,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.INVOICE_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.INVOICE_LINE_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.LINE_NUMBER,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.LINE_TYPE_LOOKUP_CODE,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.LINE_GROUP_NUMBER,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.AMOUNT,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ACCOUNTING_DATE,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.DESCRIPTION,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.AMOUNT_INCLUDES_TAX_FLAG,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PRORATE_ACROSS_FLAG,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.TAX_CODE,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.FINAL_MATCH_FLAG,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PO_HEADER_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PO_NUMBER,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PO_LINE_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PO_LINE_NUMBER,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PO_LINE_LOCATION_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PO_SHIPMENT_NUM,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PO_DISTRIBUTION_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PO_DISTRIBUTION_NUM,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.PO_UNIT_OF_MEASURE,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.INVENTORY_ITEM_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.ITEM_DESCRIPTION,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.QUANTITY_INVOICED,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.SHIP_TO_LOCATION_CODE,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.UNIT_PRICE,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.DISTRIBUTION_SET_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.DISTRIBUTION_SET_NAME,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.DIST_CODE_CONCATENATED,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.DIST_CODE_COMBINATION_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.AWT_GROUP_ID,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.AWT_GROUP_NAME,
                                             p_r_SFWBR_AP_INVOICE_LINES_INT.LAST_UPDATED_BY);
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000,'Erro ao inserir na tabela SFWBR_AP_INVO_LINES_INTER. ' || sqlerrm);
   END EBS_AP_INVOICE_LINES_INTERFACE;
   --
   PROCEDURE EBS_TMP_AP_INVO_INTERFACE(p_r_EBS_T_AP_INVO_INTER R12_DBL_T_AP_INVO_INTER%ROWTYPE) is
   BEGIN
      INSERT INTO R12_DBL_T_AP_INVO_INTER(INVOICE_ID,
                                          INVOICE_NUM,
                                          INVOICE_TYPE_LOOKUP_CODE,
                                          INVOICE_DATE,
                                          PO_NUMBER,
                                          VENDOR_ID,
                                          VENDOR_NUM,
                                          VENDOR_NAME,
                                          VENDOR_SITE_ID,
                                          VENDOR_SITE_CODE,
                                          INVOICE_AMOUNT,
                                          INVOICE_CURRENCY_CODE,
                                          EXCHANGE_RATE,
                                          EXCHANGE_RATE_TYPE,
                                          EXCHANGE_DATE,
                                          TERMS_ID,
                                          TERMS_NAME,
                                          DESCRIPTION,
                                          AWT_GROUP_ID,
                                          AWT_GROUP_NAME,
                                          LAST_UPDATE_DATE,
                                          LAST_UPDATED_BY,
                                          LAST_UPDATE_LOGIN,
                                          CREATION_DATE,
                                          CREATED_BY,
                                          ATTRIBUTE_CATEGORY,
                                          ATTRIBUTE1,
                                          ATTRIBUTE2,
                                          ATTRIBUTE3,
                                          ATTRIBUTE4,
                                          ATTRIBUTE5,
                                          ATTRIBUTE6,
                                          ATTRIBUTE7,
                                          ATTRIBUTE8,
                                          ATTRIBUTE9,
                                          ATTRIBUTE10,
                                          ATTRIBUTE11,
                                          ATTRIBUTE12,
                                          ATTRIBUTE13,
                                          ATTRIBUTE14,
                                          ATTRIBUTE15,
                                          GLOBAL_ATTRIBUTE_CATEGORY,
                                          GLOBAL_ATTRIBUTE1,
                                          GLOBAL_ATTRIBUTE2,
                                          GLOBAL_ATTRIBUTE3,
                                          GLOBAL_ATTRIBUTE4,
                                          GLOBAL_ATTRIBUTE5,
                                          GLOBAL_ATTRIBUTE6,
                                          GLOBAL_ATTRIBUTE7,
                                          GLOBAL_ATTRIBUTE8,
                                          GLOBAL_ATTRIBUTE9,
                                          GLOBAL_ATTRIBUTE10,
                                          GLOBAL_ATTRIBUTE11,
                                          GLOBAL_ATTRIBUTE12,
                                          GLOBAL_ATTRIBUTE13,
                                          GLOBAL_ATTRIBUTE14,
                                          GLOBAL_ATTRIBUTE15,
                                          GLOBAL_ATTRIBUTE16,
                                          GLOBAL_ATTRIBUTE17,
                                          GLOBAL_ATTRIBUTE18,
                                          GLOBAL_ATTRIBUTE19,
                                          GLOBAL_ATTRIBUTE20,
                                          STATUS,
                                          SOURCE,
                                          GROUP_ID,
                                          REQUEST_ID,
                                          PAYMENT_CROSS_RATE_TYPE,
                                          PAYMENT_CROSS_RATE_DATE,
                                          PAYMENT_CROSS_RATE,
                                          PAYMENT_CURRENCY_CODE,
                                          WORKFLOW_FLAG,
                                          DOC_CATEGORY_CODE,
                                          VOUCHER_NUM,
                                          PAYMENT_METHOD_LOOKUP_CODE,
                                          PAY_GROUP_LOOKUP_CODE,
                                          GOODS_RECEIVED_DATE,
                                          INVOICE_RECEIVED_DATE,
                                          GL_DATE,
                                          ACCTS_PAY_CODE_COMBINATION_ID,
                                          USSGL_TRANSACTION_CODE,
                                          EXCLUSIVE_PAYMENT_FLAG,
                                          ORG_ID,
                                          AMOUNT_APPLICABLE_TO_DISCOUNT,
                                          PREPAY_NUM,
                                          PREPAY_DIST_NUM,
                                          PREPAY_APPLY_AMOUNT,
                                          PREPAY_GL_DATE,
                                          INVOICE_INCLUDES_PREPAY_FLAG,
                                          NO_XRATE_BASE_AMOUNT,
                                          VENDOR_EMAIL_ADDRESS,
                                          TERMS_DATE,
                                          REQUESTER_ID,
                                          SHIP_TO_LOCATION,
                                          EXTERNAL_DOC_REF)
      VALUES                             (p_r_EBS_T_AP_INVO_INTER.INVOICE_ID,
                                          p_r_EBS_T_AP_INVO_INTER.INVOICE_NUM,
                                          p_r_EBS_T_AP_INVO_INTER.INVOICE_TYPE_LOOKUP_CODE,
                                          p_r_EBS_T_AP_INVO_INTER.INVOICE_DATE,
                                          p_r_EBS_T_AP_INVO_INTER.PO_NUMBER,
                                          p_r_EBS_T_AP_INVO_INTER.VENDOR_ID,
                                          p_r_EBS_T_AP_INVO_INTER.VENDOR_NUM,
                                          p_r_EBS_T_AP_INVO_INTER.VENDOR_NAME,
                                          p_r_EBS_T_AP_INVO_INTER.VENDOR_SITE_ID,
                                          p_r_EBS_T_AP_INVO_INTER.VENDOR_SITE_CODE,
                                          p_r_EBS_T_AP_INVO_INTER.INVOICE_AMOUNT,
                                          p_r_EBS_T_AP_INVO_INTER.INVOICE_CURRENCY_CODE,
                                          p_r_EBS_T_AP_INVO_INTER.EXCHANGE_RATE,
                                          p_r_EBS_T_AP_INVO_INTER.EXCHANGE_RATE_TYPE,
                                          p_r_EBS_T_AP_INVO_INTER.EXCHANGE_DATE,
                                          p_r_EBS_T_AP_INVO_INTER.TERMS_ID,
                                          p_r_EBS_T_AP_INVO_INTER.TERMS_NAME,
                                          p_r_EBS_T_AP_INVO_INTER.DESCRIPTION,
                                          p_r_EBS_T_AP_INVO_INTER.AWT_GROUP_ID,
                                          p_r_EBS_T_AP_INVO_INTER.AWT_GROUP_NAME,
                                          p_r_EBS_T_AP_INVO_INTER.LAST_UPDATE_DATE,
                                          p_r_EBS_T_AP_INVO_INTER.LAST_UPDATED_BY,
                                          p_r_EBS_T_AP_INVO_INTER.LAST_UPDATE_LOGIN,
                                          p_r_EBS_T_AP_INVO_INTER.CREATION_DATE,
                                          p_r_EBS_T_AP_INVO_INTER.CREATED_BY,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE_CATEGORY,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE1,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE2,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE3,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE4,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE5,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE6,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE7,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE8,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE9,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE10,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE11,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE12,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE13,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE14,
                                          p_r_EBS_T_AP_INVO_INTER.ATTRIBUTE15,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE_CATEGORY,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE1,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE2,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE3,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE4,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE5,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE6,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE7,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE8,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE9,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE10,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE11,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE12,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE13,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE14,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE15,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE16,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE17,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE18,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE19,
                                          p_r_EBS_T_AP_INVO_INTER.GLOBAL_ATTRIBUTE20,
                                          p_r_EBS_T_AP_INVO_INTER.STATUS,
                                          p_r_EBS_T_AP_INVO_INTER.SOURCE,
                                          p_r_EBS_T_AP_INVO_INTER.GROUP_ID,
                                          p_r_EBS_T_AP_INVO_INTER.REQUEST_ID,
                                          p_r_EBS_T_AP_INVO_INTER.PAYMENT_CROSS_RATE_TYPE,
                                          p_r_EBS_T_AP_INVO_INTER.PAYMENT_CROSS_RATE_DATE,
                                          p_r_EBS_T_AP_INVO_INTER.PAYMENT_CROSS_RATE,
                                          p_r_EBS_T_AP_INVO_INTER.PAYMENT_CURRENCY_CODE,
                                          p_r_EBS_T_AP_INVO_INTER.WORKFLOW_FLAG,
                                          p_r_EBS_T_AP_INVO_INTER.DOC_CATEGORY_CODE,
                                          p_r_EBS_T_AP_INVO_INTER.VOUCHER_NUM,
                                          p_r_EBS_T_AP_INVO_INTER.PAYMENT_METHOD_LOOKUP_CODE,
                                          p_r_EBS_T_AP_INVO_INTER.PAY_GROUP_LOOKUP_CODE,
                                          p_r_EBS_T_AP_INVO_INTER.GOODS_RECEIVED_DATE,
                                          p_r_EBS_T_AP_INVO_INTER.INVOICE_RECEIVED_DATE,
                                          p_r_EBS_T_AP_INVO_INTER.GL_DATE,
                                          p_r_EBS_T_AP_INVO_INTER.ACCTS_PAY_CODE_COMBINATION_ID,
                                          p_r_EBS_T_AP_INVO_INTER.USSGL_TRANSACTION_CODE,
                                          p_r_EBS_T_AP_INVO_INTER.EXCLUSIVE_PAYMENT_FLAG,
                                          p_r_EBS_T_AP_INVO_INTER.ORG_ID,
                                          p_r_EBS_T_AP_INVO_INTER.AMOUNT_APPLICABLE_TO_DISCOUNT,
                                          p_r_EBS_T_AP_INVO_INTER.PREPAY_NUM,
                                          p_r_EBS_T_AP_INVO_INTER.PREPAY_DIST_NUM,
                                          p_r_EBS_T_AP_INVO_INTER.PREPAY_APPLY_AMOUNT,
                                          p_r_EBS_T_AP_INVO_INTER.PREPAY_GL_DATE,
                                          p_r_EBS_T_AP_INVO_INTER.INVOICE_INCLUDES_PREPAY_FLAG,
                                          p_r_EBS_T_AP_INVO_INTER.NO_XRATE_BASE_AMOUNT,
                                          p_r_EBS_T_AP_INVO_INTER.VENDOR_EMAIL_ADDRESS,
                                          p_r_EBS_T_AP_INVO_INTER.TERMS_DATE,
                                          p_r_EBS_T_AP_INVO_INTER.REQUESTER_ID,
                                          p_r_EBS_T_AP_INVO_INTER.SHIP_TO_LOCATION,
                                          p_r_EBS_T_AP_INVO_INTER.EXTERNAL_DOC_REF);
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000,'Erro ao inserir na tabela R12_DBL_T_AP_INVO_INTER. ' || sqlerrm);
   END EBS_TMP_AP_INVO_INTERFACE;
   --
   PROCEDURE EBS_TMP_AP_INVO_LINES_INTER(p_r_EBS_T_AP_INVOICE_LINES_INT R12_DBL_T_AP_INVO_LINES_INTER%ROWTYPE) is
   BEGIN
      INSERT INTO R12_DBL_T_AP_INVO_LINES_INTER(LAST_UPDATE_DATE,
                                                LAST_UPDATE_LOGIN,
                                                CREATED_BY,
                                                CREATION_DATE,
                                                ATTRIBUTE_CATEGORY,
                                                ATTRIBUTE1,
                                                ATTRIBUTE2,
                                                ATTRIBUTE3,
                                                ATTRIBUTE4,
                                                ATTRIBUTE5,
                                                ATTRIBUTE6,
                                                ATTRIBUTE7,
                                                ATTRIBUTE8,
                                                ATTRIBUTE9,
                                                ATTRIBUTE10,
                                                ATTRIBUTE11,
                                                ATTRIBUTE12,
                                                ATTRIBUTE13,
                                                ATTRIBUTE14,
                                                ATTRIBUTE15,
                                                GLOBAL_ATTRIBUTE_CATEGORY,
                                                GLOBAL_ATTRIBUTE1,
                                                GLOBAL_ATTRIBUTE2,
                                                GLOBAL_ATTRIBUTE3,
                                                GLOBAL_ATTRIBUTE4,
                                                GLOBAL_ATTRIBUTE5,
                                                GLOBAL_ATTRIBUTE6,
                                                GLOBAL_ATTRIBUTE7,
                                                GLOBAL_ATTRIBUTE8,
                                                GLOBAL_ATTRIBUTE9,
                                                GLOBAL_ATTRIBUTE10,
                                                GLOBAL_ATTRIBUTE11,
                                                GLOBAL_ATTRIBUTE12,
                                                GLOBAL_ATTRIBUTE13,
                                                GLOBAL_ATTRIBUTE14,
                                                GLOBAL_ATTRIBUTE15,
                                                GLOBAL_ATTRIBUTE16,
                                                GLOBAL_ATTRIBUTE17,
                                                GLOBAL_ATTRIBUTE18,
                                                GLOBAL_ATTRIBUTE19,
                                                GLOBAL_ATTRIBUTE20,
                                                PO_RELEASE_ID,
                                                RELEASE_NUM,
                                                ACCOUNT_SEGMENT,
                                                BALANCING_SEGMENT,
                                                COST_CENTER_SEGMENT,
                                                PROJECT_ID,
                                                TASK_ID,
                                                EXPENDITURE_TYPE,
                                                EXPENDITURE_ITEM_DATE,
                                                EXPENDITURE_ORGANIZATION_ID,
                                                PROJECT_ACCOUNTING_CONTEXT,
                                                PA_ADDITION_FLAG,
                                                PA_QUANTITY,
                                                USSGL_TRANSACTION_CODE,
                                                STAT_AMOUNT,
                                                TYPE_1099,
                                                INCOME_TAX_REGION,
                                                ASSETS_TRACKING_FLAG,
                                                PRICE_CORRECTION_FLAG,
                                                ORG_ID,
                                                RECEIPT_NUMBER,
                                                RECEIPT_LINE_NUMBER,
                                                MATCH_OPTION,
                                                PACKING_SLIP,
                                                RCV_TRANSACTION_ID,
                                                PA_CC_AR_INVOICE_ID,
                                                PA_CC_AR_INVOICE_LINE_NUM,
                                                REFERENCE_1,
                                                REFERENCE_2,
                                                PA_CC_PROCESSED_CODE,
                                                TAX_RECOVERY_RATE,
                                                TAX_RECOVERY_OVERRIDE_FLAG,
                                                TAX_RECOVERABLE_FLAG,
                                                TAX_CODE_OVERRIDE_FLAG,
                                                TAX_CODE_ID,
                                                CREDIT_CARD_TRX_ID,
                                                AWARD_ID,
                                                VENDOR_ITEM_NUM,
                                                TAXABLE_FLAG,
                                                PRICE_CORRECT_INV_NUM,
                                                EXTERNAL_DOC_LINE_REF,
                                                INVOICE_ID,
                                                INVOICE_LINE_ID,
                                                LINE_NUMBER,
                                                LINE_TYPE_LOOKUP_CODE,
                                                LINE_GROUP_NUMBER,
                                                AMOUNT,
                                                ACCOUNTING_DATE,
                                                DESCRIPTION,
                                                AMOUNT_INCLUDES_TAX_FLAG,
                                                PRORATE_ACROSS_FLAG,
                                                TAX_CODE,
                                                FINAL_MATCH_FLAG,
                                                PO_HEADER_ID,
                                                PO_NUMBER,
                                                PO_LINE_ID,
                                                PO_LINE_NUMBER,
                                                PO_LINE_LOCATION_ID,
                                                PO_SHIPMENT_NUM,
                                                PO_DISTRIBUTION_ID,
                                                PO_DISTRIBUTION_NUM,
                                                PO_UNIT_OF_MEASURE,
                                                INVENTORY_ITEM_ID,
                                                ITEM_DESCRIPTION,
                                                QUANTITY_INVOICED,
                                                SHIP_TO_LOCATION_CODE,
                                                UNIT_PRICE,
                                                DISTRIBUTION_SET_ID,
                                                DISTRIBUTION_SET_NAME,
                                                DIST_CODE_CONCATENATED,
                                                DIST_CODE_COMBINATION_ID,
                                                AWT_GROUP_ID,
                                                AWT_GROUP_NAME,
                                                LAST_UPDATED_BY)
      VALUES                                   (p_r_EBS_T_AP_INVOICE_LINES_INT.LAST_UPDATE_DATE,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.LAST_UPDATE_LOGIN,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.CREATED_BY,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.CREATION_DATE,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE_CATEGORY,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE1,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE2,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE3,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE4,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE5,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE6,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE7,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE8,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE9,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE10,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE11,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE12,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE13,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE14,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ATTRIBUTE15,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE_CATEGORY,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE1,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE2,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE3,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE4,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE5,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE6,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE7,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE8,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE9,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE10,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE11,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE12,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE13,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE14,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE15,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE16,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE17,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE18,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE19,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.GLOBAL_ATTRIBUTE20,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PO_RELEASE_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.RELEASE_NUM,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ACCOUNT_SEGMENT,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.BALANCING_SEGMENT,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.COST_CENTER_SEGMENT,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PROJECT_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.TASK_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.EXPENDITURE_TYPE,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.EXPENDITURE_ITEM_DATE,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.EXPENDITURE_ORGANIZATION_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PROJECT_ACCOUNTING_CONTEXT,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PA_ADDITION_FLAG,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PA_QUANTITY,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.USSGL_TRANSACTION_CODE,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.STAT_AMOUNT,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.TYPE_1099,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.INCOME_TAX_REGION,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ASSETS_TRACKING_FLAG,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PRICE_CORRECTION_FLAG,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ORG_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.RECEIPT_NUMBER,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.RECEIPT_LINE_NUMBER,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.MATCH_OPTION,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PACKING_SLIP,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.RCV_TRANSACTION_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PA_CC_AR_INVOICE_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PA_CC_AR_INVOICE_LINE_NUM,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.REFERENCE_1,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.REFERENCE_2,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PA_CC_PROCESSED_CODE,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.TAX_RECOVERY_RATE,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.TAX_RECOVERY_OVERRIDE_FLAG,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.TAX_RECOVERABLE_FLAG,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.TAX_CODE_OVERRIDE_FLAG,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.TAX_CODE_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.CREDIT_CARD_TRX_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.AWARD_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.VENDOR_ITEM_NUM,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.TAXABLE_FLAG,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PRICE_CORRECT_INV_NUM,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.EXTERNAL_DOC_LINE_REF,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.INVOICE_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.INVOICE_LINE_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.LINE_NUMBER,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.LINE_TYPE_LOOKUP_CODE,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.LINE_GROUP_NUMBER,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.AMOUNT,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ACCOUNTING_DATE,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.DESCRIPTION,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.AMOUNT_INCLUDES_TAX_FLAG,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PRORATE_ACROSS_FLAG,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.TAX_CODE,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.FINAL_MATCH_FLAG,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PO_HEADER_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PO_NUMBER,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PO_LINE_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PO_LINE_NUMBER,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PO_LINE_LOCATION_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PO_SHIPMENT_NUM,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PO_DISTRIBUTION_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PO_DISTRIBUTION_NUM,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.PO_UNIT_OF_MEASURE,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.INVENTORY_ITEM_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.ITEM_DESCRIPTION,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.QUANTITY_INVOICED,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.SHIP_TO_LOCATION_CODE,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.UNIT_PRICE,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.DISTRIBUTION_SET_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.DISTRIBUTION_SET_NAME,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.DIST_CODE_CONCATENATED,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.DIST_CODE_COMBINATION_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.AWT_GROUP_ID,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.AWT_GROUP_NAME,
                                                p_r_EBS_T_AP_INVOICE_LINES_INT.LAST_UPDATED_BY);
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000,'Erro ao inserir na tabela R12_DBL_T_AP_INVO_LINES_INTER. ' || sqlerrm);
   END EBS_TMP_AP_INVO_LINES_INTER;
   --
   PROCEDURE EBS_RA_INTERFACE_LINES_ALL(p_r_RA_INTERFACE_LINES_ALL SFWBR_RA_INTERFACE_LINES_ALL%ROWTYPE) is
   BEGIN
      INSERT INTO SFWBR_RA_INTERFACE_LINES_ALL(INTERFACE_LINE_ID,
                                               INTERFACE_LINE_CONTEXT,
                                               INTERFACE_LINE_ATTRIBUTE1,
                                               INTERFACE_LINE_ATTRIBUTE2,
                                               INTERFACE_LINE_ATTRIBUTE3,
                                               INTERFACE_LINE_ATTRIBUTE4,
                                               INTERFACE_LINE_ATTRIBUTE5,
                                               INTERFACE_LINE_ATTRIBUTE6,
                                               INTERFACE_LINE_ATTRIBUTE7,
                                               INTERFACE_LINE_ATTRIBUTE8,
                                               BATCH_SOURCE_NAME,
                                               SET_OF_BOOKS_ID,
                                               LINE_TYPE,
                                               DESCRIPTION,
                                               CURRENCY_CODE,
                                               AMOUNT,
                                               CUST_TRX_TYPE_NAME,
                                               CUST_TRX_TYPE_ID,
                                               TERM_NAME,
                                               TERM_ID,
                                               ORIG_SYSTEM_BATCH_NAME,
                                               ORIG_SYSTEM_BILL_CUSTOMER_REF,
                                               ORIG_SYSTEM_BILL_CUSTOMER_ID,
                                               ORIG_SYSTEM_BILL_ADDRESS_REF,
                                               ORIG_SYSTEM_BILL_ADDRESS_ID,
                                               ORIG_SYSTEM_BILL_CONTACT_REF,
                                               ORIG_SYSTEM_BILL_CONTACT_ID,
                                               ORIG_SYSTEM_SHIP_CUSTOMER_REF,
                                               ORIG_SYSTEM_SHIP_CUSTOMER_ID,
                                               ORIG_SYSTEM_SHIP_ADDRESS_REF,
                                               ORIG_SYSTEM_SHIP_ADDRESS_ID,
                                               ORIG_SYSTEM_SHIP_CONTACT_REF,
                                               ORIG_SYSTEM_SHIP_CONTACT_ID,
                                               ORIG_SYSTEM_SOLD_CUSTOMER_REF,
                                               ORIG_SYSTEM_SOLD_CUSTOMER_ID,
                                               LINK_TO_LINE_ID,
                                               LINK_TO_LINE_CONTEXT,
                                               LINK_TO_LINE_ATTRIBUTE1,
                                               LINK_TO_LINE_ATTRIBUTE2,
                                               LINK_TO_LINE_ATTRIBUTE3,
                                               LINK_TO_LINE_ATTRIBUTE4,
                                               LINK_TO_LINE_ATTRIBUTE5,
                                               LINK_TO_LINE_ATTRIBUTE6,
                                               LINK_TO_LINE_ATTRIBUTE7,
                                               RECEIPT_METHOD_NAME,
                                               RECEIPT_METHOD_ID,
                                               CONVERSION_TYPE,
                                               CONVERSION_DATE,
                                               CONVERSION_RATE,
                                               CUSTOMER_TRX_ID,
                                               TRX_DATE,
                                               GL_DATE,
                                               DOCUMENT_NUMBER,
                                               TRX_NUMBER,
                                               LINE_NUMBER,
                                               QUANTITY,
                                               QUANTITY_ORDERED,
                                               UNIT_SELLING_PRICE,
                                               UNIT_STANDARD_PRICE,
                                               PRINTING_OPTION,
                                               INTERFACE_STATUS,
                                               REQUEST_ID,
                                               RELATED_BATCH_SOURCE_NAME,
                                               RELATED_TRX_NUMBER,
                                               RELATED_CUSTOMER_TRX_ID,
                                               PREVIOUS_CUSTOMER_TRX_ID,
                                               CREDIT_METHOD_FOR_ACCT_RULE,
                                               CREDIT_METHOD_FOR_INSTALLMENTS,
                                               REASON_CODE,
                                               TAX_RATE,
                                               TAX_CODE,
                                               TAX_PRECEDENCE,
                                               EXCEPTION_ID,
                                               EXEMPTION_ID,
                                               SHIP_DATE_ACTUAL,
                                               FOB_POINT,
                                               SHIP_VIA,
                                               WAYBILL_NUMBER,
                                               INVOICING_RULE_NAME,
                                               INVOICING_RULE_ID,
                                               ACCOUNTING_RULE_NAME,
                                               ACCOUNTING_RULE_ID,
                                               ACCOUNTING_RULE_DURATION,
                                               RULE_START_DATE,
                                               PRIMARY_SALESREP_NUMBER,
                                               PRIMARY_SALESREP_ID,
                                               SALES_ORDER,
                                               SALES_ORDER_LINE,
                                               SALES_ORDER_DATE,
                                               SALES_ORDER_SOURCE,
                                               SALES_ORDER_REVISION,
                                               PURCHASE_ORDER,
                                               PURCHASE_ORDER_REVISION,
                                               PURCHASE_ORDER_DATE,
                                               AGREEMENT_NAME,
                                               AGREEMENT_ID,
                                               MEMO_LINE_NAME,
                                               MEMO_LINE_ID,
                                               INVENTORY_ITEM_ID,
                                               MTL_SYSTEM_ITEMS_SEG1,
                                               MTL_SYSTEM_ITEMS_SEG2,
                                               MTL_SYSTEM_ITEMS_SEG3,
                                               MTL_SYSTEM_ITEMS_SEG4,
                                               MTL_SYSTEM_ITEMS_SEG5,
                                               MTL_SYSTEM_ITEMS_SEG6,
                                               MTL_SYSTEM_ITEMS_SEG7,
                                               MTL_SYSTEM_ITEMS_SEG8,
                                               MTL_SYSTEM_ITEMS_SEG9,
                                               MTL_SYSTEM_ITEMS_SEG10,
                                               MTL_SYSTEM_ITEMS_SEG11,
                                               MTL_SYSTEM_ITEMS_SEG12,
                                               MTL_SYSTEM_ITEMS_SEG13,
                                               MTL_SYSTEM_ITEMS_SEG14,
                                               MTL_SYSTEM_ITEMS_SEG15,
                                               MTL_SYSTEM_ITEMS_SEG16,
                                               MTL_SYSTEM_ITEMS_SEG17,
                                               MTL_SYSTEM_ITEMS_SEG18,
                                               MTL_SYSTEM_ITEMS_SEG19,
                                               MTL_SYSTEM_ITEMS_SEG20,
                                               REFERENCE_LINE_ID,
                                               REFERENCE_LINE_CONTEXT,
                                               REFERENCE_LINE_ATTRIBUTE1,
                                               REFERENCE_LINE_ATTRIBUTE2,
                                               REFERENCE_LINE_ATTRIBUTE3,
                                               REFERENCE_LINE_ATTRIBUTE4,
                                               REFERENCE_LINE_ATTRIBUTE5,
                                               REFERENCE_LINE_ATTRIBUTE6,
                                               REFERENCE_LINE_ATTRIBUTE7,
                                               TERRITORY_ID,
                                               TERRITORY_SEGMENT1,
                                               TERRITORY_SEGMENT2,
                                               TERRITORY_SEGMENT3,
                                               TERRITORY_SEGMENT4,
                                               TERRITORY_SEGMENT5,
                                               TERRITORY_SEGMENT6,
                                               TERRITORY_SEGMENT7,
                                               TERRITORY_SEGMENT8,
                                               TERRITORY_SEGMENT9,
                                               TERRITORY_SEGMENT10,
                                               TERRITORY_SEGMENT11,
                                               TERRITORY_SEGMENT12,
                                               TERRITORY_SEGMENT13,
                                               TERRITORY_SEGMENT14,
                                               TERRITORY_SEGMENT15,
                                               TERRITORY_SEGMENT16,
                                               TERRITORY_SEGMENT17,
                                               TERRITORY_SEGMENT18,
                                               TERRITORY_SEGMENT19,
                                               TERRITORY_SEGMENT20,
                                               ATTRIBUTE_CATEGORY,
                                               ATTRIBUTE1,
                                               ATTRIBUTE2,
                                               ATTRIBUTE3,
                                               ATTRIBUTE4,
                                               ATTRIBUTE5,
                                               ATTRIBUTE6,
                                               ATTRIBUTE7,
                                               ATTRIBUTE8,
                                               ATTRIBUTE9,
                                               ATTRIBUTE10,
                                               ATTRIBUTE11,
                                               ATTRIBUTE12,
                                               ATTRIBUTE13,
                                               ATTRIBUTE14,
                                               ATTRIBUTE15,
                                               HEADER_ATTRIBUTE_CATEGORY,
                                               HEADER_ATTRIBUTE1,
                                               HEADER_ATTRIBUTE2,
                                               HEADER_ATTRIBUTE3,
                                               HEADER_ATTRIBUTE4,
                                               HEADER_ATTRIBUTE5,
                                               HEADER_ATTRIBUTE6,
                                               HEADER_ATTRIBUTE7,
                                               HEADER_ATTRIBUTE8,
                                               HEADER_ATTRIBUTE9,
                                               HEADER_ATTRIBUTE10,
                                               HEADER_ATTRIBUTE11,
                                               HEADER_ATTRIBUTE12,
                                               HEADER_ATTRIBUTE13,
                                               HEADER_ATTRIBUTE14,
                                               HEADER_ATTRIBUTE15,
                                               COMMENTS,
                                               INTERNAL_NOTES,
                                               INITIAL_CUSTOMER_TRX_ID,
                                               USSGL_TRANSACTION_CODE_CONTEXT,
                                               USSGL_TRANSACTION_CODE,
                                               ACCTD_AMOUNT,
                                               CUSTOMER_BANK_ACCOUNT_ID,
                                               CUSTOMER_BANK_ACCOUNT_NAME,
                                               UOM_CODE,
                                               UOM_NAME,
                                               DOCUMENT_NUMBER_SEQUENCE_ID,
                                               LINK_TO_LINE_ATTRIBUTE10,
                                               LINK_TO_LINE_ATTRIBUTE11,
                                               LINK_TO_LINE_ATTRIBUTE12,
                                               LINK_TO_LINE_ATTRIBUTE13,
                                               LINK_TO_LINE_ATTRIBUTE14,
                                               LINK_TO_LINE_ATTRIBUTE15,
                                               LINK_TO_LINE_ATTRIBUTE8,
                                               LINK_TO_LINE_ATTRIBUTE9,
                                               REFERENCE_LINE_ATTRIBUTE10,
                                               REFERENCE_LINE_ATTRIBUTE11,
                                               REFERENCE_LINE_ATTRIBUTE12,
                                               REFERENCE_LINE_ATTRIBUTE13,
                                               REFERENCE_LINE_ATTRIBUTE14,
                                               REFERENCE_LINE_ATTRIBUTE15,
                                               REFERENCE_LINE_ATTRIBUTE8,
                                               REFERENCE_LINE_ATTRIBUTE9,
                                               INTERFACE_LINE_ATTRIBUTE10,
                                               INTERFACE_LINE_ATTRIBUTE11,
                                               INTERFACE_LINE_ATTRIBUTE12,
                                               INTERFACE_LINE_ATTRIBUTE13,
                                               INTERFACE_LINE_ATTRIBUTE14,
                                               INTERFACE_LINE_ATTRIBUTE15,
                                               INTERFACE_LINE_ATTRIBUTE9,
                                               VAT_TAX_ID,
                                               REASON_CODE_MEANING,
                                               LAST_PERIOD_TO_CREDIT,
                                               PAYING_CUSTOMER_ID,
                                               PAYING_SITE_USE_ID,
                                               TAX_EXEMPT_FLAG,
                                               TAX_EXEMPT_REASON_CODE,
                                               TAX_EXEMPT_REASON_CODE_MEANING,
                                               TAX_EXEMPT_NUMBER,
                                               SALES_TAX_ID,
                                               CREATED_BY,
                                               CREATION_DATE,
                                               LAST_UPDATED_BY,
                                               LAST_UPDATE_DATE,
                                               LAST_UPDATE_LOGIN,
                                               LOCATION_SEGMENT_ID,
                                               MOVEMENT_ID,
                                               ORG_ID,
                                               AMOUNT_INCLUDES_TAX_FLAG,
                                               HEADER_GDF_ATTR_CATEGORY,
                                               HEADER_GDF_ATTRIBUTE1,
                                               HEADER_GDF_ATTRIBUTE2,
                                               HEADER_GDF_ATTRIBUTE3,
                                               HEADER_GDF_ATTRIBUTE4,
                                               HEADER_GDF_ATTRIBUTE5,
                                               HEADER_GDF_ATTRIBUTE6,
                                               HEADER_GDF_ATTRIBUTE7,
                                               HEADER_GDF_ATTRIBUTE8,
                                               HEADER_GDF_ATTRIBUTE9,
                                               HEADER_GDF_ATTRIBUTE10,
                                               HEADER_GDF_ATTRIBUTE11,
                                               HEADER_GDF_ATTRIBUTE12,
                                               HEADER_GDF_ATTRIBUTE13,
                                               HEADER_GDF_ATTRIBUTE14,
                                               HEADER_GDF_ATTRIBUTE15,
                                               HEADER_GDF_ATTRIBUTE16,
                                               HEADER_GDF_ATTRIBUTE17,
                                               HEADER_GDF_ATTRIBUTE18,
                                               HEADER_GDF_ATTRIBUTE19,
                                               HEADER_GDF_ATTRIBUTE20,
                                               HEADER_GDF_ATTRIBUTE21,
                                               HEADER_GDF_ATTRIBUTE22,
                                               HEADER_GDF_ATTRIBUTE23,
                                               HEADER_GDF_ATTRIBUTE24,
                                               HEADER_GDF_ATTRIBUTE25,
                                               HEADER_GDF_ATTRIBUTE26,
                                               HEADER_GDF_ATTRIBUTE27,
                                               HEADER_GDF_ATTRIBUTE28,
                                               HEADER_GDF_ATTRIBUTE29,
                                               HEADER_GDF_ATTRIBUTE30,
                                               LINE_GDF_ATTR_CATEGORY,
                                               LINE_GDF_ATTRIBUTE1,
                                               LINE_GDF_ATTRIBUTE2,
                                               LINE_GDF_ATTRIBUTE3,
                                               LINE_GDF_ATTRIBUTE4,
                                               LINE_GDF_ATTRIBUTE5,
                                               LINE_GDF_ATTRIBUTE6,
                                               LINE_GDF_ATTRIBUTE7,
                                               LINE_GDF_ATTRIBUTE8,
                                               LINE_GDF_ATTRIBUTE9,
                                               LINE_GDF_ATTRIBUTE10,
                                               LINE_GDF_ATTRIBUTE11,
                                               LINE_GDF_ATTRIBUTE12,
                                               LINE_GDF_ATTRIBUTE13,
                                               LINE_GDF_ATTRIBUTE14,
                                               LINE_GDF_ATTRIBUTE15,
                                               LINE_GDF_ATTRIBUTE16,
                                               LINE_GDF_ATTRIBUTE17,
                                               LINE_GDF_ATTRIBUTE18,
                                               LINE_GDF_ATTRIBUTE19,
                                               LINE_GDF_ATTRIBUTE20,
                                               RESET_TRX_DATE_FLAG,
                                               PAYMENT_SERVER_ORDER_NUM,
                                               APPROVAL_CODE,
                                               ADDRESS_VERIFICATION_CODE,
                                               WAREHOUSE_ID,
                                               TRANSLATED_DESCRIPTION,
                                               CONS_BILLING_NUMBER,
                                               PROMISED_COMMITMENT_AMOUNT,
                                               PAYMENT_SET_ID,
                                               ORIGINAL_GL_DATE,
                                               CONTRACT_LINE_ID,
                                               CONTRACT_ID,
                                               SOURCE_DATA_KEY1,
                                               SOURCE_DATA_KEY2,
                                               SOURCE_DATA_KEY3,
                                               SOURCE_DATA_KEY4,
                                               SOURCE_DATA_KEY5,
                                               INVOICED_LINE_ACCTG_LEVEL)
      VALUES                                  (p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_CONTEXT,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ATTRIBUTE1,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ATTRIBUTE2,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ATTRIBUTE3,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ATTRIBUTE4,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ATTRIBUTE5,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ATTRIBUTE6,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ATTRIBUTE7,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ATTRIBUTE8,
                                               p_r_RA_INTERFACE_LINES_ALL.BATCH_SOURCE_NAME,
                                               p_r_RA_INTERFACE_LINES_ALL.SET_OF_BOOKS_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_TYPE,
                                               p_r_RA_INTERFACE_LINES_ALL.DESCRIPTION,
                                               p_r_RA_INTERFACE_LINES_ALL.CURRENCY_CODE,
                                               p_r_RA_INTERFACE_LINES_ALL.AMOUNT,
                                               p_r_RA_INTERFACE_LINES_ALL.CUST_TRX_TYPE_NAME,
                                               p_r_RA_INTERFACE_LINES_ALL.CUST_TRX_TYPE_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.TERM_NAME,
                                               p_r_RA_INTERFACE_LINES_ALL.TERM_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIG_SYSTEM_BATCH_NAME,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIG_SYSTEM_BILL_CUSTOMER_REF,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIG_SYSTEM_BILL_CUSTOMER_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIG_SYSTEM_BILL_ADDRESS_REF,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIG_SYSTEM_BILL_ADDRESS_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIG_SYSTEM_BILL_CONTACT_REF,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIG_SYSTEM_BILL_CONTACT_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIG_SYSTEM_SHIP_CUSTOMER_REF,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIG_SYSTEM_SHIP_CUSTOMER_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIG_SYSTEM_SHIP_ADDRESS_REF,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIG_SYSTEM_SHIP_ADDRESS_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIG_SYSTEM_SHIP_CONTACT_REF,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIG_SYSTEM_SHIP_CONTACT_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIG_SYSTEM_SOLD_CUSTOMER_REF,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIG_SYSTEM_SOLD_CUSTOMER_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_CONTEXT,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ATTRIBUTE1,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ATTRIBUTE2,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ATTRIBUTE3,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ATTRIBUTE4,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ATTRIBUTE5,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ATTRIBUTE6,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ATTRIBUTE7,
                                               p_r_RA_INTERFACE_LINES_ALL.RECEIPT_METHOD_NAME,
                                               p_r_RA_INTERFACE_LINES_ALL.RECEIPT_METHOD_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.CONVERSION_TYPE,
                                               p_r_RA_INTERFACE_LINES_ALL.CONVERSION_DATE,
                                               p_r_RA_INTERFACE_LINES_ALL.CONVERSION_RATE,
                                               p_r_RA_INTERFACE_LINES_ALL.CUSTOMER_TRX_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.TRX_DATE,
                                               p_r_RA_INTERFACE_LINES_ALL.GL_DATE,
                                               p_r_RA_INTERFACE_LINES_ALL.DOCUMENT_NUMBER,
                                               p_r_RA_INTERFACE_LINES_ALL.TRX_NUMBER,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_NUMBER,
                                               p_r_RA_INTERFACE_LINES_ALL.QUANTITY,
                                               p_r_RA_INTERFACE_LINES_ALL.QUANTITY_ORDERED,
                                               p_r_RA_INTERFACE_LINES_ALL.UNIT_SELLING_PRICE,
                                               p_r_RA_INTERFACE_LINES_ALL.UNIT_STANDARD_PRICE,
                                               p_r_RA_INTERFACE_LINES_ALL.PRINTING_OPTION,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_STATUS,
                                               p_r_RA_INTERFACE_LINES_ALL.REQUEST_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.RELATED_BATCH_SOURCE_NAME,
                                               p_r_RA_INTERFACE_LINES_ALL.RELATED_TRX_NUMBER,
                                               p_r_RA_INTERFACE_LINES_ALL.RELATED_CUSTOMER_TRX_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.PREVIOUS_CUSTOMER_TRX_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.CREDIT_METHOD_FOR_ACCT_RULE,
                                               p_r_RA_INTERFACE_LINES_ALL.CREDIT_METHOD_FOR_INSTALLMENTS,
                                               p_r_RA_INTERFACE_LINES_ALL.REASON_CODE,
                                               p_r_RA_INTERFACE_LINES_ALL.TAX_RATE,
                                               p_r_RA_INTERFACE_LINES_ALL.TAX_CODE,
                                               p_r_RA_INTERFACE_LINES_ALL.TAX_PRECEDENCE,
                                               p_r_RA_INTERFACE_LINES_ALL.EXCEPTION_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.EXEMPTION_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.SHIP_DATE_ACTUAL,
                                               p_r_RA_INTERFACE_LINES_ALL.FOB_POINT,
                                               p_r_RA_INTERFACE_LINES_ALL.SHIP_VIA,
                                               p_r_RA_INTERFACE_LINES_ALL.WAYBILL_NUMBER,
                                               p_r_RA_INTERFACE_LINES_ALL.INVOICING_RULE_NAME,
                                               p_r_RA_INTERFACE_LINES_ALL.INVOICING_RULE_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.ACCOUNTING_RULE_NAME,
                                               p_r_RA_INTERFACE_LINES_ALL.ACCOUNTING_RULE_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.ACCOUNTING_RULE_DURATION,
                                               p_r_RA_INTERFACE_LINES_ALL.RULE_START_DATE,
                                               p_r_RA_INTERFACE_LINES_ALL.PRIMARY_SALESREP_NUMBER,
                                               p_r_RA_INTERFACE_LINES_ALL.PRIMARY_SALESREP_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.SALES_ORDER,
                                               p_r_RA_INTERFACE_LINES_ALL.SALES_ORDER_LINE,
                                               p_r_RA_INTERFACE_LINES_ALL.SALES_ORDER_DATE,
                                               p_r_RA_INTERFACE_LINES_ALL.SALES_ORDER_SOURCE,
                                               p_r_RA_INTERFACE_LINES_ALL.SALES_ORDER_REVISION,
                                               p_r_RA_INTERFACE_LINES_ALL.PURCHASE_ORDER,
                                               p_r_RA_INTERFACE_LINES_ALL.PURCHASE_ORDER_REVISION,
                                               p_r_RA_INTERFACE_LINES_ALL.PURCHASE_ORDER_DATE,
                                               p_r_RA_INTERFACE_LINES_ALL.AGREEMENT_NAME,
                                               p_r_RA_INTERFACE_LINES_ALL.AGREEMENT_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.MEMO_LINE_NAME,
                                               p_r_RA_INTERFACE_LINES_ALL.MEMO_LINE_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.INVENTORY_ITEM_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG1,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG2,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG3,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG4,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG5,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG6,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG7,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG8,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG9,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG10,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG11,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG12,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG13,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG14,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG15,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG16,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG17,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG18,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG19,
                                               p_r_RA_INTERFACE_LINES_ALL.MTL_SYSTEM_ITEMS_SEG20,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_CONTEXT,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ATTRIBUTE1,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ATTRIBUTE2,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ATTRIBUTE3,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ATTRIBUTE4,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ATTRIBUTE5,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ATTRIBUTE6,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ATTRIBUTE7,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT1,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT2,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT3,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT4,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT5,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT6,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT7,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT8,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT9,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT10,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT11,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT12,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT13,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT14,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT15,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT16,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT17,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT18,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT19,
                                               p_r_RA_INTERFACE_LINES_ALL.TERRITORY_SEGMENT20,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE_CATEGORY,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE1,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE2,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE3,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE4,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE5,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE6,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE7,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE8,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE9,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE10,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE11,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE12,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE13,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE14,
                                               p_r_RA_INTERFACE_LINES_ALL.ATTRIBUTE15,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE_CATEGORY,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE1,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE2,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE3,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE4,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE5,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE6,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE7,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE8,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE9,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE10,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE11,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE12,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE13,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE14,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_ATTRIBUTE15,
                                               p_r_RA_INTERFACE_LINES_ALL.COMMENTS,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERNAL_NOTES,
                                               p_r_RA_INTERFACE_LINES_ALL.INITIAL_CUSTOMER_TRX_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.USSGL_TRANSACTION_CODE_CONTEXT,
                                               p_r_RA_INTERFACE_LINES_ALL.USSGL_TRANSACTION_CODE,
                                               p_r_RA_INTERFACE_LINES_ALL.ACCTD_AMOUNT,
                                               p_r_RA_INTERFACE_LINES_ALL.CUSTOMER_BANK_ACCOUNT_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.CUSTOMER_BANK_ACCOUNT_NAME,
                                               p_r_RA_INTERFACE_LINES_ALL.UOM_CODE,
                                               p_r_RA_INTERFACE_LINES_ALL.UOM_NAME,
                                               p_r_RA_INTERFACE_LINES_ALL.DOCUMENT_NUMBER_SEQUENCE_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ATTRIBUTE10,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ATTRIBUTE11,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ATTRIBUTE12,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ATTRIBUTE13,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ATTRIBUTE14,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ATTRIBUTE15,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ATTRIBUTE8,
                                               p_r_RA_INTERFACE_LINES_ALL.LINK_TO_LINE_ATTRIBUTE9,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ATTRIBUTE10,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ATTRIBUTE11,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ATTRIBUTE12,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ATTRIBUTE13,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ATTRIBUTE14,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ATTRIBUTE15,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ATTRIBUTE8,
                                               p_r_RA_INTERFACE_LINES_ALL.REFERENCE_LINE_ATTRIBUTE9,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ATTRIBUTE10,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ATTRIBUTE11,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ATTRIBUTE12,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ATTRIBUTE13,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ATTRIBUTE14,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ATTRIBUTE15,
                                               p_r_RA_INTERFACE_LINES_ALL.INTERFACE_LINE_ATTRIBUTE9,
                                               p_r_RA_INTERFACE_LINES_ALL.VAT_TAX_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.REASON_CODE_MEANING,
                                               p_r_RA_INTERFACE_LINES_ALL.LAST_PERIOD_TO_CREDIT,
                                               p_r_RA_INTERFACE_LINES_ALL.PAYING_CUSTOMER_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.PAYING_SITE_USE_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.TAX_EXEMPT_FLAG,
                                               p_r_RA_INTERFACE_LINES_ALL.TAX_EXEMPT_REASON_CODE,
                                               p_r_RA_INTERFACE_LINES_ALL.TAX_EXEMPT_REASON_CODE_MEANING,
                                               p_r_RA_INTERFACE_LINES_ALL.TAX_EXEMPT_NUMBER,
                                               p_r_RA_INTERFACE_LINES_ALL.SALES_TAX_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.CREATED_BY,
                                               p_r_RA_INTERFACE_LINES_ALL.CREATION_DATE,
                                               p_r_RA_INTERFACE_LINES_ALL.LAST_UPDATED_BY,
                                               p_r_RA_INTERFACE_LINES_ALL.LAST_UPDATE_DATE,
                                               p_r_RA_INTERFACE_LINES_ALL.LAST_UPDATE_LOGIN,
                                               p_r_RA_INTERFACE_LINES_ALL.LOCATION_SEGMENT_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.MOVEMENT_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.ORG_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.AMOUNT_INCLUDES_TAX_FLAG,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTR_CATEGORY,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE1,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE2,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE3,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE4,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE5,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE6,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE7,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE8,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE9,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE10,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE11,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE12,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE13,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE14,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE15,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE16,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE17,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE18,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE19,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE20,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE21,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE22,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE23,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE24,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE25,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE26,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE27,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE28,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE29,
                                               p_r_RA_INTERFACE_LINES_ALL.HEADER_GDF_ATTRIBUTE30,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTR_CATEGORY,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE1,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE2,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE3,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE4,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE5,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE6,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE7,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE8,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE9,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE10,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE11,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE12,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE13,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE14,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE15,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE16,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE17,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE18,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE19,
                                               p_r_RA_INTERFACE_LINES_ALL.LINE_GDF_ATTRIBUTE20,
                                               p_r_RA_INTERFACE_LINES_ALL.RESET_TRX_DATE_FLAG,
                                               p_r_RA_INTERFACE_LINES_ALL.PAYMENT_SERVER_ORDER_NUM,
                                               p_r_RA_INTERFACE_LINES_ALL.APPROVAL_CODE,
                                               p_r_RA_INTERFACE_LINES_ALL.ADDRESS_VERIFICATION_CODE,
                                               p_r_RA_INTERFACE_LINES_ALL.WAREHOUSE_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.TRANSLATED_DESCRIPTION,
                                               p_r_RA_INTERFACE_LINES_ALL.CONS_BILLING_NUMBER,
                                               p_r_RA_INTERFACE_LINES_ALL.PROMISED_COMMITMENT_AMOUNT,
                                               p_r_RA_INTERFACE_LINES_ALL.PAYMENT_SET_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.ORIGINAL_GL_DATE,
                                               p_r_RA_INTERFACE_LINES_ALL.CONTRACT_LINE_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.CONTRACT_ID,
                                               p_r_RA_INTERFACE_LINES_ALL.SOURCE_DATA_KEY1,
                                               p_r_RA_INTERFACE_LINES_ALL.SOURCE_DATA_KEY2,
                                               p_r_RA_INTERFACE_LINES_ALL.SOURCE_DATA_KEY3,
                                               p_r_RA_INTERFACE_LINES_ALL.SOURCE_DATA_KEY4,
                                               p_r_RA_INTERFACE_LINES_ALL.SOURCE_DATA_KEY5,
                                               p_r_RA_INTERFACE_LINES_ALL.INVOICED_LINE_ACCTG_LEVEL);
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000,'Erro ao inserir na tabela SFWBR_RA_INTERFACE_LINES_ALL. ' || sqlerrm);
   END EBS_RA_INTERFACE_LINES_ALL;
   --
   PROCEDURE EBS_RA_INTERFACE_SALESCREDITS(p_r_RA_INTERFACE_SALESCREDITS SFWBR_RA_INTER_SALESCREDITS_AL%ROWTYPE) is
   BEGIN
      INSERT INTO SFWBR_RA_INTER_SALESCREDITS_AL(INTERFACE_SALESCREDIT_ID,
                                                 INTERFACE_LINE_ID,
                                                 INTERFACE_LINE_CONTEXT,
                                                 INTERFACE_LINE_ATTRIBUTE1,
                                                 INTERFACE_LINE_ATTRIBUTE2,
                                                 INTERFACE_LINE_ATTRIBUTE3,
                                                 INTERFACE_LINE_ATTRIBUTE4,
                                                 INTERFACE_LINE_ATTRIBUTE5,
                                                 INTERFACE_LINE_ATTRIBUTE6,
                                                 INTERFACE_LINE_ATTRIBUTE7,
                                                 INTERFACE_LINE_ATTRIBUTE8,
                                                 SALESREP_NUMBER,
                                                 SALESREP_ID,
                                                 SALES_CREDIT_TYPE_NAME,
                                                 SALES_CREDIT_TYPE_ID,
                                                 SALES_CREDIT_AMOUNT_SPLIT,
                                                 SALES_CREDIT_PERCENT_SPLIT,
                                                 INTERFACE_STATUS,
                                                 REQUEST_ID,
                                                 ATTRIBUTE_CATEGORY,
                                                 ATTRIBUTE1,
                                                 ATTRIBUTE2,
                                                 ATTRIBUTE3,
                                                 ATTRIBUTE4,
                                                 ATTRIBUTE5,
                                                 ATTRIBUTE6,
                                                 ATTRIBUTE7,
                                                 ATTRIBUTE8,
                                                 ATTRIBUTE9,
                                                 ATTRIBUTE10,
                                                 ATTRIBUTE11,
                                                 ATTRIBUTE12,
                                                 ATTRIBUTE13,
                                                 ATTRIBUTE14,
                                                 ATTRIBUTE15,
                                                 INTERFACE_LINE_ATTRIBUTE10,
                                                 INTERFACE_LINE_ATTRIBUTE11,
                                                 INTERFACE_LINE_ATTRIBUTE12,
                                                 INTERFACE_LINE_ATTRIBUTE13,
                                                 INTERFACE_LINE_ATTRIBUTE14,
                                                 INTERFACE_LINE_ATTRIBUTE15,
                                                 INTERFACE_LINE_ATTRIBUTE9,
                                                 CREATED_BY,
                                                 CREATION_DATE,
                                                 LAST_UPDATED_BY,
                                                 LAST_UPDATE_DATE,
                                                 LAST_UPDATE_LOGIN,
                                                 ORG_ID,
                                                 SALESGROUP_ID)
      VALUES                                    (p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_SALESCREDIT_ID,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ID,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_CONTEXT,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ATTRIBUTE1,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ATTRIBUTE2,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ATTRIBUTE3,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ATTRIBUTE4,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ATTRIBUTE5,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ATTRIBUTE6,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ATTRIBUTE7,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ATTRIBUTE8,
                                                 p_r_RA_INTERFACE_SALESCREDITS.SALESREP_NUMBER,
                                                 p_r_RA_INTERFACE_SALESCREDITS.SALESREP_ID,
                                                 p_r_RA_INTERFACE_SALESCREDITS.SALES_CREDIT_TYPE_NAME,
                                                 p_r_RA_INTERFACE_SALESCREDITS.SALES_CREDIT_TYPE_ID,
                                                 p_r_RA_INTERFACE_SALESCREDITS.SALES_CREDIT_AMOUNT_SPLIT,
                                                 p_r_RA_INTERFACE_SALESCREDITS.SALES_CREDIT_PERCENT_SPLIT,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_STATUS,
                                                 p_r_RA_INTERFACE_SALESCREDITS.REQUEST_ID,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE_CATEGORY,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE1,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE2,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE3,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE4,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE5,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE6,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE7,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE8,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE9,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE10,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE11,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE12,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE13,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE14,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ATTRIBUTE15,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ATTRIBUTE10,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ATTRIBUTE11,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ATTRIBUTE12,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ATTRIBUTE13,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ATTRIBUTE14,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ATTRIBUTE15,
                                                 p_r_RA_INTERFACE_SALESCREDITS.INTERFACE_LINE_ATTRIBUTE9,
                                                 p_r_RA_INTERFACE_SALESCREDITS.CREATED_BY,
                                                 p_r_RA_INTERFACE_SALESCREDITS.CREATION_DATE,
                                                 p_r_RA_INTERFACE_SALESCREDITS.LAST_UPDATED_BY,
                                                 p_r_RA_INTERFACE_SALESCREDITS.LAST_UPDATE_DATE,
                                                 p_r_RA_INTERFACE_SALESCREDITS.LAST_UPDATE_LOGIN,
                                                 p_r_RA_INTERFACE_SALESCREDITS.ORG_ID,
                                                 p_r_RA_INTERFACE_SALESCREDITS.SALESGROUP_ID);
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000,'Erro ao inserir na tabela SFWBR_RA_INTER_SALESCREDITS_AL. ' || sqlerrm);
   END EBS_RA_INTERFACE_SALESCREDITS;
   --
   PROCEDURE GL_INTERFACE(p_r_CAIBR_GL_INTERFACE SFWBR_GL_INTERFACE%ROWTYPE) IS
   BEGIN
      INSERT INTO SFWBR_GL_INTERFACE(STATUS,
                                     SET_OF_BOOKS_ID,
                                     ACCOUNTING_DATE,
                                     CURRENCY_CODE,
                                     DATE_CREATED,
                                     CREATED_BY,
                                     ACTUAL_FLAG,
                                     USER_JE_CATEGORY_NAME,
                                     USER_JE_SOURCE_NAME,
                                     CURRENCY_CONVERSION_DATE,
                                     ENCUMBRANCE_TYPE_ID,
                                     BUDGET_VERSION_ID,
                                     USER_CURRENCY_CONVERSION_TYPE,
                                     CURRENCY_CONVERSION_RATE,
                                     AVERAGE_JOURNAL_FLAG,
                                     ORIGINATING_BAL_SEG_VALUE,
                                     SEGMENT1,
                                     SEGMENT2,
                                     SEGMENT3,
                                     SEGMENT4,
                                     SEGMENT5,
                                     SEGMENT6,
                                     SEGMENT7,
                                     SEGMENT8,
                                     SEGMENT9,
                                     SEGMENT10,
                                     SEGMENT11,
                                     SEGMENT12,
                                     SEGMENT13,
                                     SEGMENT14,
                                     SEGMENT15,
                                     SEGMENT16,
                                     SEGMENT17,
                                     SEGMENT18,
                                     SEGMENT19,
                                     SEGMENT20,
                                     SEGMENT21,
                                     SEGMENT22,
                                     SEGMENT23,
                                     SEGMENT24,
                                     SEGMENT25,
                                     SEGMENT26,
                                     SEGMENT27,
                                     SEGMENT28,
                                     SEGMENT29,
                                     SEGMENT30,
                                     ENTERED_DR,
                                     ENTERED_CR,
                                     ACCOUNTED_DR,
                                     ACCOUNTED_CR,
                                     TRANSACTION_DATE,
                                     REFERENCE1,
                                     REFERENCE2,
                                     REFERENCE3,
                                     REFERENCE4,
                                     REFERENCE5,
                                     REFERENCE6,
                                     REFERENCE7,
                                     REFERENCE8,
                                     REFERENCE9,
                                     REFERENCE10,
                                     REFERENCE11,
                                     REFERENCE12,
                                     REFERENCE13,
                                     REFERENCE14,
                                     REFERENCE15,
                                     REFERENCE16,
                                     REFERENCE17,
                                     REFERENCE18,
                                     REFERENCE19,
                                     REFERENCE20,
                                     REFERENCE21,
                                     REFERENCE22,
                                     REFERENCE23,
                                     REFERENCE24,
                                     REFERENCE25,
                                     REFERENCE26,
                                     REFERENCE27,
                                     REFERENCE28,
                                     REFERENCE29,
                                     REFERENCE30,
                                     JE_BATCH_ID,
                                     PERIOD_NAME,
                                     JE_HEADER_ID,
                                     JE_LINE_NUM,
                                     CHART_OF_ACCOUNTS_ID,
                                     FUNCTIONAL_CURRENCY_CODE,
                                     CODE_COMBINATION_ID,
                                     DATE_CREATED_IN_GL,
                                     WARNING_CODE,
                                     STATUS_DESCRIPTION,
                                     STAT_AMOUNT,
                                     GROUP_ID,
                                     REQUEST_ID,
                                     SUBLEDGER_DOC_SEQUENCE_ID,
                                     SUBLEDGER_DOC_SEQUENCE_VALUE,
                                     ATTRIBUTE1,
                                     ATTRIBUTE2,
                                     GL_SL_LINK_ID,
                                     GL_SL_LINK_TABLE,
                                     ATTRIBUTE3,
                                     ATTRIBUTE4,
                                     ATTRIBUTE5,
                                     ATTRIBUTE6,
                                     ATTRIBUTE7,
                                     ATTRIBUTE8,
                                     ATTRIBUTE9,
                                     ATTRIBUTE10,
                                     ATTRIBUTE11,
                                     ATTRIBUTE12,
                                     ATTRIBUTE13,
                                     ATTRIBUTE14,
                                     ATTRIBUTE15,
                                     ATTRIBUTE16,
                                     ATTRIBUTE17,
                                     ATTRIBUTE18,
                                     ATTRIBUTE19,
                                     ATTRIBUTE20,
                                     CONTEXT,
                                     CONTEXT2,
                                     INVOICE_DATE,
                                     TAX_CODE,
                                     INVOICE_IDENTIFIER,
                                     INVOICE_AMOUNT,
                                     CONTEXT3,
                                     USSGL_TRANSACTION_CODE,
                                     DESCR_FLEX_ERROR_MESSAGE,
                                     JGZZ_RECON_REF,
                                     REFERENCE_DATE)
      VALUES                        (p_r_CAIBR_GL_INTERFACE.STATUS,
                                     p_r_CAIBR_GL_INTERFACE.SET_OF_BOOKS_ID,
                                     p_r_CAIBR_GL_INTERFACE.ACCOUNTING_DATE,
                                     p_r_CAIBR_GL_INTERFACE.CURRENCY_CODE,
                                     p_r_CAIBR_GL_INTERFACE.DATE_CREATED,
                                     p_r_CAIBR_GL_INTERFACE.CREATED_BY,
                                     p_r_CAIBR_GL_INTERFACE.ACTUAL_FLAG,
                                     p_r_CAIBR_GL_INTERFACE.USER_JE_CATEGORY_NAME,
                                     p_r_CAIBR_GL_INTERFACE.USER_JE_SOURCE_NAME,
                                     p_r_CAIBR_GL_INTERFACE.CURRENCY_CONVERSION_DATE,
                                     p_r_CAIBR_GL_INTERFACE.ENCUMBRANCE_TYPE_ID,
                                     p_r_CAIBR_GL_INTERFACE.BUDGET_VERSION_ID,
                                     p_r_CAIBR_GL_INTERFACE.USER_CURRENCY_CONVERSION_TYPE,
                                     p_r_CAIBR_GL_INTERFACE.CURRENCY_CONVERSION_RATE,
                                     p_r_CAIBR_GL_INTERFACE.AVERAGE_JOURNAL_FLAG,
                                     p_r_CAIBR_GL_INTERFACE.ORIGINATING_BAL_SEG_VALUE,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT1,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT2,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT3,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT4,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT5,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT6,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT7,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT8,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT9,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT10,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT11,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT12,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT13,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT14,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT15,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT16,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT17,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT18,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT19,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT20,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT21,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT22,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT23,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT24,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT25,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT26,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT27,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT28,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT29,
                                     p_r_CAIBR_GL_INTERFACE.SEGMENT30,
                                     p_r_CAIBR_GL_INTERFACE.ENTERED_DR,
                                     p_r_CAIBR_GL_INTERFACE.ENTERED_CR,
                                     p_r_CAIBR_GL_INTERFACE.ACCOUNTED_DR,
                                     p_r_CAIBR_GL_INTERFACE.ACCOUNTED_CR,
                                     p_r_CAIBR_GL_INTERFACE.TRANSACTION_DATE,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE1,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE2,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE3,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE4,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE5,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE6,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE7,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE8,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE9,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE10,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE11,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE12,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE13,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE14,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE15,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE16,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE17,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE18,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE19,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE20,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE21,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE22,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE23,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE24,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE25,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE26,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE27,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE28,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE29,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE30,
                                     p_r_CAIBR_GL_INTERFACE.JE_BATCH_ID,
                                     p_r_CAIBR_GL_INTERFACE.PERIOD_NAME,
                                     p_r_CAIBR_GL_INTERFACE.JE_HEADER_ID,
                                     p_r_CAIBR_GL_INTERFACE.JE_LINE_NUM,
                                     p_r_CAIBR_GL_INTERFACE.CHART_OF_ACCOUNTS_ID,
                                     p_r_CAIBR_GL_INTERFACE.FUNCTIONAL_CURRENCY_CODE,
                                     p_r_CAIBR_GL_INTERFACE.CODE_COMBINATION_ID,
                                     p_r_CAIBR_GL_INTERFACE.DATE_CREATED_IN_GL,
                                     p_r_CAIBR_GL_INTERFACE.WARNING_CODE,
                                     p_r_CAIBR_GL_INTERFACE.STATUS_DESCRIPTION,
                                     p_r_CAIBR_GL_INTERFACE.STAT_AMOUNT,
                                     p_r_CAIBR_GL_INTERFACE.GROUP_ID,
                                     p_r_CAIBR_GL_INTERFACE.REQUEST_ID,
                                     p_r_CAIBR_GL_INTERFACE.SUBLEDGER_DOC_SEQUENCE_ID,
                                     p_r_CAIBR_GL_INTERFACE.SUBLEDGER_DOC_SEQUENCE_VALUE,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE1,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE2,
                                     p_r_CAIBR_GL_INTERFACE.GL_SL_LINK_ID,
                                     p_r_CAIBR_GL_INTERFACE.GL_SL_LINK_TABLE,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE3,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE4,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE5,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE6,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE7,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE8,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE9,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE10,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE11,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE12,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE13,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE14,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE15,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE16,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE17,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE18,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE19,
                                     p_r_CAIBR_GL_INTERFACE.ATTRIBUTE20,
                                     p_r_CAIBR_GL_INTERFACE.CONTEXT,
                                     p_r_CAIBR_GL_INTERFACE.CONTEXT2,
                                     p_r_CAIBR_GL_INTERFACE.INVOICE_DATE,
                                     p_r_CAIBR_GL_INTERFACE.TAX_CODE,
                                     p_r_CAIBR_GL_INTERFACE.INVOICE_IDENTIFIER,
                                     p_r_CAIBR_GL_INTERFACE.INVOICE_AMOUNT,
                                     p_r_CAIBR_GL_INTERFACE.CONTEXT3,
                                     p_r_CAIBR_GL_INTERFACE.USSGL_TRANSACTION_CODE,
                                     p_r_CAIBR_GL_INTERFACE.DESCR_FLEX_ERROR_MESSAGE,
                                     p_r_CAIBR_GL_INTERFACE.JGZZ_RECON_REF,
                                     p_r_CAIBR_GL_INTERFACE.REFERENCE_DATE);
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000,'Erro ao inserir na tabela SFWBR_GL_INTERFACE. ' || sqlerrm);
   END GL_INTERFACE;
   --
   PROCEDURE EBS_REC_INVOICES_INTERFACE(p_r_CAIBR_REC_INVO_INTER SFWBR_REC_INVO_INTER%ROWTYPE) IS
   BEGIN
      INSERT INTO SFWBR_REC_INVO_INTER(ADDITIONAL_AMOUNT, -- 1
                                       ADDITIONAL_TAX, -- 2
                                       ALTERNATE_CURRENCY_CONV_RATE, -- 3
                                       CLEARANCE_DATE, -- 4
                                       CONTRACT_ID, -- 5
                                       CREATED_BY, -- 6
                                       CREATION_DATE, -- 7
                                       CUSTOMS_EXPENSE_FUNC, -- 8
                                       DESCRIPTION, -- 9
                                       DESTINATION_STATE_CODE, -- 10
                                       DESTINATION_STATE_ID, -- 11
                                       DIFF_ICMS_AMOUNT, -- 12
                                       DIFF_ICMS_AMOUNT_RECOVER, -- 13
                                       DIFF_ICMS_TAX, -- 14
                                       DI_DATE, -- 15
                                       DOCUMENT_NUMBER, -- 16
                                       DOCUMENT_TYPE, -- 17
                                       DOLLAR_CUSTOMS_EXPENSE, -- 18
                                       DOLLAR_FREIGHT_INTERNATIONAL, -- 19
                                       DOLLAR_IMPORTATION_PIS_AMOUNT, -- 20
                                       DOLLAR_IMPORTATION_TAX_AMOUNT, -- 21
                                       DOLLAR_IMPORT_COFINS_AMOUNT, -- 22
                                       DOLLAR_INSURANCE_AMOUNT, -- 23
                                       DOLLAR_INVOICE_AMOUNT, -- 24
                                       DOLLAR_SISCOMEX_AMOUNT, -- 25
                                       DOLLAR_TOTAL_CIF_AMOUNT, -- 26
                                       DOLLAR_TOTAL_FOB_AMOUNT, -- 27
                                       ENTITY_ID, -- 28
                                       FIRST_PAYMENT_DATE, -- 29
                                       FISCAL_DOCUMENT_MODEL, -- 30
                                       FREIGHT_AMOUNT, -- 31
                                       FREIGHT_AP_FLAG, -- 32
                                       FREIGHT_FLAG, -- 33
                                       FREIGHT_INTERNATIONAL, -- 34
                                       FUNRURAL_AMOUNT, -- 35
                                       FUNRURAL_BASE, -- 36
                                       FUNRURAL_TAX, -- 37
                                       GL_DATE, -- 38
                                       GROSS_TOTAL_AMOUNT, -- 39
                                       ICMS_AMOUNT, -- 40
                                       ICMS_BASE, -- 41
                                       ICMS_ST_AMOUNT, -- 42
                                       ICMS_ST_AMOUNT_RECOVER, -- 43
                                       ICMS_ST_BASE, -- 44
                                       ICMS_TAX, -- 45
                                       ICMS_TYPE, -- 46
                                       IE, -- 47
                                       IMPORTATION_COFINS_AMOUNT, -- 48
                                       IMPORTATION_EXPENSE_DOL, -- 49
                                       IMPORTATION_EXPENSE_FUNC, -- 50
                                       IMPORTATION_FREIGHT_WEIGHT, -- 51
                                       IMPORTATION_INSURANCE_AMOUNT, -- 52
                                       IMPORTATION_NUMBER, -- 53
                                       IMPORTATION_PIS_AMOUNT, -- 54
                                       IMPORTATION_TAX_AMOUNT, -- 55
                                       INCOME_CODE, -- 56
                                       INSS_ADDITIONAL_AMOUNT_1, -- 57
                                       INSS_ADDITIONAL_AMOUNT_2, -- 58
                                       INSS_ADDITIONAL_AMOUNT_3, -- 59
                                       INSS_ADDITIONAL_BASE_1, -- 60
                                       INSS_ADDITIONAL_BASE_2, -- 61
                                       INSS_ADDITIONAL_BASE_3, -- 62
                                       INSS_ADDITIONAL_TAX_1, -- 63
                                       INSS_ADDITIONAL_TAX_2, -- 64
                                       INSS_ADDITIONAL_TAX_3, -- 65
                                       INSS_AMOUNT, -- 66
                                       INSS_AUTONOMOUS_AMOUNT, -- 67
                                       INSS_AUTONOMOUS_INVOICED_TOTAL, -- 68
                                       INSS_AUTONOMOUS_TAX, -- 69
                                       INSS_BASE, -- 70
                                       INSS_TAX, -- 71
                                       INSURANCE_AMOUNT, -- 72
                                       INTERFACE_INVOICE_ID, -- 73
                                       INTERFACE_OPERATION_ID, -- 74
                                       INVOICE_AMOUNT, -- 75
                                       INVOICE_DATE, -- 76
                                       INVOICE_ID, -- 77
                                       INVOICE_NUM, -- 78
                                       INVOICE_TYPE_CODE, -- 79
                                       INVOICE_TYPE_ID, -- 80
                                       INVOICE_WEIGHT, -- 81
                                       IPI_AMOUNT, -- 82
                                       IRRF_BASE_DATE, -- 83
                                       IR_AMOUNT, -- 84
                                       IR_BASE, -- 85
                                       IR_CATEG, -- 86
                                       IR_TAX, -- 87
                                       IR_VENDOR, -- 88
                                       ISS_AMOUNT, -- 89
                                       ISS_BASE, -- 90
                                       ISS_CITY_CODE, -- 91
                                       ISS_CITY_ID, -- 92
                                       ISS_TAX, -- 93
                                       LAST_UPDATED_BY, -- 94
                                       LAST_UPDATE_DATE, -- 95
                                       LAST_UPDATE_LOGIN, -- 96
                                       LOCATION_CODE, -- 97
                                       LOCATION_ID, -- 98
                                       OPERATION_ID, -- 99
                                       ORGANIZATION_CODE, -- 100
                                       ORGANIZATION_ID, -- 101
                                       OTHER_EXPENSES, -- 102
                                       PAYMENT_DISCOUNT, -- 103
                                       PO_CONVERSION_RATE, -- 104
                                       PO_CURRENCY_CODE, -- 105
                                       PRESUMED_ICMS_TAX_AMOUNT, -- 106
                                       PROCESS_FLAG, -- 107
                                       RECEIVE_DATE, -- 108
                                       CEO_ATTRIBUTE1, -- 109
                                       CEO_ATTRIBUTE10, -- 110
                                       CEO_ATTRIBUTE11, -- 111
                                       CEO_ATTRIBUTE12, -- 112
                                       CEO_ATTRIBUTE13, -- 113
                                       CEO_ATTRIBUTE14, -- 114
                                       CEO_ATTRIBUTE15, -- 115
                                       CEO_ATTRIBUTE16, -- 116
                                       CEO_ATTRIBUTE17, -- 117
                                       CEO_ATTRIBUTE18, -- 118
                                       CEO_ATTRIBUTE19, -- 119
                                       CEO_ATTRIBUTE2, -- 120
                                       CEO_ATTRIBUTE20, -- 121
                                       CEO_ATTRIBUTE3, -- 122
                                       CEO_ATTRIBUTE4, -- 123
                                       CEO_ATTRIBUTE5, -- 124
                                       CEO_ATTRIBUTE6, -- 125
                                       CEO_ATTRIBUTE7, -- 126
                                       CEO_ATTRIBUTE8, -- 127
                                       CEO_ATTRIBUTE9, -- 128
                                       CEO_ATTRIBUTE_CATEGORY, -- 129
                                       RETURN_AMOUNT, -- 130
                                       RETURN_CFO_CODE, -- 131
                                       RETURN_CFO_ID, -- 132
                                       RETURN_DATE, -- 133
                                       CIN_ATTRIBUTE1, -- 134
                                       CIN_ATTRIBUTE10, -- 135
                                       CIN_ATTRIBUTE11, -- 136
                                       CIN_ATTRIBUTE12, -- 137
                                       CIN_ATTRIBUTE13, -- 138
                                       CIN_ATTRIBUTE14, -- 139
                                       CIN_ATTRIBUTE15, -- 140
                                       CIN_ATTRIBUTE16, -- 141
                                       CIN_ATTRIBUTE17, -- 142
                                       CIN_ATTRIBUTE18, -- 143
                                       CIN_ATTRIBUTE19, -- 144
                                       CIN_ATTRIBUTE2, -- 145
                                       CIN_ATTRIBUTE20, -- 146
                                       CIN_ATTRIBUTE3, -- 147
                                       CIN_ATTRIBUTE4, -- 148
                                       CIN_ATTRIBUTE5, -- 149
                                       CIN_ATTRIBUTE6, -- 150
                                       CIN_ATTRIBUTE7, -- 151
                                       CIN_ATTRIBUTE8, -- 152
                                       CIN_ATTRIBUTE9, -- 153
                                       CIN_ATTRIBUTE_CATEGORY, -- 154
                                       SERIES, -- 155
                                       SEST_SENAT_AMOUNT, -- 156
                                       SEST_SENAT_BASE, -- 157
                                       SEST_SENAT_TAX, -- 158
                                       SHIP_VIA_LOOKUP_CODE, -- 159
                                       SISCOMEX_AMOUNT, -- 160
                                       SOURCE, -- 161
                                       SOURCE_ITEMS, -- 162
                                       SOURCE_STATE_CODE, -- 163
                                       SOURCE_STATE_ID, -- 164
                                       SUBST_ICMS_AMOUNT, -- 165
                                       SUBST_ICMS_BASE, -- 166
                                       TERMS_DATE, -- 167
                                       TERMS_ID, -- 168
                                       TERMS_NAME, -- 169
                                       TOTAL_CIF_AMOUNT, -- 170
                                       TOTAL_FOB_AMOUNT, -- 171
                                       TOTAL_FREIGHT_WEIGHT, -- 172
                                       USER_DEFINED_CONVERSION_RATE,-- 173
                                       ELETRONIC_INVOICE_KEY, --174
                                       IMPORT_DOCUMENT_TYPE,--) -- 175
-- Inicio Alteração - Marcos R. Carneiro - Chamado: 451053 - CAT6...
                                       IMPORT_OTHER_VAL_INCLUDED_ICMS, -- 176
                                       IMPORT_OTHER_VAL_NOT_ICMS, -- 177
                                       DOLLAR_OTHER_VAL_INCLUDED_ICMS, -- 178
                                       DOLLAR_OTHER_VAL_NOT_ICMS) -- 179
-- Final Alteração - Marcos R. Carneiro - Chamado: 451053 - CAT6...
      VALUES                          (p_r_CAIBR_REC_INVO_INTER.ADDITIONAL_AMOUNT, -- 1
                                       p_r_CAIBR_REC_INVO_INTER.ADDITIONAL_TAX, -- 2
                                       p_r_CAIBR_REC_INVO_INTER.ALTERNATE_CURRENCY_CONV_RATE, -- 3
                                       p_r_CAIBR_REC_INVO_INTER.CLEARANCE_DATE, -- 4
                                       p_r_CAIBR_REC_INVO_INTER.CONTRACT_ID, -- 5
                                       p_r_CAIBR_REC_INVO_INTER.CREATED_BY, -- 6
                                       p_r_CAIBR_REC_INVO_INTER.CREATION_DATE, -- 7
                                       p_r_CAIBR_REC_INVO_INTER.CUSTOMS_EXPENSE_FUNC, -- 8
                                       p_r_CAIBR_REC_INVO_INTER.DESCRIPTION, -- 9
                                       p_r_CAIBR_REC_INVO_INTER.DESTINATION_STATE_CODE, -- 10
                                       p_r_CAIBR_REC_INVO_INTER.DESTINATION_STATE_ID, -- 11
                                       p_r_CAIBR_REC_INVO_INTER.DIFF_ICMS_AMOUNT, -- 12
                                       p_r_CAIBR_REC_INVO_INTER.DIFF_ICMS_AMOUNT_RECOVER, -- 13
                                       p_r_CAIBR_REC_INVO_INTER.DIFF_ICMS_TAX, -- 14
                                       p_r_CAIBR_REC_INVO_INTER.DI_DATE, -- 15
                                       p_r_CAIBR_REC_INVO_INTER.DOCUMENT_NUMBER, -- 16
                                       p_r_CAIBR_REC_INVO_INTER.DOCUMENT_TYPE, -- 17
                                       p_r_CAIBR_REC_INVO_INTER.DOLLAR_CUSTOMS_EXPENSE, -- 18
                                       p_r_CAIBR_REC_INVO_INTER.DOLLAR_FREIGHT_INTERNATIONAL, -- 19
                                       p_r_CAIBR_REC_INVO_INTER.DOLLAR_IMPORTATION_PIS_AMOUNT, -- 20
                                       p_r_CAIBR_REC_INVO_INTER.DOLLAR_IMPORTATION_TAX_AMOUNT, -- 21
                                       p_r_CAIBR_REC_INVO_INTER.DOLLAR_IMPORT_COFINS_AMOUNT, -- 22
                                       p_r_CAIBR_REC_INVO_INTER.DOLLAR_INSURANCE_AMOUNT, -- 23
                                       p_r_CAIBR_REC_INVO_INTER.DOLLAR_INVOICE_AMOUNT, -- 24
                                       p_r_CAIBR_REC_INVO_INTER.DOLLAR_SISCOMEX_AMOUNT, -- 25
                                       p_r_CAIBR_REC_INVO_INTER.DOLLAR_TOTAL_CIF_AMOUNT, -- 26
                                       p_r_CAIBR_REC_INVO_INTER.DOLLAR_TOTAL_FOB_AMOUNT, -- 27
                                       p_r_CAIBR_REC_INVO_INTER.ENTITY_ID, -- 28
                                       p_r_CAIBR_REC_INVO_INTER.FIRST_PAYMENT_DATE, -- 29
                                       p_r_CAIBR_REC_INVO_INTER.FISCAL_DOCUMENT_MODEL, -- 30
                                       p_r_CAIBR_REC_INVO_INTER.FREIGHT_AMOUNT, -- 31
                                       p_r_CAIBR_REC_INVO_INTER.FREIGHT_AP_FLAG, -- 32
                                       p_r_CAIBR_REC_INVO_INTER.FREIGHT_FLAG, -- 33
                                       p_r_CAIBR_REC_INVO_INTER.FREIGHT_INTERNATIONAL, -- 34
                                       p_r_CAIBR_REC_INVO_INTER.FUNRURAL_AMOUNT, -- 35
                                       p_r_CAIBR_REC_INVO_INTER.FUNRURAL_BASE, -- 36
                                       p_r_CAIBR_REC_INVO_INTER.FUNRURAL_TAX, -- 37
                                       p_r_CAIBR_REC_INVO_INTER.GL_DATE, -- 38
                                       p_r_CAIBR_REC_INVO_INTER.GROSS_TOTAL_AMOUNT, -- 39
                                       p_r_CAIBR_REC_INVO_INTER.ICMS_AMOUNT, -- 40
                                       p_r_CAIBR_REC_INVO_INTER.ICMS_BASE, -- 41
                                       p_r_CAIBR_REC_INVO_INTER.ICMS_ST_AMOUNT, -- 42
                                       p_r_CAIBR_REC_INVO_INTER.ICMS_ST_AMOUNT_RECOVER, -- 43
                                       p_r_CAIBR_REC_INVO_INTER.ICMS_ST_BASE, -- 44
                                       p_r_CAIBR_REC_INVO_INTER.ICMS_TAX, -- 45
                                       p_r_CAIBR_REC_INVO_INTER.ICMS_TYPE, -- 46
                                       p_r_CAIBR_REC_INVO_INTER.IE, -- 47
                                       p_r_CAIBR_REC_INVO_INTER.IMPORTATION_COFINS_AMOUNT, -- 48
                                       p_r_CAIBR_REC_INVO_INTER.IMPORTATION_EXPENSE_DOL, -- 49
                                       p_r_CAIBR_REC_INVO_INTER.IMPORTATION_EXPENSE_FUNC, -- 50
                                       p_r_CAIBR_REC_INVO_INTER.IMPORTATION_FREIGHT_WEIGHT, -- 51
                                       p_r_CAIBR_REC_INVO_INTER.IMPORTATION_INSURANCE_AMOUNT, -- 52
                                       p_r_CAIBR_REC_INVO_INTER.IMPORTATION_NUMBER, -- 53
                                       p_r_CAIBR_REC_INVO_INTER.IMPORTATION_PIS_AMOUNT, -- 54
                                       p_r_CAIBR_REC_INVO_INTER.IMPORTATION_TAX_AMOUNT, -- 55
                                       p_r_CAIBR_REC_INVO_INTER.INCOME_CODE, -- 56
                                       p_r_CAIBR_REC_INVO_INTER.INSS_ADDITIONAL_AMOUNT_1, -- 57
                                       p_r_CAIBR_REC_INVO_INTER.INSS_ADDITIONAL_AMOUNT_2, -- 58
                                       p_r_CAIBR_REC_INVO_INTER.INSS_ADDITIONAL_AMOUNT_3, -- 59
                                       p_r_CAIBR_REC_INVO_INTER.INSS_ADDITIONAL_BASE_1, -- 60
                                       p_r_CAIBR_REC_INVO_INTER.INSS_ADDITIONAL_BASE_2, -- 61
                                       p_r_CAIBR_REC_INVO_INTER.INSS_ADDITIONAL_BASE_3, -- 62
                                       p_r_CAIBR_REC_INVO_INTER.INSS_ADDITIONAL_TAX_1, -- 63
                                       p_r_CAIBR_REC_INVO_INTER.INSS_ADDITIONAL_TAX_2, -- 64
                                       p_r_CAIBR_REC_INVO_INTER.INSS_ADDITIONAL_TAX_3, -- 65
                                       p_r_CAIBR_REC_INVO_INTER.INSS_AMOUNT, -- 66
                                       p_r_CAIBR_REC_INVO_INTER.INSS_AUTONOMOUS_AMOUNT, -- 67
                                       p_r_CAIBR_REC_INVO_INTER.INSS_AUTONOMOUS_INVOICED_TOTAL, -- 68
                                       p_r_CAIBR_REC_INVO_INTER.INSS_AUTONOMOUS_TAX, -- 69
                                       p_r_CAIBR_REC_INVO_INTER.INSS_BASE, -- 70
                                       p_r_CAIBR_REC_INVO_INTER.INSS_TAX, -- 71
                                       p_r_CAIBR_REC_INVO_INTER.INSURANCE_AMOUNT, -- 72
                                       p_r_CAIBR_REC_INVO_INTER.INTERFACE_INVOICE_ID, -- 73
                                       p_r_CAIBR_REC_INVO_INTER.INTERFACE_OPERATION_ID, -- 74
                                       p_r_CAIBR_REC_INVO_INTER.INVOICE_AMOUNT, -- 75
                                       p_r_CAIBR_REC_INVO_INTER.INVOICE_DATE, -- 76
                                       p_r_CAIBR_REC_INVO_INTER.INVOICE_ID, -- 77
                                       p_r_CAIBR_REC_INVO_INTER.INVOICE_NUM, -- 78
                                       p_r_CAIBR_REC_INVO_INTER.INVOICE_TYPE_CODE, -- 79
                                       p_r_CAIBR_REC_INVO_INTER.INVOICE_TYPE_ID, -- 80
                                       p_r_CAIBR_REC_INVO_INTER.INVOICE_WEIGHT, -- 81
                                       p_r_CAIBR_REC_INVO_INTER.IPI_AMOUNT, -- 82
                                       p_r_CAIBR_REC_INVO_INTER.IRRF_BASE_DATE, -- 83
                                       p_r_CAIBR_REC_INVO_INTER.IR_AMOUNT, -- 84
                                       p_r_CAIBR_REC_INVO_INTER.IR_BASE, -- 85
                                       p_r_CAIBR_REC_INVO_INTER.IR_CATEG, -- 86
                                       p_r_CAIBR_REC_INVO_INTER.IR_TAX, -- 87
                                       p_r_CAIBR_REC_INVO_INTER.IR_VENDOR, -- 88
                                       p_r_CAIBR_REC_INVO_INTER.ISS_AMOUNT, -- 89
                                       p_r_CAIBR_REC_INVO_INTER.ISS_BASE, -- 90
                                       p_r_CAIBR_REC_INVO_INTER.ISS_CITY_CODE, -- 91
                                       p_r_CAIBR_REC_INVO_INTER.ISS_CITY_ID, -- 92
                                       p_r_CAIBR_REC_INVO_INTER.ISS_TAX, -- 93
                                       p_r_CAIBR_REC_INVO_INTER.LAST_UPDATED_BY, -- 94
                                       p_r_CAIBR_REC_INVO_INTER.LAST_UPDATE_DATE, -- 95
                                       p_r_CAIBR_REC_INVO_INTER.LAST_UPDATE_LOGIN, -- 96
                                       p_r_CAIBR_REC_INVO_INTER.LOCATION_CODE, -- 97
                                       p_r_CAIBR_REC_INVO_INTER.LOCATION_ID, -- 98
                                       p_r_CAIBR_REC_INVO_INTER.OPERATION_ID, -- 99
                                       p_r_CAIBR_REC_INVO_INTER.ORGANIZATION_CODE, -- 100
                                       p_r_CAIBR_REC_INVO_INTER.ORGANIZATION_ID, -- 101
                                       p_r_CAIBR_REC_INVO_INTER.OTHER_EXPENSES, -- 102
                                       p_r_CAIBR_REC_INVO_INTER.PAYMENT_DISCOUNT, -- 103
                                       p_r_CAIBR_REC_INVO_INTER.PO_CONVERSION_RATE, -- 104
                                       p_r_CAIBR_REC_INVO_INTER.PO_CURRENCY_CODE, -- 105
                                       p_r_CAIBR_REC_INVO_INTER.PRESUMED_ICMS_TAX_AMOUNT, -- 106
                                       p_r_CAIBR_REC_INVO_INTER.PROCESS_FLAG, -- 107
                                       p_r_CAIBR_REC_INVO_INTER.RECEIVE_DATE, -- 108
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE1, -- 109
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE10, -- 110
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE11, -- 111
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE12, -- 112
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE13, -- 113
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE14, -- 114
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE15, -- 115
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE16, -- 116
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE17, -- 117
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE18, -- 118
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE19, -- 119
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE2, -- 120
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE20, -- 121
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE3, -- 122
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE4, -- 123
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE5, -- 124
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE6, -- 125
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE7, -- 126
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE8, -- 127
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE9, -- 128
                                       p_r_CAIBR_REC_INVO_INTER.CEO_ATTRIBUTE_CATEGORY, -- 129
                                       p_r_CAIBR_REC_INVO_INTER.RETURN_AMOUNT, -- 130
                                       p_r_CAIBR_REC_INVO_INTER.RETURN_CFO_CODE, -- 131
                                       p_r_CAIBR_REC_INVO_INTER.RETURN_CFO_ID, -- 132
                                       p_r_CAIBR_REC_INVO_INTER.RETURN_DATE, -- 133
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE1, -- 134
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE10, -- 135
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE11, -- 136
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE12, -- 137
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE13, -- 138
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE14, -- 139
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE15, -- 140
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE16, -- 141
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE17, -- 142
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE18, -- 143
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE19, -- 144
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE2, -- 145
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE20, -- 146
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE3, -- 147
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE4, -- 148
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE5, -- 149
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE6, -- 150
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE7, -- 151
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE8, -- 152
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE9, -- 153
                                       p_r_CAIBR_REC_INVO_INTER.CIN_ATTRIBUTE_CATEGORY, -- 154
                                       p_r_CAIBR_REC_INVO_INTER.SERIES, -- 155
                                       p_r_CAIBR_REC_INVO_INTER.SEST_SENAT_AMOUNT, -- 156
                                       p_r_CAIBR_REC_INVO_INTER.SEST_SENAT_BASE, -- 157
                                       p_r_CAIBR_REC_INVO_INTER.SEST_SENAT_TAX, -- 158
                                       p_r_CAIBR_REC_INVO_INTER.SHIP_VIA_LOOKUP_CODE, -- 159
                                       p_r_CAIBR_REC_INVO_INTER.SISCOMEX_AMOUNT, -- 160
                                       p_r_CAIBR_REC_INVO_INTER.SOURCE, -- 161
                                       p_r_CAIBR_REC_INVO_INTER.SOURCE_ITEMS, -- 162
                                       p_r_CAIBR_REC_INVO_INTER.SOURCE_STATE_CODE, -- 163
                                       p_r_CAIBR_REC_INVO_INTER.SOURCE_STATE_ID, -- 164
                                       p_r_CAIBR_REC_INVO_INTER.SUBST_ICMS_AMOUNT, -- 165
                                       p_r_CAIBR_REC_INVO_INTER.SUBST_ICMS_BASE, -- 166
                                       p_r_CAIBR_REC_INVO_INTER.TERMS_DATE, -- 167
                                       p_r_CAIBR_REC_INVO_INTER.TERMS_ID, -- 168
                                       p_r_CAIBR_REC_INVO_INTER.TERMS_NAME, -- 169
                                       p_r_CAIBR_REC_INVO_INTER.TOTAL_CIF_AMOUNT, -- 170
                                       p_r_CAIBR_REC_INVO_INTER.TOTAL_FOB_AMOUNT, -- 171
                                       p_r_CAIBR_REC_INVO_INTER.TOTAL_FREIGHT_WEIGHT, -- 172
                                       p_r_CAIBR_REC_INVO_INTER.USER_DEFINED_CONVERSION_RATE, -- 173
                                       p_r_CAIBR_REC_INVO_INTER.ELETRONIC_INVOICE_KEY, -- 174
                                       p_r_CAIBR_REC_INVO_INTER.IMPORT_DOCUMENT_TYPE,--); -- 175
-- Inicio Alteração - Marcos R. Carneiro - Chamado: 451053 - CAT6...
                                       p_r_CAIBR_REC_INVO_INTER.IMPORT_OTHER_VAL_INCLUDED_ICMS, -- 176
                                       p_r_CAIBR_REC_INVO_INTER.IMPORT_OTHER_VAL_NOT_ICMS, -- 177
                                       p_r_CAIBR_REC_INVO_INTER.DOLLAR_OTHER_VAL_INCLUDED_ICMS, -- 178
                                       p_r_CAIBR_REC_INVO_INTER.DOLLAR_OTHER_VAL_NOT_ICMS); -- 179
-- Final Alteração - Marcos R. Carneiro - Chamado: 451053 - CAT6...
      --
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000,'Erro ao inserir na tabela SFWBR_REC_INVO_INTER. ' || sqlerrm);
   END EBS_REC_INVOICES_INTERFACE;
   --
   PROCEDURE EBS_REC_INVOICE_LINES_INT(p_r_CAIBR_REC_INVO_LINES_INTER SFWBR_REC_INVO_LINES_INTER%ROWTYPE) IS
   BEGIN
      --INSERT INTO SFWBR_REC_INVO_LINES_INTER
      --VALUES p_r_CAIBR_REC_INVO_LINES_INTER;
      INSERT INTO SFWBR_REC_INVO_LINES_INTER(ATTRIBUTE14, -- 1
                                             ATTRIBUTE15, -- 2
                                             CFO_CODE, -- 3
                                             CLASSIFICATION_CODE, -- 4
                                             COFINS_AMOUNT_RECOVER, -- 5
                                             COFINS_TRIBUTARY_CODE, -- 6
                                             CREATED_BY, -- 7
                                             CREATION_DATE, -- 8
                                             CUSTOMS_EXPENSE_FUNC, -- 9
                                             DB_CODE_COMBINATION_ID, -- 10
                                             DESCRIPTION, -- 11
                                             DIFF_ICMS_AMOUNT, -- 12
                                             DIFF_ICMS_AMOUNT_RECOVER, -- 13
                                             DIFF_ICMS_TAX, -- 14
                                             DISCOUNT_AMOUNT, -- 15
                                             DOLLAR_CUSTOMS_EXPENSE, -- 16
                                             DOLLAR_FOB_AMOUNT, -- 17
                                             DOLLAR_FREIGHT_INTERNACIONAL, -- 18
                                             DOLLAR_IMPORTATION_TAX_AMOUNT, -- 19
                                             DOLLAR_INSURANCE_AMOUNT, -- 20
                                             FOB_AMOUNT, -- 21
                                             FREIGHT_AMOUNT, -- 22
                                             FREIGHT_INTERNACIONAL, -- 23
                                             ICMS_AMOUNT, -- 24
                                             ICMS_AMOUNT_RECOVER, -- 25
                                             ICMS_BASE, -- 26
                                             ICMS_ST_AMOUNT, -- 27
                                             ICMS_ST_AMOUNT_RECOVER, -- 28
                                             ICMS_ST_BASE, -- 29
                                             ICMS_TAX, -- 30
                                             ICMS_TAX_CODE, -- 31
                                             IMPORTATION_COFINS_AMOUNT, -- 32
                                             IMPORTATION_EXPENSE_FUNC, -- 33
                                             IMPORTATION_INSURANCE_AMOUNT, -- 34
                                             IMPORTATION_PIS_AMOUNT, -- 35
                                             IMPORTATION_PIS_COFINS_BASE, -- 36
                                             IMPORTATION_TAX_AMOUNT, -- 37
                                             INSURANCE_AMOUNT, -- 38
                                             INTERFACE_INVOICE_ID, -- 39
                                             INTERFACE_INVOICE_LINE_ID, -- 40
                                             IPI_AMOUNT, -- 41
                                             IPI_AMOUNT_RECOVER, -- 42
                                             IPI_BASE_AMOUNT, -- 43
                                             IPI_TAX, -- 44
                                             IPI_TAX_CODE, -- 45
                                             IPI_TRIBUTARY_CODE, -- 46
                                             IPI_TRIBUTARY_TYPE, -- 47
                                             ITEM_ID, -- 48
                                             LAST_UPDATE_DATE, -- 49
                                             LAST_UPDATED_BY, -- 50
                                             LINE_LOCATION_ID, -- 51
                                             LINE_NUM, -- 52
                                             NET_AMOUNT, -- 53
                                             OPERATION_FISCAL_TYPE, -- 54
                                             OTHER_EXPENSES, -- 55
                                             PIS_AMOUNT_RECOVER, -- 56
                                             PIS_TRIBUTARY_CODE, -- 57
                                             QUANTITY, -- 58
                                             RECEIPT_FLAG, -- 59
                                             REQUISITION_LINE_ID, -- 60
                                             TOTAL_AMOUNT, -- 61
                                             TRIBUTARY_STATUS_CODE, -- 62
                                             UNIT_PRICE, -- 63
                                             UOM, -- 64
                                             UTILIZATION_CODE) -- 65
      VALUES                                 (p_r_CAIBR_REC_INVO_LINES_INTER.ATTRIBUTE14, -- 1
                                              p_r_CAIBR_REC_INVO_LINES_INTER.ATTRIBUTE15, -- 2
                                              p_r_CAIBR_REC_INVO_LINES_INTER.CFO_CODE, -- 3
                                              p_r_CAIBR_REC_INVO_LINES_INTER.CLASSIFICATION_CODE, -- 4
                                              p_r_CAIBR_REC_INVO_LINES_INTER.COFINS_AMOUNT_RECOVER, -- 5
                                              p_r_CAIBR_REC_INVO_LINES_INTER.COFINS_TRIBUTARY_CODE, -- 6
                                              p_r_CAIBR_REC_INVO_LINES_INTER.CREATED_BY, -- 7
                                              p_r_CAIBR_REC_INVO_LINES_INTER.CREATION_DATE, -- 8
                                              p_r_CAIBR_REC_INVO_LINES_INTER.CUSTOMS_EXPENSE_FUNC, -- 9
                                              p_r_CAIBR_REC_INVO_LINES_INTER.DB_CODE_COMBINATION_ID, -- 10
                                              p_r_CAIBR_REC_INVO_LINES_INTER.DESCRIPTION, -- 11
                                              p_r_CAIBR_REC_INVO_LINES_INTER.DIFF_ICMS_AMOUNT, -- 12
                                              p_r_CAIBR_REC_INVO_LINES_INTER.DIFF_ICMS_AMOUNT_RECOVER, -- 13
                                              p_r_CAIBR_REC_INVO_LINES_INTER.DIFF_ICMS_TAX, -- 14
                                              p_r_CAIBR_REC_INVO_LINES_INTER.DISCOUNT_AMOUNT, -- 15
                                              p_r_CAIBR_REC_INVO_LINES_INTER.DOLLAR_CUSTOMS_EXPENSE, -- 16
                                              p_r_CAIBR_REC_INVO_LINES_INTER.DOLLAR_FOB_AMOUNT, -- 17
                                              p_r_CAIBR_REC_INVO_LINES_INTER.DOLLAR_FREIGHT_INTERNACIONAL, -- 18
                                              p_r_CAIBR_REC_INVO_LINES_INTER.DOLLAR_IMPORTATION_TAX_AMOUNT, -- 19
                                              p_r_CAIBR_REC_INVO_LINES_INTER.DOLLAR_INSURANCE_AMOUNT, -- 20
                                              p_r_CAIBR_REC_INVO_LINES_INTER.FOB_AMOUNT, -- 21
                                              p_r_CAIBR_REC_INVO_LINES_INTER.FREIGHT_AMOUNT, -- 22
                                              p_r_CAIBR_REC_INVO_LINES_INTER.FREIGHT_INTERNACIONAL, -- 23
                                              p_r_CAIBR_REC_INVO_LINES_INTER.ICMS_AMOUNT, -- 24
                                              p_r_CAIBR_REC_INVO_LINES_INTER.ICMS_AMOUNT_RECOVER, -- 25
                                              p_r_CAIBR_REC_INVO_LINES_INTER.ICMS_BASE, -- 26
                                              p_r_CAIBR_REC_INVO_LINES_INTER.ICMS_ST_AMOUNT, -- 27
                                              p_r_CAIBR_REC_INVO_LINES_INTER.ICMS_ST_AMOUNT_RECOVER, -- 28
                                              p_r_CAIBR_REC_INVO_LINES_INTER.ICMS_ST_BASE, -- 29
                                              p_r_CAIBR_REC_INVO_LINES_INTER.ICMS_TAX, -- 30
                                              p_r_CAIBR_REC_INVO_LINES_INTER.ICMS_TAX_CODE, -- 31
                                              p_r_CAIBR_REC_INVO_LINES_INTER.IMPORTATION_COFINS_AMOUNT, -- 32
                                              p_r_CAIBR_REC_INVO_LINES_INTER.IMPORTATION_EXPENSE_FUNC, -- 33
                                              p_r_CAIBR_REC_INVO_LINES_INTER.IMPORTATION_INSURANCE_AMOUNT, -- 34
                                              p_r_CAIBR_REC_INVO_LINES_INTER.IMPORTATION_PIS_AMOUNT, -- 35
                                              p_r_CAIBR_REC_INVO_LINES_INTER.IMPORTATION_PIS_COFINS_BASE, -- 36
                                              p_r_CAIBR_REC_INVO_LINES_INTER.IMPORTATION_TAX_AMOUNT, -- 37
                                              p_r_CAIBR_REC_INVO_LINES_INTER.INSURANCE_AMOUNT, -- 38
                                              p_r_CAIBR_REC_INVO_LINES_INTER.INTERFACE_INVOICE_ID, -- 39
                                              p_r_CAIBR_REC_INVO_LINES_INTER.INTERFACE_INVOICE_LINE_ID, -- 40
                                              p_r_CAIBR_REC_INVO_LINES_INTER.IPI_AMOUNT, -- 41
                                              p_r_CAIBR_REC_INVO_LINES_INTER.IPI_AMOUNT_RECOVER, -- 42
                                              p_r_CAIBR_REC_INVO_LINES_INTER.IPI_BASE_AMOUNT, -- 43
                                              p_r_CAIBR_REC_INVO_LINES_INTER.IPI_TAX, -- 44
                                              p_r_CAIBR_REC_INVO_LINES_INTER.IPI_TAX_CODE, -- 45
                                              p_r_CAIBR_REC_INVO_LINES_INTER.IPI_TRIBUTARY_CODE, -- 46
                                              p_r_CAIBR_REC_INVO_LINES_INTER.IPI_TRIBUTARY_TYPE, -- 47
                                              p_r_CAIBR_REC_INVO_LINES_INTER.ITEM_ID, -- 48
                                              p_r_CAIBR_REC_INVO_LINES_INTER.LAST_UPDATE_DATE, -- 49
                                              p_r_CAIBR_REC_INVO_LINES_INTER.LAST_UPDATED_BY, -- 50
                                              p_r_CAIBR_REC_INVO_LINES_INTER.LINE_LOCATION_ID, -- 51
                                              p_r_CAIBR_REC_INVO_LINES_INTER.LINE_NUM, -- 52
                                              p_r_CAIBR_REC_INVO_LINES_INTER.NET_AMOUNT, -- 53
                                              p_r_CAIBR_REC_INVO_LINES_INTER.OPERATION_FISCAL_TYPE, -- 54
                                              p_r_CAIBR_REC_INVO_LINES_INTER.OTHER_EXPENSES, -- 55
                                              p_r_CAIBR_REC_INVO_LINES_INTER.PIS_AMOUNT_RECOVER, -- 56
                                              p_r_CAIBR_REC_INVO_LINES_INTER.PIS_TRIBUTARY_CODE, -- 57
                                              p_r_CAIBR_REC_INVO_LINES_INTER.QUANTITY, -- 58
                                              p_r_CAIBR_REC_INVO_LINES_INTER.RECEIPT_FLAG, -- 59
                                              p_r_CAIBR_REC_INVO_LINES_INTER.REQUISITION_LINE_ID, -- 60
                                              p_r_CAIBR_REC_INVO_LINES_INTER.TOTAL_AMOUNT, -- 61
                                              p_r_CAIBR_REC_INVO_LINES_INTER.TRIBUTARY_STATUS_CODE, -- 62
                                              p_r_CAIBR_REC_INVO_LINES_INTER.UNIT_PRICE, -- 63
                                              p_r_CAIBR_REC_INVO_LINES_INTER.UOM, -- 64
                                              p_r_CAIBR_REC_INVO_LINES_INTER.UTILIZATION_CODE); -- 65
      --
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000,'Erro ao inserir na tabela SFWBR_REC_INVO_LINES_INTER. ' || sqlerrm);
   END EBS_REC_INVOICE_LINES_INT;
   --
   PROCEDURE EBS_REC_INVO_LINE_PAR_INT(p_r_CAIBR_REC_INVO_LINE_PAR_IN SFWBR_REC_INVO_LINE_PAR_INT%ROWTYPE) IS
   BEGIN
      INSERT INTO SFWBR_REC_INVO_LINE_PAR_INT
      VALUES p_r_CAIBR_REC_INVO_LINE_PAR_IN;
      --
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000,'Erro ao inserir na tabela SFWBR_REC_INVO_LINE_PAR_INT. ' || sqlerrm);
   END EBS_REC_INVO_LINE_PAR_INT;
   --
   PROCEDURE EBS_REC_INVO_PAR_INT(p_r_CAIBR_REC_INVO_PAR_INT SFWBR_REC_INVO_PAR_INT%ROWTYPE) IS
   BEGIN
      INSERT INTO SFWBR_REC_INVO_PAR_INT
      VALUES p_r_CAIBR_REC_INVO_PAR_INT;
      --
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000,'Erro ao inserir na tabela SFWBR_REC_INVO_PAR_INT. ' || sqlerrm);
   END EBS_REC_INVO_PAR_INT;
   --
   PROCEDURE EBS_GL_DAILY_RATES_INTERFACE(p_r_CAIBR_GL_DAILY_RATES_INTER SFWBR_GL_DAILY_RATES_INTERFACE%ROWTYPE) IS
   BEGIN
      INSERT INTO SFWBR_GL_DAILY_RATES_INTERFACE(FROM_CURRENCY,
                                                 TO_CURRENCY,
                                                 FROM_CONVERSION_DATE,
                                                 TO_CONVERSION_DATE,
                                                 USER_CONVERSION_TYPE,
                                                 CONVERSION_RATE,
                                                 MODE_FLAG,
                                                 INVERSE_CONVERSION_RATE,
                                                 USER_ID,
                                                 LAUNCH_RATE_CHANGE,
                                                 CONTEXT,
                                                 ATTRIBUTE1,
                                                 ATTRIBUTE2,
                                                 ATTRIBUTE3,
                                                 ATTRIBUTE4,
                                                 ATTRIBUTE5,
                                                 ATTRIBUTE6,
                                                 ATTRIBUTE7,
                                                 ATTRIBUTE8,
                                                 ATTRIBUTE9,
                                                 ATTRIBUTE10,
                                                 ATTRIBUTE11,
                                                 ATTRIBUTE12,
                                                 ATTRIBUTE13,
                                                 ATTRIBUTE14,
                                                 USED_FOR_AB_TRANSLATION,
                                                 ATTRIBUTE15)
      VALUES                                    (p_r_CAIBR_GL_DAILY_RATES_INTER.FROM_CURRENCY,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.TO_CURRENCY,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.FROM_CONVERSION_DATE,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.TO_CONVERSION_DATE,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.USER_CONVERSION_TYPE,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.CONVERSION_RATE,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.MODE_FLAG,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.INVERSE_CONVERSION_RATE,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.USER_ID,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.LAUNCH_RATE_CHANGE,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.CONTEXT,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.ATTRIBUTE1,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.ATTRIBUTE2,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.ATTRIBUTE3,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.ATTRIBUTE4,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.ATTRIBUTE5,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.ATTRIBUTE6,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.ATTRIBUTE7,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.ATTRIBUTE8,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.ATTRIBUTE9,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.ATTRIBUTE10,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.ATTRIBUTE11,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.ATTRIBUTE12,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.ATTRIBUTE13,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.ATTRIBUTE14,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.USED_FOR_AB_TRANSLATION,
                                                 p_r_CAIBR_GL_DAILY_RATES_INTER.ATTRIBUTE15);
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000,'Erro ao inserir na tabela SFWBR_GL_DAILY_RATES_INTERFACE. ' || sqlerrm);
   END EBS_GL_DAILY_RATES_INTERFACE;
   --
   PROCEDURE TMP_GL_INTERFACE(p_r_CAIBR_GL_INTERFACE SFWBR_GL_INTERFACE%ROWTYPE) is
   BEGIN
      INSERT INTO R12_DBL_TMP_GL_INTERFACE(STATUS,
                                           SET_OF_BOOKS_ID,
                                           ACCOUNTING_DATE,
                                           CURRENCY_CODE,
                                           DATE_CREATED,
                                           CREATED_BY,
                                           ACTUAL_FLAG,
                                           USER_JE_CATEGORY_NAME,
                                           USER_JE_SOURCE_NAME,
                                           CURRENCY_CONVERSION_DATE,
                                           ENCUMBRANCE_TYPE_ID,
                                           BUDGET_VERSION_ID,
                                           USER_CURRENCY_CONVERSION_TYPE,
                                           CURRENCY_CONVERSION_RATE,
                                           AVERAGE_JOURNAL_FLAG,
                                           ORIGINATING_BAL_SEG_VALUE,
                                           SEGMENT1,
                                           SEGMENT2,
                                           SEGMENT3,
                                           SEGMENT4,
                                           SEGMENT5,
                                           SEGMENT6,
                                           SEGMENT7,
                                           SEGMENT8,
                                           SEGMENT9,
                                           SEGMENT10,
                                           SEGMENT11,
                                           SEGMENT12,
                                           SEGMENT13,
                                           SEGMENT14,
                                           SEGMENT15,
                                           SEGMENT16,
                                           SEGMENT17,
                                           SEGMENT18,
                                           SEGMENT19,
                                           SEGMENT20,
                                           SEGMENT21,
                                           SEGMENT22,
                                           SEGMENT23,
                                           SEGMENT24,
                                           SEGMENT25,
                                           SEGMENT26,
                                           SEGMENT27,
                                           SEGMENT28,
                                           SEGMENT29,
                                           SEGMENT30,
                                           ENTERED_DR,
                                           ENTERED_CR,
                                           ACCOUNTED_DR,
                                           ACCOUNTED_CR,
                                           TRANSACTION_DATE,
                                           REFERENCE1,
                                           REFERENCE2,
                                           REFERENCE3,
                                           REFERENCE4,
                                           REFERENCE5,
                                           REFERENCE6,
                                           REFERENCE7,
                                           REFERENCE8,
                                           REFERENCE9,
                                           REFERENCE10,
                                           REFERENCE11,
                                           REFERENCE12,
                                           REFERENCE13,
                                           REFERENCE14,
                                           REFERENCE15,
                                           REFERENCE16,
                                           REFERENCE17,
                                           REFERENCE18,
                                           REFERENCE19,
                                           REFERENCE20,
                                           REFERENCE21,
                                           REFERENCE22,
                                           REFERENCE23,
                                           REFERENCE24,
                                           REFERENCE25,
                                           REFERENCE26,
                                           REFERENCE27,
                                           REFERENCE28,
                                           REFERENCE29,
                                           REFERENCE30,
                                           JE_BATCH_ID,
                                           PERIOD_NAME,
                                           JE_HEADER_ID,
                                           JE_LINE_NUM,
                                           CHART_OF_ACCOUNTS_ID,
                                           FUNCTIONAL_CURRENCY_CODE,
                                           CODE_COMBINATION_ID,
                                           DATE_CREATED_IN_GL,
                                           WARNING_CODE,
                                           STATUS_DESCRIPTION,
                                           STAT_AMOUNT,
                                           GROUP_ID,
                                           REQUEST_ID,
                                           SUBLEDGER_DOC_SEQUENCE_ID,
                                           SUBLEDGER_DOC_SEQUENCE_VALUE,
                                           ATTRIBUTE1,
                                           ATTRIBUTE2,
                                           GL_SL_LINK_ID,
                                           GL_SL_LINK_TABLE,
                                           ATTRIBUTE3,
                                           ATTRIBUTE4,
                                           ATTRIBUTE5,
                                           ATTRIBUTE6,
                                           ATTRIBUTE7,
                                           ATTRIBUTE8,
                                           ATTRIBUTE9,
                                           ATTRIBUTE10,
                                           ATTRIBUTE11,
                                           ATTRIBUTE12,
                                           ATTRIBUTE13,
                                           ATTRIBUTE14,
                                           ATTRIBUTE15,
                                           ATTRIBUTE16,
                                           ATTRIBUTE17,
                                           ATTRIBUTE18,
                                           ATTRIBUTE19,
                                           ATTRIBUTE20,
                                           CONTEXT,
                                           CONTEXT2,
                                           INVOICE_DATE,
                                           TAX_CODE,
                                           INVOICE_IDENTIFIER,
                                           INVOICE_AMOUNT,
                                           CONTEXT3,
                                           USSGL_TRANSACTION_CODE,
                                           DESCR_FLEX_ERROR_MESSAGE,
                                           JGZZ_RECON_REF,
                                           REFERENCE_DATE)
      VALUES                              (p_r_CAIBR_GL_INTERFACE.STATUS,
                                           p_r_CAIBR_GL_INTERFACE.SET_OF_BOOKS_ID,
                                           p_r_CAIBR_GL_INTERFACE.ACCOUNTING_DATE,
                                           p_r_CAIBR_GL_INTERFACE.CURRENCY_CODE,
                                           p_r_CAIBR_GL_INTERFACE.DATE_CREATED,
                                           p_r_CAIBR_GL_INTERFACE.CREATED_BY,
                                           p_r_CAIBR_GL_INTERFACE.ACTUAL_FLAG,
                                           p_r_CAIBR_GL_INTERFACE.USER_JE_CATEGORY_NAME,
                                           p_r_CAIBR_GL_INTERFACE.USER_JE_SOURCE_NAME,
                                           p_r_CAIBR_GL_INTERFACE.CURRENCY_CONVERSION_DATE,
                                           p_r_CAIBR_GL_INTERFACE.ENCUMBRANCE_TYPE_ID,
                                           p_r_CAIBR_GL_INTERFACE.BUDGET_VERSION_ID,
                                           p_r_CAIBR_GL_INTERFACE.USER_CURRENCY_CONVERSION_TYPE,
                                           p_r_CAIBR_GL_INTERFACE.CURRENCY_CONVERSION_RATE,
                                           p_r_CAIBR_GL_INTERFACE.AVERAGE_JOURNAL_FLAG,
                                           p_r_CAIBR_GL_INTERFACE.ORIGINATING_BAL_SEG_VALUE,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT1,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT2,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT3,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT4,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT5,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT6,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT7,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT8,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT9,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT10,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT11,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT12,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT13,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT14,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT15,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT16,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT17,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT18,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT19,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT20,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT21,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT22,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT23,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT24,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT25,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT26,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT27,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT28,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT29,
                                           p_r_CAIBR_GL_INTERFACE.SEGMENT30,
                                           p_r_CAIBR_GL_INTERFACE.ENTERED_DR,
                                           p_r_CAIBR_GL_INTERFACE.ENTERED_CR,
                                           p_r_CAIBR_GL_INTERFACE.ACCOUNTED_DR,
                                           p_r_CAIBR_GL_INTERFACE.ACCOUNTED_CR,
                                           p_r_CAIBR_GL_INTERFACE.TRANSACTION_DATE,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE1,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE2,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE3,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE4,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE5,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE6,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE7,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE8,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE9,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE10,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE11,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE12,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE13,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE14,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE15,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE16,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE17,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE18,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE19,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE20,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE21,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE22,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE23,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE24,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE25,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE26,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE27,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE28,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE29,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE30,
                                           p_r_CAIBR_GL_INTERFACE.JE_BATCH_ID,
                                           p_r_CAIBR_GL_INTERFACE.PERIOD_NAME,
                                           p_r_CAIBR_GL_INTERFACE.JE_HEADER_ID,
                                           p_r_CAIBR_GL_INTERFACE.JE_LINE_NUM,
                                           p_r_CAIBR_GL_INTERFACE.CHART_OF_ACCOUNTS_ID,
                                           p_r_CAIBR_GL_INTERFACE.FUNCTIONAL_CURRENCY_CODE,
                                           p_r_CAIBR_GL_INTERFACE.CODE_COMBINATION_ID,
                                           p_r_CAIBR_GL_INTERFACE.DATE_CREATED_IN_GL,
                                           p_r_CAIBR_GL_INTERFACE.WARNING_CODE,
                                           p_r_CAIBR_GL_INTERFACE.STATUS_DESCRIPTION,
                                           p_r_CAIBR_GL_INTERFACE.STAT_AMOUNT,
                                           p_r_CAIBR_GL_INTERFACE.GROUP_ID,
                                           p_r_CAIBR_GL_INTERFACE.REQUEST_ID,
                                           p_r_CAIBR_GL_INTERFACE.SUBLEDGER_DOC_SEQUENCE_ID,
                                           p_r_CAIBR_GL_INTERFACE.SUBLEDGER_DOC_SEQUENCE_VALUE,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE1,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE2,
                                           p_r_CAIBR_GL_INTERFACE.GL_SL_LINK_ID,
                                           p_r_CAIBR_GL_INTERFACE.GL_SL_LINK_TABLE,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE3,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE4,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE5,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE6,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE7,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE8,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE9,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE10,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE11,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE12,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE13,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE14,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE15,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE16,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE17,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE18,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE19,
                                           p_r_CAIBR_GL_INTERFACE.ATTRIBUTE20,
                                           p_r_CAIBR_GL_INTERFACE.CONTEXT,
                                           p_r_CAIBR_GL_INTERFACE.CONTEXT2,
                                           p_r_CAIBR_GL_INTERFACE.INVOICE_DATE,
                                           p_r_CAIBR_GL_INTERFACE.TAX_CODE,
                                           p_r_CAIBR_GL_INTERFACE.INVOICE_IDENTIFIER,
                                           p_r_CAIBR_GL_INTERFACE.INVOICE_AMOUNT,
                                           p_r_CAIBR_GL_INTERFACE.CONTEXT3,
                                           p_r_CAIBR_GL_INTERFACE.USSGL_TRANSACTION_CODE,
                                           p_r_CAIBR_GL_INTERFACE.DESCR_FLEX_ERROR_MESSAGE,
                                           p_r_CAIBR_GL_INTERFACE.JGZZ_RECON_REF,
                                           p_r_CAIBR_GL_INTERFACE.REFERENCE_DATE);
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000,'Erro ao inserir na tabela R12_DBL_TMP_GL_INTERFACE. ' || sqlerrm);
   END TMP_GL_INTERFACE;
   --
END PKG_R12_DBL_EXP_INSERT;
/