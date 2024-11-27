  METHOD set_data.
    DATA: total_number_of_records TYPE int8,
          lt_main_data            TYPE TABLE OF zinf_t008.


    DATA(lo_page)           = io_request->get_paging( ).
    DATA(top)               = io_request->get_paging( )->get_page_size( ).
    DATA(skip)              = io_request->get_paging( )->get_offset( ).
*
    DATA(start) = skip + 1.
    DATA(end)   = top + skip.

    DELETE mt_main_data WHERE correct_balance IS INITIAL.
    LOOP AT mt_main_data ASSIGNING FIELD-SYMBOL(<lfs_main_data>) FROM start TO end.
      APPEND <lfs_main_data> TO lt_main_data.
    ENDLOOP.
*
    TRY.
        IF io_request->is_total_numb_of_rec_requested( ).
          total_number_of_records = lines( mt_main_data ).
          io_response->set_total_number_of_records( total_number_of_records ).
        ENDIF.
        io_response->set_data( lt_main_data ).
        LOOP AT mt_main_data ASSIGNING <lfs_main_data>.
          <lfs_main_data>-hkont = |{ <lfs_main_data>-hkont ALPHA = IN }|.
        ENDLOOP.

        MODIFY zinf_t008 FROM TABLE @mt_main_data.

      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
    ENDTRY.
  ENDMETHOD.