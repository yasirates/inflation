  METHOD if_rap_query_provider~select.

*    DATA : lr_bukrs  TYPE if_rap_query_filter=>tt_range_option,
*           lr_rspmon TYPE if_rap_query_filter=>tt_range_option,
*           lr_cspmon TYPE if_rap_query_filter=>tt_range_option,
*           lr_rldnr  TYPE if_rap_query_filter=>tt_range_option.

*    DATA: lo_root_filter_node     TYPE REF TO /iwbep/if_cp_filter_node.


    DATA(requested_fields) = io_request->get_requested_elements( ).
    DATA(lv_cond) = io_request->get_filter( )->get_as_sql_string( ).
    DATA(lt_filter_condition) = io_request->get_filter( )->get_as_ranges( ).

    DATA: lv_bukrs  TYPE bukrs,
          lv_rspmon TYPE fins_fyearperiod,
          lv_cspmon TYPE fins_fyearperiod,
          lv_rldnr  TYPE zinf_e_rldnr.

    LOOP AT lt_filter_condition INTO DATA(ls_condition).
      CASE ls_condition-name.
        WHEN 'BUKRS'.
          lv_bukrs = VALUE #( ls_condition-range[ 1 ]-low OPTIONAL ).
        WHEN 'RSPMON'.
          lv_rspmon = VALUE #( ls_condition-range[ 1 ]-low OPTIONAL ).
        WHEN 'CSPMON'.
          lv_cspmon =  VALUE #( ls_condition-range[ 1 ]-low OPTIONAL ).
        WHEN 'RLDNR'.
          lv_rldnr =  VALUE #( ls_condition-range[ 1 ]-low OPTIONAL ).
      ENDCASE.
    ENDLOOP.

    IF io_request->is_data_requested( ).

      mo_regulative_common = NEW #(  ).

      me->get_data(
        iv_bukrs    = lv_bukrs
        iv_rspmon   = lv_rspmon
        iv_cspmon   = lv_cspmon
        iv_rldnr    = lv_rldnr
        io_request  = io_request
        io_response = io_response
      ).

      me->process_data(
        iv_bukrs  = lv_bukrs
        iv_rldnr  = lv_rldnr
        iv_rspmon = lv_rspmon
        iv_cspmon = lv_cspmon
      ).

      me->set_data(
        io_request  = io_request
        io_response = io_response
      ).
    ENDIF.

  ENDMETHOD.