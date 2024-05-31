  METHOD cumulative_data.
    DATA lv_hkont TYPE hkont.
    DATA: lv_balance_stock TYPE zinf_e_dmbtr.
    "- daha önce değerlenen bir dönem varsa ilgili hesaba göre kümülatif bakiye alınır  !
    LOOP AT mt_log INTO DATA(wa_log) WHERE bukrs = is_deger-bukrs
                                       AND hkont = is_deger-hkont
                                       AND rldnr = is_deger-rldnr
                                       AND budat = iv_edate.

      ms_main_data            = CORRESPONDING #( wa_log ).

      IF lv_hkont NE is_deger-hkont.
        DATA(lv_uuid) = cl_system_uuid=>create_uuid_c36_static( ).
      ENDIF.

      lv_hkont = is_deger-hkont.

      ms_main_data-uuid       = lv_uuid.
      ms_main_data-endex_date = mv_prev_date.
      ms_main_data-budat      = mv_budat.
*      lv_balance_stock        = wa_log-dmbtr.

      ms_main_data-prev_date  = mv_prev_date.


      CLEAR ms_main_data-factor.
      IF ms_rate_table2 IS NOT INITIAL AND ms_rate_table2-bank_rate IS NOT INITIAL.
        "ms_main_data-factor = ms_rate_table1-bank_rate / ms_rate_table2-bank_rate.
        ms_main_data-factor =  ms_rate_table2-bank_rate / ms_rate_table1-bank_rate.
        CONDENSE ms_main_data-factor NO-GAPS.
      ENDIF.

      CLEAR ms_main_data-dmbtr.
      ms_main_data-dmbtr            = ms_main_data-endex_balance.
      ms_main_data-endex_balance    = ms_main_data-factor * ms_main_data-dmbtr.

      IF ms_main_data-endex_balance IS NOT INITIAL.
        ms_main_data-correct_balance = ms_main_data-endex_balance - ms_main_data-dmbtr.
      ENDIF.

      ms_main_data-budat = iv_budat.

      CLEAR : ms_main_data-belnr,
              ms_main_data-gjahr,
              ms_main_data-rev_belnr,
              ms_main_data-rev_gjahr.

      COLLECT ms_main_data INTO mt_main_data.
    ENDLOOP.
  ENDMETHOD.