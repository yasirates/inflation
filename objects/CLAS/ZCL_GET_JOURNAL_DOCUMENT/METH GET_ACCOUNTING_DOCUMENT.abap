  METHOD get_accounting_document.
    SELECT SINGLE *
       FROM I_JournalEntry
      WHERE DocumentReferenceID EQ @iv_reference_id
       INTO @DATA(ls_entry).

    IF sy-subrc IS INITIAL AND ls_entry-SenderAccountingDocument IS NOT INITIAL.
      ev_accountingDocument = ls_entry-AccountingDocument.
      ev_fiscalyear         = ls_entry-FiscalYear.
      ev_companycode        = ls_entry-CompanyCode.
    ENDIF.
  ENDMETHOD.