  METHOD if_rap_query_provider~select.

    mo_regulative_common =  NEW #( ).

    me->get_filter_parameter( io_request = io_request ).

    me->get_data( ).

    me->process_data(  ).

    me->set_data(
      io_request  = io_request
      io_response = io_response
    ).

  ENDMETHOD.