  METHOD get_data.
*
    DELETE FROM zinf_t008 WHERE belnr IS INITIAL
                            AND gjahr IS INITIAL.

    COMMIT WORK AND WAIT.

    SELECT *
       FROM zinf_t001
      INTO TABLE @mt_rate_table.


    IF it_hkont IS NOT INITIAL.
      SELECT *
        FROM zinf_t003
        WHERE bukrs EQ @iv_bukrs
          AND rldnr EQ @iv_rldnr
          AND statu EQ '' "- Sadece boş olanlar anahesap değerleme programında kullanılır , A ve P olanlar ise Ters çalışan hesaplar programına dahil edilir.
          AND hkont IN @it_hkont
         INTO TABLE @mt_deger.
    ELSE.
      SELECT *
        FROM zinf_t003
       WHERE bukrs EQ @iv_bukrs
         AND rldnr EQ @iv_rldnr
         AND statu EQ '' "- Sadece boş olanlar anahesap değerleme programında kullanılır , A ve P olanlar ise Ters çalışan hesaplar programına dahil edilir.
        INTO TABLE @mt_deger.
    ENDIF.
*
    SELECT SINGLE Currency, ChartOfAccounts
      FROM I_CompanyCode
     WHERE CompanyCode EQ @iv_bukrs
      INTO @DATA(wa_companyode).


    IF mt_deger IS NOT INITIAL.
      SELECT * FROM I_GLAccountText
         FOR ALL ENTRIES IN @mt_deger
       WHERE GLAccount       EQ @mt_deger-hkont
         AND ChartOfAccounts EQ @wa_companyode-ChartOfAccounts
         AND Language        EQ @sy-langu
         INTO TABLE @mt_skat.

      SORT mt_skat BY GLAccount." for SAKNR.

      SELECT *
        FROM zinf_t008
        FOR ALL ENTRIES IN @mt_deger
        WHERE bukrs EQ @mt_deger-bukrs
          AND hkont EQ @mt_deger-hkont
          AND rldnr EQ @mt_deger-rldnr
          INTO TABLE @mt_log.

      SORT mt_log BY bukrs hkont rldnr.
    ENDIF.


    SELECT * FROM zinf_t026
      WHERE bukrs      EQ @iv_bukrs
        AND endex_date EQ @iv_idate
     INTO TABLE @mt_t026.

  ENDMETHOD.