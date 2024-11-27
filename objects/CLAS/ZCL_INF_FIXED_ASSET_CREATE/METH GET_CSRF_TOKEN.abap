  METHOD get_csrf_token.
    DATA : url          TYPE string.

    me->get_service_info( iv_service_id = '05' ).

    DATA(service_info) = VALUE #( mt_users[ 1 ] OPTIONAL ).

    url = service_info-service_url.

    TRY.
        DATA(lo_http_destination) = cl_http_destination_provider=>create_by_url( i_url = CONV #( service_info-service_url ) ).
      CATCH cx_http_dest_provider_error.
        "handle exception
    ENDTRY.

    TRY.
        DATA(lo_web_http_client)  = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ).
      CATCH cx_web_http_client_error.
        "handle exception
    ENDTRY.

    DATA(lo_web_http_request) = lo_web_http_client->get_http_request( ).

    lo_web_http_request->set_authorization_basic(
      EXPORTING
        i_username = CONV #( service_info-username )
        i_password = CONV #( service_info-password )
    ).

    lo_web_http_request->set_header_fields( VALUE #( ( name = 'Accept'          value = '*/*' )
                                                     ( name = 'Accept-Encoding' value = 'gzip,deflate' )
                                                     ( name = 'Connection'      value = 'Keep-Alive' )
                                                     ( name = 'x-csrf-token'    value = 'fetch' )
    ) ).

    TRY.
        DATA(lo_web_http_response) = lo_web_http_client->execute( if_web_http_client=>get ).
      CATCH cx_web_http_client_error.
        "handle exception
    ENDTRY.

    lo_web_http_response->get_status(
      RECEIVING
        r_value = DATA(ls_status)
    ).
    TRY.
        lo_web_http_response->get_text(
          RECEIVING
            r_value = DATA(return)
        ).

        lo_web_http_response->get_header_field(
          EXPORTING
            i_name  = 'x-csrf-token'
          RECEIVING
            r_value = rv_token
        ).
      CATCH cx_web_message_error INTO DATA(cx_message).
    ENDTRY.

    lo_web_http_response->get_cookies(
      RECEIVING
        r_value = mt_cookies
    ).

*    mt_cookies = lt_cookies.
  ENDMETHOD.