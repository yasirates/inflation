  METHOD if_http_service_extension~handle_request.
    DATA : url          TYPE string,
           lv_json_temp TYPE string.

    DATA(lv_uuid)      = request->get_form_field( i_name = 'IV_UUID' ).
    DATA(lv_operation) = request->get_form_field( i_name = 'IV_OPERATION' ).
    DATA(lv_prog)      = request->get_form_field( i_name = 'IV_PROG' ).

    "- 01 Create
    "- 02 Reverse
    get_service_info( iv_service_id = COND #( WHEN lv_operation EQ '01' THEN '02'
                                              WHEN lv_operation EQ '02' THEN '03' ) ).

    DATA(service_info) = VALUE #( mt_users[ 1 ] OPTIONAL ).

    url = service_info-service_url.

    CLEAR mv_service_data.
    mv_service_data = request->get_text( ).

    TRY.
        DATA(lo_http_destination) = cl_http_destination_provider=>create_by_url( i_url = CONV #( service_info-service_url ) ).
        DATA(lo_web_http_client)  = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ).

        DATA(lo_web_http_request) = lo_web_http_client->get_http_request( ).

        lo_web_http_request->set_authorization_basic(
          EXPORTING
            i_username = CONV #( service_info-username )
            i_password = CONV #( service_info-password )
        ).

        lo_web_http_request->set_header_fields( VALUE #( ( name = 'Accept'          value = 'application/xml' )
                                                         ( name = 'Content-Type'    value = 'text/xml;charset=UTF-8' )
                                                         ( name = 'Accept-Encoding' value = 'gzip,deflate' )
                                                         ( name = 'Connection'      value = 'Keep-Alive' )
*                                                         ( name = 'SOAPAction'      value = 'http://sap.com/xi/SAPSCORE/SFIN/JournalEntryBulkLedgerCreationRequest_In/JournalEntryBulkLedgerCreationRequest_InRequest' )
        ) ).

        lo_web_http_request->set_text( EXPORTING i_text = mv_service_data ).

        DATA(lo_web_http_response) = lo_web_http_client->execute( if_web_http_client=>post ).

        lo_web_http_response->get_status(
          RECEIVING
            r_value = DATA(ls_status)
        ).

        DATA lv_text TYPE string.
        CASE lv_operation.
          WHEN '01'.
            lv_text = ls_status-code &&  | | && ls_status-reason.
            response->set_text( i_text = lv_text ).

            TRY.
                lo_web_http_response->get_text(
                  RECEIVING
                    r_value = DATA(return)
                ).
              CATCH cx_web_message_error INTO DATA(cx_message).
            ENDTRY.

            update_db(
              iv_operation = CONV #( lv_operation )
              iv_sysuuid   = CONV #( lv_uuid )
              iv_prog      = CONV #( lv_prog )
              iv_return    = return
            ).

            response->set_text( i_text = return ).
          WHEN '02'.
            lo_web_http_response->get_text(
              RECEIVING
                r_value = DATA(reversal_response)
            ).

            update_after_reverse( iv_data = reversal_response
                                  iv_uuid = CONV #( lv_uuid ) ).

            response->set_text( i_text = reversal_response ).
        ENDCASE.
    ENDTRY.
  ENDMETHOD.