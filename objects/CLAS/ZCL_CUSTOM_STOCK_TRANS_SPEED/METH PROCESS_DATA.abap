  METHOD process_data.

    DATA: lv_balance_stock    TYPE bapicurr_d,
          lv_balance_discount TYPE bapicurr_d,
          lv_report_stock     TYPE bapicurr_d,
          lv_check_stock      TYPE bapicurr_d,
          lv_balance_cost     TYPE bapicurr_d.

    DATA(lv_rspmon) = iv_rspmon(4) && iv_rspmon+5(2).
    DATA(lv_cspmon) = iv_cspmon(4) && iv_cspmon+5(2).

    DATA: lv_date1 TYPE datum,
          lv_date2 TYPE datum,
          lv_date3 TYPE datum.


    lv_date1 = |{ lv_rspmon(6) }| & |01|.
    lv_date2 = |{ lv_cspmon(6) }| & |01|.
*
    mo_regulative_common->rp_last_day_of_months(
      EXPORTING
        day_in            = lv_date1
      IMPORTING
        last_day_of_month = lv_date1
      EXCEPTIONS
        day_in_no_date    = 1
        OTHERS            = 2
    ).
*
    mo_regulative_common->rp_last_day_of_months(
      EXPORTING
        day_in            = lv_date2
      IMPORTING
        last_day_of_month = lv_date2
      EXCEPTIONS
        day_in_no_date    = 1
        OTHERS            = 2
    ).

    APPEND INITIAL LINE TO mt_business_data ASSIGNING FIELD-SYMBOL(<lfs_business_data>).

    <lfs_business_data> = VALUE #( bukrs  = iv_bukrs
                                   waers  = mv_waers
                                   rspmon = iv_rspmon
                                   cspmon = iv_cspmon ).

    LOOP AT mt_stock ASSIGNING FIELD-SYMBOL(<lfs_stock>).
      IF <lfs_stock>-stock_hkont IS NOT INITIAL.
        ms_hkont = <lfs_stock>-stock_hkont.
        APPEND ms_hkont TO mt_hkont. CLEAR ms_hkont.
      ENDIF.
      IF  <lfs_stock>-discount_hkont IS NOT INITIAL.
        ms_hkont = <lfs_stock>-discount_hkont.
        APPEND ms_hkont TO mt_hkont. CLEAR ms_hkont.
      ENDIF.
    ENDLOOP.

    DATA lv_beg_spmon TYPE fins_fyearperiod VALUE '2005001'.
    zinf_trial_balance_service=>trigger_trial_balance_service2(
      EXPORTING
        iv_company_code = iv_bukrs
        iv_ledger       = iv_rldnr
        it_hkont        = mt_hkont
*       iv_beg_spmon    = CONV #( iv_cspmon )
        iv_beg_spmon    = CONV #( lv_beg_spmon )
        iv_end_spmon    = CONV #( iv_rspmon )
      RECEIVING
        rt_balance      = mt_stock_balance
    ).

    DATA lv_rspmon_stock_total TYPE  bapicurr_d.
    DATA lv_cspmon_stock_total TYPE  bapicurr_d.

    LOOP AT mt_stock_balance INTO DATA(ls_stock_balance).
      IF ls_stock_balance-fisc_year  LE iv_rspmon(4) AND
         ls_stock_balance-fis_period LE iv_rspmon+5(2).
        lv_rspmon_stock_total += ls_stock_balance-balance.
      ENDIF.

      IF ls_stock_balance-fisc_year  LE iv_cspmon(4) AND
         ls_stock_balance-fis_period LE iv_cspmon+5(2).
        lv_cspmon_stock_total += ls_stock_balance-balance.
      ENDIF.
    ENDLOOP.

    <lfs_business_data>-stock_balance = ( lv_rspmon_stock_total + lv_cspmon_stock_total ) / 2.

    CLEAR : mt_hkont , ms_hkont.
    LOOP AT mt_cost ASSIGNING FIELD-SYMBOL(<lfs_cost>) WHERE cost_hkont IS NOT INITIAL.
      ms_hkont = <lfs_cost>-cost_hkont.
      APPEND ms_hkont TO mt_hkont. CLEAR ms_hkont.
    ENDLOOP.

    zinf_trial_balance_service=>trigger_trial_balance_service2(
      EXPORTING
        iv_company_code = iv_bukrs
        iv_ledger       = iv_rldnr
        it_hkont        = mt_hkont
        iv_beg_spmon    = CONV #( lv_beg_spmon )
        iv_end_spmon    = CONV #( iv_rspmon )
      RECEIVING
        rt_balance      = mt_account_balance
    ).

    LOOP AT mt_cost ASSIGNING <lfs_cost>.
      DATA(lv_cost_hkont) = |{ <lfs_cost>-cost_hkont ALPHA = OUT }|.

      CONDENSE lv_cost_hkont NO-GAPS.
      LOOP AT mt_account_balance INTO DATA(ls_balance) WHERE gl_account EQ lv_cost_hkont
                                                       AND balance    NE 0.
        <lfs_business_data>-cost_balance += ls_balance-balance.
      ENDLOOP.
    ENDLOOP.

    IF <lfs_business_data>-cost_balance < 0.
      <lfs_business_data>-cost_balance  = <lfs_business_data>-cost_balance * -1.
    ENDIF.

    IF <lfs_business_data>-stock_balance IS NOT INITIAL.
      <lfs_business_data>-stock_trans_speed = <lfs_business_data>-cost_balance / <lfs_business_data>-stock_balance.
    ENDIF.

    IF <lfs_business_data>-stock_trans_speed IS NOT INITIAL.
      DATA(lv_date) = lv_date1 - lv_date2.
      <lfs_business_data>-stock_trans_speed_d = ( lv_date1 - lv_date2 ) / <lfs_business_data>-stock_trans_speed.
    ENDIF.

    "-
    mo_regulative_common->rp_last_day_of_months(
      EXPORTING
        day_in            = lv_date1
      IMPORTING
        last_day_of_month = lv_date1
      EXCEPTIONS
        day_in_no_date    = 1
        OTHERS            = 2
    ).

    lv_date3 = lv_date1 - <lfs_business_data>-stock_trans_speed_d.

    <lfs_business_data>-stock_trans_speed_m =  lv_date3(4) && '0' && lv_date3+4(2).

    MODIFY zinf_t013 FROM TABLE @mt_business_data.
    IF sy-subrc IS INITIAL.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

    LOOP AT mt_business_data ASSIGNING <lfs_business_data>.
      APPEND INITIAL LINE TO mt_display_data ASSIGNING FIELD-SYMBOL(<lfs_display_data>).
      <lfs_display_data> = CORRESPONDING #( <lfs_business_data> ).
      <lfs_display_data>-rldnr = iv_rldnr.
    ENDLOOP.
  ENDMETHOD.