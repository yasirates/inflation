CLASS zcl_get_journal_document DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.
    INTERFACES if_http_service_extension .
    METHODS : get_accounting_document IMPORTING VALUE(iv_reference_id)       TYPE I_JournalEntry-DocumentReferenceID
                                      EXPORTING VALUE(ev_companycode)        TYPE bukrs
                                                VALUE(ev_fiscalyear)         TYPE gjahr
                                                VALUE(ev_AccountingDocument) TYPE I_JournalEntry-AccountingDocument.