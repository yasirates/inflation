  METHOD get_service_info.
    SELECT *
      FROM zinf_users
     WHERE service_id EQ @iv_service_id
      INTO TABLE @mt_users.
  ENDMETHOD.