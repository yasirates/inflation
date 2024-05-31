  METHOD fill_trial_balance.
    DATA: lv_balance_stock TYPE zinf_e_dmbtr.

    DATA(lv_hkont) = shift_left( val = is_deger-hkont sub = '0' ).

    "- geçmiş yıllara ait bakiyelerin yıl bazlı toplamları yazılır.
    IF iv_cancel_old_balance EQ abap_false.
      LOOP AT it_sum_balance INTO DATA(ls_sum_balance) WHERE gl_account EQ lv_hkont. "fisc_year < iv_fyear.
        CLEAR lv_balance_stock.
        ms_main_data-uuid             = cl_system_uuid=>create_uuid_c36_static( ).
        ms_main_data-bukrs            = iv_bukrs.
        ms_main_data-budat            = iv_budat.
        ms_main_data-rldnr            = iv_rldnr.
        ms_main_data-hkont            = shift_left( val = is_deger-hkont sub = '0' ).
        ms_main_data-blart            = is_deger-blart.
        ms_main_data-acc_principle    = is_deger-acc_principle.
        ms_main_data-correct_hkont_bs = is_deger-correct_hkont_bs.
        ms_main_data-correct_hkont_pl = is_deger-correct_hkont_pl.
        ms_main_data-txt50            = VALUE #( mt_skat[ GLAccount = is_deger-hkont ]-GLAccountLongName OPTIONAL ).

        lv_balance_stock = ls_sum_balance-balance.

        ms_main_data-endex_date =  ms_main_data-prev_date = mv_prev_date.

        IF ms_rate_table2 IS NOT INITIAL AND ms_rate_table2-bank_rate IS NOT INITIAL.
          "ms_main_data-factor = ms_rate_table1-bank_rate / ms_rate_table2-bank_rate.
          ms_main_data-factor =  ms_rate_table2-bank_rate / ms_rate_table1-bank_rate.
*          ms_main_data-factor = round( val = ms_main_data-factor dec = '1' ).
          CONDENSE ms_main_data-factor NO-GAPS.

        ENDIF.

        ms_main_data-dmbtr            = lv_balance_stock.
        ms_main_data-endex_balance    = ms_main_data-factor * ms_main_data-dmbtr.

        IF ms_main_data-endex_balance IS NOT INITIAL.
          ms_main_data-correct_balance = ms_main_data-endex_balance - ms_main_data-dmbtr.
        ENDIF.

        APPEND ms_main_data TO mt_main_data. CLEAR ms_main_data.
      ENDLOOP.
    ENDIF.

    "- iv_prev_date ile lv_index_date arasında ki bakiyeler -> INDEX TARIHI ekrandaki Değerleme Tarihini ifade ediyor.
    "DATA(lv_index_date) = mo_regulative_common->month_plus_determine( months = '-1' olddate = iv_budat ).

    " - burası -1 olacak
    DATA(lv_index_date) = mo_regulative_common->month_plus_determine( months = '-1' olddate = mv_budat ).

    WHILE iv_prev_date < lv_index_date.

      LOOP AT it_balance INTO DATA(ls_balance) WHERE gl_account EQ lv_hkont
*                                                 AND fisc_year  EQ iv_fyear
                                                 AND fisc_year  EQ lv_index_date(4)
                                                 AND fis_period EQ lv_index_date+4(2).

        CLEAR lv_balance_stock.
        ms_main_data-uuid = cl_system_uuid=>create_uuid_c36_static( ).
        ms_main_data-bukrs            = iv_bukrs.
        ms_main_data-budat            = iv_budat.
        ms_main_data-rldnr            = iv_rldnr.
        ms_main_data-hkont            = ls_balance-gl_account.
        ms_main_data-blart            = is_deger-blart.
        ms_main_data-acc_principle    = is_deger-acc_principle.
        ms_main_data-correct_hkont_bs = is_deger-correct_hkont_bs.
        ms_main_data-correct_hkont_pl = is_deger-correct_hkont_pl.
        ms_main_data-txt50            = VALUE #( mt_skat[ GLAccount = is_deger-hkont ]-GLAccountLongName OPTIONAL ).

        lv_balance_stock = ls_balance-balance.

        ms_main_data-prev_date = mv_prev_date.

        "-gerçek endeks tarihi ile okunan rate
        DATA(lv_date2) = lv_index_date.
        mo_regulative_common->rp_last_day_of_months(
          EXPORTING
            day_in            = lv_date2
          IMPORTING
            last_day_of_month = lv_date2
          EXCEPTIONS
            day_in_no_date    = 1
            OTHERS            = 2
        ).

        "-gerçek endeks tarihi
        ms_main_data-endex_date = lv_date2.
        READ TABLE mt_rate_table INTO DATA(ls_rate2) WITH KEY rate_type = iv_rtype
                                                              budat     = lv_date2.

        IF ls_rate2 IS NOT INITIAL AND ls_rate2-bank_rate IS NOT INITIAL.
          "ms_main_data-factor = ms_rate_table1-bank_rate / ls_rate2-bank_rate.
*          ms_main_data-factor =  ls_rate2-bank_rate / ms_rate_table1-bank_rate.

          " -Değerleme tarihine ait index / Gerçek index tarihine ait index
          ms_main_data-factor =  ms_rate_table2-bank_rate / ls_rate2-bank_rate.
*          ms_main_data-factor = round( val = ms_main_data-factor dec = '1' ).
          CONDENSE ms_main_data-factor NO-GAPS.
        ENDIF.

        ms_main_data-dmbtr            = lv_balance_stock.
        ms_main_data-endex_balance    = ms_main_data-factor * ms_main_data-dmbtr.

        IF ms_main_data-endex_balance IS NOT INITIAL.
          ms_main_data-correct_balance = ms_main_data-endex_balance - ms_main_data-dmbtr.
        ENDIF.

        APPEND ms_main_data TO mt_main_data. CLEAR ms_main_data.
      ENDLOOP.

      lv_index_date = mo_regulative_common->month_plus_determine( months = '-1' olddate = lv_index_date ).

      mo_regulative_common->rp_last_day_of_months(
        EXPORTING
          day_in            = lv_index_date
        IMPORTING
          last_day_of_month = lv_index_date
        EXCEPTIONS
          day_in_no_date    = 1
          OTHERS            = 2
      ).
    ENDWHILE.

    "- İlk değerleme sonrası -> endeks tarihine ait trial balance satırını ekleme.
    DATA(lv_hkont2) = |{ is_deger-hkont ALPHA = IN }|.
    READ TABLE mt_log INTO DATA(wa_log) WITH KEY hkont = lv_hkont2.
    IF wa_log-belnr IS NOT INITIAL.
      CLEAR ls_balance.
      READ TABLE it_balance INTO ls_balance WITH KEY gl_account = lv_hkont
                                                     fisc_year  = iv_prev_date(4)
                                                     fis_period = iv_prev_date+4(2).
      CHECK sy-subrc IS INITIAL.
      CLEAR lv_balance_stock.
      ms_main_data-uuid = cl_system_uuid=>create_uuid_c36_static( ).
      ms_main_data-bukrs            = iv_bukrs.
      ms_main_data-budat            = iv_budat.
      ms_main_data-rldnr            = iv_rldnr.
      ms_main_data-hkont            = ls_balance-gl_account.
      ms_main_data-blart            = is_deger-blart.
      ms_main_data-acc_principle    = is_deger-acc_principle.
      ms_main_data-correct_hkont_bs = is_deger-correct_hkont_bs.
      ms_main_data-correct_hkont_pl = is_deger-correct_hkont_pl.
      ms_main_data-txt50            = VALUE #( mt_skat[ GLAccount = is_deger-hkont ]-GLAccountLongName OPTIONAL ).

      lv_balance_stock = ls_balance-balance.

      ms_main_data-prev_date = mv_prev_date.

      "-gerçek endeks tarihi ile okunan rate
      CLEAR lv_date2.
      lv_date2 = lv_index_date.
      mo_regulative_common->rp_last_day_of_months(
        EXPORTING
          day_in            = lv_date2
        IMPORTING
          last_day_of_month = lv_date2
        EXCEPTIONS
          day_in_no_date    = 1
          OTHERS            = 2
      ).

      "-gerçek endeks tarihi
      ms_main_data-endex_date = lv_date2.
      CLEAR ls_rate2.
      READ TABLE mt_rate_table INTO ls_rate2 WITH KEY rate_type = iv_rtype
                                                      budat     = lv_date2.

      IF ls_rate2 IS NOT INITIAL AND ls_rate2-bank_rate IS NOT INITIAL.
        "ms_main_data-factor = ms_rate_table1-bank_rate / ls_rate2-bank_rate.
*          ms_main_data-factor =  ls_rate2-bank_rate / ms_rate_table1-bank_rate.

        " -Değerleme tarihine ait index / Gerçek index tarihine ait index
        ms_main_data-factor =  ms_rate_table2-bank_rate / ls_rate2-bank_rate.
*        ms_main_data-factor = round( val = ms_main_data-factor dec = '1' ).
        CONDENSE ms_main_data-factor NO-GAPS.
      ENDIF.

      ms_main_data-dmbtr            = lv_balance_stock.
      ms_main_data-endex_balance    = ms_main_data-factor * ms_main_data-dmbtr.

      IF ms_main_data-endex_balance IS NOT INITIAL.
        ms_main_data-correct_balance = ms_main_data-endex_balance - ms_main_data-dmbtr.
      ENDIF.

      APPEND ms_main_data TO mt_main_data. CLEAR ms_main_data.

    ENDIF.

*
    lv_hkont = |{ is_deger-hkont ALPHA = IN }|.
    LOOP AT mt_t026 INTO DATA(ls_026) WHERE hkont EQ lv_hkont.

      CLEAR lv_balance_stock.
      ms_main_data-uuid = cl_system_uuid=>create_uuid_c36_static( ).
      ms_main_data-bukrs            = iv_bukrs.
      ms_main_data-budat            = iv_budat.
      ms_main_data-rldnr            = iv_rldnr.
      ms_main_data-hkont            = ls_026-hkont.
      ms_main_data-blart            = is_deger-blart.
      ms_main_data-acc_principle    = is_deger-acc_principle.
      ms_main_data-correct_hkont_bs = is_deger-correct_hkont_bs.
      ms_main_data-correct_hkont_pl = is_deger-correct_hkont_pl.
      ms_main_data-txt50            = VALUE #( mt_skat[ GLAccount = is_deger-hkont ]-GLAccountLongName OPTIONAL ).

      lv_balance_stock = ls_026-balance_amount.

      ms_main_data-prev_date = mv_prev_date.

      "-gerçek endeks tarihi ile okunan rate
      lv_date2 = lv_index_date.
      mo_regulative_common->rp_last_day_of_months(
        EXPORTING
          day_in            = lv_date2
        IMPORTING
          last_day_of_month = lv_date2
        EXCEPTIONS
          day_in_no_date    = 1
          OTHERS            = 2
      ).

      "-gerçek endeks tarihi
      ms_main_data-endex_date = lv_date2.
      CLEAR ls_rate2.
      READ TABLE mt_rate_table INTO ls_rate2 WITH KEY rate_type = iv_rtype
                                                      budat     = lv_date2.

      IF ls_rate2 IS NOT INITIAL AND ls_rate2-bank_rate IS NOT INITIAL.
        "ms_main_data-factor = ms_rate_table1-bank_rate / ls_rate2-bank_rate.
*          ms_main_data-factor =  ls_rate2-bank_rate / ms_rate_table1-bank_rate.

        " -Değerleme tarihine ait index / Gerçek index tarihine ait index
        ms_main_data-factor =  ms_rate_table2-bank_rate / ls_rate2-bank_rate.
        ms_main_data-factor = round( val = ms_main_data-factor dec = '1' ).
        CONDENSE ms_main_data-factor NO-GAPS.
      ENDIF.

      ms_main_data-dmbtr            = lv_balance_stock.
      ms_main_data-endex_balance    = ms_main_data-factor * ms_main_data-dmbtr.

      IF ms_main_data-endex_balance IS NOT INITIAL.
        ms_main_data-correct_balance = ms_main_data-endex_balance - ms_main_data-dmbtr.
      ENDIF.

      APPEND ms_main_data TO mt_main_data. CLEAR ms_main_data.
    ENDLOOP.
  ENDMETHOD.