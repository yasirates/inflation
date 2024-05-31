  METHOD if_rap_query_provider~select.
*
    DATA: company_code TYPE bukrs,
          ledger       TYPE zinf_e_rldnr,
          budat        TYPE budat,
          rate_type    TYPE zinf_e_rate_type.

    DATA(lv_entity_name) = io_request->get_entity_id( ).

    IF io_request->is_data_requested( ).
*      DATA(requested_fields) = io_request->get_requested_elements( ).
*      DATA(lv_cond) = io_request->get_filter( )->get_as_sql_string( ).

      mo_regulative_common = NEW #( ).

      DATA(filter_conditions) = io_request->get_filter( )->get_as_ranges( ).

      LOOP AT filter_conditions INTO DATA(condition).
        CASE condition-name.
          WHEN 'BUKRS'.
            company_code = VALUE #( condition-range[ 1 ]-low OPTIONAL ).
          WHEN 'RTYPE'.
            rate_type = VALUE #( condition-range[ 1 ]-low OPTIONAL ).
          WHEN 'BUDAT'.
            budat =  VALUE #( condition-range[ 1 ]-low OPTIONAL ).
          WHEN 'RLDNR'.
            ledger =  VALUE #( condition-range[ 1 ]-low OPTIONAL ).
        ENDCASE.
      ENDLOOP.
*
      get_data(
        iv_bukrs = company_code
        iv_rldnr = ledger
      ).
*
      process_data(
        iv_bukrs = company_code
        iv_gjahr = CONV gjahr( budat(4) )
        iv_rldnr = ledger
        iv_budat = budat
        iv_rtype = rate_type
      ).
*
      set_data(
        io_request  = io_request
        io_response = io_response
      ).
    ENDIF.
  ENDMETHOD.