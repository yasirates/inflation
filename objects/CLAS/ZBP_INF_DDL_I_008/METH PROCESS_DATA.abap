  METHOD process_data.

    DATA: lv_balance_stock TYPE zinf_e_dmbtr.

    LOOP AT mt_deger ASSIGNING FIELD-SYMBOL(<lfs_deger>).

      ms_main_data-bukrs            = iv_bukrs.
      ms_main_data-budat            = iv_budat.
      ms_main_data-rldnr            = iv_rldnr.
      ms_main_data-hkont            = <lfs_deger>-hkont.
      ms_main_data-blart            = <lfs_deger>-blart.
      ms_main_data-acc_principle    = <lfs_deger>-acc_principle.
      ms_main_data-correct_hkont_bs = <lfs_deger>-correct_hkont_bs.
      ms_main_data-correct_hkont_pl = <lfs_deger>-correct_hkont_pl.
      ms_main_data-txt50            = VALUE #( mt_skat[ GLAccount = <lfs_deger>-hkont ]-GLAccountLongName OPTIONAL ).

      DATA(wa_hval_l) = VALUE #( mt_hval_l[ bukrs = <lfs_deger>-bukrs
                                            hkont = <lfs_deger>-hkont
                                            rldnr = <lfs_deger>-rldnr ] OPTIONAL ).

      IF wa_hval_l IS NOT INITIAL.
        ms_main_data-belnr     = wa_hval_l-belnr.
        ms_main_data-gjahr     = wa_hval_l-gjahr.
        ms_main_data-rev_belnr = wa_hval_l-rev_belnr.
        ms_main_data-rev_gjahr = wa_hval_l-rev_gjahr.
      ENDIF.



      call_bapi(
        EXPORTING
          iv_hkont   = <lfs_deger>-hkont
          iv_fmonth  = iv_budat+4(2)
          iv_fyear   = iv_gjahr
          iv_rldnr   = iv_rldnr
          iv_bukrs   = iv_bukrs
        IMPORTING
          ev_balance = lv_balance_stock
      ).


      IF <lfs_deger>-statu EQ 'A' AND <lfs_deger>-source EQ '1'.
        SELECT _header~postingDate,
               _item~GLAccount,
               _item~ledgergllineitem,
               _item~amountincompanycodecurrency
          FROM i_journalentry AS _header INNER JOIN  i_journalentryitem AS _item ON _header~companycode        EQ _item~companycode
                                                                                AND _header~fiscalyear         EQ _item~fiscalyear
         WHERE _header~fiscalyear         EQ @iv_gjahr
           AND _header~companycode        EQ @iv_bukrs
           AND _item~glaccount            EQ @<lfs_deger>-hkont
           AND _item~sourceledger         EQ @iv_rldnr
           AND _header~PostingDate        LE @iv_budat
           AND ( _header~ReverseDocument  EQ '' OR ( _header~ReverseDocument NE '' AND _header~PostingDate GE @iv_budat ) )
           AND _item~chartofaccounts      EQ 'YCOA'
           AND _item~DebitCreditCode      EQ 'S'
         ORDER BY _item~ledgergllineitem   INTO TABLE @mt_dmbtr.

      ELSEIF <lfs_deger>-statu EQ 'P' AND <lfs_deger>-source EQ '1'.
        SELECT _header~postingDate,
               _item~glaccount,
               _item~ledgergllineitem,
               _item~amountincompanycodecurrency
          FROM i_journalentry AS _header INNER JOIN  i_journalentryitem AS _item ON _header~companycode        EQ _item~companycode
*                                                                                AND _header~accountingdocument EQ _item~accountingdocument
                                                                                AND _header~fiscalyear         EQ _item~fiscalyear
         WHERE _header~fiscalyear         EQ @iv_gjahr
           AND _header~companycode        EQ @iv_bukrs
           AND _header~accountingdocument EQ @<lfs_deger>-hkont
           AND _item~sourceledger         EQ @iv_rldnr
           AND _header~PostingDate        LE @iv_budat
           AND ( _header~ReverseDocument  EQ '' OR ( _header~ReverseDocument NE '' AND _header~PostingDate GE @iv_budat ) )
           AND _item~chartofaccounts      EQ 'YCOA'
           AND _item~DebitCreditCode      EQ 'H'
         ORDER BY _item~ledgergllineitem INTO TABLE @mt_dmbtr.

      ELSEIF <lfs_deger>-statu EQ 'A' AND <lfs_deger>-source EQ '2'.

        SELECT _header~postingDate,
               _item~glaccount,
               _item~ledgergllineitem,
               _item~amountincompanycodecurrency
        FROM i_journalentry AS _header INNER JOIN  i_journalentryitem AS _item ON _header~companycode        EQ _item~companycode
*                                                                              AND _header~accountingdocument EQ _item~accountingdocument
                                                                              AND _header~fiscalyear         EQ _item~fiscalyear
             WHERE _header~companycode        EQ @iv_bukrs
               AND _header~fiscalyear         EQ @iv_gjahr
               AND _header~accountingdocument EQ @<lfs_deger>-hkont
               AND _item~sourceledger         EQ @iv_rldnr
               AND _header~PostingDate        LE @iv_budat
               AND _item~chartofaccounts      EQ 'YCOA'
               AND _item~DebitCreditCode      EQ 'S'
             ORDER BY _item~ledgergllineitem INTO CORRESPONDING FIELDS OF TABLE @mt_dmbtr.

      ELSEIF <lfs_deger>-statu EQ 'P' AND <lfs_deger>-source EQ '2'.

        SELECT _header~postingDate,
               _item~glaccount,
               _item~ledgergllineitem,
               _item~amountincompanycodecurrency
        FROM i_journalentry AS _header INNER JOIN  i_journalentryitem AS _item ON _header~companycode        EQ _item~companycode
*                                                                             AND _header~accountingdocument EQ _item~accountingdocument
                                                                              AND _header~fiscalyear         EQ _item~fiscalyear
             WHERE _header~companycode        EQ @iv_bukrs
               AND _header~fiscalyear         EQ @iv_gjahr
               AND _header~accountingdocument EQ @<lfs_deger>-hkont
               AND _item~sourceledger         EQ @iv_rldnr
               AND _header~PostingDate        LE @iv_budat
               AND _item~chartofaccounts      EQ 'YCOA'
               AND _item~DebitCreditCode      EQ 'H'
             ORDER BY _item~ledgergllineitem INTO CORRESPONDING FIELDS OF TABLE @mt_dmbtr.

      ENDIF.

      SORT mt_dmbtr BY postingdate DESCENDING glaccount ledgergllineitem DESCENDING.

      LOOP AT mt_dmbtr ASSIGNING FIELD-SYMBOL(<lfs_dmbtr>).
        ms_main_data-devir_budat = <lfs_dmbtr>-postingdate.
        ms_main_data-devir_belnr = <lfs_dmbtr>-glaccount.
        ms_main_data-devir_buzei = <lfs_dmbtr>-ledgergllineitem.
        ms_main_data-endex_date = <lfs_dmbtr>-postingdate.

        mo_regulative_common->rp_last_day_of_months(
          EXPORTING
            day_in            = ms_main_data-endex_date
          IMPORTING
            last_day_of_month = ms_main_data-endex_date
          EXCEPTIONS
            day_in_no_date    = 1
            OTHERS            = 2
        ).
*
        DATA(lv_date1) = iv_budat.
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
        SELECT SINGLE *
          FROM zinf_t001
         WHERE rate_type EQ @iv_rtype
           AND budat     EQ @lv_date1
          INTO @DATA(ls_rate1).
*
        DATA(lv_date2) =   ms_main_data-endex_date.
        mo_regulative_common->rp_last_day_of_months(
          EXPORTING
            day_in            = lv_date2
          IMPORTING
            last_day_of_month = lv_date2
          EXCEPTIONS
            day_in_no_date    = 1
            OTHERS            = 2
        ).
*
        SELECT SINGLE *
          FROM zinf_t001
         WHERE rate_type EQ @iv_rtype
           AND budat     EQ @lv_date2
           INTO @DATA(ls_rate2).
*
        IF ls_rate2-bank_rate IS NOT INITIAL.
          ms_main_data-factor = ls_rate1-bank_rate / ls_rate2-bank_rate.
        ENDIF.

        CLEAR ls_rate2.
        <lfs_dmbtr>-amountincompanycodecurrency = abs( <lfs_dmbtr>-amountincompanycodecurrency ).
*
        SELECT SINGLE *
          FROM i_journalentry
         WHERE AccountingDocument EQ @ms_main_data-belnr
           AND SenderFiscalYear EQ @ms_main_data-gjahr
          INTO @DATA(ls_journalentry).

        IF sy-subrc IS INITIAL AND ls_journalentry-ReverseDocument IS NOT INITIAL.
          CLEAR:ms_main_data-belnr,ms_main_data-gjahr .
        ENDIF.

        "-
        SELECT SINGLE *
          FROM i_journalentry
         WHERE AccountingDocument EQ @ms_main_data-rev_belnr
           AND SenderFiscalYear EQ @ms_main_data-rev_gjahr
          INTO @ls_journalentry.

        IF sy-subrc EQ 0 AND ls_journalentry-ReverseDocument IS NOT INITIAL.
          CLEAR:ms_main_data-rev_belnr,ms_main_data-rev_gjahr .
        ENDIF.

        "-
        IF <lfs_dmbtr>-amountincompanycodecurrency < lv_balance_stock OR lv_balance_stock < 0.
          ms_main_data-dmbtr           = <lfs_dmbtr>-amountincompanycodecurrency .
          ms_main_data-endex_balance   = ms_main_data-factor * ms_main_data-dmbtr.

          IF ms_main_data-endex_balance IS NOT INITIAL.
            ms_main_data-correct_balance = ms_main_data-endex_balance - ms_main_data-dmbtr.
          ENDIF.

          lv_balance_stock = lv_balance_stock - <lfs_dmbtr>-amountincompanycodecurrency.
          APPEND ms_main_data TO mt_main_data.
          CLEAR:ms_main_data-factor,ms_main_data-endex_balance,ms_main_data-correct_balance.

        ELSE.
          ms_main_data-dmbtr           = lv_balance_stock.
          ms_main_data-endex_balance   = ms_main_data-factor * ms_main_data-dmbtr.
          IF ms_main_data-endex_balance IS NOT INITIAL.
            ms_main_data-correct_balance = ms_main_data-endex_balance - ms_main_data-dmbtr.
          ENDIF.
          lv_balance_stock = 0.
          APPEND ms_main_data TO mt_main_data.
          CLEAR:ms_main_data-factor,ms_main_data-endex_balance,ms_main_data-correct_balance.
          EXIT.
        ENDIF.
      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.