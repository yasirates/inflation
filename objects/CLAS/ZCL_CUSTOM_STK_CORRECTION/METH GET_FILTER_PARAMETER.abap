  METHOD get_filter_parameter .
    TRY.
        DATA(filter_conditions) = io_request->get_filter( )->get_as_ranges( ).

        LOOP AT filter_conditions INTO DATA(condition).
          CASE condition-name.
            WHEN 'BUKRS'.
              mv_company_code   = VALUE #( condition-range[ 1 ]-low OPTIONAL ).
            WHEN 'RSPMON'.
              mv_period         = VALUE #( condition-range[ 1 ]-low OPTIONAL ).
            WHEN 'RLDNR'.
              mv_rldnr          = VALUE #( condition-range[ 1 ]-low OPTIONAL ).
            WHEN 'RTYPE'.
              mv_rtype          = VALUE #( condition-range[ 1 ]-low OPTIONAL ).
            WHEN 'AVARAGE_METHOD'.
              mv_avarage_method = VALUE #( condition-range[ 1 ]-low OPTIONAL ).
            WHEN 'STOCK_HKONT'.
*              mr_stock_hkont = VALUE #( condition-range[ 1 ]-low OPTIONAL ).
              mr_stock_hkont = VALUE #( FOR ls IN condition-range ( sign   = ls-sign
                                                                    option = ls-option
                                                                    low    = ls-low
                                                                    high   = ls-high ) ).
              SORT mr_stock_hkont ASCENDING BY low high.
              DELETE ADJACENT DUPLICATES FROM mr_stock_hkont.
          ENDCASE.
        ENDLOOP.
      CATCH cx_rap_query_filter_no_range.
        "handle exception
    ENDTRY.
  ENDMETHOD.