  METHOD process_data.
    DATA: hkont_flag       TYPE abap_boolean,
          lv_balance_stock TYPE zinf_e_dmbtr.


    CLEAR mt_hkont.
    LOOP AT mt_deger ASSIGNING FIELD-SYMBOL(<lfs_deger>).
      ms_hkont = <lfs_deger>-hkont.
      APPEND ms_hkont TO mt_hkont. CLEAR ms_hkont.
    ENDLOOP.

*  IF mt_log IS INITIAL.
    mt_account_balances =  me->account_decomposition( it_hkont = mt_hkont ).

    "- bakiye geçiş tablosunda kayıt yoksa trial balancedan okunmalı -> tarihler : 01.01.2000 ile endeks tarihi -1 ay arasındakilerin tamamı
    me->call_trial_balance(
      EXPORTING
        iv_rldnr       = iv_rldnr
        iv_bukrs       = iv_bukrs
        it_hkont       = mt_hkont
        iv_begda       = mc_begda
        iv_endda       = mv_budat
        iv_sum_flag    = abap_true
        iv_index_date  = mv_prev_date
      IMPORTING
        et_balance     = DATA(lt_balance)
        et_sum_balance = DATA(lt_sum_balance)
    ).
*    ENDIF.

    DATA lv_factor TYPE zinf_e_factor.
    LOOP AT mt_deger ASSIGNING <lfs_deger>.
      CLEAR lv_factor.
      DATA(wa_log) = VALUE #( mt_log[ bukrs = <lfs_deger>-bukrs
                                      hkont = <lfs_deger>-hkont
                                      rldnr = <lfs_deger>-rldnr ] OPTIONAL ).

      IF wa_log IS INITIAL.
        "- 1. adımda Bakiye Geçiş tablosuna bakılır yoksa lt_sum_balance tablosundan okunur.
        READ TABLE mt_t026 INTO DATA(wa_026) WITH KEY hkont = <lfs_deger>-hkont.
        IF wa_026 IS NOT INITIAL.
          me->fill_trial_balance( it_sum_balance        = lt_sum_balance
                                  it_balance            = lt_balance
                                  iv_prev_date          = iv_prev_date
                                  iv_fyear              = iv_gjahr
                                  iv_rldnr              = iv_rldnr
                                  iv_bukrs              = iv_bukrs
                                  iv_budat              = iv_budat
                                  iv_rtype              = iv_rtype
                                  is_deger              = <lfs_deger>
                                  iv_cancel_old_balance = abap_false
                                  ).
        ELSE.
          me->fill_trial_balance( it_sum_balance = lt_sum_balance
                                  it_balance     = lt_balance
                                  iv_prev_date   = iv_prev_date
                                  iv_fyear       = iv_gjahr
                                  iv_rldnr       = iv_rldnr
                                  iv_bukrs       = iv_bukrs
                                  iv_budat       = iv_budat
                                  iv_rtype       = iv_rtype
                                  is_deger       = <lfs_deger> ).
        ENDIF.
      ELSE.

        CLEAR lv_balance_stock.
        "- daha önce değerlenmiş bir dönem var mı kontrolü ?
        SELECT SINGLE @abap_true
          FROM zinf_t008
          WHERE budat EQ @iv_prev_date
          INTO @DATA(is_true).

        IF is_true EQ abap_true.
          LOOP AT mt_log INTO DATA(ls_log) WHERE hkont = <lfs_deger>-hkont
                                             AND budat = iv_budat
                                             AND belnr IS NOT INITIAL.

          ENDLOOP.
          IF sy-subrc IS INITIAL.
            LOOP AT mt_log INTO wa_log WHERE bukrs     = <lfs_deger>-bukrs
                                         AND hkont     = <lfs_deger>-hkont
                                         AND rldnr     = <lfs_deger>-rldnr
                                         AND prev_date = iv_prev_date
                                         AND gjahr     = iv_gjahr.
              ms_main_data = CORRESPONDING #( wa_log ).
              APPEND ms_main_data TO mt_main_data. CLEAR ms_main_data.
            ENDLOOP.

          ELSE." Muhasebeleşmiş bir kayıt yok ise.

            "- sonraki değerleme dönemleri için önceki döneme ait kümülatif bakiye alınıyor.
            me->cumulative_data( is_deger = <lfs_deger>
                                 iv_budat = iv_budat
                                 iv_edate = iv_prev_date ).

            me->fill_trial_balance( it_sum_balance        = lt_sum_balance
                                    it_balance            = lt_balance
                                    iv_prev_date          = iv_prev_date
                                    iv_fyear              = iv_gjahr
                                    iv_rldnr              = iv_rldnr
                                    iv_bukrs              = iv_bukrs
                                    iv_budat              = iv_budat
                                    iv_rtype              = iv_rtype
                                    is_deger              = <lfs_deger>
                                    iv_cancel_old_balance = abap_true ).
          ENDIF.
        ELSE.
          LOOP AT mt_log INTO wa_log WHERE bukrs     = <lfs_deger>-bukrs
                                       AND hkont     = <lfs_deger>-hkont
                                       AND rldnr     = <lfs_deger>-rldnr
                                       AND prev_date = iv_prev_date
                                       AND gjahr     = iv_gjahr.
            ms_main_data = CORRESPONDING #( wa_log ).
            APPEND ms_main_data TO mt_main_data. CLEAR ms_main_data.
          ENDLOOP.
        ENDIF.
      ENDIF.

    ENDLOOP.

    "- Avans hesapları ters bakiyelerin eklenmesi..
    SELECT * FROM zinf_t028
      WHERE endex_date GE @iv_prev_date
        AND budat      LE @iv_budat
        INTO TABLE @DATA(lt_028).



    DATA(temp_main_tab) = mt_main_data.
    LOOP AT lt_028 INTO DATA(ls_028).

      DATA(lv_hkont) = |{ ls_028-hkont ALPHA = OUT }|.
      READ TABLE temp_main_tab ASSIGNING FIELD-SYMBOL(<lfs_main_data>) WITH KEY hkont = lv_hkont.
      CHECK sy-subrc IS INITIAL.

      ms_main_data-uuid      = cl_system_uuid=>create_uuid_c36_static( ).
      ms_main_data-bukrs     = iv_bukrs.
      ms_main_data-prev_date = iv_prev_date.
      ms_main_data-budat     = iv_budat.
      ms_main_data-rtype     = iv_rtype.
      ms_main_data-hkont     = ls_028-hkont.
      ms_main_data-rldnr     = iv_rldnr.
      ms_main_data-dmbtr     = ls_028-dmbtr.
      ms_main_data-blart     = <lfs_main_data>-blart.
      ms_main_data-endex_date = ls_028-endex_date.
      ms_main_data-correct_hkont_bs = <lfs_main_data>-correct_hkont_bs.
      ms_main_data-correct_hkont_pl = <lfs_main_data>-correct_hkont_pl.
      ms_main_data-txt50            = VALUE #( mt_skat[ GLAccount = <lfs_main_data>-hkont ]-GLAccountLongName OPTIONAL ).

      IF ms_rate_table2 IS NOT INITIAL AND ms_rate_table2-bank_rate IS NOT INITIAL.
        ms_main_data-factor =  ms_rate_table2-bank_rate / ms_rate_table1-bank_rate.
        CONDENSE ms_main_data-factor NO-GAPS.
      ENDIF.

      ms_main_data-endex_balance    = ms_main_data-factor * ms_main_data-dmbtr.

      IF ms_main_data-endex_balance IS NOT INITIAL.
        ms_main_data-correct_balance = ms_main_data-endex_balance - ms_main_data-dmbtr.
      ENDIF.
      APPEND ms_main_data TO mt_main_data. CLEAR ms_main_data.
    ENDLOOP.

  ENDMETHOD.