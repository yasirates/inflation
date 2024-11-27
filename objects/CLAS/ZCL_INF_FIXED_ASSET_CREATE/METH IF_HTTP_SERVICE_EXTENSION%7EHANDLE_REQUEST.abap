  METHOD if_http_service_extension~handle_request.
    DATA: url   TYPE string,
          token TYPE string.

    CLEAR mv_cookies.

    me->get_csrf_token(
      EXPORTING
        request  = request
        response = response
      RECEIVING
        rv_token = token
    ).

    me->get_service_info( iv_service_id = '04' ).

    DATA(service_info) = VALUE #( mt_users[ 1 ] OPTIONAL ).

    url = service_info-service_url.

    CLEAR mv_service_data.
    mv_service_data = request->get_text( ).

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

    LOOP AT mt_cookies INTO DATA(ls_cookies).
      lo_web_http_request->set_cookie(
        EXPORTING
          i_name    = ls_cookies-name
          i_path    = ls_cookies-path
          i_value   = ls_cookies-value
          i_domain  = ls_cookies-domain
          i_expires = ls_cookies-expires
          i_secure  = ls_cookies-secure
      ).
    ENDLOOP.

    lo_web_http_request->set_header_fields( VALUE #( ( name = 'Accept'          value = '*/*' )
                                                     ( name = 'Content-Type'    value = 'application/json' )
                                                     ( name = 'Accept-Encoding' value = 'gzip,deflate,br' )
                                                     ( name = 'Connection'      value = 'keep-alive' )
                                                     ( name = 'x-csrf-token'    value = token )
    ) ).

    DATA(lv_bukrs)              = request->get_form_field( i_name = 'IV_BUKRS' ).
    DATA(lv_master_fixed_asset) = request->get_form_field( i_name = 'IV_MASTER_FIXED_ASSET' ).
    DATA(lv_fixed_asset)   = request->get_form_field( i_name = 'IV_FIXED_ASSET' ).
    DATA(lv_rldnr)         = request->get_form_field( i_name = 'IV_RLDNR' ).
    DATA(lv_val_date)      = request->get_form_field( i_name = 'IV_VAL_DATE' ).

    lo_web_http_request->set_text( EXPORTING i_text = mv_service_data ).

    TRY.
        DATA(lo_web_http_response) = lo_web_http_client->execute( if_web_http_client=>post ).
      CATCH cx_web_http_client_error.
        "handle exception
    ENDTRY.

    lo_web_http_response->get_status(
      RECEIVING
        r_value = DATA(ls_status)
    ).


    DATA lv_text TYPE string.
    lv_text = ls_status-code &&  | | && ls_status-reason.
    response->set_text( i_text = lv_text ).

    TRY.
        lo_web_http_response->get_text(
          RECEIVING
            r_value = DATA(return)
        ).
      CATCH cx_web_message_error INTO DATA(cx_message).
    ENDTRY.


    response->set_text( i_text = return ).

    IF ls_status-code EQ '200'.

      lo_web_http_response->get_header_fields(
        RECEIVING
          r_value = DATA(response_header_fields)
      ).

      READ TABLE response_header_fields INTO DATA(header_field)  WITH KEY name = 'sap-messages'.
      IF sy-subrc EQ 0.

        me->json_deserialize(
          EXPORTING
            iv_json_data = header_field-value
          IMPORTING
            rv_json_data = mt_service_res_json_data
        ).

        IF mt_service_res_json_data IS NOT INITIAL.
          READ TABLE mt_service_res_json_data INTO DATA(ls_json_data) INDEX 1.
          IF  sy-subrc EQ 0.
            FIND 'Variable2' IN ls_json_data-longtexturl MATCH OFFSET DATA(lv_var2_position).
            lv_var2_position = lv_var2_position + 11.
            DATA(create_belnr) = ls_json_data-longtexturl+lv_var2_position(10).
            IF create_belnr IS NOT INITIAL AND strlen( create_belnr ) EQ 10.

              ms_success_response-belnr = create_belnr.
              /ui2/cl_json=>serialize(
                EXPORTING
                  data        = ms_success_response
                  pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                RECEIVING
                  r_json      = DATA(lv_json)
              ).

              response->set_text( i_text = lv_json ).

              INSERT INTO zinf_t030 VALUES @( VALUE #( bukrs    = lv_bukrs
                                                       anln1    = lv_master_fixed_asset
                                                       anln2    = lv_fixed_asset
                                                       rldnr    = lv_rldnr
                                                       belnr    = create_belnr
                                                       gjahr    = lv_val_date(4)
                                                       val_date = lv_val_date
              ) ).
              IF sy-subrc EQ 0.
                COMMIT WORK AND WAIT.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.