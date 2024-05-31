  METHOD get_data.

    DATA(lv_rspmon) = iv_rspmon(4) && iv_rspmon+5(2).
    DATA(lv_cspmon) = iv_cspmon(4) && iv_cspmon+5(2).

    SELECT *
      FROM zinf_t005
     WHERE bukrs EQ @iv_bukrs
       AND gjahr EQ @lv_cspmon(4)
       AND monat EQ @lv_cspmon+4(2)
*       AND hkont EQ @<lfs_stock>-stock_hkont
      INTO TABLE @mt_005.

    SELECT * FROM zinf_t007
     WHERE bukrs EQ @iv_bukrs
       AND rldnr EQ @iv_rldnr
       INTO TABLE @mt_stock.

    SELECT *
      FROM zinf_t009
        WHERE bukrs EQ @iv_bukrs
          AND rldnr EQ @iv_rldnr
      INTO TABLE @mt_cost.
*
    SELECT SINGLE Currency
      FROM I_CompanyCode
     WHERE CompanyCode EQ @iv_bukrs
      INTO @mv_waers.
*


  ENDMETHOD.