  METHOD json_deserialize.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = iv_json_data
      CHANGING
        data = rv_json_data
    ).
  ENDMETHOD.