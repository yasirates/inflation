  METHOD set_data.
    DATA total_number_of_records TYPE int8.
    DATA lt_main_data TYPE TABLE OF zinf_custom_stock_trans_speed.

    DATA(top)               = io_request->get_paging( )->get_page_size( ).
    DATA(skip)              = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields)  = io_request->get_requested_elements( ).
    DATA(sort_order)        = io_request->get_sort_elements( ).

    DATA(start) = skip + 1.
    DATA(end)   = top + skip.

    LOOP AT mt_display_data ASSIGNING FIELD-SYMBOL(<lfs_main_data>) FROM start TO end.
      APPEND <lfs_main_data> TO lt_main_data.
    ENDLOOP.

    TRY.
        io_response->set_data( lt_main_data ).

        IF io_request->is_total_numb_of_rec_requested( ).
          total_number_of_records = lines( lt_main_data ).
          io_response->set_total_number_of_records( total_number_of_records ).
        ENDIF.
      CATCH cx_root INTO DATA(exception).

*        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
*        DATA(exception_t100_key) = cl_message_helper=>get_latest_t100_exception( exception )->t100key.
        DATA(exception_t100_key) = if_t100_message~t100key.

        RAISE EXCEPTION TYPE zcl_custom_stock_trans_speed
          EXPORTING
            textid   = VALUE scx_t100key( msgid = exception_t100_key-msgid
                                          msgno = exception_t100_key-msgno
                                          attr1 = exception_t100_key-attr1
                                          attr2 = exception_t100_key-attr2
                                          attr3 = exception_t100_key-attr3
                                          attr4 = exception_t100_key-attr4 )
            previous = exception.
    ENDTRY.


*    IF io_request->is_total_numb_of_rec_requested(  ).
*      total_number_of_records = lines( mt_display_data ).
*      io_response->set_total_number_of_records( total_number_of_records ).
*    ENDIF.

  ENDMETHOD.