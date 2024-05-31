  METHOD account_decomposition.
    "- İlgili Hesap Bakiye Geçiş tablosunda varsa Trial Balancedan okumasına gerek yok.Bakiye Geçişte yoksa Log Trial Balance tablosundan okumalı !
    LOOP AT it_hkont INTO DATA(wa_hkont).
      DATA(lv_hkont) = shift_left( val = wa_hkont sub = '0' ).
      READ TABLE mt_t026 INTO DATA(ls_t026) WITH KEY hkont = lv_hkont.
      IF sy-subrc IS INITIAL.
        ms_hkont = ls_t026-hkont.
        APPEND ms_hkont TO rt_hkont. CLEAR ms_hkont.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.