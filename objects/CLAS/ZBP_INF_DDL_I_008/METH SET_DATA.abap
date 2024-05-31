  METHOD set_data.
    DATA total_number_of_records TYPE int8.
    DATA lo_root_filter_node TYPE REF TO /iwbep/if_cp_filter_node.

    DATA(top)               = io_request->get_paging( )->get_page_size( ).
    DATA(skip)              = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields)  = io_request->get_requested_elements( ).
    DATA(sort_order)        = io_request->get_sort_elements( ).

    TRY.
        io_response->set_data( mt_main_data ).
        IF io_request->is_total_numb_of_rec_requested( ).
          total_number_of_records = lines( mt_main_data ).
          io_response->set_total_number_of_records( total_number_of_records ).
        ENDIF.
      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
    ENDTRY.
  ENDMETHOD.