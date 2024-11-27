  METHOD prepare_date.
    LOOP AT mr_index_date ASSIGNING FIELD-SYMBOL(<lfs_index_date>).
      mo_regulative_common->rp_last_day_of_months(
        EXPORTING
          day_in            = CONV #( <lfs_index_date>-low )
        IMPORTING
          last_day_of_month = DATA(last_day_of_month)
        EXCEPTIONS
          day_in_no_date    = 1
          OTHERS            = 2
      ).

      <lfs_index_date>-low = last_day_of_month.
    ENDLOOP.

    CLEAR last_day_of_month.
    LOOP AT mr_valuation_date ASSIGNING FIELD-SYMBOL(<lfs_valuation_date>).
      mo_regulative_common->rp_last_day_of_months(
        EXPORTING
          day_in            = CONV #( <lfs_valuation_date>-low )
        IMPORTING
          last_day_of_month = last_day_of_month
        EXCEPTIONS
          day_in_no_date    = 1
          OTHERS            = 2
      ).

      <lfs_valuation_date>-low = last_day_of_month.
    ENDLOOP.
  ENDMETHOD.