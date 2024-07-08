CLASS zcl_inf_journal_entry_create DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES : BEGIN OF mty_xml,
              uuid               TYPE string,
              AccountingDocument TYPE string,
              CompanyCode        TYPE string,
              FiscalYear         TYPE string,
              TypeID             TYPE string,
              SeverityCode       TYPE string,
              Note               TYPE string,
            END OF mty_xml.

    DATA : mt_reverse_xml  TYPE TABLE OF mty_xml,
           ms_reverse_xml  TYPE mty_xml,
           mt_xml          TYPE TABLE OF mty_xml,
           ms_xml          TYPE mty_xml,
           mv_service_data TYPE string.

    CLASS-DATA: mt_users        TYPE TABLE OF zinf_users.
    INTERFACES if_http_service_extension .

    METHODS:
      get_service_info IMPORTING VALUE(iv_service_id) TYPE zinf_users-service_id,

      update_db IMPORTING VALUE(iv_operation) TYPE zinf_e_service_operation
                          VALUE(iv_sysuuid)   TYPE sysuuid_c36
                          VALUE(iv_prog)      TYPE zinf_e_prog
                          VALUE(iv_return)    TYPE string,


      update_after_reverse IMPORTING VALUE(iv_data) TYPE string
                                     VALUE(iv_uuid) TYPE sysuuid_c36.
