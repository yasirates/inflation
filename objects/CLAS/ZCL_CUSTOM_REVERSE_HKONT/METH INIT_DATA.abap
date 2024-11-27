  METHOD init_data.
    mo_regulative_common->rp_last_day_of_months(
      EXPORTING
        day_in            = iv_budat
      IMPORTING
        last_day_of_month = mv_budat
      EXCEPTIONS
        day_in_no_date    = 1
        OTHERS            = 2
    ).

    mo_regulative_common->rp_last_day_of_months(
      EXPORTING
        day_in            = iv_prev_date
      IMPORTING
        last_day_of_month = mv_prev_date
      EXCEPTIONS
        day_in_no_date    = 1
        OTHERS            = 2
    ).

    READ TABLE mt_rate_table INTO ms_rate_table1 WITH KEY rate_type = iv_rtype
                                                          budat     = mv_prev_date.

    READ TABLE mt_rate_table INTO ms_rate_table2 WITH KEY rate_type = iv_rtype
                                                          budat     = mv_budat.
  ENDMETHOD.