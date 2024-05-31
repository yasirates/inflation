  METHOD get_service_info.
    SELECT *
      FROM zinf_users
     WHERE service_id EQ '01'
      INTO TABLE @mt_users.
  ENDMETHOD.