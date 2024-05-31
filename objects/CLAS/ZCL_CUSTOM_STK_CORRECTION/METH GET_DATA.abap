  METHOD get_data.
    DATA : lv_date1 TYPE datum,
           lv_date2 TYPE datum.


    DELETE FROM zinf_t002 WHERE belnr IS INITIAL
                            AND gjahr IS INITIAL.

    SELECT * FROM zinf_t001
      INTO TABLE @mt_t001.

    CLEAR mt_stock.
    SELECT * FROM zinf_t007
         WHERE bukrs       EQ @mv_company_code
           AND rldnr       EQ @mv_rldnr
           AND stock_hkont IN @mr_stock_hkont
         INTO TABLE @mt_stock.

    SELECT SINGLE Currency, ChartOfAccounts
      FROM I_CompanyCode
     WHERE CompanyCode EQ @mv_company_code
      INTO @DATA(wa_companyode).

    SELECT *
      FROM ddcds_customer_domain_value_t( p_domain_name = 'ZNF_D_ACC_TYPE' )
      INTO TABLE @mt_acc_val.

    IF mt_stock IS NOT INITIAL.
      SELECT GLAccount, GLAccountLongName FROM i_glaccounttext
         FOR ALL ENTRIES IN @mt_stock
       WHERE GLAccount       EQ @mt_stock-stock_hkont
         AND ChartOfAccounts EQ @wa_companyode-ChartOfAccounts
         AND Language        EQ @sy-langu
        INTO TABLE @DATA(mt_skat).

      SORT mt_skat BY GLAccount.
    ENDIF.

    lv_date1 = |{ mv_period(4) }{ mv_period+5(2) }| && |01|.

    mo_regulative_common->rp_last_day_of_months(
      EXPORTING
        day_in            = lv_date1
      IMPORTING
        last_day_of_month = lv_date1
      EXCEPTIONS
        day_in_no_date    = 1
        OTHERS            = 2
    ).

    gv_date1 = lv_date1.

    CLEAR ms_bank_report.
    SELECT SINGLE * FROM zinf_t001
      WHERE rate_type EQ @mv_rtype
        AND budat     EQ @lv_date1
        INTO @ms_bank_report.

    CLEAR mt_stspe.
    SELECT * FROM zinf_t013
        WHERE bukrs  EQ @mv_company_code
        AND rspmon   EQ @mv_period
        AND rldnr    EQ @mv_rldnr
        INTO TABLE @mt_stspe.

    IF mt_stock IS NOT INITIAL.
      CLEAR mt_corr_log.
      SELECT * FROM zinf_t002
         FOR ALL ENTRIES IN @mt_stock
         WHERE bukrs       EQ @mv_company_code
           AND rspmon      EQ @mv_period
           AND stock_hkont EQ @mt_stock-stock_hkont
           INTO TABLE @mt_corr_log.

      SORT mt_corr_log BY bukrs stock_hkont rspmon.
    ENDIF.
  ENDMETHOD.