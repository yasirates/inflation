  METHOD update_db.
    DATA: lv_postingdate         TYPE i_journalentry-PostingDate,
          lv_documentdate        TYPE i_journalentry-DocumentDate,
          lv_companycode         TYPE i_journalentry-CompanyCode,
          lv_DocumentReferenceID TYPE i_journalentry-DocumentReferenceID,
*          lv_fiscalyear          TYPE I_JournalEntry-FiscalYear,
          lv_AccountingDocument  TYPE I_JournalEntry-AccountingDocument.

*    zcl_etr_regulative_common=>parse_xml(
    zinf_regulative_common=>parse_xml(
      EXPORTING
        iv_xml_string = iv_return
      RECEIVING
        rt_data       = DATA(lt_service_data) ).

    LOOP AT lt_service_data ASSIGNING FIELD-SYMBOL(<lfs_service_data>).
      CHECK <lfs_service_data>-node_type EQ 'CO_NT_VALUE'.
      CASE <lfs_service_data>-name .
*        WHEN 'DocumentReferenceID'.
*          ms_xml-documentreferenceid = <lfs_service_data>-value.
*        WHEN 'CompanyCode'.
*          ms_xml-companycode         = <lfs_service_data>-value.
*        WHEN 'DocumentDate'.
*          ms_xml-documentDate        = <lfs_service_data>-value.
*        WHEN 'PostingDate'.
*          ms_xml-postingDate         = <lfs_service_data>-value.
*          APPEND ms_xml TO mt_xml. CLEAR ms_xml.
        WHEN 'UUID'.
          ms_xml-uuid              = <lfs_service_data>-value.
        WHEN 'AccountingDocument'.
          ms_xml-AccountingDocument = <lfs_service_data>-value.
        WHEN 'CompanyCode'.
          ms_xml-companycode        = <lfs_service_data>-value.
        WHEN 'FiscalYear'.
          ms_xml-FiscalYear         = <lfs_service_data>-value.
        WHEN 'TypeID'.
          ms_xml-typeid             = <lfs_service_data>-value.
        WHEN 'SeverityCode'.
          ms_xml-SeverityCode       =  <lfs_service_data>-value.
        WHEN 'Note'.
          ms_xml-note               = <lfs_service_data>-value.
          APPEND ms_xml TO mt_xml. CLEAR ms_xml.
      ENDCASE.
    ENDLOOP.

    CLEAR ms_xml.
    READ TABLE mt_xml INTO ms_xml INDEX 1.
    IF sy-subrc IS INITIAL.
      CHECK ms_xml-accountingdocument NE '0000000000'.
      CASE iv_prog.
        WHEN '01'.
          UPDATE zinf_t008 SET belnr = @ms_xml-accountingdocument,
                               gjahr = @ms_xml-fiscalyear
                         WHERE uuid  = @iv_sysuuid.
          COMMIT WORK AND WAIT.
        WHEN '02'.
          UPDATE zinf_t002 SET belnr = @ms_xml-accountingdocument,
                               gjahr = @ms_xml-fiscalyear
                         WHERE uuid  = @iv_sysuuid.
          COMMIT WORK AND WAIT.
      ENDCASE.
    ENDIF.
  ENDMETHOD.