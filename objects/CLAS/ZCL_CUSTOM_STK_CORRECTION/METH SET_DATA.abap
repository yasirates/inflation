  METHOD set_data.
    DATA: total_number_of_records TYPE int8,
*          lo_root_filter_node     TYPE REF TO /iwbep/if_cp_filter_node,
          lt_main_data            TYPE TABLE OF zinf_t002.

*    DATA(lv_page)           = io_request->get_paging( ).
    DATA(top)               = io_request->get_paging( )->get_page_size( ).
    DATA(skip)              = io_request->get_paging( )->get_offset( ).
*    DATA(sort_order)        = io_request->get_sort_elements( ).

    DATA(start) = skip + 1.
    DATA(end)   = top + skip.

    LOOP AT mt_log ASSIGNING FIELD-SYMBOL(<lfs_log>) FROM start TO end.
      APPEND <lfs_log> TO lt_main_data.
    ENDLOOP.

    TRY.
*        SORT lt_main_data ASCENDING BY hkont endex_date.
        io_response->set_data( lt_main_data ).
        IF io_request->is_total_numb_of_rec_requested( ).
          total_number_of_records = lines( mt_log ).
          io_response->set_total_number_of_records( total_number_of_records ).
        ENDIF.
*        LOOP AT mt_main_data ASSIGNING <lfs_main_data>.
*          <lfs_main_data>-hkont = |{ <lfs_main_data>-hkont ALPHA = IN }|.
*        ENDLOOP.
*        MODIFY zinf_t008 FROM TABLE @mt_main_data.

      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
    ENDTRY.
  ENDMETHOD.