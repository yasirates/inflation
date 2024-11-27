  METHOD trigger_trial_balance_service2.

    DATA: ls_account_balances_01 TYPE zinf_s_bapi1028_4,
          ls_account_balances_02 TYPE zinf_s_bapi1028_4,
          ls_account_balances_03 TYPE zinf_s_bapi1028_4,
          ls_account_balances_04 TYPE zinf_s_bapi1028_4,
          ls_account_balances_05 TYPE zinf_s_bapi1028_4,
          ls_account_balances_06 TYPE zinf_s_bapi1028_4,
          ls_account_balances_07 TYPE zinf_s_bapi1028_4,
          ls_account_balances_08 TYPE zinf_s_bapi1028_4,
          ls_account_balances_09 TYPE zinf_s_bapi1028_4,
          ls_account_balances_10 TYPE zinf_s_bapi1028_4,
          ls_account_balances_11 TYPE zinf_s_bapi1028_4,
          ls_account_balances_12 TYPE zinf_s_bapi1028_4,
          ls_account_balances_13 TYPE zinf_s_bapi1028_4,
          ls_account_balances_14 TYPE zinf_s_bapi1028_4,
          ls_account_balances_15 TYPE zinf_s_bapi1028_4,
          ls_account_balances_16 TYPE zinf_s_bapi1028_4,
          url                    TYPE string,
          select_value           TYPE string,
          lv_temp_datum          TYPE datum,
          lv_temp_endda          TYPE datum.


    get_service_info(  ).

    DATA(service_info) = VALUE #( mt_users[ 1 ] OPTIONAL ).

    IF iv_gjahr IS NOT INITIAL.
      DATA(lv_filter_begda) = iv_gjahr && '-01-01T00:00:00'.
      DATA(lv_filter_endda) = iv_gjahr && '-12-31T00:00:00'.
    ENDIF.

    IF iv_beg_spmon IS NOT INITIAL AND iv_end_spmon IS NOT INITIAL.
      lv_filter_begda = iv_beg_spmon(4) && iv_beg_spmon+5(2) && '01T00:00:00'.

      lv_temp_datum   = iv_end_spmon(4) && iv_end_spmon+5(2) && '01'.
      zinf_regulative_common=>rp_last_day_of_months(
        EXPORTING
          day_in            = lv_temp_datum
        IMPORTING
          last_day_of_month = lv_temp_endda
        EXCEPTIONS
          day_in_no_date    = 1
          OTHERS            = 2
      ).
      lv_filter_begda = lv_filter_begda(4) && |-| && lv_filter_begda+4(2) && |-| && lv_filter_begda+6(2) && |T00:00:00|.
      lv_filter_endda = lv_temp_endda(4) && |-| && lv_temp_endda+4(2) && |-| && lv_temp_endda+6(2) && |T00:00:00|.
    ENDIF.

    IF iv_begda IS NOT INITIAL AND iv_endda IS NOT INITIAL.
*     lv_filter_begda = iv_gjahr && '-01-01T00:00:00'
      lv_filter_begda = iv_begda(4) && |-| && iv_begda+4(2) && |-| && iv_begda+6(2) && |T00:00:00|.
      lv_filter_endda = iv_endda(4) && |-| && iv_endda+4(2) && |-| && iv_endda+6(2) && |T00:00:00|.
    ENDIF.

    "url = |https://my404671-api.s4hana.cloud.sap:443/sap/opu/odata/sap/C_TRIALBALANCE_CDS/C_TRIALBALANCE|.
    url = service_info-service_url && |(P_FromPostingDate=datetime| && |'| && lv_filter_begda && |',| && |P_ToPostingDate=datetime| && |'| && lv_filter_endda && |')/Results|.

    select_value = 'CompanyCode,GLAccount,DebitCreditCode,FiscalYearPeriod,StartingBalanceAmtInCoCodeCrcy,DebitAmountInCoCodeCrcy,DebitAmountInCoCodeCrcy_E,' &&
                    'CreditAmountInCoCodeCrcy,CreditAmountInCoCodeCrcy_E,EndingBalanceAmtInCoCodeCrcy,EndingBalanceAmtInCoCodeCrcy_E'.

    IF it_hkont IS NOT INITIAL.
      DATA(filter) = 'Ledger eq ' && |'{ iv_ledger }'| && | and CompanyCode eq |  && |'{ iv_company_code }'| && | and ( GLAccount eq |.


      DATA lv_param TYPE string.
      LOOP AT it_hkont ASSIGNING FIELD-SYMBOL(<lfs_hkont>).
        DATA(lv_hkont) = <lfs_hkont>.

        IF sy-tabix EQ 1.
          lv_param = | '{ lv_hkont }'|.
*          '0001231231'
        ELSEIF sy-tabix GT 1.
          lv_param = lv_param && | or  GLAccount eq | && | '{ lv_hkont }'|.
*          or GLAccount eq '0001231231'
        ENDIF.
      ENDLOOP.

      lv_param = lv_param && ')'.

      filter = filter && lv_param.

    ELSE.
      IF iv_hkont IS INITIAL.
        filter = 'Ledger eq ' && |'{ iv_ledger }'| && | and CompanyCode eq |  && |'{ iv_company_code }'|.
      ELSE.
        filter = 'Ledger eq ' && |'{ iv_ledger }'| && | and CompanyCode eq |  && |'{ iv_company_code }'| && | and GLAccount eq |  && |'{ iv_hkont }'|.
      ENDIF.
    ENDIF.
*      data(filter) = 'Ledger eq ' && |'{ iv_ledger }'| && | and CompanyCode eq |  && |'{ iv_company_code }' and GLAccount eq '39912000'|.

    TRY.
        DATA(lo_http_destination) = cl_http_destination_provider=>create_by_url( url ).
        DATA(lo_web_http_client)  = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ).
        DATA(lo_web_http_request) = lo_web_http_client->get_http_request( ).

        lo_web_http_request->set_authorization_basic(
          EXPORTING
            i_username = CONV #( service_info-username )
            i_password = CONV #( service_info-password )
        ).

        lo_web_http_request->set_form_field(
          EXPORTING
            i_name  = '$filter'
            i_value = filter
        ).

        lo_web_http_request->set_form_field(
          EXPORTING
            i_name  = '$select'
            i_value = select_value
        ).

        lo_web_http_request->set_header_fields( VALUE #(
        ( name = 'DataServiceVersion' value = '2.0' )
        ( name = 'Accept'             value = 'application/xml' )
        ) ).

        DATA(lo_web_http_response) = lo_web_http_client->execute( if_web_http_client=>get ).

        DATA(lv_response) = lo_web_http_response->get_text( ).

        zcl_etr_regulative_common=>parse_xml(
          EXPORTING
            iv_xml_string = lv_response
          RECEIVING
            rt_data       = DATA(lt_response_service)
        ).

        "-
        DATA ls_service_data TYPE mty_service_data.
        LOOP AT lt_response_service ASSIGNING FIELD-SYMBOL(<lfs_response_service>).
          CHECK <lfs_response_service>-node_type EQ 'CO_NT_VALUE'.
          CASE <lfs_response_service>-name .
            WHEN 'updated'.
              CLEAR ls_service_data.
            WHEN 'CompanyCode'.
              ls_service_data-companycode                    = <lfs_response_service>-value.
            WHEN 'GLAccount'.
              ls_service_data-glaccount                      = <lfs_response_service>-value.
            WHEN 'DebitCreditCode'.
              ls_service_data-DebitCreditCode                = <lfs_response_service>-value.
            WHEN 'FiscalYearPeriod'.
              ls_service_data-FiscalYearPeriod               = <lfs_response_service>-value.
            WHEN 'StartingBalanceAmtInCoCodeCrcy'.
              ls_service_data-StartingBalanceAmtInCoCodeCrcy = <lfs_response_service>-value.
            WHEN 'DebitAmountInCoCodeCrcy'.
              ls_service_data-DebitAmountInCoCodeCrcy        = <lfs_response_service>-value.
            WHEN 'DebitAmountInCoCodeCrcy_E'.
              ls_service_data-DebitAmountInCoCodeCrcy_E      = <lfs_response_service>-value.
            WHEN 'CreditAmountInCoCodeCrcy'.
              ls_service_data-CreditAmountInCoCodeCrcy       = <lfs_response_service>-value.
            WHEN 'CreditAmountInCoCodeCrcy_E'.
              ls_service_data-CreditAmountInCoCodeCrcy_E     = <lfs_response_service>-value.
            WHEN 'EndingBalanceAmtInCoCodeCrcy'.
              ls_service_data-EndingBalanceAmtInCoCodeCrcy   = <lfs_response_service>-value.
            WHEN 'EndingBalanceAmtInCoCodeCrcy_E'.
              ls_service_data-EndingBalanceAmtInCoCodeCrcy_E = <lfs_response_service>-value.
              APPEND ls_service_data TO mt_service_data. CLEAR ls_service_data.
          ENDCASE.
        ENDLOOP.


        LOOP AT it_hkont INTO DATA(ls_hkont).
          lv_hkont = shift_left( val = ls_hkont sub = '0' ).

          LOOP AT mt_service_data INTO ls_service_data WHERE glaccount EQ lv_hkont.
            CASE ls_service_data-debitcreditcode.
              WHEN 'S'.
                CASE ls_service_data-fiscalyearperiod+4(3).
                  WHEN '001'.
                    ls_account_balances_01-fisc_year  = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_01-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_01-gl_account = ls_service_data-glaccount.
*                  ls_account_balances_01-debits_per = ls_account_balances_01-debits_per + ls_service_data-startingbalanceamtincocodecrcy + ls_service_data-DebitAmountInCoCodeCrcy.
                    ls_account_balances_01-debits_per = ls_account_balances_01-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
                    APPEND ls_account_balances_01 TO rt_balance. CLEAR ls_account_balances_01.
                  WHEN '002'.
                    ls_account_balances_02-fisc_year  = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_02-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_02-gl_account = ls_service_data-glaccount.
                    ls_account_balances_02-debits_per = ls_account_balances_02-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
                    APPEND ls_account_balances_02 TO rt_balance. CLEAR ls_account_balances_02.
                  WHEN '003'.
                    ls_account_balances_03-fisc_year  = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_03-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_03-gl_account = ls_service_data-glaccount.
                    ls_account_balances_03-debits_per = ls_account_balances_03-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
                    APPEND ls_account_balances_03 TO rt_balance. CLEAR ls_account_balances_03.
                  WHEN '004'.
                    ls_account_balances_04-fisc_year  = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_04-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_04-gl_account = ls_service_data-glaccount.
                    ls_account_balances_04-debits_per = ls_account_balances_04-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
                    APPEND ls_account_balances_04 TO rt_balance. CLEAR ls_account_balances_04.
                  WHEN '005'.
                    ls_account_balances_05-fisc_year  = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_05-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_05-gl_account = ls_service_data-glaccount.
                    ls_account_balances_05-debits_per = ls_account_balances_05-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
                    APPEND ls_account_balances_05 TO rt_balance. CLEAR ls_account_balances_05.
                  WHEN '006'.
                    ls_account_balances_06-fisc_year  = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_06-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_06-gl_account = ls_service_data-glaccount.
                    ls_account_balances_06-debits_per = ls_account_balances_06-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
                    APPEND ls_account_balances_06 TO rt_balance. CLEAR ls_account_balances_06.
                  WHEN '007'.
                    ls_account_balances_07-fisc_year  = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_07-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_07-gl_account = ls_service_data-glaccount.
                    ls_account_balances_07-debits_per = ls_account_balances_07-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
                    APPEND ls_account_balances_07 TO rt_balance. CLEAR ls_account_balances_07.
                  WHEN '008'.
                    ls_account_balances_08-fisc_year  = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_08-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_08-gl_account = ls_service_data-glaccount.
                    ls_account_balances_08-debits_per = ls_account_balances_08-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
                    APPEND ls_account_balances_08 TO rt_balance. CLEAR ls_account_balances_08.
                  WHEN '009'.
                    ls_account_balances_09-fisc_year  = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_09-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_09-gl_account = ls_service_data-glaccount.
                    ls_account_balances_09-debits_per = ls_account_balances_09-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
                    APPEND ls_account_balances_09 TO rt_balance. CLEAR ls_account_balances_09.
                  WHEN '010'.
                    ls_account_balances_10-fisc_year  = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_10-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_10-gl_account = ls_service_data-glaccount.
                    ls_account_balances_10-debits_per = ls_account_balances_10-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
                    APPEND ls_account_balances_10 TO rt_balance. CLEAR ls_account_balances_10.
                  WHEN '011'.
                    ls_account_balances_11-fisc_year  = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_11-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_11-gl_account = ls_service_data-glaccount.
                    ls_account_balances_11-debits_per = ls_account_balances_11-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
                    APPEND ls_account_balances_11 TO rt_balance. CLEAR ls_account_balances_11.
                  WHEN '012'.
                    ls_account_balances_12-fisc_year  = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_12-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_12-gl_account = ls_service_data-glaccount.
                    ls_account_balances_12-debits_per = ls_account_balances_12-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
                    APPEND ls_account_balances_12 TO rt_balance. CLEAR ls_account_balances_12.
*                  WHEN '013'.
*                    ls_account_balances_13-fisc_year  = ls_service_data-fiscalyearperiod(4).
*                    ls_account_balances_13-fis_period = ls_service_data-fiscalyearperiod+5(2).
*                    ls_account_balances_13-gl_account = ls_service_data-glaccount.
*                    ls_account_balances_13-debits_per = ls_account_balances_13-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
*                    APPEND ls_account_balances_13 TO rt_balance. CLEAR ls_account_balances_13.
*                  WHEN '014'.
*                    ls_account_balances_14-fisc_year  = ls_service_data-fiscalyearperiod(4).
*                    ls_account_balances_14-fis_period = ls_service_data-fiscalyearperiod+5(2).
*                    ls_account_balances_14-gl_account = ls_service_data-glaccount.
*                    ls_account_balances_14-debits_per = ls_account_balances_14-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
*                    APPEND ls_account_balances_14 TO rt_balance. CLEAR ls_account_balances_14.
*                  WHEN '015'.
*                    ls_account_balances_15-fisc_year  = ls_service_data-fiscalyearperiod(4).
*                    ls_account_balances_15-fis_period = ls_service_data-fiscalyearperiod+5(2).
*                    ls_account_balances_15-gl_account = ls_service_data-glaccount.
*                    ls_account_balances_15-debits_per = ls_account_balances_15-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
*                    APPEND ls_account_balances_15 TO rt_balance. CLEAR ls_account_balances_15.
*                  WHEN '016'.
*                    ls_account_balances_16-fisc_year  = ls_service_data-fiscalyearperiod(4).
*                    ls_account_balances_16-fis_period = ls_service_data-fiscalyearperiod+5(2).
*                    ls_account_balances_16-gl_account = ls_service_data-glaccount.
*                    ls_account_balances_16-debits_per = ls_account_balances_16-debits_per + ls_service_data-DebitAmountInCoCodeCrcy.
*                    APPEND ls_account_balances_16 TO rt_balance. CLEAR ls_account_balances_16.
                ENDCASE.
              WHEN 'H'.
                CASE ls_service_data-fiscalyearperiod+4(3).
                  WHEN '001'.
                    ls_account_balances_01-fisc_year = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_01-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_01-gl_account = ls_service_data-glaccount.
*                  ls_account_balances_01-credit_per = ls_account_balances_01-credit_per + ls_service_data-startingbalanceamtincocodecrcy + ls_service_data-DebitAmountInCoCodeCrcy.
                    ls_account_balances_01-credit_per = ls_account_balances_01-credit_per  + ls_service_data-creditamountincocodecrcy.
                    APPEND ls_account_balances_01 TO rt_balance. CLEAR ls_account_balances_01.
                  WHEN '002'.
                    ls_account_balances_02-fisc_year = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_02-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_02-gl_account = ls_service_data-glaccount.
                    ls_account_balances_02-credit_per = ls_account_balances_02-credit_per + ls_service_data-creditamountincocodecrcy.
                    APPEND ls_account_balances_02 TO rt_balance. CLEAR ls_account_balances_02.
                  WHEN '003'.
                    ls_account_balances_03-fisc_year = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_03-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_03-gl_account = ls_service_data-glaccount.
                    ls_account_balances_03-credit_per = ls_account_balances_03-credit_per + ls_service_data-creditamountincocodecrcy.
                    APPEND ls_account_balances_03 TO rt_balance. CLEAR ls_account_balances_03.
                  WHEN '004'.
                    ls_account_balances_04-fisc_year = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_04-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_04-gl_account = ls_service_data-glaccount.
                    ls_account_balances_04-credit_per = ls_account_balances_04-credit_per + ls_service_data-creditamountincocodecrcy.
                    APPEND ls_account_balances_04 TO rt_balance. CLEAR ls_account_balances_04.
                  WHEN '005'.
                    ls_account_balances_05-fisc_year = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_05-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_05-gl_account = ls_service_data-glaccount.
                    ls_account_balances_05-credit_per = ls_account_balances_05-credit_per + ls_service_data-creditamountincocodecrcy.
                    APPEND ls_account_balances_05 TO rt_balance. CLEAR ls_account_balances_05.
                  WHEN '006'.
                    ls_account_balances_06-fisc_year = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_06-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_06-gl_account = ls_service_data-glaccount.
                    ls_account_balances_06-credit_per = ls_account_balances_06-credit_per + ls_service_data-creditamountincocodecrcy.
                    APPEND ls_account_balances_06 TO rt_balance. CLEAR ls_account_balances_06.
                  WHEN '007'.
                    ls_account_balances_07-fisc_year = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_07-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_07-gl_account = ls_service_data-glaccount.
                    ls_account_balances_07-credit_per = ls_account_balances_07-credit_per + ls_service_data-creditamountincocodecrcy.
                    APPEND ls_account_balances_07 TO rt_balance. CLEAR ls_account_balances_07.
                  WHEN '008'.
                    ls_account_balances_08-fisc_year = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_08-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_08-gl_account = ls_service_data-glaccount.
                    ls_account_balances_08-credit_per = ls_account_balances_08-credit_per + ls_service_data-creditamountincocodecrcy.
                    APPEND ls_account_balances_08 TO rt_balance. CLEAR ls_account_balances_08.
                  WHEN '009'.
                    ls_account_balances_09-fisc_year = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_09-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_09-gl_account = ls_service_data-glaccount.
                    ls_account_balances_09-credit_per = ls_account_balances_09-credit_per + ls_service_data-creditamountincocodecrcy.
                    APPEND ls_account_balances_09 TO rt_balance. CLEAR ls_account_balances_09.
                  WHEN '010'.
                    ls_account_balances_10-fisc_year = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_10-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_10-gl_account = ls_service_data-glaccount.
                    ls_account_balances_10-credit_per = ls_account_balances_10-credit_per + ls_service_data-creditamountincocodecrcy.
                    APPEND ls_account_balances_10 TO rt_balance. CLEAR ls_account_balances_10.
                  WHEN '011'.
                    ls_account_balances_11-fisc_year = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_11-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_11-gl_account = ls_service_data-glaccount.
                    ls_account_balances_11-credit_per = ls_account_balances_11-credit_per + ls_service_data-creditamountincocodecrcy.
                    APPEND ls_account_balances_11 TO rt_balance. CLEAR ls_account_balances_11.
                  WHEN '012'.
                    ls_account_balances_12-fisc_year = ls_service_data-fiscalyearperiod(4).
                    ls_account_balances_12-fis_period = ls_service_data-fiscalyearperiod+5(2).
                    ls_account_balances_12-gl_account = ls_service_data-glaccount.
                    ls_account_balances_12-credit_per = ls_account_balances_12-credit_per + ls_service_data-creditamountincocodecrcy.
                    APPEND ls_account_balances_12 TO rt_balance. CLEAR ls_account_balances_12.
*                  WHEN '013'.
*                    ls_account_balances_13-fisc_year = ls_service_data-fiscalyearperiod(4).
*                    ls_account_balances_13-fis_period = ls_service_data-fiscalyearperiod+5(2).
*                    ls_account_balances_13-gl_account = ls_service_data-glaccount.
*                    ls_account_balances_13-credit_per = ls_account_balances_13-credit_per + ls_service_data-creditamountincocodecrcy.
*                    APPEND ls_account_balances_13 TO rt_balance. CLEAR ls_account_balances_13.
*                  WHEN '014'.
*                    ls_account_balances_14-fisc_year = ls_service_data-fiscalyearperiod(4).
*                    ls_account_balances_14-fis_period = ls_service_data-fiscalyearperiod+5(2).
*                    ls_account_balances_14-gl_account = ls_service_data-glaccount.
*                    ls_account_balances_14-credit_per = ls_account_balances_14-credit_per + ls_service_data-creditamountincocodecrcy.
*                    APPEND ls_account_balances_14 TO rt_balance. CLEAR ls_account_balances_14.
*                  WHEN '015'.
*                    ls_account_balances_15-fisc_year = ls_service_data-fiscalyearperiod(4).
*                    ls_account_balances_15-fis_period = ls_service_data-fiscalyearperiod+5(2).
*                    ls_account_balances_15-gl_account = ls_service_data-glaccount.
*                    ls_account_balances_15-credit_per = ls_account_balances_15-credit_per + ls_service_data-creditamountincocodecrcy.
*                    APPEND ls_account_balances_15 TO rt_balance. CLEAR ls_account_balances_15.
*                  WHEN '016'.
*                    ls_account_balances_16-fisc_year = ls_service_data-fiscalyearperiod(4).
*                    ls_account_balances_16-fis_period = ls_service_data-fiscalyearperiod+5(2).
*                    ls_account_balances_16-gl_account = ls_service_data-glaccount.
*                    ls_account_balances_16-credit_per = ls_account_balances_16-credit_per + ls_service_data-creditamountincocodecrcy.
*                    APPEND ls_account_balances_16 TO rt_balance. CLEAR ls_account_balances_16.
                ENDCASE.
            ENDCASE.
          ENDLOOP.
        ENDLOOP.

        LOOP AT rt_balance ASSIGNING FIELD-SYMBOL(<lfs_balance>).
          <lfs_balance>-balance = <lfs_balance>-debits_per + <lfs_balance>-credit_per.
        ENDLOOP.

        DELETE rt_balance WHERE gl_account IS INITIAL.
      CATCH cx_root INTO DATA(lx_root).
        DATA(lv_message) = lx_root->get_text( ).

    ENDTRY.
  ENDMETHOD.