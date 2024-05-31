  METHOD call_trial_balance.

    CLEAR mt_account_balance.
    zinf_trial_balance_service=>trigger_trial_balance_service(
      EXPORTING
        iv_company_code = iv_bukrs
        iv_ledger       = iv_rldnr
        iv_gjahr        = iv_fyear
        iv_hkont        = iv_hkont
        it_hkont        = it_hkont
      RECEIVING
        rt_balance      = mt_account_balance
    ).

    IF it_hkont IS INITIAL.
      READ TABLE mt_account_balance ASSIGNING FIELD-SYMBOL(<lfs_account_balance>) WITH KEY fis_period = iv_fmonth.
      IF sy-subrc IS INITIAL.
        ev_balance = <lfs_account_balance>-balance.
      ENDIF.
    ELSE.
      et_balance = mt_account_balance.
    ENDIF.

  ENDMETHOD.