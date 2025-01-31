  METHOD prepare_data.
    DATA(valuation_date) = VALUE #( mr_valuation_date[ 1 ]-low OPTIONAL ).
*    DATA(index_date) = VALUE #( mr_index_date[ 1 ]-low  OPTIONAL ).


    DATA(ls_index_rate_data) = VALUE #( mt_index_table[ budat = valuation_date ] OPTIONAL ).
*    DATA(ls_valuation_rate_data) = VALUE #( mt_index_table[ budat = index_date ] OPTIONAL ).

    LOOP AT mt_029 INTO DATA(ls_029).

      ms_out_data = CORRESPONDING #( ls_029 ).

      DATA(ls_valuation_rate_data) = VALUE #( mt_index_table[ budat = ls_029-endex_date ] OPTIONAL ).

      ms_out_data-index_date = ls_029-endex_date.

      "-Katsayı
      TRY.
          ms_out_data-factor = ls_index_rate_data-bank_rate / ls_valuation_rate_data-bank_rate.
        CATCH cx_root INTO DATA(lox_root).
          CLEAR ms_out_data-factor.
      ENDTRY.

      "- Endekslenmiş Tutar(Satınalma).
      ms_out_data-index_amt_purc = ms_out_data-reval_amount * ms_out_data-factor.

      "- Endekslenmiş Tutar(Amortisman).
      ms_out_data-index_amt_depr = ms_out_data-depre_amount * ms_out_data-factor.

      "- Düzeltme Farkı(Satınalma).
      ms_out_data-corr_amt_purc =  ms_out_data-index_amt_purc - ms_out_data-reval_amount.
      IF  ms_out_data-corr_amt_purc < 0.
        ms_out_data-corr_amt_purc = ms_out_data-corr_amt_purc * -1.
      ENDIF.

      "- Düzeltme Farkı (Amortisman).
      ms_out_data-corr_amt_depr =  ms_out_data-index_amt_depr - ms_out_data-depre_amount.
      IF ms_out_data-corr_amt_depr < 0.
        ms_out_data-corr_amt_depr = ms_out_data-corr_amt_depr * -1.
      ENDIF.

      DATA(lv_anln1) = CONV anln1( |{  ls_029-anln1 ALPHA = OUT }| ).
      DATA(lv_anln2) = CONV anln2( |{  ls_029-anln2 ALPHA = OUT }| ).

      READ TABLE mt_030 INTO DATA(ls_030) WITH KEY bukrs = ls_029-bukrs
                                                   anln1 = lv_anln1
                                                   anln2 = lv_anln2
                                                   rldnr = ls_029-rldnr
                                                   val_date = ls_029-val_date.
      IF sy-subrc EQ 0.
        ms_out_data-belnr = ls_030-belnr.
        ms_out_data-gjahr = ls_030-gjahr.
      ENDIF.

      APPEND ms_out_data TO mt_out_data. CLEAR ms_out_data.
    ENDLOOP.

*    mt_out_data = CORRESPONDING #( mt_029 ).
  ENDMETHOD.