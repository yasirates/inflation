  METHOD update_after_reverse.
    DATA: lv_fiscalyear         TYPE I_JournalEntry-FiscalYear,
          lv_AccountingDocument TYPE I_JournalEntry-AccountingDocument.

    zinf_regulative_common=>parse_xml(
      EXPORTING
        iv_xml_string = iv_data
      RECEIVING
        rt_data       = DATA(lt_service_data) ).

    CLEAR ms_reverse_xml.
    LOOP AT lt_service_data ASSIGNING FIELD-SYMBOL(<lfs_service_data>).
      CHECK <lfs_service_data>-node_type EQ 'CO_NT_VALUE'.
      CASE <lfs_service_data>-name .
        WHEN 'UUID'.
          ms_reverse_xml-uuid = <lfs_service_data>-value.
        WHEN 'AccountingDocument'.
          ms_reverse_xml-AccountingDocument = <lfs_service_data>-value.
        WHEN 'CompanyCode'.
          ms_reverse_xml-CompanyCode = <lfs_service_data>-value.
        WHEN 'FiscalYear'.
          ms_reverse_xml-FiscalYear = <lfs_service_data>-value.
        WHEN 'TypeID'.
          ms_reverse_xml-TypeID = <lfs_service_data>-value.
        WHEN 'SeverityCode'.
          ms_reverse_xml-SeverityCode = <lfs_service_data>-value.
        WHEN 'Note'.
          ms_reverse_xml-Note = <lfs_service_data>-value.
          APPEND ms_reverse_xml TO mt_reverse_xml.
      ENDCASE.
    ENDLOOP.

    READ TABLE mt_reverse_xml INTO ms_reverse_xml INDEX 1.
    IF ms_reverse_xml-accountingdocument NE '0000000000'.
      lv_AccountingDocument = ms_reverse_xml-accountingdocument.
      lv_fiscalyear         = ms_reverse_xml-fiscalyear.
      UPDATE zinf_t008 SET rev_belnr = @lv_AccountingDocument,
                           rev_gjahr = @lv_fiscalyear
                      WHERE uuid = @iv_uuid.
      COMMIT WORK AND WAIT.
    ENDIF.
  ENDMETHOD.