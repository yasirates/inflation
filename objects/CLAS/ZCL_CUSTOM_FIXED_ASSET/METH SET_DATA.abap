  METHOD set_data.
    DATA: total_number_of_records TYPE int8.
    DATA lt_out_data TYPE TABLE OF zinf_custom_fixed_asset.

    DATA(lo_page)  = io_request->get_paging( ).
    DATA(top)      = io_request->get_paging( )->get_page_size( ).
    DATA(skip)     = io_request->get_paging( )->get_offset( ).
*
    DATA(start) = skip + 1.
    DATA(end)   = top + skip.

    LOOP AT mt_out_data ASSIGNING FIELD-SYMBOL(<lfs_out_data>) FROM start TO end.
      APPEND <lfs_out_data> TO lt_out_data.
    ENDLOOP.
*
    TRY.
        IF io_request->is_total_numb_of_rec_requested( ).
          total_number_of_records = lines( lt_out_data ).
          io_response->set_total_number_of_records( total_number_of_records ).
        ENDIF.
        io_response->set_data( lt_out_data ).

      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
    ENDTRY.

  ENDMETHOD.