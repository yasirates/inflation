  METHOD process_data.
    DATA lv_date2 TYPE datum.

    LOOP AT mt_stock INTO DATA(ls_stock).
      ms_hkont = ls_stock-stock_hkont.
      APPEND ms_hkont TO mt_hkont. CLEAR ms_hkont.

*      ms_hkont = ls_stock-discount_hkont.
*      APPEND ms_hkont TO mt_hkont. CLEAR ms_hkont.
    ENDLOOP.

    IF mt_hkont IS NOT INITIAL.
      DATA lv_beg_spmon TYPE fins_fyearperiod VALUE '2005001'.
      zinf_trial_balance_service=>trigger_trial_balance_service2(
        EXPORTING
          iv_company_code = mv_company_code
          iv_ledger       = mv_rldnr
          it_hkont        = mt_hkont
          iv_beg_spmon    = CONV #( lv_beg_spmon )
          iv_end_spmon    = CONV #( mv_period )
        RECEIVING
          rt_balance      = mt_account_balances
      ).
    ENDIF.

    LOOP AT mt_stock INTO ls_stock.
      CLEAR : lv_date2 .

      TRY.
          ms_log-uuid             = cl_system_uuid=>create_uuid_c36_static( ).
        CATCH cx_uuid_error.
          "handle exception
      ENDTRY.

      ms_log-bukrs            = mv_company_code.
*      ms_log-waers               = gv_waers.
      ms_log-rspmon           = mv_period.
      ms_log-rldnr            = mv_rldnr.
      ms_log-rtype            = mv_rtype.
      ms_log-index_rate       = ms_bank_report-bank_rate.
      ms_log-blart            = ls_stock-blart.
      ms_log-acc_principle    = ls_stock-acc_principle.
      ms_log-stock_hkont      = ls_stock-stock_hkont.
      ms_log-correct_hkont_bs = ls_stock-correct_hkont_bs.
      ms_log-correct_hkont_pl = ls_stock-correct_hkont_pl.


      READ TABLE mt_stspe INTO DATA(ls_stspe) WITH KEY bukrs    = ms_log-bukrs
                                                       rspmon   = ms_log-rspmon
                                                       acc_type = ls_stock-acc_type .
      IF sy-subrc IS INITIAL.
        lv_date2 = |{  ls_stspe-stock_trans_speed_m(4) }| & |{  ls_stspe-stock_trans_speed_m+5(2) }| & |01|.
        ms_log-stock_trans_speed_m = ls_stspe-stock_trans_speed_m.
        IF ls_stspe-acc_type IS NOT INITIAL.
          READ TABLE mt_acc_val INTO DATA(ls_acc_val) WITH KEY value_low = ls_stspe-acc_type.
          IF sy-subrc IS INITIAL.
            ms_log-ddtext = ls_acc_val-text.
          ENDIF.
        ENDIF.
      ELSE.
        READ TABLE mt_stspe INTO ls_stspe WITH KEY bukrs   = ms_log-bukrs
                                                  rspmon   = ms_log-rspmon
                                                  acc_type = space .
        IF sy-subrc EQ 0.
          lv_date2 = |{ ls_stspe-stock_trans_speed_m(4) }| & |{ ls_stspe-stock_trans_speed_m+5(2) }| & |01|.
          ms_log-stock_trans_speed_m = ls_stspe-stock_trans_speed_m .
        ENDIF.
      ENDIF.

      mo_regulative_common->rp_last_day_of_months(
        EXPORTING
          day_in            = lv_date2
        IMPORTING
          last_day_of_month = lv_date2
        EXCEPTIONS
          day_in_no_date    = 1
          OTHERS            = 2
      ).

      CLEAR ms_bank_trans.
      READ TABLE mt_t001 INTO ms_bank_trans WITH KEY rate_type = mv_rtype
                                                     budat     = lv_date2.
      CLEAR lv_date2.
      DATA: lv_year TYPE gjahr.
      IF mv_avarage_method EQ 'true' .
        CLEAR:lv_year,lv_date2.

        IF ( gv_date1+4(2) EQ '01' OR
          gv_date1+4(2) EQ '02' OR
          gv_date1+4(2) EQ '03' ).
          lv_year = gv_date1(4) - 1 .
          lv_date2 = lv_year && '12' && '31' .
        ELSEIF ( gv_date1+4(2) EQ '04' OR
                 gv_date1+4(2) EQ '05' OR
                 gv_date1+4(2) EQ '06' ).
          lv_date2 = gv_date1(4) && '03' && '31' .
        ELSEIF ( gv_date1+4(2) EQ '07' OR
                 gv_date1+4(2) EQ '08' OR
                 gv_date1+4(2) EQ '09' ).
          lv_date2 = gv_date1(4) && '06' && '30' .
        ELSE.
          lv_date2 = gv_date1(4) && '09' && '30' .
        ENDIF.

        ms_log-stock_trans_speed_m = lv_date2(4) && |0|  && lv_date2+4(2).

        CLEAR ms_bank_bort.
        READ TABLE mt_t001 INTO ms_bank_bort WITH KEY rate_type = mv_rtype
                                                        budat     = lv_date2.

        IF sy-subrc IS INITIAL.
          IF sy-subrc EQ 0.
            TRY.
                ms_log-factor = ms_bank_report-bank_rate / ( ( ms_bank_bort-bank_rate + ms_bank_report-bank_rate ) / 2 ) .
              CATCH cx_sy_zerodivide.
            ENDTRY.
          ENDIF.
          CLEAR lv_date2.
        ENDIF.
      ELSE.
        TRY.
            ms_log-factor              = ms_bank_report-bank_rate / ms_bank_trans-bank_rate.
          CATCH cx_sy_zerodivide.
        ENDTRY.
      ENDIF.

      READ TABLE mt_corr_log INTO DATA(ls_corr_log) WITH KEY bukrs       = ms_log-bukrs
                                                             stock_hkont = ms_log-stock_hkont
                                                             rspmon      = ms_log-rspmon
                                                             rldnr       = ms_log-rldnr BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        SELECT SINGLE *
                 FROM i_journalentry
                 WHERE companycode        = @ls_corr_log-bukrs
                   AND accountingdocument = @ls_corr_log-belnr
                   AND fiscalyear         = @ls_corr_log-gjahr
                   INTO @DATA(ls_journalentry).

        IF sy-subrc EQ 0 AND ls_journalentry-ReverseDocument IS INITIAL.
          ms_log-belnr     = ls_corr_log-belnr.
          ms_log-gjahr     = ls_corr_log-gjahr.
        ENDIF.
      ENDIF.

      READ TABLE mt_skat INTO DATA(ls_skat) WITH KEY GLAccount = ms_log-stock_hkont BINARY SEARCH.
      IF sy-subrc EQ 0.
        ms_log-txt50 = ls_skat-GLAccountLongName.
      ENDIF.

      DATA lv_stock_hkont TYPE hkont.
      lv_stock_hkont = |{ ls_stock-stock_hkont ALPHA = OUT }|.
      DATA(lv_stock_balance) = REDUCE bapicurr_d( INIT x = 0 FOR ls_balance IN mt_account_balances
                                                           WHERE ( gl_account EQ lv_stock_hkont )
                                                           NEXT x = x + ls_balance-balance ).

      ms_log-stock_balance = lv_stock_balance.
      ms_log-endex_balance = ms_log-stock_balance * ms_log-factor.
      ms_log-total_amount = ms_log-stock_balance * ms_log-factor.

      IF ms_log-endex_balance NE 0 .
        ms_log-correct_balance = ms_log-endex_balance - ms_log-stock_balance.
      ENDIF.

      IF ms_log-endex_balance IS INITIAL.
        CLEAR ms_log.
        CONTINUE.
      ENDIF.

      IF ms_log-endex_balance < 0 OR ms_log-factor < 1.
        ms_log-endex_balance = ms_log-endex_balance * -1.
      ENDIF.

      IF ms_log-correct_balance < 0 OR ms_log-factor < 1.
        ms_log-correct_balance = ms_log-correct_balance * -1.
      ENDIF.

      IF ms_log-total_amount < 0 OR ms_log-factor < 1.
        ms_log-total_amount = ms_log-total_amount * -1.
      ENDIF.

      IF ms_log-stock_balance < 0 OR ms_log-factor < 1.
        ms_log-stock_balance = ms_log-stock_balance * -1.
      ENDIF.

      APPEND ms_log TO mt_log. CLEAR ms_log.
    ENDLOOP.

    IF mt_log IS NOT INITIAL.
      MODIFY zinf_t002 FROM TABLE @mt_log.
    ENDIF.
  ENDMETHOD.