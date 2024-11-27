  METHOD if_rap_query_provider~select.
*
    DATA: company_code TYPE bukrs,
          budat        TYPE budat,
          prev_date    TYPE zinf_e_previous_date,
          ledger       TYPE zinf_e_rldnr,
          rate_type    TYPE zinf_e_rate_type,
          hkont        TYPE RANGE OF hkont.

*    IF io_request->is_data_requested( ).
    mt_requested_elements = io_request->get_requested_elements( ).

    mo_regulative_common = NEW #( ).

    DATA(filter_conditions) = io_request->get_filter( )->get_as_ranges( ).
    LOOP AT filter_conditions INTO DATA(condition).
      CASE condition-name.
        WHEN 'BUKRS'.
          company_code = VALUE #( condition-range[ 1 ]-low OPTIONAL ).
        WHEN 'PREV_DATE'.
          prev_date = VALUE #( condition-range[ 1 ]-low OPTIONAL ).
        WHEN 'BUDAT'.
          budat =  VALUE #( condition-range[ 1 ]-low OPTIONAL ).
        WHEN 'RTYPE'.
          rate_type = VALUE #( condition-range[ 1 ]-low OPTIONAL ).
        WHEN 'RLDNR'.
          ledger =  VALUE #( condition-range[ 1 ]-low OPTIONAL ).
        WHEN 'HKONT'.
          LOOP AT condition-range INTO DATA(ls_range).
            APPEND VALUE #( sign   = ls_range-sign
                            option = ls_range-option
                            low    = ls_range-low
                            high   = ls_range-high ) TO hkont.
          ENDLOOP.
      ENDCASE.
    ENDLOOP.
*
    me->get_data(
      iv_bukrs = company_code
      iv_rldnr = ledger
      iv_idate = prev_date
      it_hkont = hkont
    ).

    me->init_data(
      iv_rtype     = rate_type
      iv_budat     = budat
      iv_prev_date = prev_date
    ).
*
    TRY.
        me->process_data(
          iv_bukrs     = company_code
          iv_gjahr     = CONV gjahr( budat(4) )
          iv_rldnr     = ledger
          iv_budat     = budat
          iv_prev_date = prev_date
          iv_rtype     = rate_type
        ).
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.
*
    me->set_data(
      io_request  = io_request
      io_response = io_response
    ).

*    ENDIF.
  ENDMETHOD.