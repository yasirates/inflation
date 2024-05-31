  METHOD if_http_service_extension~handle_request.

    DATA lv_response TYPE string.
    DATA(reference_id) = request->get_form_field( i_name = 'IV_REFERENCE_ID' ).

    IF reference_id IS NOT INITIAL.
      me->get_accounting_document(
        EXPORTING
          iv_reference_id       = CONV #( reference_id )
        IMPORTING
          ev_companycode        = DATA(companycode)
          ev_fiscalyear         = DATA(fiscalyear)
          ev_accountingdocument = DATA(accountingdocument)
      ).
      companycode = '1000'.
      fiscalyear = '2024'.
      accountingdocument = '0000123321'.
*      IF accountingdocument IS NOT INITIAL.
        lv_response = companycode && '/' && fiscalyear && '/' && accountingdocument.
        response->set_text( i_text = lv_response ).
*      ELSE.
*        response->set_text( i_text = 'Belge bulunamadı' ).
*      ENDIF.
    ENDIF.
  ENDMETHOD.