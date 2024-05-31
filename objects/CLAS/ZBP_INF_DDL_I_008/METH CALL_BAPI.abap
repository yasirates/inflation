  METHOD call_bapi.

    CLEAR mt_account_balances.
    zinf_trial_balance_service=>trigger_trial_balance_service(
      EXPORTING
        iv_company_code = iv_bukrs
        iv_ledger       = iv_rldnr
        iv_gjahr        = iv_fyear
      RECEIVING
        rt_balance      = mt_account_balances
    ).

    READ TABLE mt_account_balances INTO DATA(account_balance) WITH KEY fis_period = iv_fmonth.
    IF sy-subrc IS INITIAL.
      ev_balance = account_balance-balance.
    ENDIF.

  ENDMETHOD.