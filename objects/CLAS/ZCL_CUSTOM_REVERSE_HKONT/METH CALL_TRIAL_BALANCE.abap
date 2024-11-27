  METHOD call_trial_balance.
    CLEAR mt_account_balances.

    zinf_trial_balance_service=>trigger_trial_balance_service3(
      EXPORTING
        iv_company_code = iv_bukrs
        iv_ledger       = iv_rldnr
        iv_gjahr        = iv_fyear
        iv_begda        = iv_begda
        iv_endda        = iv_endda
        iv_hkont        = iv_hkont
        it_hkont        = it_hkont
      RECEIVING
        rt_balance      = mt_account_balances
    ).

    IF it_hkont IS INITIAL.
      READ TABLE mt_account_balances ASSIGNING FIELD-SYMBOL(<lfs_account_balance>) WITH KEY fis_period = iv_fmonth.
      IF sy-subrc IS INITIAL.
        ev_balance = <lfs_account_balance>-balance.
      ENDIF.
    ELSE.
      et_balance = mt_account_balances.
    ENDIF.

    "- Yıl bazında collect edilir.
    LOOP AT mt_account_balances ASSIGNING <lfs_account_balance> ."WHERE fisc_year   LE iv_index_date(4) AND fis_period  LT iv_index_date+4(2).

      DATA(lv_spmon) = <lfs_account_balance>-fisc_year && <lfs_account_balance>-fis_period.
      CHECK lv_spmon <= iv_index_date(6).
      ms_sum_balance = VALUE #( "fisc_year  = <lfs_account_balance>-fisc_year
                                 debits_per = <lfs_account_balance>-debits_per
                                 credit_per = <lfs_account_balance>-credit_per
                                 gl_account = <lfs_account_balance>-gl_account
                                 balance    = <lfs_account_balance>-balance ).

      COLLECT ms_sum_balance INTO et_sum_balance. CLEAR ms_sum_balance.
    ENDLOOP.
    et_balance = mt_account_balances.
  ENDMETHOD.