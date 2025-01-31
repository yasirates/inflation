  METHOD if_rap_query_provider~select.

    mo_regulative_common = NEW #( ).

    me->prepare_date( ).

    "- get filter parameters..
    TRY.
        DATA(lt_filter_param) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
        "handle exception
    ENDTRY.

    LOOP AT lt_filter_param INTO DATA(ls_filter_param).

      CASE ls_filter_param-name.
        WHEN 'BUKRS'.
          mr_company_code = ls_filter_param-range .
        WHEN 'ANLN1'.
          mr_anln1 = ls_filter_param-range.
        WHEN 'ANLN2'.
          mr_anln2 = ls_filter_param-range.
        WHEN 'RLDNR'.
          mr_rldnr = ls_filter_param-range.
        WHEN 'DEPRECIATION_AREA'.
          mr_depr_area = ls_filter_param-range.
        WHEN 'BUDAT'.
          mr_budat = ls_filter_param-range.
        WHEN 'VAL_DATE'.
          mr_valuation_date = ls_filter_param-range.
        WHEN 'INDEX_DATE'.
          mr_index_date = ls_filter_param-range.
      ENDCASE.

    ENDLOOP.

    TRY.
        me->get_data( ).

        me->prepare_data(  ).

        me->set_data(
          io_request  = io_request
          io_response = io_response
        ).
      CATCH cx_root INTO DATA(cx_root).
    ENDTRY.

  ENDMETHOD.